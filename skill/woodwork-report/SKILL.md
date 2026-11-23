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
- **Never edit `.woodwork/` (or `woodwork/`)** in the user's project. Its look is chosen with a form; its values are overridden on a line (`#material("GL24h", f_t_0_d: 11.0)`).
- **The user's language.** Use the sheets and templates of the language of the report (`fr`, `de` or `en`), and write text, labels and headings in it.

## Method

1. **Typst.** Run `typst --version`. If it is missing or not 0.15.x, tell the user (https://github.com/typst/typst/releases) and stop compiling, but still write the files.
2. **The project.** A new report is a folder laid out as in «Project layout» below: write its files as shown there, the engine copied from `assets/woodwork/` into `<root>/.woodwork/`. In an existing project, keep its layout; if `.woodwork/` (or `woodwork/`) exists, read the `woodwork-version` line of its `woodwork.typ`, and if it differs from this skill's version, ask the user before replacing the folder. Only when the user asks for a short one-file note, copy the Simple Report of the language instead (`assets/templates/fr/rapport-simple/`, `de/einfacher-bericht/`, `en/simple-report/`), the engine in `<root>/woodwork/`, and fill its fields at its top.
3. **The calculations.** One file per calculation, in the folder of its chapter (`Einwirkungen/Wind/Windlast.typ`, `Tragwerksanalyse/S066-Druck.typ`), included by its section (`#include "/Tragwerksanalyse/S066-Druck.typ"`). For each member check:
   - Find the check in `references/catalog.md`. Use the standard sheet for a short report, the detailed one when the user wants the derivation, text and figure.
   - Paste the sheet's content into the calculation's file, its `#import` line replaced by `#import "/000-Typst-Config/commands.typ": *`. Set its heading one level under the section that includes it, and add the member's name to it (`=== Stütze S066 — Druck mit Knicken (SIA 265)`).
   - Give each domain a unique name, the file's name (`#domain("S066-Druck")`), so each member's variables stay apart and another file can read one by its domain (`#var("eta", domain: "S066-Druck")`).
   - Change the values the user gives (forces, dimensions, strength class, moisture class), the labels if needed. Keep every other line, and rewrite it in the house style below.
4. **A free calculation**, when no sheet fits: write it with the commands, in the house style below. Read `references/commands.md` first for anything not shown here.
5. **Compile**: `typst compile --root <root> <root>/StatischerBericht.typ`, and with `--input level=1` and `level=3`. Read the error, fix, compile again until it passes. Then tell the user the utilisation of each check (the `η` printed) and any check that fails (✘).

## Project layout

The root of the project is the Typst root (`--root .`): every file imports by an absolute path from it. Folder names are in the report's language; the German ones below are the reference.

```
<Projekt>/
├── StatischerBericht.typ          entry: config, title page, outline, the sections in order
├── 000-titel.typ                  title page: assets/templates/<lang>/titel-bfh.typ, its /woodwork/ paths made /.woodwork/
├── 000-references.bib             bibliography
├── 000-Typst-Config/
│   ├── config.typ                 the look: Woodwork's form bfh + the captions
│   └── commands.typ               the ONE import of every file: Woodwork + the project's own commands
├── .woodwork/                     copy of assets/woodwork/, never edited; to update, replace the folder
├── .vscode/settings.json          "tinymist.rootPath": "${workspaceFolder}"
├── Sections/                      001-einleitung.typ, 002-grundlagen.typ, 003-baustoffe.typ, 004-einwirkungen.typ,
│                                  005-tragwerksanalyse.typ, 006-nachweise.typ, 007-literatur.typ, 009-anhang.typ
├── Einwirkungen/                  Auflast/, Nutzlast/, Schnee/, Wind/: one calculation per file
├── Tragwerksanalyse/              one calculation per member or check
└── Images/                        pictures, one sub-folder per subject
```

`000-Typst-Config/commands.typ`:

```
// Every command of the report, in one import: each .typ file of the project starts with this one line.
#import "/.woodwork/woodwork.typ": *

// `#from-level(n)[...]` prints its content only when the report's level (`--input level=…`, default 2) is n or more.
#let from-level(n, body) = context if report-level.get() >= n { body }

// The report's level, fixed at compile time: typst compile --input level=1|2|3. Called once by each entry file.
#let set-report-level() = {
  let lv = int(sys.inputs.at("level", default: "2"))
  assert(lv in (1, 2, 3), message: "invalid --input level=" + str(lv) + ", expected 1, 2, or 3")
  report-level.update(lv)
}
```

`000-Typst-Config/config.typ`:

```
#import "/.woodwork/forms/bfh.typ": bfh

#let conf(doc) = {
  show: bfh.with(lang: "de", region: "CH")
  // «Abbildung 1 — …» under a figure; «Tabelle 1: …» above a table, centred and bold (the form sets the place and the weight)
  set figure.caption(separator: [ — ])
  show figure.where(kind: table): set figure.caption(separator: [: ])
  doc
}
```

`StatischerBericht.typ`:

```
#import "/000-Typst-Config/config.typ": conf
#import "/000-Typst-Config/commands.typ": *
#show: conf

#set-report-level()
#number-digits.update(3)

#include "000-titel.typ"
#outline()
#pagebreak()

#include "Sections/001-einleitung.typ"
#include "Sections/004-einwirkungen.typ"
#include "Sections/005-tragwerksanalyse.typ"
```

A section (`Sections/004-einwirkungen.typ`) starts with the same import, its heading `= Einwirkungen`, then `== …` headings and the `#include` of its calculations, a `#pagebreak(weak: true)` between two of them.

## House style of a calculation

```typ
#import "/woodwork/woodwork.typ": *

=== Stütze S066 — Druck mit Knicken (SIA 265)

#domain(
  "S066-Druck",
)[
#calc-defaults(
  presets: "block-left",
) <S066-Druck-presets>

// ═══════════════ EINWIRKUNGEN ═══════════════

// ─── Normalkraft ───
*Einwirkung*

  #var(
    "N_Ed", "N_(E,d)", 1305.24, "kN",
    label: "Bemessungswert Normalkraft (Druck)",
    descr: "Minimum der Umhüllenden Tragsicherheit Typ 2.",
  )

// ═══════════════ STATISCHES SYSTEM ═══════════════

// ─── Querschnitt ───
*Querschnitt*

  #var("b", "b", 320, "mm", label: "Breite")
  #var("h", "h", 320, "mm", label: "Höhe")
  #eq("A", "A", `b * h`, unit: "mm²", label: "Querschnittsfläche")

// ═══════════════ WIDERSTAND ═══════════════

// ─── Baustoff GL24h ───
*Baustoff GL24h*

  #material("GL24h", moisture: 1)

// ═══════════════ NACHWEIS ═══════════════

// ─── Druck ───
*Nachweis*

  #eq(
    "sigma_c_0_d", "sigma_(c,0,d)", `N_Ed / A`,
    unit: "N/mm²",
    label: "Druckspannung",
  )
  #verify(
    `sigma_c_0_d <= f_c_0_d`,
    name-calc: "eta",
    name-visible: "eta",
    label: "Nachweis Druck",
    norm: "SIA 265",
    norm-section: "4.2.4",
  )
]
```

In the project, the first line is `#import "/000-Typst-Config/commands.typ": *` (shown here with the engine's own path so that it compiles alone).

- **The heading is written by hand** just above `#domain` (Woodwork's domain prints none), one level under the section that includes the file.
- **Every domain starts with `#calc-defaults(presets: "block-left") <ID-presets>`**: the `block` presets, the label in a column at the left 35 % wide, level 3, for the rest of the domain. Write no `level:` in `#domain(`. A domain that must print less writes it beside the bundle (`presets: "block-left",` then `level:   2,`); any argument written there wins over the bundle.
- **`#domain(` and `#calc-defaults(`** are written one argument per line, the values aligned after the colons when there are several (`presets:        "block",` / `label-position: "left",`), then `)[` and `) <ID-presets>`. No unused argument written as a comment: the editor lists them.
- **Long `#var`, `#eq`, `#word-var`, `#verify`** (with a label, more than about 80 characters): the positional arguments (key, symbol, value or formula, unit) on the first line after `#var(`, then one named argument per line, a trailing comma, `)` alone. A short call stays on one line.
- **Banners**: the main parts, in this order where they apply, `// ═══════════════ STATISCHES SYSTEM ═══════════════`, `EINWIRKUNGEN`, `WIDERSTAND`, `NACHWEIS` (in the report's language); the sub-parts `// ─── Geometrie ───`; a blank line between blocks. A visible sub-heading inside a calculation is bold (`*Nutzlasten*`), never italic, just under its banner.
- **Input values stay as individual `#var` lines.** Do not gather them into a `#var-table` at the head of a check.
- **Keys** are symbols: the part before the first `_` is the letter (a Greek name gives its letter, `sigma` → σ), every part after is an index: `sigma_m_d` → σ<sub>m,d</sub>. In formulas use the keys, `*` to multiply, `^` for a power, a literal with its unit in quotes: `(3 "m")`.
- **Units** as a report prints them: `mm`, `kN`, `kNm`, `N/mm²`, `mm²`, `kN/m`. The engine converts.
- `#material("GL24h", moisture: 1)` reads a strength class of SIA 265 Tabelle 8 or 9 and publishes its design values (`f_m_d`, `f_t_0_d`, `f_c_0_d`, `f_c_90_d`, `f_v_d`, `E_0_mean`, …); `#var("key", from: "sia265/<file>", path: "<keys.joined.by.dots>")` reads a constant of a norm table; `#eq(…, cases:)` computes by cases.

## Tables and figures

- **Every table is a figure**, so the form `bfh` gives it the BFH style: «Tabelle n: Name» above it, centred and bold; the grey-blue header, the striped rows; what follows the table in the figure (a description, a legend) stands under it.

```typ
#import "/woodwork/forms/bfh.typ": bfh
#show: bfh.with(lang: "de")
#show figure.where(kind: table): set figure.caption(separator: [: ])

#figure(
  caption: [Schichtaufbau Flachdach],
  {
    table(
      columns: 3,
      table.header([*Schicht*], [*Dicke [m]*], [*Last [kN/m²]*]),
      [Kies],    [0.06], [1.2],
      [EPDM],    [],     [0.1],
      table.footer([*Total*], [], [1.3]),
    )
    [Lasten nach SIA 261, Anhang A.]
  },
) <Flachdach-table-1>
```

- **No italic title line** (`_Schichtaufbau_`) above a table any more: the caption is the title.
- **A `#var-table`** goes in a figure too, in a box that keeps its cells left-aligned while the figure centres it: `#figure(kind: table, caption: [Zusammenstellung], box(align(left, var-table(…)))) <ID-table-k>`.
- **A figure** takes its caption under it, «Abbildung n — …»; a figure or table printed only from a level is wrapped in `#from-level(2)[…]`.
- Labels: `<ID-table-k>`, `<ID-figure-k>`, the domain's name as `ID`.

## When the compile stops

Woodwork refuses with a panic that names what is wrong and what it accepts: an unknown argument, a variable used before it is declared, a unit of the wrong dimension, an unknown strength class, preset or table path. Read the message (`panicked with: …`), fix the line it names, compile again. Never work around a refusal by typing a value.

## Traps

- The project's root matters: every file imports by an absolute path from `--root` (`/000-Typst-Config/commands.typ`, `/.woodwork/…`). Compile with `--root` at the project's folder, and open VS Code on it.
- A form is set once, in `000-Typst-Config/config.typ` (`#show: bfh.with(chapter-break: false)` in the Simple Report). The look changes by changing that line to `neutral` or `compact`; do not add a second `#show`.
- The form `bfh` puts the chapter of the page in its header; that is expected.
- A sheet's figure is `image("/woodwork/figures/<name>.svg")`: in a project whose engine is in `.woodwork/`, write `/.woodwork/figures/<name>.svg`.
- A domain with a fixed level (the bundle `block-left` sets 3) prints its descriptions as footnotes even when the file is included hidden; a file only read by others keeps the long form `presets: "block", label-position: "left", label-width: 35%, scope: "domain"` without a level.
