# The actions in Excel

> Woodcore computed the snow, the wind and the permanent loads in its tabs «Neige», «Vent» and «Poids propre et surcharge» (`calc/domains/snow_source.py`, `wind_source.py`, `wind_forces.py`, `dead_load_layers.py`, `dead_load_source.py`). When Woodcore was stopped (November 2026), the checks went to the Typst sheets of `sheets/` and these calculations to three Excel workbooks, `actions/fr/`.

## What each workbook computes

| Workbook | Sheet a case is typed in | What it computes | Woodcore's module |
|---|---|---|---|
| `neige.xlsx` | «Neige» | h_ref = h₀ + Δh (Annexe D), s_k of (10) with its floor, C_e (5.2.4, or a value of one's own), C_T, the shape coefficients of Figur 2 and 4 for the five roofs of Figur 3 (flat, mono-pitch, duo-pitch, sheds, curved), μ₁ = 0.8 where the sliding is hindered (5.3.4), and q_k = μ · C_e · C_T · s_k for each load model. Said, not computed: above 2000 m (5.1.4), the cornice above 800 m (5.3.7), a height step (5.3.6), a slope of 60° that sheds its snow (5.3.3), a large flat roof (5.3.5), C_T under 1. Figur 2 is drawn as a chart. | `snow_source.py` |
| `vent.xlsx` | «Tableau 31» to «Tableau 64», one sheet per table of Annexe C | c_h of (12) with its floors and category IV read as III above 30 m (6.2.1.2), q_p = c_h · q_p0 (11); c_red of Figur 9 for b·h and d·h, the larger in an oblique row (6.3.3); for the sheet's table: the global forces q_k = c_red · c_d · c_f · q_p and Q_k = q_k · A_ref (15), and the local pressures q_k = q_p · (c_d · c_pe − c_pi) (13), (14) for the openings chosen (a table that gives c_pi by openings) or each surface's own c_pi, their largest and smallest over the directions with their φ. To the right: three axonometric views of the table's building, each zone in its colour and named (Woodcore's 3D model), then the table itself, one line per column, and q_k for every direction. «Sommaire» lists the tables with a link to each sheet. | `wind_source.py`, `wind_forces.py` |
| `poids-propre-et-surcharge.xlsx` | «Composition 1», «Composition 2», the eight «Lignum …» | A build-up of up to 15 layers, top to bottom: g_k or a_k, a pose (continuous γ · t · w, spaced γ · t · b / e, per surface, typed), a material from «Matériaux», two layers on one level (`Liée à la ligne du dessous`) the one that is not spaced filling w = 1000 · (1 − b/e); a load imposed in place of the computed one; g_k, a_k, their sum, the tenth above it or a value imposed. «Vue d'ensemble» lists every build-up; «Charges utiles» is SIA 261 Tabelle 8. | `dead_load_layers.py`, `dead_load_source.py` |

A case is one sheet: a second roof or building is the sheet copied. Every cell typed and every result has a name local to its sheet (`h_0`, `q_p`, `cf1_q_max`, `g_k`…), so that a copied sheet keeps its own and a later export to Typst can read a case by its names.

## Where the numbers come from

- **The norm's values** are read by `tools/build_actions.py` from `woodwork/data/sia261/` and written into sheets of the workbook that say which file they come from: «Données SIA 261», «Figure 9», and in `vent.xlsx` each table on its own sheet (what each column is, the values as printed, and in folded columns the larger and the smaller value of each cell, a pair ±x or a/b counting both). The formulas read those cells, never a number of their own.
- **The axonometric views** of `vent.xlsx` are PNG in `source/actions/wind-views/` (`T<table>-<view>.png`: 1 from the corner of walls A and D, 2 from the opposite corner, 3 from above), drawn once by `tools/render_wind_views.py <Woodcore>` from Woodcore's `wind_geometry.py` and `model3d.py`, every zone in its own colour.
- **`woodwork/data/sia261/`** is copied from Woodcore by `tools/import_norms.py`, as the other norms: the `excerpts` and `editions` of `5.2-schnee.json`, which quote the clauses, are left out (CON-007), and so is Annexe C's geometry for Woodcore's 3D view.
- **`source/actions/materials.json`** is Woodcore's catalogue of materials as its tab offered it, read out once by `tools/import_actions.py`: SIA 261 Tabellen 28 to 30, the strength classes of SIA 265 and the panels of SIA 265/1 weighed as the wood of SIA 261, and the material library of the office's load workbook (origin «classeur»). **`source/actions/dead-load-templates.json`** is Woodcore's eight build-ups of Lignum's *Holzbau mit System*.

## Building and checking

```
python tools/build_actions.py                 # writes actions/fr/*.xlsx (openpyxl)
python tools/check_actions.py <Woodcore>      # LibreOffice recalculates; compared with Woodcore's modules
```

`check_actions.py` types 96 cases of snow (every roof, four sites, the sliding possible and hindered) and 185 of wind (every table of Annexe C with five buildings, every terrain category and opening) into copies of the workbooks, has LibreOffice recalculate them, and compares every result with what Woodcore's own modules compute for the same source; the eight Lignum build-ups are compared with Woodcore's sums. On 5 November 2026 every value was Woodcore's (tolerance 1e-9). It needs Woodcore, openpyxl and `soffice`; it is a maintainer's check and is not in `tests/`, which keep to the standard library.

## The export to Typst

`tools/actions_typ.py` (a window: `python tools/actions_typ.py`, or a double click on `actions/exporter-typ.pyw`; without it `python tools/actions_typ.py <workbook> <sheet> <folder>`) writes one case -- a sheet -- as four files, named after the case's «Désignation»:

| File | What it holds |
|---|---|
| `<action>-<case>-calcul.typ` | A function `<action>-<case>(display: "none")` opening the domain `<action>-<case>`: every value typed in the sheet as `#var`, every constant of the norm as `#var(from:, path:)` (its file of `woodwork/data/`), every value computed as `#eq`, one argument per line, grouped and commented as the sheet groups them. Called without argument it prints nothing. |
| `<action>-<case>-1-resume.typ` | The results in one table. |
| `<action>-<case>-2-standard.typ` | The data and the results in tables; for the wind, each extreme with its direction and its coefficients. |
| `<action>-<case>-3-detail.typ` | The calculation printed line by line (`display: auto`: formula, numbers, clause), then the results. |

A presentation file imports the calculation file, calls it, then recalls the values with `#var-table` or `get` -- a number printed is one Typst computed. The report includes one presentation file; the calculation file stands beside it, `woodwork/` at the project's root.

What is read from the workbook, not computed again: what the engineer typed, what Excel read off a figure (μ of Figur 2 and 4, c_red of Figur 9 -- each cited with the α or the element it was read for), and, for the wind, the direction of each coefficient's largest and smallest q_k; the coefficients themselves are taken from the table in `woodwork/data/sia261/` for that direction, and the extremes are computed in Typst. The workbook must have been saved by Excel (or LibreOffice) since its last change: openpyxl reads the values Excel saved, and a workbook never opened holds none -- the export says so, and refuses a sheet whose «État du calcul» is red.

`check_actions.py` exports every case it checks and compares the values Typst computes (read back with `typst query`) with the workbook's.

The export is Python run by the engineer, the one exception to «Python is for the maintainer's tools» (decisions D-22); what it writes needs Typst alone.

## What is not done yet

- German and English workbooks.
- The figures of the norm in the workbooks: their place and their publication wait on the engineer (the repository is public, D-13).
