// woodwork/lib/material.typ -- #material: a strength class read from woodwork/data/, its design values published as variables of the domain it stands in (founding spec REQ-009).
//
// The rule is Woodcore's (calc/domains/member_check_material.py, Strengths._grade, 4 Nov 2026): SIA 265 Tabelle 8 and 9 give **design** values, which the moisture class (η_w, Tabelle 4, its «resistance» column) and impact (η_t, 2.2.6) multiply -- f_d = η_w · η_t · f_d,Tab. The moduli, the density and f_m,k are published as the table gives them. Every value is a #var or an #eq, so it is printed, cited and computed as every other line of a sheet.

#import "formula.typ": var, eq

// The tables of SIA 265 a class is looked up in, in order: solid timber (Tabelle 8), glulam (Tabelle 9).
#let material-tables = (
  (file: "../data/sia265/tab08-vollholz.json", key: "table_8", cite: "Tab. 8"),
  (file: "../data/sia265/tab09-brettschichtholz.json", key: "table_9", cite: "Tab. 9"),
)
#let eta-w-table = json("../data/sia265/tab04-eta-w.json").table_4
#let eta-t-clause = json("../data/sia265/2.2.6-eta-t.json").eta_t
// The office's own materials: one file, a list under `materials`, each with an `id`, its `_source` and its design values (docs/typst/commands.md, «#material»).
#let my-materials-file = "../data/my-materials/materials.json"

// The strengths a moisture class and impact multiply, and the values published as the table gives them.
#let material-strengths = ("f_m_d", "f_t_0_d", "f_c_0_d", "f_t_90_d", "f_c_90_d", "f_v_d")
#let material-as-given = ("f_m_k", "E_m_mean", "E_0_mean", "E_90_mean", "G_mean", "rho_k")
#let material-units = (rho_k: "kg/m³")
// The cases of f_c,90,d in Tabelle 8 and 9.
#let material-cases = ("generell", "mit_vorholz", "endauflagerung")

// The row of a class, and where it was read: a table of SIA 265, else the office's file.
#let material-row(id) = {
  for t in material-tables {
    let table = json(t.file).at(t.key)
    let row = table.grades.find(g => g.id == id)
    if row != none { return (row: row, norm: "SIA 265", cite: t.cite, table: table) }
  }
  let own = json(my-materials-file).materials
  let row = own.find(m => m.id == id)
  if row != none { return (row: row, norm: row.at("norm", default: none), cite: row.at("norm_ref", default: ""), table: none) }
  panic("material: no class " + repr(id) + " in SIA 265 Tabelle 8 or 9 (woodwork/data/sia265/tab08-vollholz.json, tab09-brettschichtholz.json) nor in woodwork/data/my-materials/materials.json -- the classes there are "
    + (material-tables.map(t => json(t.file).at(t.key).grades.map(g => g.id)).flatten() + own.map(m => m.id)).join(", "))
}

// f_c,90,d of a row for one of its cases, the bracketed value where `larger` says the larger indentations do not matter.
#let material-c90(row, case, larger) = {
  let cell = row.at("f_c_90_d", default: none)
  if cell == none { return none }
  if type(cell) != dictionary { return cell }
  if not (case in cell) { panic("material: f_c_90_d has no case " + repr(case) + " -- the cases are " + cell.keys().map(k => repr(k)).join(", ")) }
  let c = cell.at(case)
  if type(c) != dictionary { return c }
  if larger { c.at("groessere_eindrueckungen", default: c.value) } else { c.value }
}

/// A strength class: reads it in SIA 265 Tabelle 8 or 9 (`woodwork/data/sia265/`), else in the office's `woodwork/data/my-materials/materials.json`, and publishes its values as variables of the domain it stands in -- the design strengths `f_m_d`, `f_t_0_d`, `f_c_0_d`, `f_t_90_d`, `f_c_90_d`, `f_v_d` as η_w · η_t · the table's value, and `f_m_k`, `E_m_mean`, `E_0_mean`, `E_90_mean`, `G_mean`, `rho_k` as the table gives them. It prints nothing unless asked: `print:` lists the values whose calculation is printed, with η_w and η_t.
///
/// ```typ
/// #domain("tension", norm: "SIA 265")[
///   #material("GL24h",
/// 	moisture: 1)
///   #var("N_t_d", 180, "kN")
///   #var("A", 28000, "mm²")
///   #eq("sigma_t_0_d", `N_t_d / A`)
///   #verify(`sigma_t_0_d <= f_t_0_d`)
/// ]
/// ```
///
/// The calculation of a value printed, a value of the engineer's own, two materials in one domain:
///
/// ```typ
/// #domain("contact", norm: "SIA 265")[
///   #material("GL24h",
/// 	moisture: 2,
/// 	print: ("f_c_90_d",),
/// 	suffix: "1")
///   #material("C24",
/// 	f_c_90_d: 2.0,
/// 	suffix: "2")
/// ]
/// ```
///
/// - id (str): the class, as the table writes it (`"GL24h"`, `"C24"`), or an `id` of `my-materials/materials.json`.
/// - moisture (int): the moisture class, 1, 2 or 3 (SIA 265 Tabelle 4).
/// - impact (bool): an impact action, η_t = 1.4 instead of 1.0 (SIA 265 2.2.6).
/// - case (str): the case of f_c,90,d -- `"generell"`, `"mit_vorholz"`, `"endauflagerung"`.
/// - larger (bool): the bracketed f_c,90,d, where the larger indentations provably do not matter.
/// - print (array): the keys whose calculation is printed (`("f_t_0_d",)`), with η_w and η_t.
/// - suffix (str, none): a suffix for every key, so two materials stand in one domain -- `suffix: "1"` publishes (`as` is a word of Typst and cannot name an argument) `f_c_90_d_1`, `eta_w_1`.
/// - ..values (float): a design value of the engineer's own, `f_t_0_d: 11.0`, which replaces the table's and is printed as his.
/// -> content
#let material(id, moisture: 1, impact: false, case: "generell", larger: false, print: (), suffix: none, ..values) = {
  if values.pos().len() > 0 { panic("material: write the class first and every other argument by name -- material(\"GL24h\", moisture: 1)") }
  let given = values.named()
  let known = material-strengths + material-as-given
  for k in given.keys() {
    if not (k in known) { panic("material: " + repr(k) + " is not a value of a class -- " + known.map(x => repr(x)).join(", ")) }
    if type(given.at(k)) not in (int, float) { panic("material: " + k + ": is a number in the table's unit, got " + repr(given.at(k))) }
  }
  if type(print) != array { panic("material: print: is a list of keys, (\"f_t_0_d\",) -- got " + repr(print)) }
  for k in print { if not (k in known) { panic("material: print: " + repr(k) + " is not a value of a class -- " + known.map(x => repr(x)).join(", ")) } }
  if not (case in material-cases) { panic("material: case: " + repr(case) + " is not a case of f_c,90,d -- " + material-cases.map(c => repr(c)).join(", ")) }
  let w = eta-w-table.classes.find(c => c.id == moisture)
  if w == none { panic("material: moisture: " + repr(moisture) + " is not a moisture class of SIA 265 Tabelle 4 -- 1, 2, 3") }
  if type(impact) != bool { panic("material: impact: is true or false, got " + repr(impact)) }
  let found = material-row(id)
  let row = found.row
  let suffix = if suffix == none { "" } else { "_" + str(suffix) }
  let key(k) = k + suffix
  let hidden(k) = not (k in print)
  let shown = print.len() > 0
  let factors-cite = (norm: "SIA 265")
  // the two factors, printed where a calculation is
  var(key("eta_w"), w.resistance, "", label: "Feuchteklasse " + str(moisture), norm: "SIA 265", norm-section: "Tab. 4", display: if shown { auto } else { "none" })
  var(key("eta_t"), if impact { eta-t-clause.impact } else { eta-t-clause.normal }, "", norm: "SIA 265", norm-section: "2.2.6", display: if shown { auto } else { "none" })
  for k in material-strengths {
    if k in given {
      var(key(k), given.at(k), "N/mm²", label: "Wert des Ingenieurs", display: if hidden(k) { "none" } else { auto })
      continue
    }
    let raw = if k == "f_c_90_d" { material-c90(row, case, larger) } else { row.at(k, default: none) }
    if raw == none { continue }
    var(key(k) + "_tab", raw, "N/mm²", label: id, norm: found.norm, norm-section: found.cite, display: if hidden(k) { "none" } else { auto })
    eq(key(k), "eta_w" + suffix + " * eta_t" + suffix + " * " + key(k) + "_tab", unit: "N/mm²", norm: found.norm, norm-section: found.cite,
       display-formula: if hidden(k) { "none" } else { auto }, display-equation: if hidden(k) { "none" } else { auto })
  }
  for k in material-as-given {
    let raw = given.at(k, default: row.at(k, default: none))
    if raw == none { continue }
    var(key(k), raw, material-units.at(k, default: "N/mm²"), label: if k in given { "Wert des Ingenieurs" } else { id }, norm: if k in given { none } else { found.norm }, norm-section: if k in given { none } else { found.cite }, display: if hidden(k) { "none" } else { auto })
  }
}
