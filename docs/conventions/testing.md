# Testing

## The runner

From `Woodwork/`:

    python tests/run_tests.py                 every test file, each in a process of its own
    python tests/run_tests.py -k material     only the files or functions whose name matches
    python tests/run_tests.py --failed        only what failed in the previous run (tests/.last-run.json)
    python tests/run_tests.py --related woodwork/lib/formula.typ
                                              only the test files that name one of these files, plus the previous failures
    python tests/run_tests.py -v              the traceback of a failure

Standard library only, no framework: a test is a function `test_*` in `tests/test_*.py`; a failure is an `AssertionError` or any exception; `conftest.Skip` skips. Typst 0.15.1 must be on the `PATH` (a test that needs it skips with that reason otherwise). The whole suite is small and runs in the foreground; a file is stopped after 300 s.

## Compiling in a test

`conftest.compile_typ(source, files=None, lang="en")` writes `source` as `main.typ` into a fresh temporary project that holds a copy of `woodwork/` (plus `files`, a dict of extra paths), compiles it with `--root` at that project, and returns `(ok, stdout, stderr, pdf_path)`. `conftest.query_values(source)` compiles with `typst query` on the engine's metadata and returns the registry's values, for tests that read a number rather than a page. `conftest.panic_message(stderr)` returns the message of a Typst panic alone (Typst 0.15 prints it without quotes), or `None`.

## What each file guards

| File | Guards |
|---|---|
| `test_tooling.py` | The skills and agents name no Woodcore path; `CLAUDE.md` and `docs/README.md` name only files that exist. |
| `test_engine_standalone.py` | `woodwork/` compiles alone in an empty project; no `json(` or `read(` of `woodwork/lib` reaches outside `woodwork/`; every `t-str` key has fr, de and en; the engine's words follow `text.lang`. |
| `test_domain_defaults.py` | What `#domain` is given holds for its lines, a line overrides it; `norm` is inherited where a line cites a clause; the default rendering (label left, formula, numbers, result) without `level`; keys of several indices; `"right"` and the refusal of `"line-right"`; no heading. |
| `test_units.py` | `units:` on a domain, for values written and results; `unit:` on a line; two units of one dimension refused. |
| `test_preset.py` | `preset:` equals the same settings written; the domain overrides its preset; a preset may set `units` and `norm`; an unknown preset is refused with the list. |
| `test_data.py` | Every table of `woodwork/data/` has its `_source`, cites no Woodcore path, and holds the values of the Woodcore table it was copied from (`tools/import_norms.py`'s map). |
| `test_from_and_cases.py` | `#var(…, from:, path:)` reads a value of `woodwork/data/` with its unit and citation, refuses a wrong path listing what is there; `#eq(…, cases:)` computes and prints the case that holds, refuses malformed cases. |
| `test_material.py` | `#material` reads a class, applies η_w and η_t, publishes its values with their provenance, takes an engineer's value, suffixes with `as:`, refuses an unknown class. |
| `test_generate.py` | `sheets/` is what `tools/generate.py` writes, byte for byte; a missing label key or language is named; the three trees have the same sheets; one named argument per line. |
| `test_sheets.py` | Every generated sheet compiles; standard and detailed give the same utilisation; the values equal Woodcore's reference cases. |
