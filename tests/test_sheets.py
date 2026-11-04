"""The sheets of phase 1 (founding spec REQ-002, REQ-011, UI-001): every generated sheet compiles in its language; a standard and a detailed sheet give the same utilisations; each check's utilisation equals the one Woodcore's member check computes for the same inputs, where Woodcore stands beside Woodwork."""

import json
import re
import shutil
import subprocess
import sys
import tempfile

from conftest import ENGINE, ROOT, TMP, Skip, typst

LANGS = ("fr", "de", "en")
DETAILED = {"fr": "-detaille", "de": "-detailliert", "en": "-detailed"}


_CACHE = {}


def all_utilisations(lang):
    """The utilisations of every sheet of a language -- every `eta…` its #verify lines store --, read in one compile: one document includes the 36 sheets, the registry read after each."""
    if lang in _CACHE:
        return _CACHE[lang]
    exe = typst()
    TMP.mkdir(parents=True, exist_ok=True)
    folder = tempfile.mkdtemp(dir=TMP)
    shutil.copytree(ENGINE, folder + "/woodwork")
    shutil.copytree(ROOT / "sheets" / lang, folder + "/sheets")
    lines = ['#set text(lang: "%s")' % lang, '#import "/woodwork/lib/calc-engine.typ": var-registry']
    for p in sheets(lang):
        rel = p.relative_to(ROOT / "sheets" / lang).as_posix()
        domain = re.search(r'#domain\("([^"]+)"', p.read_text(encoding="utf-8")).group(1)
        lines.append('#include "/sheets/%s"' % rel)
        lines.append('#context [#metadata((sheet: "%s", values: var-registry.get().domains.at("%s"))) <r>]' % (rel, domain))
    with open(folder + "/main.typ", "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines) + "\n")
    proc = subprocess.run([exe, "query", "--root", folder, folder + "/main.typ", "<r>"], capture_output=True, text=True, encoding="utf-8")
    assert proc.returncode == 0, (lang, proc.stderr[-1500:])
    out = {}
    for item in json.loads(proc.stdout):
        v = item["value"]
        out[v["sheet"]] = {k: x["value"] for k, x in v["values"].items() if k.startswith("eta") and k not in ("eta_w", "eta_t", "eta_w_E")}
    _CACHE[lang] = out
    return out


def utilisations(sheet, lang):
    return all_utilisations(lang)[sheet.relative_to(ROOT / "sheets" / lang).as_posix()]


def sheets(lang):
    return sorted(p for p in (ROOT / "sheets" / lang).rglob("*.typ"))


def test_eighteen_checks_in_two_levels_and_three_languages():
    for lang in LANGS:
        found = sheets(lang)
        assert len(found) == 36, (lang, len(found))
        assert len([p for p in found if p.stem.endswith(DETAILED[lang])]) == 18, lang


def test_every_sheet_compiles_and_both_levels_agree():
    for lang in LANGS:
        for p in sheets(lang):
            if p.stem.endswith(DETAILED[lang]):
                continue
            standard = utilisations(p, lang)
            detailed = utilisations(p.with_name(p.stem + DETAILED[lang] + ".typ"), lang)
            assert standard and standard == detailed, (p.relative_to(ROOT).as_posix(), standard, detailed)
            assert all(v <= 1 for v in standard.values()), (p.relative_to(ROOT).as_posix(), standard)


# The inputs of each English sheet, as a record of Woodcore's member check (calc/domains/member_check.py, 4 Nov 2026).
def kN(v):
    return {"value": v, "unit": "kN"}


def kNm(v):
    return {"value": v, "unit": "kNm"}


R140x240 = {"type": "rec", "b": 140, "h": 240}
COLUMN = dict(l_y=3200, l_z=3200, beta_y=1.0, beta_z=1.0)
CASES = {
    "tension-parallel": dict(kind="tension", N=kN(180), section={"type": "rec", "b": 140, "h": 200}),
    "tension-perpendicular": dict(kind="tension", N=kN(3), alpha=90),
    "tension-angle": dict(kind="tension", N=kN(20), alpha=10),
    "compression-parallel": dict(kind="compression", N=kN(250)),
    "compression-perpendicular": dict(kind="compression", N=kN(35), alpha=90, l=160, w=140, c90=True),
    "compression-angle": dict(kind="compression", N=kN(80), alpha=30, l=160, w=140, c90=True),
    "bending": dict(kind="bending", N=kN(0), M_y=kNm(12)),
    "bending-biaxial": dict(kind="bending", N=kN(0), M_y=kNm(12), M_z=kNm(3)),
    "bending-angle": dict(kind="bending", N=kN(0), M_y=kNm(10), alpha=5),
    "bending-tension": dict(kind="bending", N=kN(60), M_y=kNm(12)),
    "bending-compression": dict(kind="bending", N=kN(-120), M_y=kNm(12)),
    "shear": dict(kind="shear", variant="shear", V_z=kN(25)),
    "shear-off": dict(kind="shear", variant="shear-off", F=kN(35), l=200, w=140),
    "shear-compression-perp": dict(kind="shear", variant="shear-perp", V_z=kN(20), sigma_90=-0.8),
    "buckling": dict(kind="buckling", N=kN(150), section={"type": "rec", "b": 160, "h": 160}, **COLUMN),
    "lateral-torsional": dict(kind="lateral-torsional", N=kN(0), M_y=kNm(40), section={"type": "rec", "b": 140, "h": 400}, a=3000, sigma_m_crit=None),
    "lateral-torsional-compression": dict(kind="lateral-torsional", N=kN(-80), M_y=kNm(40), section={"type": "rec", "b": 140, "h": 400}, a=3000, sigma_m_crit=None, **COLUMN),
    "lateral-torsional-tension": dict(kind="lateral-torsional", N=kN(40), M_y=kNm(40), section={"type": "rec", "b": 140, "h": 400}, a=3000, sigma_m_crit=None),
}


def test_the_utilisations_are_woodcores():
    calc = ROOT.parent / "Woodcore" / "calc"
    if not calc.exists():
        raise Skip("Woodcore is not beside Woodwork")
    sys.path.insert(0, str(calc))
    from domains import member_check as mc
    english = {p.stem: p for p in sheets("en")}
    assert set(CASES) == {s for s in english if not s.endswith("-detailed")}, sorted(english)
    for name, case in CASES.items():
        case = dict(case)
        record = dict(calculable=True, fire=None, grade="GL24h", moisture_class=1, impact=False, section=R140x240, alpha=0, resistance=None)
        if case.pop("c90", False):
            # the table's f_c,90,d for the case the sheet's #material reads, through Woodcore's own reader
            record["f_c_90_table"] = mc.f_c_90_table("GL24h", "generell")
        record.update(case)
        theirs = mc.compute(record)["eta"]
        mine = max(utilisations(english[name], "en").values())
        assert abs(mine - theirs) <= 1e-9 * max(1, theirs), (name, mine, theirs)
