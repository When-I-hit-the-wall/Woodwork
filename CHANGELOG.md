# Changelog

## Unreleased — 0.1.0

- The repository, its licence (GPL-3.0, as Woodcore's engine it derives from) and the founding specification.
- The engine taken from Woodcore (`woodwork/lib/`), cut to what a sheet needs; `#domain` hands its settings to its lines (norm, positions, display, `units:`, `preset:`), prints no heading; `norm-position: "right"`; keys of several indices print as the norm writes them (N t,d).
- `#material`: a strength class of SIA 265 Tabelle 8 or 9, or of the office's `my-materials/`, and its design values η_w · η_t · f_d.
- `woodwork/data/`: 57 tables of SIA 265, SIA 265/1, SIA 260 and SN EN 14592, copied from Woodcore.
- `tools/generate.py`: the three language trees of `sheets/` from one source.
- The 18 checks of phase 1, standard and detailed, in fr, de and en (108 sheets): tension (parallel, perpendicular, at an angle), compression (parallel, perpendicular, at an angle), bending (parallel, biaxial, at an angle, with tension, with compression), shear (4.2.5.1, shear-off 4.2.6, with a stress perpendicular to the grain 4.2.7.1), buckling (4.2.8), lateral torsional buckling (4.2.9, with compression, with tension). Each one's utilisation equals Woodcore's member check for the same inputs.
- `#var(…, from:, path:)` reads a constant of `woodwork/data/`; `#eq(…, cases:)` computes by cases; a power's exponent may be a variable; `#material` also gives f_c,0,k, η_w,E and E_0,05 (Anhang B).
- The templates of form (`woodwork/forms/`: `neutral`, `compact`, `bfh`, each `#show: <name>`), the title pages `titre-bfh` and `titre-neutre`, and Woodcore's three documents as skeletons in three languages (`templates/`); `#show-norm-list`.
- The development tooling: `CLAUDE.md`, `docs/`, the skills (`requirements`, `big-feature`, `small-feature`, `architecture-review`, `implementation`, `verify-requirements`, `finish`, `issue`, `typst-sheet`, and Tinymist's `typst-writing-document`), the agents, and the test runner.
