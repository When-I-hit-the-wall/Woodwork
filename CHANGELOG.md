# Changelog

## Unreleased — 0.1.0

- The repository, its licence (GPL-3.0, as Woodcore's engine it derives from) and the founding specification.
- The engine taken from Woodcore (`woodwork/lib/`), cut to what a sheet needs; `#domain` hands its settings to its lines (norm, positions, display, `units:`, `preset:`), prints no heading; `norm-position: "right"`; keys of several indices print as the norm writes them (N t,d).
- `#material`: a strength class of SIA 265 Tabelle 8 or 9, or of the office's `my-materials/`, and its design values η_w · η_t · f_d.
- `woodwork/data/`: 57 tables of SIA 265, SIA 265/1, SIA 260 and SN EN 14592, copied from Woodcore.
- `tools/generate.py`: the three language trees of `sheets/` from one source; the first sheet, tension parallel to the grain, standard and detailed.
- The development tooling: `CLAUDE.md`, `docs/`, the skills (`requirements`, `big-feature`, `small-feature`, `architecture-review`, `implementation`, `verify-requirements`, `finish`, `issue`, `typst-sheet`, and Tinymist's `typst-writing-document`), the agents, and the test runner.
