---
name: typst-sheet
description: How to write a Woodwork calculation sheet or change Woodwork's Typst engine — the source format of a sheet (label keys, one argument per line, the domain's defaults), the commands #domain, #var, #eq, #verify, #unit and #material, how the engine computes, and the traps of Typst 0.15 met in this engine (state and context, import paths, panics, units). Read it before writing a sheet in source/ or editing woodwork/lib/. For Typst's own syntax, read typst-writing-document.
---

# typst-sheet — writing Woodwork's Typst

The commands' reference is `docs/typst/commands.md`; the engine's inside is `docs/typst/engine.md`. This skill is the working method and the traps.

## A sheet's source

A sheet is written once, in `source/<family>/<group>/<check>.typ` (English names), and generated into `sheets/fr|de|en/`. Every visible word is a key of `source/labels.json` in braces; the heading is written by hand, `#domain` prints none.

```typ
#import "/woodwork/woodwork.typ": *

= {title-tension-parallel} (SIA 265)

#domain("tension-parallel",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_t_d", 180, "kN",
	label: "{tension-force}")
  #var("b", 140, "mm",
	label: "{width}")
  #var("h", 200, "mm",
	label: "{height}")
  #eq("A", `b * h`,
	label: "{cross-section}")
  #eq("sigma_t_0_d", `N_t_d / A`,
	label: "{tensile-stress}",
	norm-section: "4.2.1.1")
  #verify(`sigma_t_0_d <= f_t_0_d`,
	label: "{tension-check}",
	norm-section: "4.2.1.1 (6)")
]
```

- **One named argument per line**, indented with a tab under its command (`tests/test_generate.py` checks it in `sheets/`).
- **No `level`.** The default rendering is the engineer's: label left, formula, numbers, result, citation right.
- **What every line shares goes on `#domain`**: `norm`, `label-position`, `norm-position`, `display-*`, `units`, `preset`. A line writes only what is its own (`label`, `norm-section`, `unit`) or what it overrides.
- **The detailed sheet** (`<check>-detailed.typ`) adds text, a figure from `figures/`, sub-headings and `#material(…, print: (…))`; it `#include`s the lines it shares with the standard sheet rather than repeating them, so both give the same utilisation.
- **Every value of a norm comes from `woodwork/data/`**, through `#material` or a table read by the engine — never a number typed from memory. A clause cited is one Woodcore's member checks already cited (the founding spec, §13, names where they were read) or one read in the PDF of the norm.
- After writing: `python tools/generate.py`, add the sheet to `examples/`, `python tests/run_tests.py -k sheets`.

## How a line computes

`#eq("A", `b * h`)` runs when Typst compiles — no Python. It reads `b` and `h` from the registry (`var-registry`, a `state`), converts them to base units, parses the formula with the engine's own parser (`tokenize`, `parse-expr` in `formula.typ`), multiplies values *and* dimensions, picks the unit of the result from `units.json` (or the domain's `units:`, or the line's `unit:`), stores `A` in the registry, then prints letters, numbers and result in a `context`. A name not declared above stops the compile.

In formulas: the registry's keys (`N_t_d`, not `N_(t,d)`); `*` multiplies (printed `·`); a literal takes its unit in quotes, `(3 "m")`; a raw block saves escaping quotes.

## Traps

- **A state's update cannot read another state.** That is why the registry carries the domain frames, the units and the defaults in its own dictionary. Add to the frame (`push-frame`), never a new `state`, unless the spec says why.
- **`context` reads, the update writes.** A value computed in an update is visible to the `context` of the same line after it; a `context` cannot feed an update. Many nested `context`s slow convergence: keep a line to one.
- **Paths.** Inside `woodwork/lib/`, read files relative to the file: `json("../data/sia265/…")`, `json("units.json")`. Never `/woodwork/…` (the user's root is unknown to the engine), never a path leaving `woodwork/`. Only a sheet imports `"/woodwork/woodwork.typ"`.
- **A refusal is a `panic`** naming the argument, its value and what is accepted. Typst 0.15 prints `panicked with: <message>` without quotes: tests read it with `conftest.panic_message`.
- **The language** of the engine's words is `text.lang`, read in a `context` (`report-lang()`); a function called outside a `context` must not need it.
- **Units** are written as the report prints them: `mm`, `kN`, `kNm`, `N/mm²`, `mm²`. `units: ("Nm",)` on a domain sets the unit of every moment of it; two units of one dimension are refused.
- **Compile to check**: `typst compile --root <project> <project>/main.typ out.pdf` with `woodwork/` copied at `<project>/woodwork/` — `tests/conftest.py`'s `compile_typ` does exactly this.
