---
name: verify-requirements
description: Independently verify a Woodwork implementation against its specification — every REQ, UI, ARCH and CON item and every acceptance criterion checked in the code, the diff, the generated sheets and the tests, not taken from the implementer's word — and report ✅ / ⚠️ / ❌ with evidence. Step 6 of big-feature; usable alone on any spec.
argument-hint: "docs/requirements/active/<fichier>.md [depuis <commit>]"
---

# verify-requirements — prove each requirement

Input: a spec (`$ARGUMENTS`), optionally the commit the work started from (else the first commit after the spec's `cree` date, else uncommitted changes against `HEAD`).

## 1. Delegate to an independent verifier

Spawn the **`requirements-verifier`** agent (Sonnet) with **only**: the spec path, the base commit, and the test command `python tests/run_tests.py` (or `-k <names>`). Do **not** give it the implementer's summary.

## 2. What it must check

For every item of §3–§6 and every line of §11: where it is realised (`path:line`) and how it is observed (a test and its result, a compiled sheet, a value read back); the criterion as written, not a weaker one; `sheets/` equal to what `tools/generate.py` writes; the three languages; `docs/` and `CHANGELOG.md`; nothing of §8 done anyway; no regression.

Verdicts: ✅ realised and proved · ⚠️ partly, or without proof · ❌ not realised.

## 3. Record and act

Write the table into §15, tick the ✅ lines of §11, log the round in §16, report in French the counts and every ⚠️/❌. Within `big-feature`: fix and verify again, at most two rounds.
