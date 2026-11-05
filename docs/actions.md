# The actions in Excel

> Woodcore computed the snow, the wind and the permanent loads in its tabs «Neige», «Vent» and «Poids propre et surcharge» (`calc/domains/snow_source.py`, `wind_source.py`, `wind_forces.py`, `dead_load_layers.py`, `dead_load_source.py`). When Woodcore was stopped (November 2026), the checks went to the Typst sheets of `sheets/` and these calculations to three Excel workbooks, `actions/fr/`.

## What each workbook computes

| Workbook | Sheet a case is typed in | What it computes | Woodcore's module |
|---|---|---|---|
| `neige.xlsx` | «Neige» | h_ref = h₀ + Δh (Annexe D), s_k of (10) with its floor, C_e (5.2.4, or a value of one's own), C_T, the shape coefficients of Figur 2 and 4 for the five roofs of Figur 3 (flat, mono-pitch, duo-pitch, sheds, curved), μ₁ = 0.8 where the sliding is hindered (5.3.4), and q_k = μ · C_e · C_T · s_k for each load model. Said, not computed: above 2000 m (5.1.4), the cornice above 800 m (5.3.7), a height step (5.3.6), a slope of 60° that sheds its snow (5.3.3), a large flat roof (5.3.5), C_T under 1. Figur 2 is drawn as a chart. | `snow_source.py` |
| `vent.xlsx` | «Vent» | c_h of (12) with its floors and category IV read as III above 30 m (6.2.1.2), q_p = c_h · q_p0 (11); c_red of Figur 9 for b·h and d·h, the larger in an oblique row (6.3.3); for the chosen table of Annexe C (31 to 60b, 63, 64): the global forces q_k = c_red · c_d · c_f · q_p and Q_k = q_k · A_ref (15), and the local pressures q_k = q_p · (c_d · c_pe − c_pi) (13), (14) for the openings chosen or each surface's own c_pi, their largest and smallest over the directions with their φ. The detail per direction is to the right of the sheet (columns H and after). | `wind_source.py`, `wind_forces.py` |
| `poids-propre-et-surcharge.xlsx` | «Composition 1», «Composition 2», the eight «Lignum …» | A build-up of up to 15 layers, top to bottom: g_k or a_k, a pose (continuous γ · t · w, spaced γ · t · b / e, per surface, typed), a material from «Matériaux», two layers on one level (`Liée à la ligne du dessous`) the one that is not spaced filling w = 1000 · (1 − b/e); a load imposed in place of the computed one; g_k, a_k, their sum, the tenth above it or a value imposed. «Vue d'ensemble» lists every build-up; «Charges utiles» is SIA 261 Tabelle 8. | `dead_load_layers.py`, `dead_load_source.py` |

A case is one sheet: a second roof or building is the sheet copied. Every cell typed and every result has a name local to its sheet (`h_0`, `q_p`, `cf1_q_max`, `g_k`…), so that a copied sheet keeps its own and a later export to Typst can read a case by its names.

## Where the numbers come from

- **The norm's values** are read by `tools/build_actions.py` from `woodwork/data/sia261/` and written into sheets of the workbook that say which file they come from: «Données SIA 261», «Figure 9», «Annexe C» (a block per table: what each column is, the values as printed, the larger and the smaller value of each cell, a pair ±x or a/b counting both), «Tableaux» (one line per table: where its block starts, its proportions, which column is the n-th force or pressure coefficient, which c_pi column each opening reads). The formulas read those cells, never a number of their own.
- **`woodwork/data/sia261/`** is copied from Woodcore by `tools/import_norms.py`, as the other norms: the `excerpts` and `editions` of `5.2-schnee.json`, which quote the clauses, are left out (CON-007), and so is Annexe C's geometry for Woodcore's 3D view.
- **`source/actions/materials.json`** is Woodcore's catalogue of materials as its tab offered it, read out once by `tools/import_actions.py`: SIA 261 Tabellen 28 to 30, the strength classes of SIA 265 and the panels of SIA 265/1 weighed as the wood of SIA 261, and the material library of the office's load workbook (origin «classeur»). **`source/actions/dead-load-templates.json`** is Woodcore's eight build-ups of Lignum's *Holzbau mit System*.

## Building and checking

```
python tools/build_actions.py                 # writes actions/fr/*.xlsx (openpyxl)
python tools/check_actions.py <Woodcore>      # LibreOffice recalculates; compared with Woodcore's modules
```

`check_actions.py` types 96 cases of snow (every roof, four sites, the sliding possible and hindered) and 185 of wind (every table of Annexe C with five buildings, every terrain category and opening) into copies of the workbooks, has LibreOffice recalculate them, and compares every result with what Woodcore's own modules compute for the same source; the eight Lignum build-ups are compared with Woodcore's sums. On 5 November 2026 every value was Woodcore's (tolerance 1e-9). It needs Woodcore, openpyxl and `soffice`; it is a maintainer's check and is not in `tests/`, which keep to the standard library.

## What is not done yet

- German and English workbooks.
- The export of a case to a `.typ` file the reports include, in three levels of detail (a later phase).
