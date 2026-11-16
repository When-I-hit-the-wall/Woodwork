# Decisions

Each settled decision: what, why, what it costs. The founding ones are those of the spec `requirements/completed/2026-11-04-woodwork-feuilles-de-calcul.md` §7, taken by the engineer on 4 November 2026.

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

## D-18 — A constant of a norm is read by `#var(…, from:, path:)`
The engineer's choice (Q-011) over a command publishing a whole clause and over constants in `#material`: one line per value, which says where it comes from. Cost: a sheet's line is longer than a number typed by hand -- which the rule of principles.md (5) forbids anyway.

## D-19 — A formula by cases is `#eq(…, cases:)`
The engineer's choice (Q-012) over an `if` inside the formula and over Typst's own `#if`: the line prints the case that held, alone. k_m of SIA 265 (39) cannot be written exactly with `min` and `max`.

## D-20 — Thousands set apart by an apostrophe
The engineer, 5 November 2026: «je préfère cette manière d'écrire : 28'000 mm²». Every number printed from 1'000 to 99'999 groups its thousands with «'» (`group-thousands` in `woodwork/lib/number.typ`); past 99'999 a power of ten, as before; a value transported for Typst to evaluate again is never grouped. In a formula the grouped number is a quoted word (an apostrophe in math is a prime); the forms set math's font on it all the same. Woodcore prints 28000.

## D-21 — `suffix:` and `titre-neutre`, confirmed
`#material(…, suffix: "1")` (Typst refuses `as` as an argument's name) and the French title page `titre-neutre` (the engineer wrote «titre-neutral»): both confirmed by the engineer on 5 November 2026.

## D-22 — The actions export to Typst through a Python window
The engineer, 5 November 2026, chose the option A of the proposals (a small Python window reading the workbook) over an Excel button (VBA, a `.xlsm`) and over a Typst command reading an exported JSON: «il faut qu'elles soient déclarées avec la commande VAR et calculées avec la commande EQ», the values in a file of their own that computes without printing, imported by the file that presents them. `tools/actions_typ.py` is therefore the one Python a user runs; what it writes needs Typst alone. Cost: openpyxl on the engineer's machine, and a workbook saved by Excel before each export.

## D-23 — A Claude skill for the user, installed by copy
The engineer, 16 November 2026 (spec 2026-11-16-skill-woodwork-report-et-simple-report), chose to copy the skill into `~/.claude/skills/` (option 3) over a Claude Code plugin and over a zip for claude.ai. Its source is `skill/woodwork-report/SKILL.md`, written once in English; `tools/install_skill.py` assembles the rest -- `assets/woodwork/`, `assets/sheets/`, `assets/templates/`, `references/commands.md` (a copy of `docs/typst/commands.md`), `references/catalog.md` (computed from `source/sheets/`) -- and stamps `woodwork-version`. The skill carries the engine, the sheets and the templates of the three languages, allows free calculations whose norm values are still read from `woodwork/data/`, and uses Woodwork only, never the `woodcore` MCP. It is the user's skill, apart from `.claude/skills/`, the maintainer's. Cost: an installed copy does not follow the repository; the script is run again after a change, and `--check` says when it is due.

## D-24 — The Simple Report, and `chapter-break` of the form bfh
The engineer, 16 November 2026: a content template «Simple Report» with no title page of its own, a title block then «1 Section», the calculations, then «2 Annexes» (de «Abschnitt», «Anhang»; en «Section», «Appendices»), no table of contents and no bibliography (`templates/<lang>/rapport-simple/`, `einfacher-bericht/`, `simple-report/`). Its section was first «Section 1»; the engineer: «renomme "1 Section 1" en "1 Section"». The form `bfh` starts every chapter on a page of its own; rather than another form, the engineer chose a new argument, `bfh.with(chapter-break: false)` (default `true`, unchanged), which the Simple Report sets.

## D-25 — The skill also as a zip for claude.ai
The engineer, 16 November 2026: a skill copied into `~/.claude/skills/` is Claude Code's alone and never shows in claude.ai's Plugins > Skills. Of a one-off zip and an option of the script, he chose the option: `python tools/install_skill.py --zip <file>` writes the same assembled skill, under a folder `woodwork-report/`, to upload there. claude.ai takes 200 files at most and the skill holds some 770: the engine, the sheets and the templates go into three inner zips, `assets/woodwork.zip`, `sheets.zip`, `templates.zip`, which the skill tells Claude to unzip before use (the engineer's choice over a zip of one language or of the engine alone). Cost: the uploaded zip ages like the copy, and Claude in claude.ai's chat may have no Typst to compile with.

## Licence — GPL-3.0
Woodwork's engine derives from Woodcore, which is GPL-3.0.
