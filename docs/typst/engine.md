# The engine

How `woodwork/lib/` works, for its maintainer. It was taken from Woodcore's `lib/` on 4 November 2026 (commit 1bf6093f of 28 October) and cut to what a sheet needs (founding spec, plan step 3); it lives on its own since.

## Files

| File | Holds |
|---|---|
| `calc-engine-core.typ` | The registry (`var-registry`), the report level, numbers and their display, `get`, the chains a long formula is stacked into. |
| `calc-engine-display.typ` | `render-table`, the booktabs table every table of the engine is set as. |
| `calc-engine.typ` | What `formula.typ` imports of the two above, and the four constants of `#verify` (its colours, its tolerance, its relations). |
| `formula.typ` | The units and their algebra, the formula parser, `#var`, `#eq`, `#verify`, `#unit`, `#calc-defaults`, `#domain`, `#var-table`; `data-value` (`from:`/`path:`), `check-cases` and `pick-case` (`cases:`). |
| `material.typ` | `#material`. |
| `norm-list.typ`, `bibliography.typ` | `#show-norm-list`, `#show-bibliography`, `#cite-norm`, and `bib-note`, which every command citing a norm emits before its context. |
| `i18n.typ`, `strings.json` | The engine's own words in fr, de, en; the language is `text.lang` (`report-lang()`). |
| `number.typ`, `subscript.typ`, `units.json`, `display-presets.json`, `figure-palette.json` | Numbers, subscripts, the unit tables, the display presets, the figures' colours. |

## How a line is computed and printed

- **The registry** is one Typst `state` holding every variable, by domain; the stack of open domains and their **frames** (each frame: its id, its level, the defaults its `#domain` was given, its units); the document's defaults (`defaults`, which hold Woodwork's own: the `block` family, the label left, the citation right -- decisions D-12); the units table. A state's update cannot read another state, so everything a line needs lives in this one dictionary.
- **A command writes in its update and prints in a context.** `#eq` evaluates its formula in its update (`evaluate-formula`: the operands looked up innermost domain first, converted to base units, parsed by `tokenize` and `parse-expr`, values and dimensions multiplied; a power's exponent may be any dimensionless atom), picks the result's unit (`unit:` of the line, else the domains' `units:`, else `units.json`), stores the record, then in its context prints the formula in letters, in numbers and the result.
- **What a line shows** is resolved by `resolve-display`: the line's own arguments, then the frames from the innermost out, then the document's defaults, then the preset of the level (3 by default) in the family chosen. `norm` is resolved the same way, and `placed-extras` cites it only where the line writes a clause (D-16).
- **A value written** in a domain that names a unit for its dimension is held and printed in it (`to-domain-unit`).
- **A value of `woodwork/data/`** (`#var(…, from:, path:)`) is read by `data-value`: the path walked through objects and lists (an element named by its `id`), the unit taken from the nearest `units` map, the citation from the innermost object that has a `norm_ref`.
- **A formula by cases** (`#eq(…, cases:)`): `pick-case` evaluates each condition in the update, the index of the case that held is stored with the record, and the context prints that case's formula alone.

## What was cut from Woodcore

The export's readers (positions, calculations, journal, connections, connectors, checks, plans), `find-calculation`, `find`, `sync`, the uniform level and the «Affichage» preview, the domain heading, `from-level`, `load-domain-state`, `bib-of-data`, the metadata Woodcore's window read (`wc-meta`). `tests/test_engine_standalone.py` holds them gone.
