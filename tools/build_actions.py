"""The workbooks of actions/: the snow, the wind and the permanent loads computed in Excel from SIA 261:2020, as Woodcore's tabs «Neige», «Vent» and «Poids propre et surcharge» computed them in Python until Woodcore was stopped (November 2026).

    python tools/build_actions.py            # writes actions/fr/*.xlsx

Every norm value a workbook computes with is read here from woodwork/data/sia261/ and written into a sheet of the workbook that names its table and page («Données SIA 261», «Annexe C», «Figure 9», «Matériaux»): the formulas read those cells, never a number of their own. Every formula is the arithmetic of the Woodcore module named in its builder (calc/domains/snow_source.py, wind_source.py and wind_forces.py, dead_load_layers.py); tools/check_actions.py holds the workbooks' results, recalculated by LibreOffice, to Woodcore's for a set of cases.

The cells the engineer types are yellow with blue figures; each has a name local to its sheet (`h_0`, `q_p0`…), and so has each result, for the export to Typst of a later phase. A case is one sheet: a second roof or building is the sheet copied (right click, «Déplacer ou copier», «Créer une copie»), the names following the copy.

Needs openpyxl (the maintainer's tools only, principles: Python is for the maintainer).
"""

import json
import math
import re
from pathlib import Path

from openpyxl import Workbook
from openpyxl.chart import Reference, ScatterChart, Series
from openpyxl.comments import Comment
from openpyxl.formatting.rule import FormulaRule
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter as col
from openpyxl.workbook.defined_name import DefinedName
from openpyxl.worksheet.datavalidation import DataValidation

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "woodwork" / "data" / "sia261"
SOURCE = ROOT / "source" / "actions"
OUT = ROOT / "actions" / "fr"


def norm(name):
    return json.loads((DATA / (name + ".json")).read_text(encoding="utf-8"))


# --- the look of every workbook ---------------------------------------------------------------------------------------------

FONT = "Arial"
F_BASE = Font(name=FONT, size=10)
F_TITLE = Font(name=FONT, size=14, bold=True)
F_SUB = Font(name=FONT, size=9, italic=True, color="595959")
F_SECTION = Font(name=FONT, size=11, bold=True, color="FFFFFF")
F_HEAD = Font(name=FONT, size=10, bold=True)
F_INPUT = Font(name=FONT, size=10, color="0000FF")
F_RESULT = Font(name=FONT, size=10, bold=True)
F_REF = Font(name=FONT, size=9, color="595959")
F_DATA = Font(name=FONT, size=9)
FILL_INPUT = PatternFill("solid", fgColor="FFF2CC")
FILL_SECTION = PatternFill("solid", fgColor="7B5B3A")
FILL_HEAD = PatternFill("solid", fgColor="EDE3D6")
FILL_RESULT = PatternFill("solid", fgColor="E2EFDA")
FILL_RED = PatternFill("solid", fgColor="F8CBAD")
FILL_ORANGE = PatternFill("solid", fgColor="FCE4D6")
FILL_GREEN = PatternFill("solid", fgColor="E2EFDA")
THIN = Side(style="thin", color="BFBFBF")
BOX = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)
NUM3 = "0.000"
NUM2 = "0.00"
NUM1 = "0.0"
NUM0 = "0"


def absolute(ref):
    """'C5' → '$C$5'."""
    m = re.match(r"^([A-Z]+)(\d+)$", ref)
    return "$%s$%s" % m.groups()


def quoted(sheet):
    return "'%s'" % sheet.replace("'", "''")


class Sheet:
    """A calculation sheet laid out in rows: label | symbol | value | unit | SIA 261 | remark (columns A to F), every value named."""

    def __init__(self, ws, widths=(44, 12, 14, 10, 16, 70)):
        self.ws = ws
        self.row = 1
        for i, w in enumerate(widths, 1):
            ws.column_dimensions[col(i)].width = w
        ws.sheet_view.showGridLines = False

    def name(self, name, ref):
        """A name local to the sheet, so that a copied sheet keeps its own (`h_0` of «Neige (2)» is that sheet's)."""
        self.ws.defined_names[name] = DefinedName(name, attr_text="%s!%s" % (quoted(self.ws.title), absolute(ref)))

    def title(self, text, sub=None):
        c = self.ws.cell(self.row, 1, text)
        c.font = F_TITLE
        self.row += 1
        for line in ([sub] if isinstance(sub, str) else sub or []):
            self.ws.cell(self.row, 1, line).font = F_SUB
            self.row += 1
        self.row += 1

    def section(self, text, width=6):
        for i in range(1, width + 1):
            c = self.ws.cell(self.row, i)
            c.fill = FILL_SECTION
        c = self.ws.cell(self.row, 1, text)
        c.font = F_SECTION
        self.row += 1

    def head(self, labels):
        for i, text in enumerate(labels, 1):
            c = self.ws.cell(self.row, i, text)
            c.font = F_HEAD
            c.fill = FILL_HEAD
            c.border = BOX
            c.alignment = Alignment(wrap_text=True, vertical="center")
        self.row += 1

    def line(self, label, symbol, value, unit="", ref="", remark="", name=None, kind="calc", fmt=None, choices=None, strict=True, note=None):
        """One line; `kind` is «input» (yellow, blue), «calc» or «result» (bold, green)."""
        ws, r = self.ws, self.row
        ws.cell(r, 1, label).font = F_BASE
        ws.cell(r, 2, symbol).font = F_BASE
        c = ws.cell(r, 3, value)
        c.border = BOX
        c.alignment = Alignment(horizontal="right")
        if kind == "input":
            c.font, c.fill = F_INPUT, FILL_INPUT
        elif kind == "result":
            c.font, c.fill = F_RESULT, FILL_RESULT
        else:
            c.font = F_BASE
        if fmt:
            c.number_format = fmt
        ws.cell(r, 4, unit).font = F_BASE
        ws.cell(r, 5, ref).font = F_REF
        ws.cell(r, 6, remark).font = F_REF
        if choices:
            dv = DataValidation(type="list", formula1=choices, allow_blank=True, showErrorMessage=strict)
            if not strict:
                dv.showErrorMessage = False
            ws.add_data_validation(dv)
            dv.add(c)
        if note:
            c.comment = Comment(note, "Woodwork")
        ref_cell = "C%d" % r
        if name:
            self.name(name, ref_cell)
        self.row += 1
        return ref_cell

    def text(self, text, font=F_REF, column=1):
        self.ws.cell(self.row, column, text).font = font
        self.row += 1

    def skip(self, n=1):
        self.row += n


def interp(x, xs, ys, n):
    """A polyline's value at x, linear between two points and constant beyond the first and the last -- `sia261_snow.curve` and the heights of `sia261_wind.c_red`: xs and ys the absolute ranges of its n points."""
    m = "MATCH(%s,%s,1)" % (x, xs)
    first_x, first_y = "INDEX(%s,1)" % xs, "INDEX(%s,1)" % ys
    last_x, last_y = "INDEX(%s,%d)" % (xs, n), "INDEX(%s,%d)" % (ys, n)
    inner = "INDEX(%s,%s)+(INDEX(%s,%s+1)-INDEX(%s,%s))*(%s-INDEX(%s,%s))/(INDEX(%s,%s+1)-INDEX(%s,%s))" % (ys, m, ys, m, ys, m, x, xs, m, xs, m, xs, m)
    return "IF(%s<=%s,%s,IF(%s>=%s,%s,%s))" % (x, first_x, first_y, x, last_x, last_y, inner)


def data_sheet(wb, title):
    ws = wb.create_sheet(title)
    ws.sheet_view.showGridLines = False
    for i, w in enumerate((34, 14, 12, 12, 12, 12, 12, 12, 12, 12), 1):
        ws.column_dimensions[col(i)].width = w
    return ws


def put(ws, r, c, value, font=F_DATA, fmt=None, fill=None):
    cell = ws.cell(r, c, value)
    cell.font = font
    if fmt:
        cell.number_format = fmt
    if fill:
        cell.fill = fill
    return cell


def messages_block(sh, items, width=6):
    """The state of the calculation, as Woodcore's «État du calcul»: one line per message, each a formula that is empty where it does not apply -- red an entry the calculation cannot read, orange what is only said -- and a green line where every entry is read. `items` [(severity, condition, text)]; the text may be a formula's string expression (starting with `=`)."""
    sh.section("État du calcul")
    first = sh.row
    errors = []
    for severity, condition, text in items:
        expr = text[1:] if text.startswith("=") else '"%s"' % text.replace('"', '""')
        r = sh.row
        c = sh.ws.cell(r, 1, '=IF(%s,%s,"")' % (condition, expr))
        c.font = Font(name=FONT, size=10, color="C00000" if severity == "error" else "C65911")
        sh.ws.merge_cells(start_row=r, start_column=1, end_row=r, end_column=width)
        c.alignment = Alignment(wrap_text=False)
        if severity == "error":
            errors.append(condition)
        sh.row += 1
    ok = "AND(%s)" % ",".join("NOT(%s)" % e for e in errors) if errors else "TRUE"
    r = sh.row
    c = sh.ws.cell(r, 1, '=IF(%s,"Toutes les entrées sont là, le calcul est fait.","Une entrée en rouge manque ou est fausse : les résultats ne valent pas.")' % ok)
    c.font = Font(name=FONT, size=10, bold=True)
    sh.ws.merge_cells(start_row=r, start_column=1, end_row=r, end_column=width)
    sh.ws.conditional_formatting.add("A%d:%s%d" % (r, col(width), r), FormulaRule(formula=[ok], fill=FILL_GREEN))
    sh.ws.conditional_formatting.add("A%d:%s%d" % (r, col(width), r), FormulaRule(formula=["NOT(%s)" % ok], fill=FILL_RED))
    sh.name("calcul_valide", "A%d" % r)
    sh.row += 2
    return first, ok


def finish(wb, path):
    wb.calculation.fullCalcOnLoad = True
    path.parent.mkdir(parents=True, exist_ok=True)
    wb.save(path)
    return path


# --- the snow, SIA 261:2020 chapter 5 (Woodcore: calc/domains/snow_source.py) -------------------------------------------------

ROOFS = [("flat", "Toit plat"), ("mono", "Toit à un pan"), ("duo", "Toit à deux pans"), ("shed", "Sheds"), ("curved", "Toit cintré")]
EXPOSURES = [("sheltered", "abrité"), ("normal", "normal"), ("exposed", "exposé"), ("custom", "valeur propre")]
SLIDING = ["possible", "empêché ou entravé"]


def build_snow():
    data = norm("5.2-schnee")
    c = data["clause"]
    wb = Workbook()
    ws = wb.active
    ws.title = "Neige"
    d = data_sheet(wb, "Données SIA 261")

    # --- the norm's values, read off woodwork/data/sia261/5.2-schnee.json
    put(d, 1, 1, "Valeurs de SIA 261:2020, chapitre 5 « Neige »", F_TITLE)
    put(d, 2, 1, "Lues dans woodwork/data/sia261/5.2-schnee.json : %s" % data["_source"][:220] + "…", F_SUB)
    refs = {}
    r = 4
    put(d, r, 1, "Équation (10), 5.2.6", F_HEAD)
    r += 1
    for key, label in (("factor", "facteur [kN/m²]"), ("divisor", "diviseur [m]"), ("exponent", "exposant"), ("min", "minimum [kN/m²]")):
        put(d, r, 1, "s_k : " + label)
        put(d, r, 2, c["s_k"][key])
        refs["sk_" + key] = "%s!$B$%d" % (quoted(d.title), r)
        r += 1
    r += 1
    put(d, r, 1, "Coefficient d'exposition C_e, 5.2.4", F_HEAD)
    r += 1
    exposure = {e["id"]: e["value"] for e in c["exposure"]["choices"]}
    first = r
    for key, word in EXPOSURES[:3]:
        put(d, r, 1, word)
        put(d, r, 2, exposure[key])
        r += 1
    refs["ce_words"] = "%s!$A$%d:$A$%d" % (quoted(d.title), first, r - 1)
    refs["ce_values"] = "%s!$B$%d:$B$%d" % (quoted(d.title), first, r - 1)
    r += 1
    put(d, r, 1, "Corrections de l'annexe D [m]", F_HEAD)
    r += 1
    for i, v in enumerate(c["corrections"]["values"]):
        put(d, r, 2 + i, v)
    corrections_list = "%s!$B$%d:$%s$%d" % (quoted(d.title), r, col(1 + len(c["corrections"]["values"])), r)
    r += 2
    singles = [("hindered", "μ₁ où le glissement est empêché (5.3.4)", c["hindered"]["mu_1"]),
               ("alpha_0", "α₀ du toit cintré (figure 3) [°]", c["curved"]["alpha_0"]),
               ("model_1", "μ du modèle 1 du toit cintré (figure 3)", c["curved"]["model_1"]),
               ("min_side", "Côté minimal d'un grand toit plat (5.3.5) [m]", c["large_flat"]["min_side"]),
               ("steep", "Pente au-delà de laquelle la neige glisse (5.3.3) [°]", c["steep"]["alpha"]),
               ("max_altitude", "Altitude limite du chapitre 5 (5.1.4) [m]", c["max_altitude"]["value"]),
               ("cornice", "Altitude de la corniche (5.3.7) [m]", c["cornice"]["min_altitude"]),
               ("ct_default", "C_T usuel (5.2.5)", c["c_t"]["default"])]
    put(d, r, 1, "Autres valeurs", F_HEAD)
    r += 1
    for key, label, value in singles:
        put(d, r, 1, label)
        put(d, r, 2, value)
        refs[key] = "%s!$B$%d" % (quoted(d.title), r)
        r += 1
    r += 1
    curves = {}
    for key, label in (("mu_1", "μ₁ (figure 2)"), ("mu_2", "μ₂ (figure 2)"), ("mu_3", "μ₃ (figure 2)"), ("large_flat", "μ₁ des grands toits plats, selon le grand côté [m] (figure 4)")):
        pts = c[key]["points"]
        put(d, r, 1, label, F_HEAD)
        put(d, r + 1, 1, "α [°]" if key != "large_flat" else "côté [m]")
        put(d, r + 2, 1, "μ")
        for i, (x, y) in enumerate(pts):
            put(d, r + 1, 2 + i, x)
            put(d, r + 2, 2 + i, y)
        last = col(1 + len(pts))
        curves[key] = ("%s!$B$%d:$%s$%d" % (quoted(d.title), r + 1, last, r + 1), "%s!$B$%d:$%s$%d" % (quoted(d.title), r + 2, last, r + 2), len(pts))
        r += 4
    # Figure 2 drawn from 0 to 90° for the chart
    chart_row = r + 1
    put(d, r, 1, "Figure 2 tracée (pour le graphique)", F_HEAD)
    put(d, chart_row, 1, "α [°]")
    put(d, chart_row, 2, "μ₁")
    put(d, chart_row, 3, "μ₂")
    put(d, chart_row, 4, "μ₃")
    for i, alpha in enumerate(range(0, 91, 5)):
        rr = chart_row + 1 + i
        put(d, rr, 1, alpha)
        for j, key in enumerate(("mu_1", "mu_2", "mu_3")):
            xs, ys, n = curves[key]
            put(d, rr, 2 + j, "=" + interp("$A%d" % rr, xs, ys, n), fmt=NUM2)
    chart_last = chart_row + 19

    # --- the sheet
    sh = Sheet(ws)
    sh.title("Charge de neige — SIA 261:2020, chapitre 5",
             ["Cellules jaunes : à saisir. Les autres se calculent. Les valeurs de la norme sont dans la feuille « Données SIA 261 ».",
              "Un cas par feuille : pour un autre toit, copier la feuille (clic droit sur l'onglet, « Déplacer ou copier », « Créer une copie »)."])
    sh.line("Désignation du cas", "", "Toiture", kind="input", name="designation")
    sh.skip()
    sh.section("Bâtiment")
    L = sh.line("Longueur du bâtiment", "L", 15, "m", "5.3.5", "Lue par un toit plat seulement : μ₁ majoré selon la figure 4 si L et B dépassent tous deux 20 m.", "L", "input", NUM1)
    B = sh.line("Largeur du bâtiment", "B", 10, "m", "5.3.5", "", "B", "input", NUM1)
    sh.skip()
    sh.section("Lieu")
    h0 = sh.line("Altitude du lieu", "h₀", 500, "m", "5.2.6", "Altitude au-dessus du niveau de la mer.", "h_0", "input", NUM0)
    dh = sh.line("Correction d'altitude (annexe D)", "Δh", 0, "m", "Annexe D", "Carte de l'annexe D : −200, 0, +200, +400 ou +500 m (https://261.sia.ch/?lang=fr&layer=snow). Une autre valeur est acceptée.", "delta_h", "input", NUM0,
                 choices="=" + corrections_list, strict=False)
    exp = sh.line("Exposition au vent", "", "normal", "", "5.2.4", "abrité : C_e = 1,2 · normal : 1,0 · exposé : 0,8 · valeur propre : saisir C_e ci-dessous.", "exposition", "input",
                  choices='"%s"' % ",".join(w for _k, w in EXPOSURES))
    ce_own = sh.line("C_e propre (si « valeur propre »)", "C_e", "", "", "5.2.4", "", "c_e_propre", "input", NUM2)
    ce = sh.line("Coefficient d'exposition", "C_e", '=IF(%s="valeur propre",%s,INDEX(%s,MATCH(%s,%s,0)))' % (exp, ce_own, refs["ce_values"], exp, refs["ce_words"]), "", "5.2.4", "", "C_e", fmt=NUM2)
    ct = sh.line("Coefficient thermique", "C_T", 1.0, "", "5.2.5", "1,0 en général ; plus petit seulement si la fonte est accélérée par une forte transmission de chaleur (5.2.5).", "C_T", "input", NUM2)
    sh.skip()
    sh.section("Toiture")
    roof = sh.line("Forme de la toiture", "", "Toit à deux pans", "", "Figure 3", "Un toit à un pan est traité comme la moitié d'un toit à deux pans (5.3.2).", "forme", "input",
                   choices='"%s"' % ",".join(w for _k, w in ROOFS))
    a1 = sh.line("Pente du toit (versant 1)", "α₁", 30, "°", "Figure 2", "α d'un toit à un pan ou cintré, α₁ d'un toit à deux pans ou de sheds.", "alpha_1", "input", NUM1)
    a2 = sh.line("Pente du toit (versant 2)", "α₂", 30, "°", "Figure 2", "Lue par un toit à deux pans et des sheds seulement.", "alpha_2", "input", NUM1)
    slide = sh.line("Glissement de la neige", "", "possible", "", "5.3.4", "Empêché ou entravé (arrêts de neige, acrotère au bord inférieur) : μ₁ = 0,8.", "glissement", "input",
                    choices='"%s"' % ",".join(SLIDING))
    step = sh.line("Toit étagé ou contre un ouvrage plus haut", "", "non", "", "5.3.6", "Charge supplémentaire triangulaire de la figure 5 : signalée, pas calculée.", "decrochement", "input", choices='"oui,non"')
    sh.skip()

    # --- the computation (snow_source.coefficients, build_instance)
    sh.section("Résultats")
    ri = sh.line("Forme (numéro)", "", '=MATCH(%s,{"%s"},0)' % (roof, '","'.join(w for _k, w in ROOFS)), "", "", "1 plat, 2 un pan, 3 deux pans, 4 sheds, 5 cintré", "forme_n", fmt=NUM0)
    href = sh.line("Altitude de référence", "h_ref", "=%s+%s" % (h0, dh), "m", "Annexe D", "h_ref = h₀ + Δh", "h_ref", fmt=NUM0)
    sk = sh.line("Charge de neige sur le sol", "s_k",
                 "=MAX((1+(%s/%s)^%s)*%s,%s)" % (href, refs["sk_divisor"], refs["sk_exponent"], refs["sk_factor"], refs["sk_min"]),
                 "kN/m²", "5.2.6 (10)", "s_k = [1 + (h_ref / 350)²] · 0,4 kN/m² ≥ 0,9 kN/m²", "s_k", "result", NUM3)
    hindered = '%s="%s"' % (slide, SLIDING[1])
    mu1 = lambda a: "IF(%s,%s,%s)" % (hindered, refs["hindered"], interp(a, *curves["mu_1"]))
    flat = "IF(MIN(%s,%s)>%s,MAX(%s,%s),%s)" % (L, B, refs["min_side"], mu1("0"), interp("MAX(%s,%s)" % (L, B), *curves["large_flat"]), mu1("0"))
    mu2m = interp("(%s+%s)/2" % (a1, a2), *curves["mu_2"])
    mu3 = interp(a1, *curves["mu_3"])
    choose = lambda *exprs: "CHOOSE(%s,%s)" % (ri, ",".join(exprs))
    dash = '""'
    mua = sh.line('=%s' % choose('"Coefficient de forme μ₁ (figure 2, ou 4 si grand toit)"', '"Coefficient de forme μ₁"', '"Coefficient de forme μ₁₁ = μ₁(α₁)"', '"Coefficient de forme μ₁₁ = μ₁(α₁)"', '"Coefficient de forme μ₃ = μ₃(α)"'),
                  '=%s' % choose('"μ₁"', '"μ₁"', '"μ₁₁"', '"μ₁₁"', '"μ₃"'), "=" + choose(flat, mu1(a1), mu1(a1), mu1(a1), mu3), "", "Figure 2", "", "mu_a", "result", NUM2)
    mub = sh.line('=%s' % choose('""', '""', '"Coefficient de forme μ₁₂ = μ₁(α₂)"', '"Coefficient de forme μ₁₂ = μ₁(α₂)"', '""'),
                  '=%s' % choose('""', '""', '"μ₁₂"', '"μ₁₂"', '""'), "=" + choose(dash, dash, mu1(a2), mu1(a2), dash), "", "Figure 2", "", "mu_b", "result", NUM2)
    muc = sh.line('=%s' % choose('""', '""', '""', '"Coefficient de l\'accumulation μ₂m = μ₂((α₁ + α₂) / 2)"', '""'),
                  '=%s' % choose('""', '""', '""', '"μ₂m"', '""'), "=" + choose(dash, dash, dash, mu2m, dash), "", "Figure 2", "", "mu_c", "result", NUM2)
    base = sh.line("Produit C_e · C_T · s_k", "", "=%s*%s*%s" % (ce, ct, sk), "kN/m²", "5.2.2 (9)", "", "base", fmt=NUM3)
    sh.skip()
    sh.head(["Charge de neige caractéristique, q_k = μ · C_e · C_T · s_k", "Symbole", "q_k", "Unité", "SIA 261", "Modèle de charge et formule"])
    # the loads of each roof, Figur 3 (build_instance): (label, symbol, value, model and formula)
    m1, m2 = "Modèle 1 (uniforme)", "Modèle 2 (non uniforme)"
    loads = {
        "flat": [("Charge de neige", "q_k", "%s*%s" % (mua, base), "Un seul modèle : q_k = μ₁ · C_e · C_T · s_k")],
        "mono": [("Charge de neige, modèle 1", "q_k,1", "%s*%s" % (mua, base), m1 + " : μ₁ · C_e · C_T · s_k"),
                 ("Charge de neige, modèle 2", "q_k,1,2", "%s/2*%s" % (mua, base), m2 + " : μ₁ / 2 · C_e · C_T · s_k")],
        "duo": [("Charge de neige, versant 1, modèle 1", "q_k,11", "%s*%s" % (mua, base), m1 + " : μ₁₁ · C_e · C_T · s_k"),
                ("Charge de neige, versant 2, modèle 1", "q_k,12", "%s*%s" % (mub, base), m1 + " : μ₁₂ · C_e · C_T · s_k"),
                ("Charge de neige, versant 1 réduit, modèle 2", "q_k,11,2", "%s/2*%s" % (mua, base), m2 + " : μ₁₁ / 2 · C_e · C_T · s_k, l'autre versant entier, puis l'inverse"),
                ("Charge de neige, versant 2 réduit, modèle 2", "q_k,12,2", "%s/2*%s" % (mub, base), m2 + " : μ₁₂ / 2 · C_e · C_T · s_k")],
        "shed": [("Charge de neige, versant 1, modèle 1", "q_k,11", "%s*%s" % (mua, base), m1 + " : μ₁₁ · C_e · C_T · s_k"),
                 ("Charge de neige, versant 2, modèle 1", "q_k,12", "%s*%s" % (mub, base), m1 + " : μ₁₂ · C_e · C_T · s_k"),
                 ("Charge de neige de l'accumulation, modèle 2", "q_k,2m", "%s*%s" % (muc, base), m2 + " : μ₂m · C_e · C_T · s_k dans la noue")],
        "curved": [("Charge de neige, modèle 1", "q_k,1", "%s*%s" % (refs["model_1"], base), m1 + " : 0,8 · C_e · C_T · s_k"),
                   ("Charge de neige, modèle 2", "q_k,3", "%s*%s" % (mua, base), m2 + " : μ₃ · C_e · C_T · s_k, triangle côté au vent jusqu'à α₀ = 60°"),
                   ("Charge de neige, modèle 2, moitié", "q_k,3,2", "%s/2*%s" % (mua, base), m2 + " : μ₃ / 2 · C_e · C_T · s_k, triangle côté sous le vent")],
    }
    for slot in range(4):
        def pick(i, default):
            out = []
            for k, _w in ROOFS:
                if slot >= len(loads[k]):
                    out.append(default)
                elif i == 2:
                    out.append(loads[k][slot][i])
                else:
                    out.append('"%s"' % loads[k][slot][i].replace('"', '""'))
            return choose(*out)
        r = sh.row
        ws.cell(r, 1, "=" + pick(0, '""')).font = F_BASE
        ws.cell(r, 2, "=" + pick(1, '""')).font = F_BASE
        v = ws.cell(r, 3, "=" + pick(2, '""'))
        v.font, v.fill, v.border, v.number_format = F_RESULT, FILL_RESULT, BOX, NUM3
        ws.cell(r, 4, "=IF(ISNUMBER(C%d),\"kN/m²\",\"\")" % r).font = F_BASE
        ws.cell(r, 5, '=IF(ISNUMBER(C%d),"5.2.2, figure 3","")' % r).font = F_REF
        ws.cell(r, 6, "=" + pick(3, '""')).font = F_REF
        sh.name("q_k_%d" % (slot + 1), "C%d" % r)
        sh.row += 1
    sh.skip()

    # --- the state, as Woodcore's tab says it (snow_source._problems and messages)
    roof_needs_slopes = "%s>1" % ri
    two_slopes = "OR(%s=3,%s=4)" % (ri, ri)
    bad_alpha = lambda a: "OR(NOT(ISNUMBER(%s)),%s<0,%s>90)" % (a, a, a)
    items = [
        ("error", "OR(NOT(ISNUMBER(%s)),%s<0)" % (h0, h0), "h₀ : l'altitude du lieu, un nombre de mètres positif."),
        ("error", "NOT(ISNUMBER(%s))" % dh, "Δh : la correction de l'annexe D, un nombre de mètres."),
        ("error", "ISNA(MATCH(%s,{\"%s\"},0))" % (exp, '","'.join(w for _k, w in EXPOSURES)), "Exposition : abrité, normal, exposé ou valeur propre (5.2.4)."),
        ("error", 'AND(%s="valeur propre",OR(NOT(ISNUMBER(%s)),N(%s)<=0))' % (exp, ce_own, ce_own), "C_e propre : un nombre plus grand que 0 (5.2.4)."),
        ("error", "OR(NOT(ISNUMBER(%s)),%s<=0,%s>%s)" % (ct, ct, ct, refs["ct_default"]), "C_T : plus grand que 0 et au plus 1,0 (5.2.5)."),
        ("error", "ISNA(%s)" % ri, "Forme de la toiture : plat, un pan, deux pans, sheds ou cintré."),
        ("error", "AND(NOT(ISNA(%s)),%s=1,OR(NOT(ISNUMBER(%s)),N(%s)<=0,NOT(ISNUMBER(%s)),N(%s)<=0))" % (ri, ri, L, L, B, B), "L et B : les dimensions en plan d'un toit plat, en m, plus grandes que 0."),
        ("error", "AND(NOT(ISNA(%s)),%s,%s)" % (ri, roof_needs_slopes, bad_alpha(a1)), "α₁ : une pente en degrés, de 0 à 90."),
        ("error", "AND(NOT(ISNA(%s)),%s,%s)" % (ri, two_slopes, bad_alpha(a2)), "α₂ : une pente en degrés, de 0 à 90."),
        ("error", "ISNA(MATCH(%s,{\"%s\"},0))" % (slide, '","'.join(SLIDING)), "Glissement : possible ou empêché ou entravé."),
        ("info", "AND(ISNUMBER(%s),%s>%s)" % (h0, h0, refs["max_altitude"]), '="h₀ = "&%s&" m dépasse "&%s&" m : la norme n\'autorise pas ce calcul au-dessus de 2000 m (5.1.4)."' % (h0, refs["max_altitude"])),
        ("info", "AND(ISNUMBER(%s),%s>%s,%s<=%s)" % (h0, h0, refs["cornice"], h0, refs["max_altitude"]), '="Au-dessus de "&%s&" m : une corniche de neige est à considérer sur les parties en porte-à-faux (5.3.7), non calculée ici."' % refs["cornice"]),
        ("info", "AND(ISNUMBER(%s),%s>0,%s<%s)" % (ct, ct, ct, refs["ct_default"]), "C_T plus petit que 1,0 : à justifier par une forte transmission de chaleur (5.2.5)."),
        ("info", 'AND(%s="possible",OR(%s=2,%s=3,%s=4),N(%s)>=%s,N(%s)<=90)' % (slide, ri, ri, ri, a1, refs["steep"], a1), "α₁ de 60° ou plus, la neige pouvant glisser : pas de charge de neige sur ce versant (5.3.3)."),
        ("info", 'AND(%s="possible",%s,N(%s)>=%s,N(%s)<=90)' % (slide, two_slopes, a2, refs["steep"], a2), "α₂ de 60° ou plus, la neige pouvant glisser : pas de charge de neige sur ce versant (5.3.3)."),
        ("info", "AND(%s=1,MIN(N(%s),N(%s))>%s)" % (ri, L, B, refs["min_side"]), "Grand toit plat (L et B > 20 m) : μ₁ majoré selon la figure 4 (5.3.5)."),
        ("info", '%s="oui"' % step, "Toit étagé : ajouter la charge triangulaire de la figure 5 (5.3.6), non calculée ici."),
    ]
    messages_block(sh, items)

    # --- Figure 2 as a chart, the case's slopes on it
    chart = ScatterChart()
    chart.title = "Figure 2 — coefficients de forme μ selon α"
    chart.style = 2
    chart.x_axis.title = "α [°]"
    chart.y_axis.title = "μ"
    chart.x_axis.scaling.min, chart.x_axis.scaling.max = 0, 90
    chart.y_axis.scaling.min, chart.y_axis.scaling.max = 0, 2.4
    chart.x_axis.delete = False
    chart.y_axis.delete = False
    xs = Reference(d, min_col=1, min_row=chart_row + 1, max_row=chart_last)
    for j, name in enumerate(("μ₁", "μ₂", "μ₃")):
        ys = Reference(d, min_col=2 + j, min_row=chart_row + 1, max_row=chart_last)
        s = Series(ys, xs, title=name)
        s.marker.symbol = "none"
        s.smooth = False
        chart.series.append(s)
    chart.height, chart.width = 7.5, 13
    ws.add_chart(chart, "H4")
    ws.freeze_panes = "A4"
    return finish(wb, OUT / "neige.xlsx")


# --- the wind, SIA 261:2020 chapter 6 and Annexe C (Woodcore: calc/domains/wind_source.py, wind_forces.py, norms/sia261_wind.py) --

WIND_TABLES = tuple(str(n) for n in range(31, 57)) + ("57a", "57b", "57c", "57d", "58", "59a", "59b", "60a", "60b", "63", "64")
OPENINGS = [("rep", "ouvertures réparties"), ("A", "ouverture dominante dans la paroi A"), ("B", "ouverture dominante dans la paroi B"),
            ("C", "ouverture dominante dans la paroi C"), ("D", "ouverture dominante dans la paroi D")]
MAX_COLS = 37      # the widest table of Annexe C (60a)
MAX_ROWS = 6       # the longest (63)
BLOCK = 27         # rows of a table's block in «Annexe C»: title, 7 rows of what each column is, 6 shown, 6 larger, 6 smaller, one blank
META = {"label": 1, "group": 2, "surface": 3, "area": 4, "factor": 5, "own_cpi": 6, "direct": 7}
DIRECTION = re.compile(r"^([−-]?\d+(?:\.\d+)?)°$")


def wind_table(number):
    m = re.match(r"(\d+)([a-d]?)$", number)
    return norm("tab%s-wind%s" % (m.group(1), "-" + m.group(2) if m.group(2) else ""))["table"]


def oblique(label, rule):
    """sia261_wind.oblique: a row whose direction is not «less than 15°» off a reference direction takes the larger c_red (6.3.3)."""
    m = DIRECTION.match(label.strip())
    if not m:
        return False
    angle = float(m.group(1).replace("−", "-"))
    off = min(abs((angle - ref + 180) % 360 - 180) for ref in rule["reference"])
    return not off < rule["band"]


def cell_values(value):
    """(shown, larger, smaller) of a cell: a pair ±x or a/b both its values, «direct» a star, empty nothing."""
    if value is None:
        return "", "", ""
    if value == "direct":
        return "*", "*", "*"
    if isinstance(value, list):
        a, b = value
        shown = ("±%g" % abs(a)) if a == -b else "%g / %g" % (a, b)
        return shown, max(a, b), min(a, b)
    return value, value, value


def column_words(column):
    g = column["group"]
    if g == "cpe":
        return "c_pe " + column["surface"]
    if g == "cpe_local":
        return "c_pe " + column["surface"] + " (local)"
    if g == "cpi_opening":
        return "c_pi " + dict(OPENINGS)[column["opening"]].replace("ouverture dominante dans la paroi", "ouv. dom.").replace("ouvertures réparties", "réparties")
    if g == "cpi":
        return "c_pi " + column["surface"]
    area = ("%s·%s" % (("%g" % column["area_factor"]).replace(".", ","), column["area"])) if column.get("area_factor") else column["area"]
    return ("c_f%d" if g == "cf" else "c_f,s%d") % column["index"] + " (" + area + ")"


def surface_kind(column):
    """wind_forces.surface_group, in French."""
    if column["group"] == "cpe_local":
        return "locale"
    if column["surface"].endswith("°"):
        return "point"
    return "paroi" if re.match(r"^[ABCD]\d*$", column["surface"]) else "toit"


def build_wind():
    clause = norm("6.2-wind")["clause"]
    tables = [wind_table(n) for n in WIND_TABLES]
    wb = Workbook()
    ws = wb.active
    ws.title = "Vent"
    d = data_sheet(wb, "Données SIA 261")
    ac = wb.create_sheet("Annexe C")
    ac.sheet_view.showGridLines = False
    ix = wb.create_sheet("Tableaux")
    ix.sheet_view.showGridLines = False
    f9 = wb.create_sheet("Figure 9")
    f9.sheet_view.showGridLines = False
    q = quoted

    # --- «Données SIA 261»: Tableau 4, (12), c_d, scope
    put(d, 1, 1, "Valeurs de SIA 261:2020, chapitre 6 « Vent »", F_TITLE)
    put(d, 2, 1, "Lues dans woodwork/data/sia261/6.2-wind.json.", F_SUB)
    put(d, 4, 1, "Tableau 4 : catégories de terrain", F_HEAD)
    for j, h in enumerate(("Catégorie", "z_g [m]", "α_r", "Exemple")):
        put(d, 5, 1 + j, h, F_HEAD)
    for i, t in enumerate(clause["terrain"]["categories"]):
        put(d, 6 + i, 1, t["id"])
        put(d, 6 + i, 2, t["z_g"])
        put(d, 6 + i, 3, t["alpha_r"])
        put(d, 6 + i, 4, t["example"])
    terr = {"ids": "%s!$A$6:$A$9" % q(d.title), "zg": "%s!$B$6:$B$9" % q(d.title), "ar": "%s!$C$6:$C$9" % q(d.title)}
    ch = clause["c_h"]
    singles = [("ch_factor", "Équation (12) : facteur", ch["factor"]), ("ch_offset", "Équation (12) : terme ajouté", ch["offset"]),
               ("z_min", "z minimal (6.2.1.2) [m]", ch["z_min"]), ("z_min_IV", "z minimal en catégorie IV [m]", ch["z_min_IV"]),
               ("iv_as_iii", "Catégorie IV lue comme III au-dessus de [m]", ch["iv_as_iii_above"]),
               ("cd_default", "c_d usuel (6.3.5)", clause["c_d"]["default"]), ("cd_height", "Hauteur au-delà de laquelle c_d = 1,0 ne vaut que pour les bâtiments que 6.3.5 nomme [m]", clause["c_d"]["building_height"]),
               ("max_height", "Hauteur maximale (6.1.2) [m]", clause["scope"]["max_height"]), ("cred_roof", "c_red du toit et des autres surfaces (6.3.2)", clause["c_red"]["roof"]),
               ("ratio_spread", "Écart des proportions signalé au-delà de (règle de Woodcore, pas de la norme)", 1.5)]
    refs = {}
    r = 11
    put(d, r, 1, "Autres valeurs", F_HEAD)
    r += 1
    for key, label, value in singles:
        put(d, r, 1, label)
        put(d, r, 2, value)
        refs[key] = "%s!$B$%d" % (q(d.title), r)
        r += 1
    d.column_dimensions["A"].width = 70

    # --- «Figure 9»: c_red by h and beta, beyond a curve's end its last value (sia261_wind.c_red)
    curves = clause["c_red"]["curves"]
    heights = sorted({p[0] for cv in curves for p in cv["points"]})
    put(f9, 1, 1, "Figure 9 : coefficient de réduction c_red selon h [m] et β = b/h ou d/h", F_TITLE)
    put(f9, 2, 1, "Lue dans woodwork/data/sia261/6.2-wind.json. Au-delà de la fin d'une courbe, sa dernière valeur ; entre deux courbes, interpolation linéaire en log β.", F_SUB)
    put(f9, 4, 1, "β →", F_HEAD)
    put(f9, 5, 1, "h max de la courbe [m]", F_HEAD)
    for j, cv in enumerate(curves):
        put(f9, 4, 2 + j, cv["beta"], F_HEAD)
        put(f9, 5, 2 + j, cv["points"][-1][0])
        pts = dict((p[0], p[1]) for p in cv["points"])
        last = cv["points"][-1][1]
        for i, h in enumerate(heights):
            put(f9, 6 + i, 2 + j, pts.get(h, last if h > cv["points"][-1][0] else None), fmt=NUM3)
    for i, h in enumerate(heights):
        put(f9, 6 + i, 1, h, F_HEAD)
    assert heights == [5 + 5 * k for k in range(len(heights))], "Figure 9 is read on a grid of 5 m"
    nb, nh = len(curves), len(heights)
    f9r = {"betas": "%s!$B$4:$%s$4" % (q(f9.title), col(1 + nb)), "hend": "%s!$B$5:$%s$5" % (q(f9.title), col(1 + nb)),
           "grid": "%s!$B$6:$%s$%d" % (q(f9.title), col(1 + nb), 5 + nh)}
    f9.column_dimensions["A"].width = 22

    # --- «Annexe C»: a block per table; «Tableaux»: one line per table, what the sheet looks up
    put(ac, 1, 1, "SIA 261:2020, annexe C : les coefficients des bâtiments, tableaux 31 à 60b, 63 et 64", F_TITLE)
    put(ac, 2, 1, "Lus dans woodwork/data/sia261/tabNN-wind.json. Par tableau : ce qu'est chaque colonne, les valeurs telles qu'imprimées, la plus grande et la plus petite de chaque case (une paire ±x ou a/b compte ses deux valeurs, « * » est calculé directement par la norme).", F_SUB)
    ac.column_dimensions["A"].width = 16
    ac.column_dimensions["B"].width = 16
    cpe_slots = max(sum(1 for c in t["columns"] if c["group"] in ("cpe", "cpe_local")) for t in tables)
    cf_slots = max(sum(1 for c in t["columns"] if c["group"] in ("cf", "cf_snow")) for t in tables)
    heads = ["Tableau", "Titre", "h : b : d", "Toit", "Ligne du bloc", "Lignes", "Colonnes", "h/d du tableau", "b/d du tableau", "Remarques", "Colonnes « * »", "Surfaces sans aire"] + \
            ["c_pi %s" % k for k, _w in OPENINGS] + ["c_f n°%d" % (k + 1) for k in range(cf_slots)] + ["c_pe n°%d" % (k + 1) for k in range(cpe_slots)]
    for j, h in enumerate(heads):
        put(ix, 1, 1 + j, h, F_HEAD, fill=FILL_HEAD)
    ix.column_dimensions["B"].width = 50
    areas = clause["forces"]["areas"]
    start = 4
    rule = clause["c_red"]["directions"]
    for k, t in enumerate(tables):
        S = start + k * BLOCK
        cols = t["columns"]
        index = {c["key"]: i for i, c in enumerate(cols)}
        own = {c["surface"]: index[c["key"]] for c in cols if c["group"] == "cpi"}
        put(ac, S, 1, "Tableau " + t["number"], F_HEAD, fill=FILL_HEAD)
        put(ac, S, 2, t["title"], F_HEAD)
        for name, off in META.items():
            put(ac, S + off, 1, name, F_REF)
        for i, c in enumerate(cols):
            j = 4 + i
            net = c["surface"][:-2] if c.get("surface", "").endswith("_e") else c.get("surface", "")
            put(ac, S + META["label"], j, column_words(c), F_HEAD)
            put(ac, S + META["group"], j, c["group"])
            put(ac, S + META["surface"], j, net if c["group"] in ("cpe", "cpe_local") else "")
            put(ac, S + META["area"], j, c.get("area", "") or "")
            put(ac, S + META["factor"], j, c.get("area_factor") or 1)
            jj = own.get(c.get("surface"), own.get(net + "_i")) if c["group"] in ("cpe", "cpe_local") else None
            put(ac, S + META["own_cpi"], j, 0 if jj is None else jj + 1)
            put(ac, S + META["direct"], j, 1 if any(row["values"][i] == "direct" for row in t["rows"]) else 0)
        for r_, row in enumerate(t["rows"]):
            for block, off in (("shown", 8), ("hi", 14), ("lo", 20)):
                put(ac, S + off + r_, 1, {"shown": "valeurs", "hi": "plus grande", "lo": "plus petite"}[block], F_REF)
                put(ac, S + off + r_, 2, row["label"], F_HEAD if block == "shown" else F_DATA)
                put(ac, S + off + r_, 3, 1 if oblique(row["label"], rule) else 0)
                for i, v in enumerate(row["values"]):
                    shown, hi, lo = cell_values(v)
                    put(ac, S + off + r_, 4 + i, {"shown": shown, "hi": hi, "lo": lo}[block])
        # the line of the index
        rr = 2 + k
        m = re.match(r"^\s*([\d,.]+)\s*:\s*([\d,.]+)\s*:\s*([\d,.]+)\s*$", t.get("ratio") or "")
        hb = [float(x.replace(",", ".")) for x in m.groups()] if m else None
        openings = [c for c in cols if c["group"] == "cpi_opening"]
        chosen = [next((index[c["key"]] + 1 for c in openings if c["opening"] == key), index[openings[0]["key"]] + 1 if openings else 0) for key, _w in OPENINGS]
        cfs = [i + 1 for i, c in enumerate(cols) if c["group"] in ("cf", "cf_snow")]
        cpes = [i + 1 for i, c in enumerate(cols) if c["group"] in ("cpe", "cpe_local")]
        direct = [column_words(c) for i, c in enumerate(cols) if c["group"] in ("cf", "cf_snow") and any(row["values"][i] == "direct" for row in t["rows"])]
        no_area = sorted({column_words(c).split(" (")[1][:-1] for c in cols if c["group"] in ("cf", "cf_snow") and c["area"] not in areas})
        values = [t["number"], t["title"], t.get("ratio") or "", t.get("roof") or "", S, len(t["rows"]), len(cols),
                  hb[0] / hb[2] if hb else "", hb[1] / hb[2] if hb else "", " ; ".join(t.get("notes") or []), ", ".join(direct), ", ".join(no_area)] + \
                 chosen + cfs + [0] * (cf_slots - len(cfs)) + cpes + [0] * (cpe_slots - len(cpes))
        for j, v in enumerate(values):
            put(ix, rr, 1 + j, v, fmt=NUM3 if j in (7, 8) and v != "" else None)
    n = len(tables)
    ixc = lambda j: "%s!$%s$2:$%s$%d" % (q(ix.title), col(j), col(j), 1 + n)
    IX = {h: ixc(1 + j) for j, h in enumerate(heads)}
    acr = "%s!$D$1:$%s$%d" % (q(ac.title), col(3 + MAX_COLS), start + n * BLOCK)

    # --- the sheet
    sh = Sheet(ws)
    sh.title("Action du vent — SIA 261:2020, chapitre 6 et annexe C",
             ["Cellules jaunes : à saisir. Les valeurs de la norme sont dans les feuilles « Données SIA 261 », « Figure 9 », « Annexe C » et « Tableaux ».",
              "Un cas par feuille : pour un autre bâtiment, copier la feuille. Le détail par direction du vent est à droite (colonnes H et suivantes)."])
    sh.line("Désignation du cas", "", "Bâtiment", kind="input", name="designation")
    sh.skip()
    sh.section("1. Données de base")
    qp0 = sh.line("Pression dynamique de référence", "q_p0", 1.1, "kN/m²", "Annexe E", "Carte de l'annexe E : https://261.sia.ch/?lang=fr&layer=wind", "q_p0", "input", NUM2)
    cat = sh.line("Catégorie de terrain", "", "III", "", "Tableau 4", "II rive lacustre · IIa grande plaine · III localité, milieu rural · IV zone urbaine étendue", "categorie", "input",
                  choices='"%s"' % ",".join(t["id"] for t in clause["terrain"]["categories"]))
    b = sh.line("Longueur du bâtiment", "b", 20, "m", "6.3, annexe C", "Dimension de la paroi A (face au vent à φ = 0°).", "b", "input", NUM2)
    dd = sh.line("Largeur du bâtiment", "d", 12, "m", "6.3, annexe C", "Dimension dans la direction du vent à φ = 0°.", "d", "input", NUM2)
    h = sh.line("Hauteur du bâtiment", "h", 8, "m", "6.3, annexe C", "", "h", "input", NUM2)
    z_in = sh.line("Hauteur de référence (vide : z = h)", "z", "", "m", "6.2.2.3", "Vide : la pression au point le plus haut, z = h.", "z_saisi", "input", NUM2)
    cd = sh.line("Coefficient dynamique", "c_d", 1.0, "", "6.3.5", "1,0 sauf si SIA 261/1 en donne un autre.", "c_d", "input", NUM2)
    sh.skip()
    sh.section("2. Bâtiment (annexe C)")
    tab = sh.line("Tableau de l'annexe C", "", "33", "", "Annexe C", "Tableaux 31 à 60b, 63 et 64 (les bâtiments).", "tableau", "input", choices="=" + IX["Tableau"])
    ws[tab].number_format = "@"
    ti = sh.line("Ligne du tableau (index)", "", "=MATCH(%s&\"\",%s,0)" % (tab, IX["Tableau"]), "", "", "", "tableau_n", fmt=NUM0)
    look = lambda h_: "INDEX(%s,%s)" % (IX[h_], ti)
    sh.line("Titre", "", "=" + look("Titre"), "", "", "")
    sh.line("Proportions du tableau h : b : d", "", "=" + look("h : b : d"), "", "", "")
    sh.line("Proportions saisies h/d : b/d : 1", "", '=TEXT(%s/%s,"0.00")&" : "&TEXT(%s/%s,"0.00")&" : 1"' % (h, dd, b, dd), "", "", "")
    sh.line("Toit", "", "=" + look("Toit"), "", "", "")
    op = sh.line("Ouvertures (coefficient de pression intérieure)", "", OPENINGS[0][1], "", "Annexe C", "Pour les tableaux qui donnent c_pi selon les ouvertures (31-45, 58-60b). Les tableaux 46-56 prennent le c_pi de chaque surface, 57a-d, 63 et 64 aucun.",
                 "ouvertures", "input", choices='"%s"' % ",".join(w for _k, w in OPENINGS))
    opn = sh.line("Ouvertures (numéro)", "", '=MATCH(%s,{"%s"},0)' % (op, '","'.join(w for _k, w in OPENINGS)), "", "", "", "ouvertures_n", fmt=NUM0)
    opcol = sh.line("Colonne de c_pi retenue", "", '=IFERROR(INDEX(%s,%s,MATCH("c_pi "&INDEX({"%s"},%s),%s,0)),0)' % (
        "%s!$A$2:$%s$%d" % (q(ix.title), col(len(heads)), 1 + n), ti, '","'.join(k for k, _w in OPENINGS), opn, "%s!$A$1:$%s$1" % (q(ix.title), col(len(heads)))),
        "", "", "0 : le c_pi propre de chaque surface, ou aucun", "cpi_colonne", fmt=NUM0)
    S0 = sh.line("Première ligne du bloc", "", "=" + look("Ligne du bloc"), "", "", "", "bloc", fmt=NUM0)
    nrows = sh.line("Nombre de directions", "", "=" + look("Lignes"), "", "", "", "directions", fmt=NUM0)
    sh.skip()
    sh.section("3. Pression dynamique")
    z = sh.line("Hauteur lue", "z", '=IF(ISNUMBER(%s),%s,%s)' % (z_in, z_in, h), "m", "6.2.2.3", "", "z_lu", fmt=NUM2)
    prof = sh.line("Profil lu", "", '=IF(AND(%s="IV",%s>%s),"III",%s)' % (cat, z, refs["iv_as_iii"], cat), "", "6.2.1.2", "La catégorie IV est lue sur le profil III au-dessus de 30 m.", "profil")
    zu = sh.line("Hauteur au-dessus du sol", "z", '=MAX(%s,IF(%s="IV",%s,%s))' % (z, cat, refs["z_min_IV"], refs["z_min"]), "m", "6.2.1.2", "Au moins 5 m (10 m en catégorie IV).", "z", fmt=NUM2)
    zg = sh.line("Hauteur de gradient", "z_g", "=INDEX(%s,MATCH(%s,%s,0))" % (terr["zg"], prof, terr["ids"]), "m", "Tableau 4", "", "z_g", fmt=NUM0)
    ar = sh.line("Rugosité du sol", "α_r", "=INDEX(%s,MATCH(%s,%s,0))" % (terr["ar"], prof, terr["ids"]), "", "Tableau 4", "", "alpha_r", fmt=NUM2)
    chv = sh.line("Coefficient de profil", "c_h", "=%s*((%s/%s)^%s+%s)^2" % (refs["ch_factor"], zu, zg, ar, refs["ch_offset"]), "", "6.2.1.2 (12)", "c_h = 1,6 · [(z / z_g)^α_r + 0,375]²", "c_h", "result", NUM3)
    qp = sh.line("Pression dynamique", "q_p", "=%s*%s" % (chv, qp0), "kN/m²", "6.2.1.1 (11)", "q_p = c_h · q_p0", "q_p", "result", NUM3)
    sh.skip()
    sh.section("4. Coefficients de réduction (figure 9)")

    def c_red_lines(beta_expr, tag, label):
        """sia261_wind.c_red: linear in h along each curve, linear in log(β) between two curves; below 5 m the first value, beyond a curve its last."""
        bt = sh.line("β = %s" % label, "β", "=" + beta_expr, "", "Figure 9", "", "beta_" + tag, fmt=NUM3)
        hc = "MIN(MAX(%s,%d),%d)" % (h, heights[0], heights[-1])
        i_ = "MIN(INT((%s-%d)/5)+1,%d)" % (hc, heights[0], nh - 1)
        t_ = "(%s-(%d+5*(%s-1)))/5" % (hc, heights[0], i_)
        along = lambda jexpr: "(INDEX(%s,%s,%s)+(INDEX(%s,%s+1,%s)-INDEX(%s,%s,%s))*%s)" % (f9r["grid"], i_, jexpr, f9r["grid"], i_, jexpr, f9r["grid"], i_, jexpr, t_)
        j_ = "MATCH(%s,%s,1)" % (bt, f9r["betas"])
        tb = "(LN(%s)-LN(INDEX(%s,%s)))/(LN(INDEX(%s,%s+1))-LN(INDEX(%s,%s)))" % (bt, f9r["betas"], j_, f9r["betas"], j_, f9r["betas"], j_)
        formula = "=IF(%s<=INDEX(%s,1),%s,IF(%s>=INDEX(%s,%d),%s,%s+(%s-%s)*%s))" % (
            bt, f9r["betas"], along("1"), bt, f9r["betas"], nb, along(str(nb)), along(j_), along(j_ + "+1"), along(j_), tb)
        return bt, sh.line("Coefficient de réduction, surface %s" % label.split(" ")[0].replace("b/h", "b·h").replace("d/h", "d·h"), "c_red,%s" % label.split(" ")[0], formula, "", "Figure 9, 6.3.2",
                           "Pour une direction à moins de 15° des directions de référence ; au-delà, le plus grand des deux (6.3.3).", "c_red_" + tag, "result", NUM3)
    beta_bh, cbh = c_red_lines("%s/%s" % (b, h), "bh", "b/h")
    beta_dh, cdh = c_red_lines("%s/%s" % (dd, h), "dh", "d/h")
    cmax = sh.line("Coefficient de réduction, direction oblique", "c_red,max", "=MAX(%s,%s)" % (cbh, cdh), "", "6.3.3", "Directions à 15° ou plus des directions de référence 0°, 90°, 180°, 270°.", "c_red_max", "result", NUM3)
    sh.line("Coefficient de réduction, toit et autres surfaces", "c_red", "=" + refs["cred_roof"], "", "6.3.2", "", "c_red_toit", fmt=NUM2)
    sh.skip()

    # --- the detail per direction, to the right (wind_forces.global_forces and local_pressures, row by row)
    X = 8   # column H
    widths = [5, 30, 10, 9, 13, 7, 7, 7, 4] + [9] * 6 + [9] * 6 + [9] * 6 + [10, 8, 10, 8, 10, 11, 11]
    for i, w in enumerate(widths):
        ws.column_dimensions[col(X + i)].width = w
    C = {name: X + i for i, name in enumerate(["n", "label", "group", "surface", "area", "factor", "own", "cpi", "direct"])}
    VAL, QMAX, QMIN = X + 9, X + 15, X + 21
    TAIL = X + 27
    C.update({"max": TAIL, "phimax": TAIL + 1, "min": TAIL + 2, "phimin": TAIL + 3, "aref": TAIL + 4, "Qmax": TAIL + 5, "Qmin": TAIL + 6})
    top = 4
    hdr = top + 1
    c0 = ws.cell(top, X, "Détail par direction du vent : coefficients du tableau choisi et q_k = c_red · c_d · c_f · q_p (forces, kN/m²) ou q_p · (c_d · c_pe − c_pi) (pressions, kN/m²)")
    c0.font = F_HEAD
    phi_row, obl_row = hdr, hdr + 1
    labels = ["n°", "Colonne du tableau", "Groupe", "Surface", "Aire de réf.", "Facteur", "c_pi propre", "c_pi lu", "*"]
    for i, t_ in enumerate(labels):
        put(ws, phi_row, X + i, t_, F_HEAD, fill=FILL_HEAD)
        put(ws, obl_row, X + i, "oblique ? (6.3.3)" if i == 1 else "", F_REF)
    for r_ in range(MAX_ROWS):
        for base_, word in ((VAL, ""), (QMAX, "max "), (QMIN, "min ")):
            put(ws, phi_row, base_ + r_, '=IF(%d<=%s,"%s"&INDEX(%s,%s+8+%d,2),"")' % (r_ + 1, nrows, word, "%s!$A$1:$C$%d" % (q(ac.title), start + n * BLOCK), S0, r_, ), F_HEAD, fill=FILL_HEAD)
        put(ws, obl_row, VAL + r_, '=IF(%d<=%s,INDEX(%s,%s+8+%d,3),"")' % (r_ + 1, nrows, "%s!$A$1:$C$%d" % (q(ac.title), start + n * BLOCK), S0, r_), F_REF)
    for i, t_ in enumerate(["q_k max", "φ", "q_k min", "φ", "A_ref [m²]", "Q_k max [kN]", "Q_k min [kN]"]):
        put(ws, phi_row, TAIL + i, t_, F_HEAD, fill=FILL_HEAD)
    # the areas of the force coefficients' headers (sia261_wind.area), the building's own b, d, h
    area_row = top + 2 + MAX_COLS + 2
    put(ws, area_row, X + 1, "Aires de référence des en-têtes (6.2.3.2)", F_HEAD)
    area_cells = {}
    for k, (label, terms) in enumerate(areas.items()):
        rr = area_row + 1 + k
        put(ws, rr, X + 1, label, F_BASE)
        parts = []
        for tm in terms:
            f = "%s" % tm["k"]
            if tm.get("pi"):
                f += "*PI()^%d" % tm["pi"]
            for dim, ref in (("b", b), ("d", dd), ("h", h)):
                if tm.get(dim):
                    f += "*%s^%d" % (ref, tm[dim])
            parts.append(f)
        put(ws, rr, X + 2, "=" + "+".join(parts), F_BASE, NUM2)
        area_cells[label] = rr
    area_labels = "$%s$%d:$%s$%d" % (col(X + 1), area_row + 1, col(X + 1), area_row + len(areas))
    area_values = "$%s$%d:$%s$%d" % (col(X + 2), area_row + 1, col(X + 2), area_row + len(areas))
    meta = lambda key, i: "INDEX(%s,%s+%d,%d)" % (acr, S0, META[key], i)
    for i in range(1, MAX_COLS + 1):
        rr = obl_row + i
        R = lambda name: "$%s%d" % (col(C[name]), rr)
        put(ws, rr, C["n"], i, F_REF)
        inside = "%d<=INDEX(%s,%s)" % (i, IX["Colonnes"], ti)
        put(ws, rr, C["label"], '=IF(%s,%s,"")' % (inside, meta("label", i)))
        put(ws, rr, C["group"], '=IF(%s,%s,"")' % (inside, meta("group", i)), F_REF)
        put(ws, rr, C["surface"], '=IF(%s,%s,"")' % (inside, meta("surface", i)))
        put(ws, rr, C["area"], '=IF(%s,%s,"")' % (inside, meta("area", i)))
        put(ws, rr, C["factor"], '=IF(%s,%s,"")' % (inside, meta("factor", i)), F_REF)
        put(ws, rr, C["own"], '=IF(%s,%s,0)' % (inside, meta("own_cpi", i)), F_REF)
        is_cpe = 'OR(%s="cpe",%s="cpe_local")' % (R("group"), R("group"))
        is_cf = 'OR(%s="cf",%s="cf_snow")' % (R("group"), R("group"))
        put(ws, rr, C["cpi"], "=IF(%s,IF(%s>0,%s,%s),0)" % (is_cpe, opcol, opcol, R("own")), F_REF)
        put(ws, rr, C["direct"], '=IF(%s,%s,0)' % (inside, meta("direct", i)), F_REF)
        for r_ in range(MAX_ROWS):
            live = "AND(%s,%d<=%s)" % (inside, r_ + 1, nrows)
            shown = "INDEX(%s,%s+8+%d,%d)" % (acr, S0, r_, i)
            put(ws, rr, VAL + r_, '=IF(%s,IF(%s="","",%s),"")' % (live, shown, shown), fmt=NUM2)
            hi = "INDEX(%s,%s+14+%d,%d)" % (acr, S0, r_, i)
            lo = "INDEX(%s,%s+20+%d,%d)" % (acr, S0, r_, i)
            obl = "INDEX(%s,%s+8+%d,%d)" % ("%s!$A$1:$C$%d" % (q(ac.title), start + n * BLOCK), S0, r_, 3)
            factor = 'IF(%s="b·h",IF(%s=1,%s,%s),IF(%s="d·h",IF(%s=1,%s,%s),1))' % (R("area"), obl, cmax, cbh, R("area"), obl, cmax, cdh)
            p_lo = "IF(%s=0,0,IF(ISNUMBER(INDEX(%s,%s+20+%d,%s)),INDEX(%s,%s+20+%d,%s),0))" % (R("cpi"), acr, S0, r_, R("cpi"), acr, S0, r_, R("cpi"))
            p_hi = "IF(%s=0,0,IF(ISNUMBER(INDEX(%s,%s+14+%d,%s)),INDEX(%s,%s+14+%d,%s),0))" % (R("cpi"), acr, S0, r_, R("cpi"), acr, S0, r_, R("cpi"))
            for base_, v, p in ((QMAX, hi, p_lo), (QMIN, lo, p_hi)):
                put(ws, rr, base_ + r_, '=IF(AND(%s,ISNUMBER(%s)),IF(%s,%s*%s*%s*%s,IF(AND(%s,%s=0),%s*%s*%s*%s,"")),"")' % (
                    live, v, is_cpe, qp, "(%s*%s-%s)" % (cd, v, p), 1, 1, is_cf, R("direct"), factor, cd, v, qp), fmt=NUM3)
        qmax_rng = "$%s%d:$%s%d" % (col(QMAX), rr, col(QMAX + MAX_ROWS - 1), rr)
        qmin_rng = "$%s%d:$%s%d" % (col(QMIN), rr, col(QMIN + MAX_ROWS - 1), rr)
        phis = "$%s$%d:$%s$%d" % (col(VAL), phi_row, col(VAL + MAX_ROWS - 1), phi_row)
        put(ws, rr, C["max"], '=IF(COUNT(%s)=0,"",MAX(%s))' % (qmax_rng, qmax_rng), F_RESULT, NUM3)
        put(ws, rr, C["phimax"], '=IF(%s="","",INDEX(%s,MATCH(%s,%s,0)))' % (R("max"), phis, R("max"), qmax_rng))
        put(ws, rr, C["min"], '=IF(COUNT(%s)=0,"",MIN(%s))' % (qmin_rng, qmin_rng), F_RESULT, NUM3)
        put(ws, rr, C["phimin"], '=IF(%s="","",INDEX(%s,MATCH(%s,%s,0)))' % (R("min"), phis, R("min"), qmin_rng))
        put(ws, rr, C["aref"], '=IF(AND(%s,%s=0),IFERROR(%s*INDEX(%s,MATCH(%s,%s,0)),"par m²"),"")' % (is_cf, R("direct"), R("factor"), area_values, R("area"), area_labels), fmt=NUM2)
        put(ws, rr, C["Qmax"], '=IF(AND(ISNUMBER(%s),ISNUMBER(%s)),%s*%s,"")' % (R("aref"), R("max"), R("aref"), R("max")), F_RESULT, NUM1)
        put(ws, rr, C["Qmin"], '=IF(AND(ISNUMBER(%s),ISNUMBER(%s)),%s*%s,"")' % (R("aref"), R("min"), R("aref"), R("min")), F_RESULT, NUM1)
    first_detail = obl_row + 1
    detail = lambda name: "$%s$%d:$%s$%d" % (col(C[name]), first_detail, col(C[name]), first_detail + MAX_COLS - 1)

    # --- the results on the left: the forces, then the pressures, slot by slot (Tableaux: the n-th c_f, the n-th c_pe)
    sh.section("5. Forces globales (6.2.3.2)")
    sh.text("q_k = c_red · c_d · c_f · q_p (15), le plus grand et le plus petit sur les directions du tableau ; Q_k = q_k · A_ref. Valeurs négatives : succion.")
    sh.head(["Coefficient de force (aire de référence)", "A_ref [m²]", "q_k max [kN/m²]", "φ", "q_k min [kN/m²]", "Q_k max · Q_k min [kN] (φ)"])
    for k in range(cf_slots):
        rr = sh.row
        idx = "INDEX(%s,%s)" % (IX["c_f n°%d" % (k + 1)], ti)
        get = lambda name: "INDEX(%s,%s)" % (detail(name), idx)
        ws.cell(rr, 1, '=IF(%s=0,"",%s&IF(%s=1," : calculé directement par la norme (*), non calculé ici",""))' % (idx, get("label"), get("direct"))).font = F_BASE
        ws.cell(rr, 2, '=IF(%s=0,"",%s)' % (idx, get("aref"))).number_format = NUM2
        for j, name in ((3, "max"), (4, "phimax"), (5, "min")):
            c_ = ws.cell(rr, j, '=IF(%s=0,"",%s)' % (idx, get(name)))
            c_.number_format = NUM3
            if j != 4:
                c_.font, c_.fill, c_.border = F_RESULT, FILL_RESULT, BOX
        ws.cell(rr, 6, '=IF(%s=0,"",IF(ISNUMBER(%s),TEXT(%s,"0.0")&" · "&TEXT(%s,"0.0")&" kN (φ min "&%s&")","φ min "&%s))' % (idx, get("Qmax"), get("Qmax"), get("Qmin"), get("phimin"), get("phimin"))).font = F_BASE
        sh.name("cf%d_q_max" % (k + 1), "C%d" % rr)
        sh.name("cf%d_q_min" % (k + 1), "E%d" % rr)
        sh.row += 1
    sh.skip()
    sh.section("6. Pressions locales (6.2.2.1)")
    sh.text("q_k = q_p · (c_d · c_pe − c_pi) (13), (14), sans c_red (6.3.1) : la plus grande pression et la plus grande succion sur les directions du tableau.")
    sh.head(["Surface (type)", "c_pi lu", "q_k max [kN/m²]", "φ", "q_k min [kN/m²]", "φ du min"])
    for k in range(cpe_slots):
        rr = sh.row
        idx = "INDEX(%s,%s)" % (IX["c_pe n°%d" % (k + 1)], ti)
        get = lambda name: "INDEX(%s,%s)" % (detail(name), idx)
        kind = 'IF(%s="cpe_local","locale",IF(RIGHT(%s,1)="°","point",IF(ISNUMBER(MATCH(LEFT(%s,1),{"A","B","C","D"},0))*(LEN(%s)<=2),"paroi","toit")))' % (get("group"), get("surface"), get("surface"), get("surface"))
        ws.cell(rr, 1, '=IF(%s=0,"",%s&" ("&%s&")")' % (idx, get("surface"), kind)).font = F_BASE
        ws.cell(rr, 2, '=IF(%s=0,"",IF(%s=0,"0",INDEX(%s,%s+%d,%s)))' % (idx, get("cpi"), acr, S0, META["label"], get("cpi"))).font = F_REF
        for j, name in ((3, "max"), (4, "phimax"), (5, "min"), (6, "phimin")):
            c_ = ws.cell(rr, j, '=IF(%s=0,"",IF(%s="","—",%s))' % (idx, get(name), get(name)))
            c_.number_format = NUM3
            if j in (3, 5):
                c_.font, c_.fill, c_.border = F_RESULT, FILL_RESULT, BOX
        sh.name("cpe%d_q_max" % (k + 1), "C%d" % rr)
        sh.name("cpe%d_q_min" % (k + 1), "E%d" % rr)
        sh.row += 1
    sh.skip()

    # --- the state (wind_source._problems and messages)
    pos = lambda ref: "OR(NOT(ISNUMBER(%s)),N(%s)<=0)" % (ref, ref)
    def in_range(beta):
        """Not sia261_wind.in_range: β outside the curves, or h below the first height or beyond the end of the two curves around β (the pair below and above, the lower one first where β is a curve's own)."""
        j = "MATCH(%s,%s,1)" % (beta, f9r["betas"])
        j = "IF(AND(INDEX(%s,%s)=%s,%s>1),%s-1,%s)" % (f9r["betas"], j, beta, j, j, j)
        return "IFERROR(OR(%s<INDEX(%s,1),%s>INDEX(%s,%d),%s<%d,%s>MIN(INDEX(%s,%s),INDEX(%s,MIN(%s+1,%d)))),TRUE)" % (
            beta, f9r["betas"], beta, f9r["betas"], nb, h, heights[0], h, f9r["hend"], j, f9r["hend"], j, nb)
    ratio_off = "AND(ISNUMBER(%s),ISNUMBER(%s),OR(MAX(%s/%s/%s,%s/(%s/%s))>%s,MAX(%s/%s/%s,%s/(%s/%s))>%s))" % (
        look("h/d du tableau"), look("b/d du tableau"),
        h, dd, look("h/d du tableau"), look("h/d du tableau"), h, dd, refs["ratio_spread"],
        b, dd, look("b/d du tableau"), look("b/d du tableau"), b, dd, refs["ratio_spread"])
    items = [
        ("error", pos(qp0), "q_p0 : la pression dynamique de référence de l'annexe E, en kN/m², plus grande que 0."),
        ("error", 'ISNA(MATCH(%s,%s,0))' % (cat, terr["ids"]), "Catégorie de terrain : II, IIa, III ou IV (tableau 4)."),
        ("error", pos(b), "b : une dimension du bâtiment en m, plus grande que 0."),
        ("error", pos(dd), "d : une dimension du bâtiment en m, plus grande que 0."),
        ("error", pos(h), "h : une dimension du bâtiment en m, plus grande que 0."),
        ("error", "AND(ISNUMBER(%s),N(%s)>%s)" % (h, h, refs["max_height"]), '="h = "&%s&" m : les dispositions valent pour les bâtiments jusqu\'à "&%s&" m (6.1.2)."' % (h, refs["max_height"])),
        ("error", 'AND(%s<>"",OR(NOT(ISNUMBER(%s)),N(%s)<=0))' % (z_in, z_in, z_in), "z : la hauteur au-dessus du sol en m, ou vide pour z = h."),
        ("error", "ISNA(%s)" % ti, "Tableau : un des bâtiments de l'annexe C (31 à 60b, 63, 64)."),
        ("error", pos(cd), "c_d : le coefficient dynamique, plus grand que 0 (1,0 selon 6.3.5)."),
        ("error", "ISNA(%s)" % opn, "Ouvertures : réparties ou une ouverture dominante dans la paroi A, B, C ou D."),
        ("info", "AND(ISNUMBER(%s),%s<%s)" % (z, z, zu), '="z = "&%s&" m est relevé à "&%s&" m (6.2.1.2)."' % (z, zu)),
        ("info", 'AND(%s="IV",%s<>%s)' % (cat, prof, cat), "Catégorie IV au-dessus de 30 m : lue sur le profil de la catégorie III (6.2.1.2)."),
        ("info", "AND(ISNUMBER(%s),%s>%s,%s=%s)" % (h, h, refs["cd_height"], cd, refs["cd_default"]), "h dépasse 15 m : c_d = 1,0 ne vaut que pour les bâtiments que nomme 6.3.5."),
        ("info", "AND(ISNUMBER(%s),ISNUMBER(%s),%s)" % (h, beta_bh, in_range(beta_bh)), '="Surface b·h : h = "&%s&" m et β = "&TEXT(%s,"0.000")&" ne sont pas dessinés par la figure 9 ; c_red est lu au bout de la courbe la plus proche."' % (h, beta_bh)),
        ("info", "AND(ISNUMBER(%s),ISNUMBER(%s),%s)" % (h, beta_dh, in_range(beta_dh)), '="Surface d·h : h = "&%s&" m et β = "&TEXT(%s,"0.000")&" ne sont pas dessinés par la figure 9 ; c_red est lu au bout de la courbe la plus proche."' % (h, beta_dh)),
        ("info", "AND(NOT(ISNA(%s)),%s)" % (ti, ratio_off), '="Proportions saisies "&TEXT(%s/%s,"0.00")&" : "&TEXT(%s/%s,"0.00")&" : 1 loin de celles du tableau ("&%s&") : le tableau convient-il ?"' % (h, dd, b, dd, look("h : b : d"))),
        ("info", 'AND(NOT(ISNA(%s)),%s<>"")' % (ti, look("Colonnes « * »")), '="Tableau "&%s&" : "&%s&" calculé directement par la norme (*), non calculé ici."' % (tab, look("Colonnes « * »"))),
        ("info", 'AND(NOT(ISNA(%s)),%s<>"")' % (ti, look("Surfaces sans aire")), '="Tableau "&%s&" : aire de référence "&%s&" non tirée de b, d, h ; la force est donnée par m² seulement."' % (tab, look("Surfaces sans aire"))),
        ("info", 'AND(NOT(ISNA(%s)),%s<>"")' % (ti, look("Remarques")), '="Remarque du tableau : "&%s' % look("Remarques")),
    ]
    messages_block(sh, items)
    ws.freeze_panes = "A4"
    return finish(wb, OUT / "vent.xlsx")


# --- the permanent loads (Woodcore: calc/domains/dead_load_layers.py, dead_load_source.py, the «Poids propre et surcharge» tab) --

KINDS = [("gk", "g_k"), ("ak", "a_k")]
POSES = [("continuous", "continue"), ("spaced", "à entraxe"), ("surface", "par surface"), ("typed", "charge saisie")]
ORIGINS = {"sia261": "SIA 261", "sia265": "SIA 265", "sia265-1": "SIA 265/1", "ext": "classeur"}
CATEGORIES = {"board": "panneau", "conc": "béton, maçonnerie", "fill": "remblai, gravier", "floor": "revêtement de sol", "gyps": "plâtre",
              "ins": "isolation", "memb": "lé, membrane", "metal": "métal", "tile": "couverture", "wood": "bois"}
LIVE_FR = {"A1": "Surfaces habitables", "A2": "Balcons", "A3": "Escaliers", "B": "Bureaux", "C1": "Salles avec tables et chaises", "C2": "Salles à sièges fixes",
           "C3": "Surfaces librement accessibles, sport, foule", "D": "Surfaces de vente", "E": "Entrepôts et fabrication", "F": "Parkings et circulation, véhicules < 3,5 t",
           "G": "Parkings et circulation, véhicules de 3,5 à 16 t", "H": "Toitures non accessibles"}
LAYERS = 15
OWN_MATERIALS = 30


def material_names(materials):
    """{id: the name the list shows}: the French name, its origin added where two materials share it."""
    count = {}
    for m in materials:
        count[m["names"]["fr"]] = count.get(m["names"]["fr"], 0) + 1
    return {m["id"]: m["names"]["fr"] + (" (%s)" % ORIGINS[m["origin"]] if count[m["names"]["fr"]] > 1 else "") for m in materials}


def composition_sheet(wb, title, mat, roles, template=None):
    ws = wb.create_sheet(title)
    sh = Sheet(ws, widths=(5, 7, 13, 44, 20, 9, 8, 9, 9, 9, 10, 10, 9, 11, 11, 11, 40, 50))
    T = lambda n: col(n)
    sh.title("Poids propre et surcharge — composition", [
        "Cellules jaunes : à saisir. Une couche par ligne, de haut en bas. Le matériau se choisit dans la liste (feuille « Matériaux », où l'on ajoute les siens).",
        "Charge d'une couche : continue γ · t · w / 1000 ; à entraxe γ · t · b / e ; par surface le poids surfacique ; charge saisie la valeur tapée. Une charge imposée remplace la charge calculée.",
        "« Liée à la ligne du dessous » : deux lignes au même niveau (chevrons et isolation entre eux) ; la ligne qui n'est pas à entraxe remplit l'espace entre les pièces, w = 1000 · (1 − b/e)."])
    r = sh.row
    ws.cell(r, 1, "Désignation").font = F_HEAD
    c = ws.cell(r, 4, template["names"]["fr"] if template else "Composition")
    c.font, c.fill, c.border = F_INPUT, FILL_INPUT, BOX
    sh.name("designation", "D%d" % r)
    sh.row += 1
    if template:
        ref = template["reference"]
        sh.text("Modèle : %s, %s, p. %s." % (ref["book"], ref["where"], ref["page"]))
        sh.text("Hypothèses : " + template["assumptions"]["fr"])
        if template.get("book_weight"):
            bw = template["book_weight"]
            sh.text("Poids donné par le livre : %s %s (contrôle de la somme)." % (bw["value"], bw["unit"]))
    sh.skip()
    head = ["n°", "Type", "Pose", "Matériau", "Rôle (facultatif)", "Poids", "Unité", "t [mm]", "b [mm]", "e [mm]", "Liée à la ligne du dessous", "Remplir l'espace",
            "w [mm]", "Charge calculée [kN/m²]", "Charge imposée [kN/m²]", "Charge retenue [kN/m²]", "Calcul", "Remarque"]
    sh.head(head)
    ws.row_dimensions[sh.row - 1].height = 40
    first = sh.row
    last = first + LAYERS - 1
    dv = {name: DataValidation(type="list", formula1=f, allow_blank=True) for name, f in (
        ("kind", '"%s"' % ",".join(w for _k, w in KINDS)), ("pose", '"%s"' % ",".join(w for _k, w in POSES)), ("mat", "=" + mat["names"]),
        ("role", "=" + roles), ("yes", '"oui,non"'))}
    for v in dv.values():
        ws.add_data_validation(v)
    layers = (template or {}).get("layers") or []
    names, aliases = mat["by_id"], mat["aliases"]
    for i in range(LAYERS):
        r = first + i
        layer = layers[i] if i < len(layers) else None
        put(ws, r, 1, i + 1, F_REF)
        inputs = {2: ("kind", dict(KINDS)[layer["kind"]] if layer else None), 3: ("pose", dict(POSES)[layer["pose"]] if layer else None),
                  4: ("mat", names.get(aliases.get(layer["material"], layer["material"])) if layer and layer.get("material") else (layer.get("label") if layer else None)),
                  5: ("role", mat["role_words"].get(layer.get("role")) if layer and layer.get("role") else None),
                  8: (None, layer.get("thickness") if layer else None), 9: (None, layer.get("width") if layer else None), 10: (None, layer.get("spacing") if layer else None),
                  11: ("yes", ("oui" if layer.get("link") else "non") if layer else None), 12: ("yes", ("oui" if layer.get("fill", True) else "non") if layer else None),
                  15: (None, layer.get("load") if layer else None)}
        for j, (v, value) in inputs.items():
            c = ws.cell(r, j, value)
            c.font, c.fill, c.border = F_INPUT, FILL_INPUT, BOX
            if v:
                dv[v].add(c)
        ref = lambda j, rr=r: "$%s%d" % (T(j), rr)
        used = 'OR(%s<>"",%s="charge saisie")' % (ref(4), ref(3))
        put(ws, r, 6, '=IF(OR(%s="",%s="charge saisie"),"",IFERROR(INDEX(%s,MATCH(%s,%s,0)),"?"))' % (ref(4), ref(3), mat["values"], ref(4), mat["names"]), F_BASE, NUM2)
        put(ws, r, 7, '=IF(OR(%s="",%s="charge saisie"),"",IFERROR(INDEX(%s,MATCH(%s,%s,0)),""))' % (ref(4), ref(3), mat["units"], ref(4), mat["names"]), F_BASE)
        # the pose the material's unit asks (dead_load_layers.pose_for): a weight per m² is laid «par surface», a weight per m³ never is
        pose = 'IF(%s="charge saisie","charge saisie",IF(%s="kN/m²","par surface",IF(%s="par surface","continue",IF(%s="","continue",%s))))' % (ref(3), ref(7), ref(3), ref(3), ref(3))
        put(ws, r, 19, "=" + pose, F_REF)   # S: the pose computed with
        P = ref(19)
        # the partner on the same level (dead_load_layers.levels): the line below where this one is linked, the line above where that one is
        below = "AND(%s=\"oui\",%d<%d,%s<>\"oui\")" % (ref(11), r, last, "$K%d" % (r + 1) if r < last else '""')
        above = "AND(%d>%d,%s=\"oui\",%s<>\"oui\")" % (r, first, "$K%d" % (r - 1) if r > first else '""', ref(11))
        share = lambda rr: 'IF(AND($S%d="à entraxe",ISNUMBER($I%d),ISNUMBER($J%d),N($J%d)>0),$I%d/$J%d,0)' % (rr, rr, rr, rr, rr, rr)
        partner_spaced = lambda rr: '$S%d="à entraxe"' % rr
        if r < last and r > first:
            p_spaced = "OR(AND(%s,%s),AND(%s,%s))" % (below, partner_spaced(r + 1), above, partner_spaced(r - 1))
            p_share = "IF(%s,%s,IF(%s,%s,0))" % (below, share(r + 1), above, share(r - 1))
            has_partner = "OR(%s,%s)" % (below, above)
        elif r < last:
            p_spaced, p_share, has_partner = "AND(%s,%s)" % (below, partner_spaced(r + 1)), "IF(%s,%s,0)" % (below, share(r + 1)), below
        else:
            p_spaced, p_share, has_partner = "AND(%s,%s)" % (above, partner_spaced(r - 1)), "IF(%s,%s,0)" % (above, share(r - 1)), above
        put(ws, r, 13, '=IF(NOT(%s),"",IF(OR(%s="à entraxe",%s="charge saisie",%s="par surface"),"",IF(AND(%s,%s<>"non"),MAX(0,1000*(1-%s)),IF(AND(%s,%s="non"),IF(ISNUMBER(%s),%s,1000),1000))))' % (
            used, P, P, P, p_spaced, ref(12), p_share, has_partner, ref(12), ref(9), ref(9)), F_BASE, NUM0)
        g, t, b, e, w = ref(6), ref(8), ref(9), ref(10), ref(13)
        calc = 'IF(NOT(%s),"",IF(%s="charge saisie","",IF(NOT(ISNUMBER(%s)),"",IF(%s="par surface",%s,IF(NOT(ISNUMBER(%s)),"",IF(%s="à entraxe",IF(AND(ISNUMBER(%s),ISNUMBER(%s),N(%s)>0),%s*%s/1000*%s/%s,""),%s*%s/1000*%s/1000))))))' % (
            used, P, g, P, g, t, P, b, e, e, g, t, b, e, g, t, w)
        put(ws, r, 14, "=" + calc, F_BASE, NUM3)
        c = ws.cell(r, 16, '=IF(ISNUMBER(%s),%s,IF(ISNUMBER(%s),%s,""))' % (ref(15), ref(15), ref(14), ref(14)))
        c.font, c.fill, c.border, c.number_format = F_RESULT, FILL_RESULT, BOX, NUM3
        n3 = lambda x: 'SUBSTITUTE(TEXT(%s,"0.###"),",",".")' % x
        formula = 'IF(NOT(ISNUMBER(%s)),"",IF(%s="par surface",%s&" kN/m²",%s&" kN/m³ × "&%s&" m"&IF(%s="à entraxe"," × "&%s&"/"&%s,IF(AND(ISNUMBER(%s),%s<>1000)," × "&%s&"/1000",""))&" = "&TEXT(%s,"0.000")&" kN/m²"))' % (
            ref(14), P, n3(g), n3(g), n3(t + "/1000"), P, b, e, w, w, n3(w), ref(14))
        put(ws, r, 17, "=" + formula, F_REF)
        # what the line says (dead_load_messages): the first problem of the line, red in the state below
        problems = [
            ('AND(%s<>"",%s<>"charge saisie",%s="?")' % (ref(4), ref(3), g), '"matériau inconnu de la feuille Matériaux"'),
            ('AND(%s<>"",%s<>"charge saisie",%s="")' % (ref(4), ref(3), g), '"matériau sans poids"'),
            ('AND(%s,%s="")' % (used, ref(2)), '"type g_k ou a_k manquant"'),
            ('AND(%s="charge saisie",NOT(ISNUMBER(%s)))' % (ref(3), ref(15)), '"charge saisie sans valeur (colonne Charge imposée)"'),
            ('AND(%s,OR(%s="continue",%s="à entraxe"),NOT(ISNUMBER(%s)),NOT(ISNUMBER(%s)))' % (used, P, P, t, ref(15)), '"épaisseur t manquante"'),
            ('AND(%s,%s="à entraxe",OR(NOT(ISNUMBER(%s)),NOT(ISNUMBER(%s)),N(%s)<=0),NOT(ISNUMBER(%s)))' % (used, P, b, e, e, ref(15)), '"largeur b ou entraxe e manquant"'),
            ('AND(%s="oui",%s)' % (ref(11), "TRUE" if r == last else 'AND($D%d="",$C%d<>"charge saisie")' % (r + 1, r + 1)), '"liée à une ligne du dessous qui n\'existe pas"'),
            ('AND(%s="oui",%s)' % (ref(11), '$K%d="oui"' % (r - 1) if r > first else "FALSE"), '"une troisième ligne au même niveau : deux au plus"'),
            ('AND(%s,%s="à entraxe",%s)' % (below if r < last else "FALSE", P, '$S%d="à entraxe"' % (r + 1) if r < last else "FALSE"), '"deux lignes à entraxe au même niveau"'),
            ('AND(%s,%s<>"à entraxe",%s<>"charge saisie",%s)' % (below if r < last else "FALSE", P, P, '$S%d<>"à entraxe"' % (r + 1) + ',$S%d<>"charge saisie"' % (r + 1) if r < last else "FALSE"), '"deux lignes qui remplissent au même niveau : l\'une doit être à entraxe"'),
            ('AND(%s<>"",%s<>"",%s<>%s,%s<>"charge saisie")' % (ref(4), ref(7), P, "IF(%s=\"\",\"continue\",%s)" % (ref(3), ref(3)), ref(3)), '"pose lue : "&%s&" (unité du matériau)"' % P),
            ('ISNUMBER(%s)*ISNUMBER(%s)*(%s<>"charge saisie")=1' % (ref(15), ref(14), ref(3)), '"charge imposée à la place de "&TEXT(%s,"0.000")&" kN/m²"' % ref(14)),
        ]
        expr = '""'
        for cond, text in reversed(problems):
            expr = "IF(%s,%s,%s)" % (cond, text, expr)
        put(ws, r, 18, "=" + expr, Font(name=FONT, size=9, color="C00000"))
        put(ws, r, 20, '=IF(%s="","",IFERROR(INDEX(%s,MATCH(%s,%s,0)),""))' % (ref(4), mat["battens"], ref(4), mat["names"]), F_REF)   # T: «oui» where the tile carries its battens
    ws.column_dimensions["S"].hidden = True
    ws.column_dimensions["T"].hidden = True
    sh.row = last + 2
    rng = lambda j: "$%s$%d:$%s$%d" % (T(j), first, T(j), last)
    def total(label, symbol, value, unit, remark, name, kind="calc", fmt=NUM3):
        """A line of the sums, its label in the material's wide column D and its value in F."""
        r_ = sh.row
        ws.cell(r_, 4, label).font = F_BASE
        ws.cell(r_, 5, symbol).font = F_BASE
        c_ = ws.cell(r_, 6, value)
        c_.border, c_.number_format = BOX, fmt
        c_.font, c_.fill = {"input": (F_INPUT, FILL_INPUT), "result": (F_RESULT, FILL_RESULT)}.get(kind, (F_BASE, PatternFill()))
        ws.cell(r_, 7, unit).font = F_BASE
        ws.cell(r_, 8, remark).font = F_REF
        sh.name(name, "F%d" % r_)
        sh.row += 1
        return "F%d" % r_
    gk = total("Poids propre", "g_k", '=SUMIF(%s,"g_k",%s)' % (rng(2), rng(16)), "kN/m²", "", "g_k", "result")
    ak = total("Surcharge (charges permanentes ajoutées)", "a_k", '=SUMIF(%s,"a_k",%s)' % (rng(2), rng(16)), "kN/m²", "", "a_k", "result")
    tot = total("Somme", "g_k + a_k", "=%s+%s" % (gk, ak), "kN/m²", "", "somme", "result")
    auto = total("Valeur arrondie au dixième supérieur", "", "=IF(%s>0,CEILING(ROUND(%s*10,9)-1E-9,1)/10,0)" % (tot, tot), "kN/m²", "0,909 → 1,0 ; 0,900 → 0,9", "auto", fmt=NUM1)
    own = total("Valeur retenue imposée (facultatif)", "", (template or {}).get("chosen"), "kN/m²", "", "impose", "input", NUM2)
    total("Valeur retenue", "g_k + a_k", '=IF(ISNUMBER(%s),%s,%s)' % (own, own, auto), "kN/m²", "", "retenue", "result", NUM2)
    total("Soit", "", "=%s*100" % tot, "kg/m²", "g = 10 m/s²", "kg", fmt=NUM0)
    sh.skip()
    items = [("error", "COUNTIF(%s,\"?*\")-COUNTIF(%s,\"pose lue*\")-COUNTIF(%s,\"charge imposée*\")>0" % (rng(18), rng(18), rng(18)),
              '="Une ligne au moins a une remarque en rouge (colonne Remarque) : la somme n\'est pas complète."'),
             ("info", 'AND(COUNTIF(%s,"oui")>0,COUNTIF(%s,"%s")+COUNTIF(%s,"%s")>0)' % (rng(20), rng(5), mat["role_words"]["roof_battens"], rng(5), mat["role_words"]["counter_battens"]),
              "Une tuile « lattage compris » (SIA 261, tableau 29) et des lattes de toiture ou contre-lattes : le lattage est-il compté deux fois ?"),
             ("info", "ISNUMBER(%s)" % own, '="Valeur retenue imposée à la place de "&TEXT(%s,"0.0")&" kN/m²."' % auto)]
    messages_block(sh, items, width=18)
    ws.freeze_panes = ws.cell(first, 1)
    return ws


def build_dead_load():
    lib = json.loads((SOURCE / "materials.json").read_text(encoding="utf-8"))
    templates = json.loads((SOURCE / "dead-load-templates.json").read_text(encoding="utf-8"))["templates"]
    live = norm("tab08-nutzlasten")["table_8"]
    wb = Workbook()
    over = wb.active
    over.title = "Vue d'ensemble"
    mat_ws = wb.create_sheet("Matériaux")
    roles_ws = wb.create_sheet("Rôles")
    live_ws = wb.create_sheet("Charges utiles")

    # --- «Matériaux»: Woodcore's catalogue, then the engineer's own lines
    names = material_names(lib["materials"])
    mat_ws.sheet_view.showGridLines = False
    put(mat_ws, 1, 1, "Matériaux : poids volumiques et surfaciques", F_TITLE)
    put(mat_ws, 2, 1, "SIA 261:2020 tableaux 28 à 30 (woodwork/data/sia261/), les classes de SIA 265 et les panneaux de SIA 265/1 pesés comme le bois de SIA 261, et la bibliothèque du classeur de charges du bureau (« classeur »). Ses propres matériaux s'ajoutent dans les lignes jaunes, en bas.", F_SUB)
    heads = ["Nom (liste des compositions)", "Catégorie", "Origine", "Poids", "Unité", "Lattage compris", "Source du poids", "Id"]
    for j, h_ in enumerate(heads):
        put(mat_ws, 4, 1 + j, h_, F_HEAD, fill=FILL_HEAD)
    for j, w_ in enumerate((52, 18, 11, 9, 8, 9, 70, 40)):
        mat_ws.column_dimensions[col(1 + j)].width = w_
    r = 5
    for m in lib["materials"]:
        for j, v in enumerate((names[m["id"]], CATEGORIES.get(m["category"], m["category"] or ""), ORIGINS[m["origin"]], m["value"], m["unit"] or "",
                               "oui" if m["includes_battens"] else "", m["ref"], m["id"])):
            put(mat_ws, r, 1 + j, v, fmt=NUM2 if j == 3 else None)
        r += 1
    put(mat_ws, r, 1, "Mes matériaux (à compléter : nom, poids, unité kN/m³ ou kN/m²)", F_HEAD)
    r += 1
    unit_dv = DataValidation(type="list", formula1='"kN/m³,kN/m²"', allow_blank=True)
    mat_ws.add_data_validation(unit_dv)
    for i in range(OWN_MATERIALS):
        for j in (1, 2, 4, 5, 7):
            c = mat_ws.cell(r, j)
            c.fill, c.font = FILL_INPUT, F_INPUT
        put(mat_ws, r, 3, "personnel", F_REF)
        unit_dv.add(mat_ws.cell(r, 5))
        r += 1
    last = r - 1
    mq = quoted(mat_ws.title)
    mat = {"names": "%s!$A$5:$A$%d" % (mq, last), "values": "%s!$D$5:$D$%d" % (mq, last), "units": "%s!$E$5:$E$%d" % (mq, last),
           "battens": "%s!$F$5:$F$%d" % (mq, last), "by_id": names, "aliases": lib["aliases"],
           "role_words": {k: v["fr"] for k, v in lib["roles"].items()}}
    mat_ws.freeze_panes = "A5"
    mat_ws.auto_filter.ref = "A4:H%d" % last

    put(roles_ws, 1, 1, "Rôles d'une couche (facultatifs)", F_HEAD)
    for i, (k, v) in enumerate(lib["roles"].items()):
        put(roles_ws, 2 + i, 1, v["fr"])
    roles_ws.column_dimensions["A"].width = 30
    roles = "%s!$A$2:$A$%d" % (quoted(roles_ws.title), 1 + len(lib["roles"]))

    # --- «Charges utiles»: SIA 261 Tabelle 8, for reference
    live_ws.sheet_view.showGridLines = False
    put(live_ws, 1, 1, "Charges utiles : SIA 261:2020, tableau 8 (8.2.1)", F_TITLE)
    put(live_ws, 2, 1, "Lu dans woodwork/data/sia261/tab08-nutzlasten.json, transcrit de l'édition allemande. La désignation française est une traduction de Woodwork. La catégorie E est à fixer pour le projet (8.2.2).", F_SUB)
    for j, h_ in enumerate(("Catégorie", "Désignation", "Nutzfläche (SIA 261)", "Beispiel (SIA 261)", "q_k [kN/m²]", "Q_k [kN]", "Notes")):
        put(live_ws, 4, 1 + j, h_, F_HEAD, fill=FILL_HEAD)
    for i, c_ in enumerate(live["categories"]):
        notes = sorted(set(c_["notes_q"] + c_["notes_Q"] + c_["notes_category"]))
        for j, v in enumerate((c_["id"], LIVE_FR.get(c_["id"], ""), c_["nutzflaeche"], c_["beispiel"], c_["q_k"] if c_["q_k"] is not None else "à fixer",
                               c_["Q_k"] if c_["Q_k"] is not None else "à fixer", ", ".join(notes))):
            put(live_ws, 5 + i, 1 + j, v)
    rr = 6 + len(live["categories"])
    for k, v in live["notes"].items():
        put(live_ws, rr, 1, k, F_REF)
        put(live_ws, rr, 2, v, F_REF)
        rr += 1
    for j, w_ in enumerate((10, 40, 40, 60, 12, 10, 10)):
        live_ws.column_dimensions[col(1 + j)].width = w_

    # --- the build-ups: two empty, then Lignum's eight
    sheets = [composition_sheet(wb, "Composition 1", mat, roles), composition_sheet(wb, "Composition 2", mat, roles)]
    for tpl in templates:
        first_, *rest = tpl["id"].removeprefix("lignum-").split("-")
        title = "Lignum " + " ".join([first_.upper()] + rest)
        sheets.append(composition_sheet(wb, title[:31], mat, roles, tpl))
    # the sheets in their order: the overview, the build-ups, then the lists
    order = [over] + sheets + [mat_ws, roles_ws, live_ws]
    wb._sheets = order

    # --- «Vue d'ensemble»
    over.sheet_view.showGridLines = False
    put(over, 1, 1, "Poids propre et surcharge — vue d'ensemble", F_TITLE)
    put(over, 2, 1, "Une ligne par feuille de composition. Pour une composition de plus, copier une feuille (clic droit sur l'onglet, « Déplacer ou copier », « Créer une copie ») et ajouter sa ligne ici.", F_SUB)
    for j, h_ in enumerate(("Feuille", "Désignation", "g_k [kN/m²]", "a_k [kN/m²]", "g_k + a_k [kN/m²]", "Valeur retenue [kN/m²]", "État")):
        put(over, 4, 1 + j, h_, F_HEAD, fill=FILL_HEAD)
    for i, s_ in enumerate(sheets):
        rr = 5 + i
        qn = quoted(s_.title)
        put(over, rr, 1, s_.title, F_BASE)
        put(over, rr, 2, "=%s!designation" % qn, F_BASE)
        for j, name in enumerate(("g_k", "a_k", "somme")):
            put(over, rr, 3 + j, "=%s!%s" % (qn, name), F_BASE, NUM3)
        put(over, rr, 6, "=%s!retenue" % qn, F_RESULT, NUM1)
        put(over, rr, 7, '=IF(%s!calcul_valide="Toutes les entrées sont là, le calcul est fait.","complète","à corriger")' % qn, F_BASE)
    for j, w_ in enumerate((28, 50, 12, 12, 14, 18, 12)):
        over.column_dimensions[col(1 + j)].width = w_
    return finish(wb, OUT / "poids-propre-et-surcharge.xlsx")


def main():
    for build in (build_snow, build_wind, build_dead_load):
        print(build().relative_to(ROOT))


if __name__ == "__main__":
    main()
