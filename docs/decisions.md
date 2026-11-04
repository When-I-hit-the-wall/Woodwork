# Decisions

Each settled decision: what, why, what it costs. The founding ones are those of the spec `requirements/active/2026-11-04-woodwork-feuilles-de-calcul.md` §7, taken by the engineer on 4 November 2026.

## D-1 — A copy that lives alone
Woodwork's engine and tables were taken from Woodcore once; nothing links the two since. Cost: a fix in one does not reach the other.

## D-2 — Two levels, no `mode`, no `level` in the sheets
Every check has a standard and a detailed sheet. The engine still accepts `level` for a special case; no sheet writes it.

## D-3, D-11, D-14 — The domain sets, the line overrides; no heading; `"right"`
`#domain` takes the presentation arguments of its lines (Woodcore's names) and prints no heading — the sheet writes its own `= Title (norm)`. A line overrides any of them. The citation at the right is `norm-position: "right"`; Woodcore's `"line-right"` is refused with the new name.

## D-4 — `#domain` only
No `#var-domain`.

## D-5 — English code, three-language sheets
Keys, commands, arguments, docs: English. Sheets in fr, de and en, with folders, file names and labels translated.

## D-6 — Generated sheets
One source per check in `source/`, `tools/generate.py` writes the three trees. Cost: a script and a test for the maintainer.

## D-7 — `units:` is a list
`units: ("Nm", "cm²")`, each unit naming its dimension; two of one dimension are refused.

## D-9 — Pushed to a public repository
`git@github.com:When-I-hit-the-wall/Woodwork.git`, `main`.

## D-10 — Distributed as a folder in the user's project
The user copies `woodwork/` to the root of his project; sheets import `"/woodwork/woodwork.typ"`. `data/` is then beside his files and his own to correct. Rejected: a Typst package (`@local/woodwork`), which would hide `data/` and could not read the project's own materials.

## D-12 — The default rendering is the engineer's
Label left, formula then numbers then result, citation right (the `block` family of Woodcore's presets with `label-position: "left"`); the preset `report` writes the same explicitly.

## D-13 — Norm tables published as Woodcore had them
With their titles, labels and notes; only `_note` lines citing Woodcore paths are cleaned. Cost accepted: labels of SIA tables are public.

## D-15 — A key of several indices prints them separated by commas
`N_t_d` prints N<sub>t,d</sub>, `sigma_t_0_d` σ<sub>t,0,d</sub>, `E_0_mean` E<sub>0,mean</sub>: each part after the first `_` is an index, kept when it is one character, a number or a Greek name, upright when it is a word. Woodcore printed `t_d` as one quoted subscript; a sheet could then only reach the notation of the norm by writing every symbol by hand, which the engineer's syntax (founding spec T15) does not. A key of one index is printed as before (`k_dens`, `gamma_M`).

## D-16 — A line cites its domain's norm only where it cites a clause
A line that writes `norm-section:` and no `norm:` cites the domain's norm; a line without a clause cites nothing, so «SIA 265» is not repeated on every datum (the engineer's screenshots).

## Licence — GPL-3.0
Woodwork's engine derives from Woodcore, which is GPL-3.0.
