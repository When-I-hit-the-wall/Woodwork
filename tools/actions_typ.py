"""Writes a case of the workbooks of actions/ -- a roof's snow, a building's wind, a build-up's permanent loads -- as Typst files a static report includes: one file that computes every value with `#var` and `#eq` and prints nothing, and three that present it at three levels of detail, recalling the values it computed.

    python tools/actions_typ.py                                   # the window
    python tools/actions_typ.py <workbook.xlsx> <sheet> <folder>  # without the window

For a case named «Toiture» in neige.xlsx it writes, in the folder chosen:

* `neige-toiture-calcul.typ` -- the calculation: a function `neige-toiture(display: "none")` that opens the domain `neige-toiture` and declares, one argument per line, every value typed in the sheet (`#var`), every value of the norm by its file of `woodwork/data/` (`#var(from:, path:)`) and every value computed (`#eq`), as the sheet computes it;
* `neige-toiture-1-resume.typ` -- the results in one table;
* `neige-toiture-2-standard.typ` -- the data and the results in tables;
* `neige-toiture-3-detail.typ` -- the whole calculation printed line by line (its formulas, their numbers and their clauses), then the results' table.

A presentation file calls the calculation, then only recalls its values (`#var-table`, `get`): a value printed is a value Typst computed, never a number copied from the workbook. A report includes one presentation file of a case (`#include "neige-toiture-2-standard.typ"`), the calculation file beside it, and Woodwork's folder `woodwork/` at the root of its project.

What the workbook gives is what the engineer typed and what Excel read off a figure (μ of Figure 2, c_red of Figure 9) or chose among the directions of a table (the direction of the largest and the smallest q_k): the export reads the values Excel saved, so **the workbook must have been saved by Excel** (or LibreOffice) after its last change -- a workbook written by tools/build_actions.py and never opened holds no value, and the export says so.

Needs openpyxl (`pip install openpyxl`) and tkinter for the window (part of Python on Windows). A tool for the engineer's own machine; Typst alone compiles what it writes.
"""

import datetime
import json
import re
import sys
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(Path(__file__).resolve().parent))

LEVELS = (("1-resume", "Résumé : les résultats en un tableau"), ("2-standard", "Standard : données et résultats en tableaux"),
          ("3-detail", "Détaillé : tout le calcul, ligne par ligne, puis les résultats"))


class ExportError(Exception):
    """What stops an export, said to the engineer: the workbook, the sheet and what is wrong."""


# --- reading a sheet by its names --------------------------------------------------------------------------------------------

class Case:
    """A sheet of a workbook, its cells read by the names local to it, with the values Excel saved."""

    def __init__(self, path, sheet):
        from openpyxl import load_workbook
        self.path = Path(path)
        self.wb = load_workbook(self.path, data_only=True)
        if sheet not in self.wb.sheetnames:
            raise ExportError("%s n'a pas de feuille « %s » -- ses feuilles : %s" % (self.path.name, sheet, ", ".join(self.wb.sheetnames)))
        self.ws = self.wb[sheet]
        self.sheet = sheet

    def has(self, name):
        return name in self.ws.defined_names

    def cell(self, name):
        if not self.has(name):
            raise ExportError("La feuille « %s » n'a pas de cellule nommée « %s » : est-ce une feuille de calcul de actions/ ?" % (self.sheet, name))
        ref = self.ws.defined_names[name].attr_text.split("!")[1].replace("$", "")
        return self.ws[ref]

    def get(self, name, default=None):
        v = self.cell(name).value if self.has(name) else default
        return default if v is None else v

    def number(self, name):
        v = self.cell(name).value
        if isinstance(v, bool) or not isinstance(v, (int, float)):
            raise ExportError("« %s » (%s, feuille « %s ») vaut %r, pas un nombre. Le classeur a-t-il été enregistré par Excel après la dernière modification ? Un classeur jamais ouvert ne contient pas de valeurs."
                              % (name, self.cell(name).coordinate, self.sheet, v))
        return v

    def check_valid(self):
        if self.has("calcul_valide"):
            state = self.get("calcul_valide", "")
            if not state:
                raise ExportError("La feuille « %s » n'a pas de valeurs : ouvrir le classeur dans Excel, l'enregistrer, puis exporter." % self.sheet)
            if not str(state).startswith("Toutes"):
                raise ExportError("Feuille « %s » : %s Corriger les entrées en rouge (« État du calcul ») avant d'exporter." % (self.sheet, state))


# --- writing Typst that reads well --------------------------------------------------------------------------------------------

def slug(text):
    """«Toiture côté nord» → «toiture-cote-nord»: a name for a file, a domain and a function."""
    s = unicodedata.normalize("NFKD", str(text)).encode("ascii", "ignore").decode().lower()
    s = re.sub(r"[^a-z0-9]+", "-", s).strip("-")
    return s or "cas"


def lit(v):
    """A Typst literal: a string quoted, a number as Excel holds it (12 significant digits), a raw formula in backticks."""
    if isinstance(v, Raw):
        return "`%s`" % v.text
    if isinstance(v, str):
        return '"%s"' % v.replace("\\", "\\\\").replace('"', '\\"')
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, int) or (isinstance(v, float) and v.is_integer() and abs(v) < 1e12):
        return str(int(v))
    if isinstance(v, (tuple, list)):
        return "(" + ", ".join(lit(x) for x in v) + ("," if len(v) == 1 else "") + ")"
    return "%.12g" % v


class Raw:
    def __init__(self, text):
        self.text = text


def call(command, positional, named, indent=1):
    """`#var("h_0", 450, "m",` and then one named argument per line, indented a tab under its command (Woodwork's way)."""
    tab = "\t" * indent
    head = "%s#%s(%s" % (tab, command, ", ".join(lit(p) for p in positional))
    named = [(k, v) for k, v in named if v is not None]
    if not named:
        return head + ")"
    lines = [head + ("," if positional else "")]
    for i, (k, v) in enumerate(named):
        lines.append("%s\t%s: %s%s" % (tab, k, lit(v), ")" if i == len(named) - 1 else ","))
    return "\n".join(lines)


class Calc:
    """The lines of a calculation file, written in the order they compute."""

    def __init__(self):
        self.lines = []

    def comment(self, text):
        self.lines.append("")
        self.lines.append("\t// " + text)

    def var(self, key, value, unit=None, label=None, section=None, descr=None, role=None, norm=None, symbol=None):
        pos = [key] + ([symbol] if symbol else []) + [value] + ([unit] if unit else [])
        self.lines.append(call("var", pos, [("label", label), ("descr", descr), ("norm", norm), ("norm-section", section), ("role", role)]))

    def data(self, key, source, path, unit=None, label=None, section=None):
        """A value of the norm, read in its file of woodwork/data/ (never typed)."""
        self.lines.append(call("var", [key], [("from", source), ("path", path), ("unit", unit), ("label", label), ("norm-section", section)]))

    def eq(self, key, formula, label=None, section=None, role=None, unit=None, descr=None):
        self.lines.append(call("eq", [key, Raw(formula)], [("label", label), ("descr", descr), ("unit", unit), ("norm-section", section), ("role", role)]))


def head_comment(case, kind, what):
    today = datetime.date.today().isoformat()
    return ["// %s -- %s" % (kind, what),
            "// Écrit par Woodwork (tools/actions_typ.py) le %s depuis %s, feuille « %s ». Ne pas modifier à la main : changer le classeur, l'enregistrer et exporter à nouveau." % (today, case.path.name, case.sheet)]


def calc_file(case, fn, domain, title, units, calc):
    out = head_comment(case, "Calcul", title)
    out += ["// Ce fichier calcule et n'affiche rien : un fichier de présentation appelle %s() et rappelle ses valeurs." % fn, "",
            '#import "/woodwork/woodwork.typ": *', "",
            "#let %s(display: \"none\") = domain(%s," % (fn, lit(domain)),
            '\tnorm: "SIA 261",',
            "\tunits: %s," % lit(units),
            "\tdisplay: display,",
            "\tdisplay-formula: display,",
            "\tdisplay-equation: display)["]
    out += calc.lines
    out += ["]", ""]
    return "\n".join(out)


def present_file(case, fn, calc_name, title, level, body, heading, detail=False):
    word = dict(LEVELS)[level].split(" :")[0]
    out = head_comment(case, "Présentation « %s »" % word, title)
    out += ["// Les valeurs sont calculées par %s et seulement rappelées ici." % calc_name, "",
            '#import "/woodwork/woodwork.typ": *',
            '#import "%s": %s' % (calc_name, fn), ""]
    out += ["%s %s" % ("=" * heading, title), ""]
    out += ["#%s(%s)" % (fn, 'display: auto' if detail else ""), ""]
    out += body
    return "\n".join(out) + "\n"


def table(domain, role, columns=("label", "symbol", "value", "norm"), unit=None):
    named = [("role", role), ("domain", domain), ("unit", unit), ("columns", tuple(columns))]
    return call("var-table", [], named, indent=0)


# Helpers a presentation file defines for its own tables: a value of the domain with its unit, rounded as the engine rounds.
VALUE_HELPERS = """#let D = {domain}
#let value(key) = context {{
	let v = get(key, "value", domain: D)
	let u = get(key, "unit", domain: D)
	if type(v) == str [#v] else [#calc.round(v, digits: 3)#if u != "" [~#u]]
}}
#let symbol(key) = context eval(get(key, "symbol", domain: D), mode: "math")
#let label(key) = context get(key, "label", domain: D)
#let row(key) = (label(key), symbol(key), value(key))
"""


# --- the snow (neige.xlsx, «Neige») ------------------------------------------------------------------------------------------

ROOFS = {"Toit plat": "flat", "Toit à un pan": "mono", "Toit à deux pans": "duo", "Sheds": "shed", "Toit cintré": "curved"}
EXPOSURES = {"abrité": "sheltered", "normal": "normal", "exposé": "exposed", "valeur propre": "custom"}
SNOW = "sia261/5.2-schnee"


def snow(case):
    c = Calc()
    roof = ROOFS.get(case.get("forme"))
    if roof is None:
        raise ExportError("Forme de la toiture « %s » inconnue." % case.get("forme"))
    exposure = EXPOSURES.get(case.get("exposition"))
    hindered = case.get("glissement") != "possible"
    c.comment("Lieu (5.2.6, annexe D)")
    c.var("h_0", case.number("h_0"), "m", label="Altitude du lieu")
    c.var("Delta_h", case.number("delta_h"), "m", label="Correction d'altitude", section="Annexe D")
    c.eq("h_ref", "h_0 + Delta_h", label="Altitude de référence", section="Annexe D")
    c.comment("Charge de neige sur le sol, équation (10)")
    c.data("s_k_0", SNOW, "clause.s_k.factor", "kN/m²", label="Valeur de base")
    c.data("h_s", SNOW, "clause.s_k.divisor", "m", label="Altitude de l'équation (10)")
    c.data("n_s", SNOW, "clause.s_k.exponent", label="Exposant de l'équation (10)")
    c.data("s_k_min", SNOW, "clause.s_k.min", "kN/m²", label="Valeur minimale")
    c.eq("s_k_10", "s_k_0 * (1 + (h_ref / h_s)^n_s)", label="Charge de neige selon (10)", section="5.2.6 (10)")
    c.eq("s_k", "max(s_k_10, s_k_min)", label="Charge de neige sur le sol", section="5.2.6", role="result")
    c.comment("Coefficients d'exposition et thermique (5.2.4, 5.2.5)")
    if exposure == "custom":
        c.var("C_e", case.number("C_e"), label="Coefficient d'exposition (valeur propre)", section="5.2.4")
    else:
        c.data("C_e", SNOW, "clause.exposure.choices." + exposure, label="Coefficient d'exposition, exposition %s" % case.get("exposition"))
    c.var("C_T", case.number("C_T"), label="Coefficient thermique", section="5.2.5")
    c.eq("s_0", "C_e * C_T * s_k", label="Charge de neige sur le sol, exposition comprise", section="5.2.2 (9)")
    c.comment("Coefficients de forme, lus sur la figure 2 (ou 4) par le classeur, et charges, équation (9)")
    a1, a2 = case.get("alpha_1"), case.get("alpha_2")
    if roof in ("mono", "duo", "shed", "curved"):
        c.var("alpha_1", case.number("alpha_1"), "°", label="Pente du toit" + (", versant 1" if roof in ("duo", "shed") else ""))
    if roof in ("duo", "shed"):
        c.var("alpha_2", case.number("alpha_2"), "°", label="Pente du toit, versant 2")
    figure = lambda alpha: ("figure 2, α = %s°" % lit(alpha))
    m1, m2 = "modèle 1 (uniforme)", "modèle 2 (non uniforme)"
    if roof == "flat":
        L, B = case.number("L"), case.number("B")
        c.var("mu_1", case.number("mu_a"), label="Coefficient de forme", section="figure 4, L = %s m, B = %s m" % (lit(L), lit(B)) if min(L, B) > 20 else ("5.3.4" if hindered else figure(0)))
        c.eq("q_k", "mu_1 * s_0", label="Charge de neige", section="5.2.2 (9)", role="result")
    elif roof == "mono":
        c.var("mu_1", case.number("mu_a"), label="Coefficient de forme", section="5.3.4" if hindered else figure(a1))
        c.eq("q_k_1", "mu_1 * s_0", label="Charge de neige, " + m1, section="figure 3", role="result")
        c.eq("q_k_1_2", "mu_1 / 2 * s_0", label="Charge de neige, " + m2, section="figure 3", role="result")
    elif roof in ("duo", "shed"):
        c.var("mu_11", case.number("mu_a"), label="Coefficient de forme, versant 1", section="5.3.4" if hindered else figure(a1))
        c.var("mu_12", case.number("mu_b"), label="Coefficient de forme, versant 2", section="5.3.4" if hindered else figure(a2))
        c.eq("q_k_11", "mu_11 * s_0", label="Charge de neige, versant 1, " + m1, section="figure 3", role="result")
        c.eq("q_k_12", "mu_12 * s_0", label="Charge de neige, versant 2, " + m1, section="figure 3", role="result")
        if roof == "duo":
            c.eq("q_k_11_2", "mu_11 / 2 * s_0", label="Charge de neige, versant 1 réduit, " + m2, section="figure 3", role="result")
            c.eq("q_k_12_2", "mu_12 / 2 * s_0", label="Charge de neige, versant 2 réduit, " + m2, section="figure 3", role="result")
        else:
            c.var("mu_2m", case.number("mu_c"), label="Coefficient de l'accumulation, α moyen", section=figure((a1 + a2) / 2))
            c.eq("q_k_2m", "mu_2m * s_0", label="Charge de neige de l'accumulation, " + m2, section="figure 3", role="result")
    else:
        c.data("mu_1", SNOW, "clause.curved.model_1", label="Coefficient de forme, " + m1)
        c.var("mu_3", case.number("mu_a"), label="Coefficient de forme, " + m2, section=figure(a1))
        c.eq("q_k_1", "mu_1 * s_0", label="Charge de neige, " + m1, section="figure 3", role="result")
        c.eq("q_k_3", "mu_3 * s_0", label="Charge de neige, " + m2 + ", côté au vent", section="figure 3", role="result")
        c.eq("q_k_3_2", "mu_3 / 2 * s_0", label="Charge de neige, " + m2 + ", côté sous le vent", section="figure 3", role="result")
    title = "Charge de neige — %s" % case.get("designation", "Toiture")
    return {"action": "neige", "title": title, "units": ("m", "kN/m²"), "calc": c, "check": snow_results(case, roof)}


def snow_results(case, roof):
    """What the workbook computed, for the export's own check: {key: value}."""
    keys = {"flat": ["q_k"], "mono": ["q_k_1", "q_k_1_2"], "duo": ["q_k_11", "q_k_12", "q_k_11_2", "q_k_12_2"],
            "shed": ["q_k_11", "q_k_12", "q_k_2m"], "curved": ["q_k_1", "q_k_3", "q_k_3_2"]}[roof]
    out = {"s_k": case.number("s_k")}
    for i, k in enumerate(keys):
        out[k] = case.number("q_k_%d" % (i + 1))
    return out


def snow_present(info, d, level):
    if level == "1-resume":
        return [table(d, "result", ("label", "symbol", "value"))]
    if level == "2-standard":
        return ["Données", "", table(d, "data"), "", "Résultats", "", table(d, "result")]
    return ["Résultats", "", table(d, "result")]


# --- the wind (vent.xlsx, «Tableau NN») --------------------------------------------------------------------------------------

WIND = "sia261/6.2-wind"


def zone_key(text):
    """A surface or a coefficient as a part of a key: «A1» A1, «m_e» m_e, «90°» 90."""
    return re.sub(r"[^A-Za-z0-9_]", "", text.replace("°", "")) or "x"


def wind(case):
    import build_actions as ba
    m = re.match(r"^Tableau (\w+)$", case.sheet)
    if not m:
        raise ExportError("La feuille « %s » n'est pas un tableau de l'annexe C (« Tableau 31 » …)." % case.sheet)
    number = m.group(1)
    t = ba.wind_table(number)
    cols, rows = t["columns"], t["rows"]
    labels = [r["label"] for r in rows]
    clause = ba.norm("6.2-wind")["clause"]
    rule = clause["c_red"]["directions"]
    tab = "Tableau %s" % number
    c = Calc()
    c.comment("Données de base")
    c.var("q_p0", case.number("q_p0"), "kN/m²", label="Pression dynamique de référence", section="Annexe E")
    cat = case.get("categorie")
    profile = case.get("profil")
    c.var("b", case.number("b"), "m", label="Longueur du bâtiment (paroi A)")
    c.var("d", case.number("d"), "m", label="Largeur du bâtiment")
    c.var("h", case.number("h"), "m", label="Hauteur du bâtiment")
    c.var("c_d", case.number("c_d"), label="Coefficient dynamique", section="6.3.5")
    c.comment("Pression dynamique, équations (11) et (12) ; catégorie de terrain %s%s" % (cat, ", lue sur le profil III au-dessus de 30 m" if profile != cat else ""))
    if isinstance(case.get("z_saisi"), (int, float)):
        c.var("z_0", case.number("z_saisi"), "m", label="Hauteur de référence", section="6.2.2.3")
    else:
        c.eq("z_0", "h", label="Hauteur de référence, z = h", section="6.2.2.3")
    c.data("z_min", WIND, "clause.c_h.z_min_IV" if cat == "IV" else "clause.c_h.z_min", "m", label="Hauteur minimale" + (" en catégorie IV" if cat == "IV" else ""))
    c.eq("z", "max(z_0, z_min)", label="Hauteur au-dessus du sol", section="6.2.1.2")
    c.data("z_g", WIND, "clause.terrain.categories.%s.z_g" % profile, "m", label="Hauteur de gradient, catégorie %s" % profile)
    c.data("alpha_r", WIND, "clause.terrain.categories.%s.alpha_r" % profile, label="Rugosité du sol, catégorie %s" % profile)
    c.data("k_h", WIND, "clause.c_h.factor", label="Facteur de l'équation (12)")
    c.data("z_h", WIND, "clause.c_h.offset", label="Terme de l'équation (12)")
    c.eq("c_h", "k_h * ((z / z_g)^alpha_r + z_h)^2", label="Coefficient de profil", section="6.2.1.2 (12)")
    c.eq("q_p", "c_h * q_p0", label="Pression dynamique", section="6.2.1.1 (11)", role="result")
    cfs = [i for i, col in enumerate(cols) if col["group"] in ("cf", "cf_snow")]
    cpes = [i for i, col in enumerate(cols) if col["group"] in ("cpe", "cpe_local")]
    direct = lambda i: any(r["values"][i] == "direct" for r in rows)
    forces = [(k, i) for k, i in enumerate(cfs) if not direct(i)]
    needs = {cols[i].get("area") for _k, i in forces}
    if forces:
        c.comment("Coefficients de réduction, lus sur la figure 9 par le classeur (6.3.2, 6.3.3)")
        c.eq("beta_bh", "b / h", label="Élancement de la surface b·h", section="figure 9")
        c.var("c_red_bh", case.number("c_red_bh"), label="Coefficient de réduction, surface b·h", section="figure 9")
        c.eq("beta_dh", "d / h", label="Élancement de la surface d·h", section="figure 9")
        c.var("c_red_dh", case.number("c_red_dh"), label="Coefficient de réduction, surface d·h", section="figure 9")
        c.eq("c_red_max", "max(c_red_bh, c_red_dh)", label="Coefficient de réduction, direction oblique", section="6.3.3")
    check = {"q_p": case.number("q_p")}
    out_forces, out_press = [], []

    def at(label):
        return labels.index(str(label).strip()) if str(label).strip() in labels else None

    for k, i in forces:
        col = cols[i]
        n = k + 1
        words = ba.column_words(col)
        c.comment("%s : forces globales, équation (15), %s" % (words, tab))
        sides = []
        for side, name, word in (("max", "phimax", "plus grande"), ("min", "phimin", "plus petite")):
            label = case.get("cf%d_%s" % (n, name), "")
            j = at(label)
            if j is None:
                continue
            _shown, hi, lo = ba.cell_values(rows[j]["values"][i])
            value = hi if side == "max" else lo
            area = col.get("area")
            if area == "b·h":
                red = "c_red_max" if ba.oblique(labels[j], rule) else "c_red_bh"
            elif area == "d·h":
                red = "c_red_max" if ba.oblique(labels[j], rule) else "c_red_dh"
            else:
                red = None
            cf = "c_f%d_%s" % (n, side)
            c.var(cf, value, label="Coefficient de force %s, valeur %s, φ = %s" % (words, word, labels[j]), section="%s, φ = %s" % (tab, labels[j]))
            q = "q_f%d_%s" % (n, side)
            c.eq(q, ("%s * c_d * %s * q_p" % (red, cf)) if red else ("c_d * %s * q_p" % cf), label="Force par m², %s, φ = %s" % (words, labels[j]), section="6.2.3.2 (15)", role="result")
            check[q] = case.number("cf%d_q_%s" % (n, side))
            sides.append((side, q, labels[j]))
        aref = case.get("cf%d_aref" % n)
        if isinstance(aref, (int, float)) and sides:
            c.var("A_f%d" % n, aref, "m²", label="Aire de référence %s, tirée de b, d et h" % col.get("area"), section="6.2.3.2")
            for side, q, phi in sides:
                c.eq("Q_f%d_%s" % (n, side), "%s * A_f%d" % (q, n), label="Force, %s, φ = %s" % (words, phi), section="6.2.3.2", role="result")
        out_forces.append((n, words, sides, isinstance(aref, (int, float))))
    for k, i in enumerate(cpes):
        col = cols[i]
        n = k + 1
        net = col["surface"][:-2] if col["surface"].endswith("_e") else col["surface"]
        zk = zone_key(net) + ("_loc" if col["group"] == "cpe_local" else "")
        kind = ba.surface_kind(col)
        sides = []
        cpi_index = cpi_column(case, cols, i)
        c.comment("Surface %s (%s) : pression locale, équations (13) et (14), %s" % (net, kind, tab))
        for side, name, word in (("max", "phimax", "plus grande"), ("min", "phimin", "plus petite")):
            label = case.get("cpe%d_%s" % (n, name), "")
            j = at(label)
            if j is None:
                continue
            _shown, hi, lo = ba.cell_values(rows[j]["values"][i])
            value = hi if side == "max" else lo
            cpe = "c_pe_%s_%s" % (zk, side)
            c.var(cpe, value, label="Coefficient de pression extérieure, surface %s, valeur %s, φ = %s" % (net, word, labels[j]), section="%s, φ = %s" % (tab, labels[j]))
            p = 0
            if cpi_index is not None:
                _s, phi_, plo = ba.cell_values(rows[j]["values"][cpi_index])
                p = plo if side == "max" else phi_
                p = p if isinstance(p, (int, float)) else 0
            cpi = "cpi_%s_%s" % (zk, side)   # not «c_pi_…»: a part «pi» of a key prints π
            c.var(cpi, p, symbol='c_("pi",%s,"%s")' % (",".join('"%s"' % x if len(x) > 1 else x for x in zk.split("_")), side), label="Coefficient de pression intérieure, %s" % (ba.column_words(cols[cpi_index]) if cpi_index is not None else "aucun pour ce tableau"),
                  section=("%s, φ = %s" % (tab, labels[j])) if cpi_index is not None else None)
            q = "q_%s_%s" % (zk, side)
            c.eq(q, "q_p * (c_d * %s - %s)" % (cpe, cpi), label="Pression, surface %s, φ = %s" % (net, labels[j]), section="6.2.2.1 (13)", role="result")
            check[q] = case.number("cpe%d_q_%s" % (n, side))
            sides.append((side, q, labels[j]))
        out_press.append((net, kind, sides, zk))
    title = "Action du vent — %s (SIA 261, tableau %s)" % (case.get("designation", "Bâtiment"), number)
    return {"action": "vent", "title": title, "units": ("m", "kN/m²", "kN"), "calc": c, "check": check, "forces": out_forces, "pressures": out_press, "number": number}


def cpi_column(case, cols, i):
    """The column of c_pi a pressure coefficient reads, as the sheet reads it: the openings chosen, else the surface's own, else none."""
    chosen = case.get("cpi_colonne", 0) if case.has("cpi_colonne") else 0
    if isinstance(chosen, (int, float)) and chosen > 0:
        return int(chosen) - 1
    col = cols[i]
    net = col["surface"][:-2] if col["surface"].endswith("_e") else col["surface"]
    for j, c in enumerate(cols):
        if c["group"] == "cpi" and c["surface"] in (col["surface"], net + "_i"):
            return j
    return None


def wind_present(info, d, level):
    """Level 1 the results' two tables; level 2 the data, q_p and c_red, then each extreme with its coefficients; level 3 the whole calculation, then the results' tables."""
    out = [VALUE_HELPERS.format(domain=lit(d))]
    if level == "2-standard":
        keys = ["q_p0", "b", "d", "h", "c_d", "z", "c_h", "q_p"] + (["c_red_bh", "c_red_dh", "c_red_max"] if info["forces"] else [])
        out += ["Données, pression dynamique et coefficients de réduction :", "",
                "#table(", "\tcolumns: 3,", "\ttable.header([Désignation], [Symbole], [Valeur]),",
                "\t..(" + ", ".join(lit(k) for k in keys) + ").map(row).flatten(),", ")", ""]
    else:
        out += ["#table(", "\tcolumns: 3,", "\t..row(\"q_p\"),", ")", ""]
    def words(w):
        """«c_f1 (b·h)» as the norm writes it, its symbol in math."""
        w = re.sub(r"^c_f,s(\d+)", r"$c_(f,s \1)$", w)
        w = re.sub(r"^c_f(\d+)", r"$c_(f,\1)$", w)
        return "[%s]" % w.replace("_", "\\_") if "$" not in w else "[%s]" % w
    if info["forces"]:
        out += ["Forces globales, $q_k = c_\"red\" dot c_d dot c_f dot q_p$ (15), la plus grande et la plus petite sur les directions du tableau %s :" % info["number"], ""]
        if level == "2-standard":
            rows = []
            for n, w, sides, has_area in info["forces"]:
                for side, q, phi in sides:
                    rows.append('\t%s, [%s], [$phi = %s$], [#value("c_f%d_%s")], [#value("%s")], [%s],' % (
                        words(w) if side == "max" else "[]", side, phi.replace("°", "degree").replace("−", "-"), n, side, q,
                        ('#value("Q_f%d_%s")' % (n, side)) if has_area else "par m²"))
            out += ["#table(", "\tcolumns: 6,", "\ttable.header([Coefficient], [], [Direction], [$c_f$], [$q_k$], [$Q_k$]),"] + rows + [")", ""]
        else:
            rows = []
            for n, w, sides, has_area in info["forces"]:
                cells = {s: (q, phi) for s, q, phi in sides}
                line = [words(w)]
                for s in ("max", "min"):
                    line += ['[#value("%s")]' % cells[s][0], "[%s]" % cells[s][1]] if s in cells else ["[—]", "[]"]
                line += ['[#value("Q_f%d_max") · #value("Q_f%d_min")]' % (n, n) if has_area and len(cells) == 2 else "[par m²]"]
                rows.append("\t" + ", ".join(line) + ",")
            out += ["#table(", "\tcolumns: 6,", "\ttable.header([Coefficient], [$q_k$ max], [$phi$], [$q_k$ min], [$phi$], [$Q_k$ max · min]),"] + rows + [")", ""]
    if info["pressures"]:
        out += ["Pressions locales, $q_k = q_p dot (c_d dot c_\"pe\" - c_\"pi\")$ (13), (14), la plus grande et la plus petite sur les directions du tableau %s :" % info["number"], ""]
        if level == "2-standard":
            rows = []
            for net, kind, sides, zk in info["pressures"]:
                for side, q, phi in sides:
                    rows.append('\t%s, [%s], [$phi = %s$], [#value("c_pe_%s_%s")], [#value("cpi_%s_%s")], [#value("%s")],' % (
                        words("%s (%s)" % (net, kind)) if side == "max" else "[]", side, phi.replace("°", "degree").replace("−", "-"), zk, side, zk, side, q))
            out += ["#table(", "\tcolumns: 6,", "\ttable.header([Surface], [], [Direction], [$c_\"pe\"$], [$c_\"pi\"$], [$q_k$]),"] + rows + [")", ""]
        else:
            rows = []
            for net, kind, sides, zk in info["pressures"]:
                cells = {s: (q, phi) for s, q, phi in sides}
                line = [words("%s (%s)" % (net, kind))]
                for s in ("max", "min"):
                    line += ['[#value("%s")]' % cells[s][0], "[%s]" % cells[s][1]] if s in cells else ["[—]", "[]"]
                rows.append("\t" + ", ".join(line) + ",")
            out += ["#table(", "\tcolumns: 5,", "\ttable.header([Surface], [$q_k$ max], [$phi$], [$q_k$ min], [$phi$]),"] + rows + [")", ""]
    return out


# --- the permanent loads (poids-propre-et-surcharge.xlsx, a build-up) ---------------------------------------------------------

def dead(case):
    import build_actions as ba
    ws = case.ws
    if not case.has("couches"):
        raise ExportError("La feuille « %s » n'est pas une composition (« Composition 1 », « Lignum … »)." % case.sheet)
    ref = ws.defined_names["couches"].attr_text.split("!")[1].replace("$", "")
    first, last = [int(x) for x in re.findall(r"\d+", ref)]
    lib = json.loads((ROOT / "source" / "actions" / "materials.json").read_text(encoding="utf-8"))
    by_name = {m["names"]["fr"]: m for m in lib["materials"]}
    c = Calc()
    parts = {"g_k": [], "a_k": []}
    get = lambda r, j: ws.cell(r, j).value
    for r in range(first, last + 1):
        mat, pose, kind = get(r, 4), get(r, 19), get(r, 2)
        load = get(r, 16)
        if not isinstance(load, (int, float)) or kind not in parts:
            continue
        n = get(r, 1)
        what = mat or "charge saisie"
        role = get(r, 5)
        name = "%s%s" % (what, (" (%s)" % role) if role else "")
        g = "g_%d" % n
        c.comment("Couche %d : %s, %s, %s" % (n, name, kind, pose))
        imposed = isinstance(get(r, 15), (int, float))
        m = by_name.get(mat)
        source = m["ref"] if m else None
        if imposed or pose in ("charge saisie",):
            c.var(g, get(r, 15), "kN/m²", label=name + (", charge imposée" if imposed and pose != "charge saisie" else ""))
        elif pose == "par surface":
            c.var(g, get(r, 6), "kN/m²", label=name, descr=source)
        else:
            gamma, t = "gamma_%d" % n, "t_%d" % n
            c.var(gamma, get(r, 6), "kN/m³", label="Poids volumique, " + what, descr=source)
            c.var(t, get(r, 8), "mm", label="Épaisseur")
            if pose == "à entraxe":
                c.var("b_%d" % n, get(r, 9), "mm", label="Largeur des pièces")
                c.var("e_%d" % n, get(r, 10), "mm", label="Entraxe")
                c.eq(g, "%s * %s * b_%d / e_%d" % (gamma, t, n, n), label=name, unit="kN/m²")
            else:
                w = get(r, 13)
                if isinstance(w, (int, float)) and abs(w - 1000) > 1e-9:
                    c.var("w_%d" % n, w, "mm", label="Largeur remplie par mètre, w = 1000 · (1 − b/e)")
                    c.eq(g, "%s * %s * w_%d / (1000 \"mm\")" % (gamma, t, n), label=name, unit="kN/m²")
                else:
                    c.eq(g, "%s * %s" % (gamma, t), label=name, unit="kN/m²")
        parts[kind].append(g)
    if not parts["g_k"] and not parts["a_k"]:
        raise ExportError("La composition « %s » n'a aucune couche calculée : le classeur a-t-il été enregistré par Excel ?" % case.sheet)
    c.comment("Sommes")
    for kind, label in (("g_k", "Poids propre"), ("a_k", "Surcharge (charges permanentes ajoutées)")):
        if parts[kind]:
            c.eq(kind, " + ".join(parts[kind]), label=label, role="result", unit="kN/m²")
        else:
            c.var(kind, 0, "kN/m²", label=label, role="result")
    c.eq("g_ak", "g_k + a_k", label="Poids propre et surcharge", role="result", unit="kN/m²")
    retained = case.number("retenue")
    imposed = isinstance(case.get("impose"), (int, float))
    c.var("g_ak_ret", retained, "kN/m²", label="Valeur retenue" + (" (imposée)" if imposed else ", arrondie au dixième supérieur"), role="result")
    title = "Poids propre et surcharge — %s" % case.get("designation", case.sheet)
    check = {"g_k": case.number("g_k"), "a_k": case.number("a_k"), "g_ak": case.number("somme")}
    return {"action": "poids-propre", "title": title, "units": ("mm", "kN/m²"), "calc": c, "check": check}


def dead_present(info, d, level):
    if level == "1-resume":
        return [table(d, "result", ("label", "symbol", "value"))]
    if level == "2-standard":
        return ["Couches", "", call("var-table", [], [("domain", d), ("unit", "kN/m²"), ("columns", ("label", "symbol", "value"))], indent=0)]
    return ["Résultats", "", table(d, "result", ("label", "symbol", "value"))]


# --- the export ---------------------------------------------------------------------------------------------------------------

def kind_of(path):
    name = Path(path).name.lower()
    if name.startswith("neige"):
        return snow, snow_present
    if name.startswith("vent"):
        return wind, wind_present
    if name.startswith("poids"):
        return dead, dead_present
    raise ExportError("%s n'est pas un classeur de actions/ (neige, vent, poids-propre-et-surcharge)." % Path(path).name)


def sheets_of(path):
    """The sheets of a workbook a case can be exported from."""
    from openpyxl import load_workbook
    wb = load_workbook(path, read_only=False)
    return [ws.title for ws in wb.worksheets if "calcul_valide" in ws.defined_names]


def export(path, sheet, folder, heading=3, levels=None):
    """Writes the calculation file and the presentation files of one sheet; returns their paths."""
    build, present = kind_of(path)
    case = Case(path, sheet)
    case.check_valid()
    info = build(case)
    base = "%s-%s" % (info["action"], slug(case.get("designation", sheet)))
    fn = base
    domain = base
    folder = Path(folder)
    folder.mkdir(parents=True, exist_ok=True)
    calc_name = "%s-calcul.typ" % base
    written = []
    p = folder / calc_name
    p.write_text(calc_file(case, fn, domain, info["title"], info["units"], info["calc"]), encoding="utf-8", newline="\n")
    written.append(p)
    for level, _words in LEVELS:
        if levels and level not in levels:
            continue
        body = present(info, domain, level)
        p = folder / ("%s-%s.typ" % (base, level))
        p.write_text(present_file(case, fn, calc_name, info["title"], level, body, heading, detail=level == "3-detail"), encoding="utf-8", newline="\n")
        written.append(p)
    return written, info


# --- the window ---------------------------------------------------------------------------------------------------------------

def window():
    import tkinter as tk
    from tkinter import filedialog, messagebox, ttk
    root = tk.Tk()
    root.title("Woodwork — actions vers Typst")
    root.geometry("640x420")
    state = {"book": tk.StringVar(), "folder": tk.StringVar(), "heading": tk.IntVar(value=3)}
    frm = ttk.Frame(root, padding=14)
    frm.pack(fill="both", expand=True)
    ttk.Label(frm, text="Exporter un cas d'un classeur d'actions en fichiers .typ", font=("Segoe UI", 12, "bold")).grid(row=0, column=0, columnspan=3, sticky="w", pady=(0, 10))
    ttk.Label(frm, text="Classeur").grid(row=1, column=0, sticky="w")
    ttk.Entry(frm, textvariable=state["book"], width=60).grid(row=1, column=1, sticky="we")
    sheets = tk.Listbox(frm, height=10, selectmode="extended", exportselection=False)

    def choose_book():
        p = filedialog.askopenfilename(title="Classeur d'actions", filetypes=[("Excel", "*.xlsx")], initialdir=str(ROOT / "actions" / "fr"))
        if p:
            state["book"].set(p)
            sheets.delete(0, "end")
            try:
                for s in sheets_of(p):
                    sheets.insert("end", s)
            except Exception as e:   # the engineer reads what went wrong
                messagebox.showerror("Classeur", str(e))
            if not state["folder"].get():
                state["folder"].set(str(Path(p).parent / "typ"))
    ttk.Button(frm, text="Choisir…", command=choose_book).grid(row=1, column=2, padx=4)
    ttk.Label(frm, text="Cas (feuilles)").grid(row=2, column=0, sticky="nw", pady=6)
    sheets.grid(row=2, column=1, sticky="nsew", pady=6)
    ttk.Label(frm, text="Dossier").grid(row=3, column=0, sticky="w")
    ttk.Entry(frm, textvariable=state["folder"], width=60).grid(row=3, column=1, sticky="we")

    def choose_folder():
        p = filedialog.askdirectory(title="Dossier des fichiers .typ (celui du rapport)")
        if p:
            state["folder"].set(p)
    ttk.Button(frm, text="Choisir…", command=choose_folder).grid(row=3, column=2, padx=4)
    ttk.Label(frm, text="Niveau du titre").grid(row=4, column=0, sticky="w", pady=6)
    ttk.Spinbox(frm, from_=1, to=6, textvariable=state["heading"], width=4).grid(row=4, column=1, sticky="w", pady=6)

    def run():
        book, folder = state["book"].get(), state["folder"].get()
        chosen = [sheets.get(i) for i in sheets.curselection()]
        if not book or not chosen or not folder:
            messagebox.showwarning("Exporter", "Choisir un classeur, au moins un cas et un dossier.")
            return
        done = []
        try:
            for s in chosen:
                written, _info = export(book, s, folder, heading=state["heading"].get())
                done += [p.name for p in written]
        except ExportError as e:
            messagebox.showerror("Exporter", str(e))
            return
        messagebox.showinfo("Exporter", "Écrit dans %s :\n\n%s\n\nInclure dans le rapport l'un des fichiers -1-resume, -2-standard ou -3-detail." % (folder, "\n".join(done)))
    ttk.Button(frm, text="Exporter en .typ", command=run).grid(row=5, column=1, sticky="e", pady=10)
    ttk.Label(frm, text="Le classeur doit avoir été enregistré par Excel après sa dernière modification.", foreground="#666").grid(row=6, column=0, columnspan=3, sticky="w")
    frm.columnconfigure(1, weight=1)
    frm.rowconfigure(2, weight=1)
    root.mainloop()


def main():
    if len(sys.argv) == 1:
        window()
        return
    if len(sys.argv) != 4:
        sys.exit(__doc__)
    try:
        written, _info = export(sys.argv[1], sys.argv[2], sys.argv[3])
    except ExportError as e:
        sys.exit(str(e))
    for p in written:
        print(p)


if __name__ == "__main__":
    main()
