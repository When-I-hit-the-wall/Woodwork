---
name: implementation
description: Implement an approved Woodwork specification step by step following its implementation plan, keeping the spec's progress log current so the work can resume after an interruption, then run the tests and update the documentation. Step 5 of big-feature; refuses a spec that is not approved.
argument-hint: "docs/requirements/active/<fichier>.md"
---

# implementation — carry out an approved plan

Input: a spec (`$ARGUMENTS`) whose status is `approved`, `implementation` or `testing`. If it is earlier, stop and say so.

## 1. Read before writing

The spec — §3–§8, the review (§13), the plan (§14), and §16 to resume at the first step not done. Then the `docs/` files it lists and the code the plan touches. For Typst, read the **`typst-sheet`** skill (Woodwork's commands and traps) and, for the language itself, **`typst-writing-document`**.

## 2. Implement, one plan step at a time

1. Targeted edits; LF; never `git checkout --`, `stash`, `reset`, `clean`.
2. Keep `docs/architecture/principles.md`: one source; norm values from `woodwork/data/`; engine words in `woodwork/lib/strings.json` (fr/de/en); sheet words in `source/labels.json` (fr/de/en); the engine never reads outside `woodwork/`.
3. A sheet: write `source/…`, its keys in `labels.json`, then `python tools/generate.py`; add it to `examples/`.
4. A command or argument: its section in `docs/typst/commands.md` with an example that compiles, and a refusal (panic) naming what is wrong for a wrong value.
5. Add or extend the tests that prove the step.
6. Append to §16: date, step, items now done (and the commit, once pushed).

If a step turns out impossible or wrong as planned, stop and tell the engineer; do not change the plan's scope quietly.

## 3. Test → `status: testing`

`python tests/run_tests.py -k <name>` or `--related <changed files>`; then the whole suite (it is small). Report anything red by name with its output.

## 4. Documentation

The `docs/` sections the change made wrong, `docs/decisions.md` for a settled decision, `CHANGELOG.md`. Then hand over to `verify-requirements`; the verifier decides what is done.
