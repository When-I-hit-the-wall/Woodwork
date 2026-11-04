# Principles

The rules every change to Woodwork keeps. A change that breaks one says so in its spec and in `docs/decisions.md`, with what it costs.

1. **One source of truth.** Every value, word and formula is written once. A sheet lives in `source/`; the three trees of `sheets/` are its generated copies. A label lives in `source/labels.json`. A norm value lives in `woodwork/data/`. An engine word lives in `woodwork/lib/strings.json`. Where a copy is unavoidable (the tables taken from Woodcore), a test holds it equal to its origin or says when it was taken.
2. **Typst alone to use a sheet.** A user needs Typst 0.15.1 and a text editor. No Python, no network, no package manager. Python is the maintainer's: `tools/` and `tests/`.
3. **The engine stays inside `woodwork/`.** `woodwork/lib/` reads only files of `woodwork/`, by paths relative to the file that reads them (`json("../data/…")`). The user's project root is unknown to the engine: only a sheet writes `#import "/woodwork/woodwork.typ": *`.
4. **What the user copies is self-contained.** `woodwork/` plus one sheet compiles in an empty project. A sheet names its preset; a preset that is missing stops the compile with its name, rather than printing differently without a word.
5. **Norm values are read, never remembered.** Every JSON of `woodwork/data/` (but `my-materials/` and `presets.json`) names its norm, edition, table and page in `_source`. A clause a sheet cites is one Woodcore already cited, or one read in the PDF of the norm when the sheet is written.
6. **Every value has a unit and a provenance.** A `#var` carries its unit; a value of `#material` carries the table it was read from, or says it is the engineer's.
7. **The domain sets, the line overrides.** What `#domain` is given holds for every line of its body; a line that writes the same argument overrides it for itself. Order: the line, then the domain, then its preset, then Woodwork's defaults (`docs/typst/commands.md`).
8. **A refusal is a panic that names what is wrong** — the argument, the variable, the unit, the preset, the strength class — and what would be accepted. A test reads the message with `tests/conftest.py`'s `panic_message`.
9. **The rendering is the engineer's.** By default a line prints its label left, the formula in letters, then in numbers with units, then the result, and its citation right; `#verify` prints the ratio, `⩽ 1` and ✓ under a double rule. A sheet does not write `level`.
10. **Three languages.** Every sheet exists in French, German and English, with its folders, file name and labels in that language; keys, commands and arguments stay English. The engine's own words follow `text.lang`.
11. **The engineer designs the command surface.** A new command, argument or data shape is proposed with its options, trade-offs and what each would lose — never decided silently.
12. **Small, readable sheets.** One named argument per line, indented under its command, so a sheet reads easily in Typst.
