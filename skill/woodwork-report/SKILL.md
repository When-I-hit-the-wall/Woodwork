---
name: woodwork-report
description: Write a structural calculation report for timber in Typst with the Woodwork engine (SIA 260, 261, 265) — install the engine into a Typst project, start from the Simple Report or the full statical report, paste and adapt Woodwork's checks (tension, compression, bending, shear, buckling, lateral-torsional buckling) or write free calculations with the commands domain, var, eq, verify and material, then compile and fix. Use whenever the user asks for a timber calculation sheet, a member check, a «Nachweis», a «vérification», or a static report in Typst.
---

# woodwork-report — timber calculation reports in Typst

Woodwork version of this copy: @WOODWORK_VERSION@. This skill was installed by `tools/install_skill.py` of the Woodwork repository (into `~/.claude/skills/` for Claude Code, or as a zip uploaded to claude.ai); to update it, run that script again there. Do not edit this copy.

Everything below lives next to this file, in the skill's base directory:

| Path | What it holds |
|---|---|
| `assets/woodwork/` | The engine: `woodwork.typ`, `lib/`, `data/` (the norm tables), `forms/` (`neutral`, `compact`, `bfh`), `figures/`. Copied as it is into the user's project. |
| `assets/sheets/fr/`, `de/`, `en/` | Woodwork's calculation sheets, a standard and a detailed one per check. |
| `assets/templates/fr/`, `de/`, `en/` | The content templates: the Simple Report, the full statical report, the basis of design, the service criteria agreement, the title pages. |
| `references/catalog.md` | Every check: its title, its files in each language, the values to change. Read it to choose a sheet. |
| `references/commands.md` | The reference of every command and argument. Read the section you need before writing a line you have not seen in a sheet. |

Uploaded to claude.ai, the skill holds `assets/woodwork.json`, `assets/sheets.json` and `assets/templates.json` instead of the three folders (claude.ai takes 200 files at most and no zip inside a zip): each is a bundle `{path: base64 of the file}`. Unpack the three first into a working folder of your own, in your sandbox (not in the user's project), with `@UNPACK@` — `<bundle>` the JSON, `<folder>` your `<work>/assets` — and read every `assets/…` path below in that folder.

## Rules

- **Woodwork only.** Do not use the `mcp__woodcore__*` tools or any Woodcore file for this work, even when they are available: the report is plain Typst with the Woodwork engine.
- **Typst alone in the user's project.** The user compiles with Typst 0.15.1 and nothing else. Copy files and run `typst`; never add a Python script, a package or a build step to the project.
- **A norm value is read, never typed.** Every strength, factor or constant of a norm comes from `woodwork/data/`, through `#material` or `#var(…, from:, path:)`. Never write a norm value from memory. If the value the user needs is not in `woodwork/data/` (grep its folder), say so and ask the user for the value and its source; then write it as the user's own value, with its source in the label.
- **A clause is cited only when it is known.** Write `norm-section:` only for a clause a Woodwork sheet already cites for the same thing, a clause `woodwork/data/` names, or one the user gives. Otherwise write no citation rather than a guessed one.
- **Never edit `woodwork/`** in the user's project. Its look is chosen with a form; its values are overridden on a line (`#material("GL24h", f_t_0_d: 11.0)`).
- **The user's language.** Use the sheets and templates of the language of the report (`fr`, `de` or `en`), and write text, labels and headings in it.

## Method

1. **Typst.** Run `typst --version`. If it is missing or not 0.15.x, tell the user (https://github.com/typst/typst/releases) and stop compiling, but still write the files.
2. **The engine.** The project's root is the folder the user compiles from (`--root`). If `<root>/woodwork/` does not exist, copy `assets/woodwork/` there. If it exists, read the `woodwork-version` line in `<root>/woodwork/woodwork.typ`; if it differs from this skill's version, ask the user before replacing it.
3. **The skeleton.** By default, copy the Simple Report folder of the language (`assets/templates/fr/rapport-simple/`, `de/einfacher-bericht/`, `en/simple-report/`) into the project, and fill its fields at its top: document, project, number, the rows of people (empty a row's list to drop it), the date. It has a title block, then the chapter «Section» for the calculations, then «Annexes» / «Anhang» / «Appendices». No title page, no table of contents, no bibliography. When the user asks for the full statical report, copy `rapport-de-statique/` (`statischer-bericht/`, `statical-report/`) with the title page beside it (`titre-bfh.typ` …), as its first comment says.
4. **The calculations.** For each member check:
   - Find the check in `references/catalog.md`. Use the standard sheet for a short report, the detailed one when the user wants the derivation, text and figure.
   - Paste the sheet's content into the chapter, without its `#import` line (the skeleton has it). In the Simple Report, demote the sheet's heading from `=` to `==`, so the report keeps its two chapters; add the member's name to it (`== Purlin P1 — bending (SIA 265)`).
   - Give each pasted domain a unique name (`#domain("bending-p1", …)`), so each member's variables stay apart and another line can read one by its domain (`#var("eta", domain: "bending-p1")`).
   - Change the values the user gives (forces, dimensions, strength class, moisture class), the labels if needed. Keep every other line.
5. **A free calculation**, when no sheet fits: write it with the commands, in the same style (below). Read `references/commands.md` first for anything not shown here.
6. **Compile**: `typst compile --root <root> <root>/<folder>/<entry>.typ`. Read the error, fix, compile again until it passes. Then tell the user the utilisation of each check (the `η` printed) and any check that fails (✘).

## Writing a line

```typ
#import "/woodwork/woodwork.typ": *

= Purlin P1 — bending (SIA 265)

#domain("purlin-p1",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("M_d", 9.6, "kNm",
	label: "Design bending moment")
  #var("b", 120, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("W", `b * h^2 / 6`,
	label: "Section modulus")
  #eq("sigma_m_d", `M_d / W`,
	label: "Bending stress")
  #verify(`sigma_m_d <= f_m_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Bending check")
]
```

- `#domain("name", preset: "report", norm: "SIA 265")[…]` frames a calculation; what it is given holds for every line of its body. It prints no heading: write the heading by hand above it.
- `#material("GL24h", moisture: 1)` reads a strength class of SIA 265 Tabelle 8 or 9 and publishes its design values (`f_m_d`, `f_t_0_d`, `f_c_0_d`, `f_c_90_d`, `f_v_d`, `E_0_mean`, …) as variables. `print: ("f_m_d",)` prints how one is obtained.
- `#var("key", value, "unit", label: […])` declares a value; `#var("key", from: "sia265/<file>", path: "<keys.joined.by.dots>")` reads a constant of a norm table (open the JSON to find the path).
- `#eq("key", `formula`, label: […])` computes from the variables above, with units; `cases:` for a formula by cases.
- `#verify(`a <= b`, name-calc: "eta", name-visible: "eta", label: […])` checks and prints the utilisation η.
- **One named argument per line**, indented by a tab under its command, as above.
- **Keys** are symbols: the part before the first `_` is the letter (a Greek name gives its letter, `sigma` → σ), every part after is an index: `sigma_m_d` → σ<sub>m,d</sub>. In formulas use the keys, `*` to multiply, `^` for a power, a literal with its unit in quotes: `(3 "m")`.
- **Units** as a report prints them: `mm`, `kN`, `kNm`, `N/mm²`, `mm²`, `kN/m`. The engine converts.
- No `level:` argument: the default rendering (label left, formula, numbers, result, citation right) is the house style.

## When the compile stops

Woodwork refuses with a panic that names what is wrong and what it accepts: an unknown argument, a variable used before it is declared, a unit of the wrong dimension, an unknown strength class, preset or table path. Read the message (`panicked with: …`), fix the line it names, compile again. Never work around a refusal by typing a value.

## Traps

- The project's root matters: every sheet imports `"/woodwork/woodwork.typ"`, an absolute path from `--root`. Compile with `--root` at the folder that holds `woodwork/`.
- A form is set once, by the skeleton (`#show: bfh.with(chapter-break: false)` in the Simple Report). The look changes by changing that line to `neutral` or `compact`; do not add a second `#show`.
- The form `bfh` puts the chapter of the page in its header; that is expected.
- A sheet's figure is `image("/woodwork/figures/<name>.svg")`: it needs `woodwork/figures/`, which the engine copy holds.
