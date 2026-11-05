"""Holds the workbooks of actions/ to Woodcore: each case is typed into a copy of its workbook, LibreOffice recalculates them all, and every result is compared with what Woodcore's own modules compute for the same case.

    python tools/check_actions.py <path of Woodcore>

Needs openpyxl, LibreOffice (`soffice` on the PATH) and Woodcore beside it (calc/domains/snow_source.py, wind_forces.py, dead_load_source.py): a maintainer's check, run after tools/build_actions.py, never by a sheet's user. Prints each case that differs, and exits 1 if one does.
"""

import itertools
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from openpyxl import load_workbook

ROOT = Path(__file__).resolve().parent.parent
BOOKS = ROOT / "actions" / "fr"
TOL = 1e-9

ROOF_WORDS = {"flat": "Toit plat", "mono": "Toit à un pan", "duo": "Toit à deux pans", "shed": "Sheds", "curved": "Toit cintré"}
EXPOSURE_WORDS = {"sheltered": "abrité", "normal": "normal", "exposed": "exposé", "custom": "valeur propre"}
SLIDING_WORDS = {"possible": "possible", "hindered": "empêché ou entravé"}
OPENING_WORDS = {"rep": "ouvertures réparties", "A": "ouverture dominante dans la paroi A", "B": "ouverture dominante dans la paroi B",
                 "C": "ouverture dominante dans la paroi C", "D": "ouverture dominante dans la paroi D"}


def named(ws, name):
    """The cell a name local to `ws` stands for."""
    text = ws.defined_names[name].attr_text
    return re.sub(r"\$", "", text.split("!")[1])


def snow_cases():
    roofs = [("flat", {"length": 15, "width": 10}), ("flat", {"length": 30, "width": 24}), ("flat", {"length": 40, "width": 18}),
             ("mono", {"alpha_1": 12}), ("mono", {"alpha_1": 45}), ("duo", {"alpha_1": 30, "alpha_2": 30}), ("duo", {"alpha_1": 20, "alpha_2": 50}),
             ("duo", {"alpha_1": 65, "alpha_2": 35}), ("shed", {"alpha_1": 60, "alpha_2": 30}), ("shed", {"alpha_1": 25, "alpha_2": 10}),
             ("curved", {"alpha_1": 8}), ("curved", {"alpha_1": 35})]
    sites = [{"h_0": 450, "correction": 0, "exposure": "normal", "c_t": 1.0}, {"h_0": 1250, "correction": 200, "exposure": "sheltered", "c_t": 0.9},
             {"h_0": 2150, "correction": -200, "exposure": "exposed", "c_t": 1.0}, {"h_0": 300, "correction": "custom", "delta_h": 75, "exposure": "custom", "c_e": 1.1, "c_t": 1.0}]
    out = []
    for (roof, geo), site, sliding in itertools.product(roofs, sites, ("possible", "hindered")):
        src = {"schema_version": "1.4", "id": "x", "name": "", "label": "", "group": "", "roof": roof, "sliding": sliding, "length": 12, "width": 8,
               "alpha_1": 30, "alpha_2": 30, **site, **geo}
        out.append(src)
    return out


def snow_inputs(src):
    return {"L": src["length"], "B": src["width"], "h_0": src["h_0"], "delta_h": src["delta_h"] if src["correction"] == "custom" else src["correction"],
            "exposition": EXPOSURE_WORDS[src["exposure"]], "c_e_propre": src.get("c_e"), "C_T": src["c_t"], "forme": ROOF_WORDS[src["roof"]],
            "alpha_1": src["alpha_1"], "alpha_2": src["alpha_2"], "glissement": SLIDING_WORDS[src["sliding"]]}


def snow_expected(src):
    from domains import snow_source
    inst = snow_source.build_instance(src)
    v = {k: x["value"] for k, x in inst["vars"].items()}
    mus = list(snow_source.coefficients(src).values())
    return {"s_k": v["s_k"], "mu_a": mus[0][0], "mu_b": mus[1][0] if len(mus) > 1 else "", "mu_c": mus[2][0] if len(mus) > 2 else "",
            **{"q_k_%d" % (i + 1): v[name] for i, name in enumerate(inst["results"])}}


def wind_cases():
    from norms import sia261_wind
    geos = [(20.0, 12.0, 8.0, None), (36.0, 15.0, 11.5, None), (9.0, 30.0, 4.0, 6.0), (60.0, 20.0, 35.0, None), (12.0, 12.0, 120.0, 80.0)]
    out = []
    for k, number in enumerate(sia261_wind.NUMBERS):
        for j, (b, d, h, z) in enumerate(geos):
            terrain = ("II", "IIa", "III", "IV")[(k + j) % 4]
            opening = ("rep", "A", "B", "C", "D")[(k + 2 * j) % 5]
            out.append({"schema_version": "1.2", "id": "w", "name": "", "label": "", "group": "", "q_p0": (0.9, 1.1, 1.3)[(k + j) % 3], "terrain": terrain,
                        "b": b, "d": d, "h": h, "z": z, "table": number, "c_d": (1.0, 1.0, 1.2)[j % 3], "openings": opening})
    return out


def wind_inputs(src):
    return {"q_p0": src["q_p0"], "categorie": src["terrain"], "b": src["b"], "d": src["d"], "h": src["h"], "z_saisi": src["z"], "c_d": src["c_d"],
            "tableau": src["table"], "ouvertures": OPENING_WORDS[src["openings"]]}


def wind_expected(src):
    from domains import wind_forces
    a = wind_forces.analysis(src)
    out = {"c_h": a["c_h"], "q_p": a["q_p"], "c_red_bh": a["cred"]["bh"], "c_red_dh": a["cred"]["dh"], "c_red_max": a["cred"]["max"]}
    for k, f in enumerate(a["forces"]):
        out["cf%d_q_max" % (k + 1)] = "" if f["direct"] else f["max"]["q"]
        out["cf%d_q_min" % (k + 1)] = "" if f["direct"] else f["min"]["q"]
    shown = {s["key"]: s for s in a["local"]}
    columns = [c for c in a["table"]["columns"] if c["group"] in ("cpe", "cpe_local")]
    for k, c in enumerate(columns):
        s = shown.get(c["key"])
        out["cpe%d_q_max" % (k + 1)] = s["max"]["q"] if s else "—"
        out["cpe%d_q_min" % (k + 1)] = s["min"]["q"] if s else "—"
    return out


def dead_expected():
    from domains import dead_load_source, dead_load_templates, dead_load_layers
    out = []
    for tpl in dead_load_templates.shipped():
        rows = dead_load_source.layer_rows(dead_load_templates._as_source(tpl))
        gk = sum(r["load"] for r in rows if r["kind"] == "gk")
        ak = sum(r["load"] for r in rows if r["kind"] == "ak")
        out.append({"g_k": gk, "a_k": ak, "somme": gk + ak, "retenue": tpl.get("chosen") or dead_load_layers.retained(gk + ak)})
    return out


def recalc(paths, outdir, chunk=25):
    """LibreOffice computes every formula of a file openpyxl wrote (it holds no value) as it converts it; by chunks, a file it missed tried again once."""
    for attempt in range(2):
        todo = [p for p in paths if not (outdir / p.name).exists()]
        for k in range(0, len(todo), chunk):
            subprocess.run(["soffice", "--headless", "--calc", "--convert-to", "xlsx", "--outdir", str(outdir)] + [str(p) for p in todo[k:k + chunk]],
                           capture_output=True, timeout=1800)
    missing = [p.name for p in paths if not (outdir / p.name).exists()]
    if missing:
        sys.exit("LibreOffice did not recalculate %s" % ", ".join(missing))


def same(a, b):
    if isinstance(a, (int, float)) and isinstance(b, (int, float)):
        return abs(a - b) <= TOL * max(1.0, abs(b))
    return (a if a is not None else "") == (b if b is not None else "")


def main():
    woodcore = Path(sys.argv[1]).resolve()
    sys.path.insert(0, str(woodcore / "calc"))
    tmp = Path(tempfile.mkdtemp(prefix="woodwork-actions-"))
    jobs = []   # (file, sheet, expected, label)
    for book, sheet, cases, inputs, expected in (("neige.xlsx", "Neige", snow_cases(), snow_inputs, snow_expected),
                                                  ("vent.xlsx", "Vent", wind_cases(), wind_inputs, wind_expected)):
        for i, src in enumerate(cases):
            wb = load_workbook(BOOKS / book)
            ws = wb[sheet]
            for name, value in inputs(src).items():
                ws[named(ws, name)] = value
            path = tmp / ("%s-%03d.xlsx" % (book[:-5], i))
            wb.save(path)
            jobs.append((path, sheet, expected(src), "%s %d %s" % (book, i, {k: v for k, v in src.items() if k not in ("schema_version", "id", "name", "label", "group")})))
    dead = tmp / "dead.xlsx"
    shutil.copy(BOOKS / "poids-propre-et-surcharge.xlsx", dead)
    out = tmp / "out"
    recalc([j[0] for j in jobs] + [dead], out)
    failures = 0
    for path, sheet, expected, label in jobs:
        wb = load_workbook(out / path.name, data_only=True)
        ws = wb[sheet]
        names = load_workbook(path)[sheet]
        for name, want in expected.items():
            got = ws[named(names, name)].value
            if not same(got, want):
                failures += 1
                print("DIFFERS %s: %s = %r, Woodcore %r" % (label, name, got, want))
    wb = load_workbook(out / dead.name, data_only=True)
    names = load_workbook(dead)
    sheets = [s for s in wb.sheetnames if s.startswith("Lignum ")]
    for sheet, want in zip(sheets, dead_expected()):
        for name, value in want.items():
            got = wb[sheet][named(names[sheet], name)].value
            if not same(got, value):
                failures += 1
                print("DIFFERS %s: %s = %r, Woodcore %r" % (sheet, name, got, value))
    print("%d cases of snow and wind, %d build-ups: %s" % (len(jobs), len(sheets), "%d values differ" % failures if failures else "every value is Woodcore's"))
    shutil.rmtree(tmp, ignore_errors=True)
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
