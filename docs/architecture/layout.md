# Layout

## What the user copies

| Path | What it holds |
|---|---|
| `woodwork/woodwork.typ` | The one file a sheet imports: `#import "/woodwork/woodwork.typ": *`. It re-exports the commands. |
| `woodwork/lib/` | The engine, taken from Woodcore's `lib/` and cut to what a sheet needs: `formula.typ` (`#domain`, `#var`, `#eq`, `#verify`, `#unit`, `#calc-defaults`), `calc-engine*.typ` (the registry, numbers, display), `i18n.typ` and `strings.json` (the engine's words), `units.json`, `display-presets.json`, `material.typ` (`#material`). |
| `woodwork/data/` | The norm tables, one folder per norm, each file named by its table or clause without the norm and edition (`sia265/tab09-brettschichtholz.json`): today `sia265/`, `sia265-1/`, `sia260/`, `sn-en-14592/` (phase 1; SIA 261, SIA 263 and SZS C5 come with the phases that need them). `norms.json` (the documents a sheet may cite, for the bibliography), `presets.json` (named display presets), `my-materials/` (the office's own materials), `imported.json` (where each table was copied from). |
| `sheets/fr/`, `sheets/de/`, `sheets/en/` | The calculation sheets, generated. Each tree has its folders and file names in its language (`sections-bois/traction/traction-axe.typ`, `holzquerschnitte/zug/zug-parallel.typ`, `timber-sections/tension/tension-parallel.typ`), a standard and a detailed sheet per check. |

## What stays with the maintainer

| Path | What it holds |
|---|---|
| `source/` | The one source of every sheet, its labels written as keys (`label: "{tension-force}"`), in the English tree of folders. |
| `source/labels.json` | Each label key in fr, de and en, and the translated names of folders and files. |
| `figures/` | The SVG sketches the detailed sheets show. |
| `examples/` | Documents that compile every sheet: the test of the whole. |
| `tools/` | `generate.py` (source → sheets), `import_norms.py` (the one-time copy of Woodcore's tables, kept to show where each came from). |
| `tests/` | `run_tests.py`, `conftest.py`, `test_*.py`. |
| `docs/` | This documentation and the specifications. |
| `.claude/` | The skills and agents that develop Woodwork. |
