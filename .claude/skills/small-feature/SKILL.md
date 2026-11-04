---
name: small-feature
description: Light Woodwork workflow for a small, local change — a fix or adjustment in one sheet or one engine function, with no new command, argument or data shape and no architectural choice. States 3–8 acceptance criteria in the chat, implements without waiting for approval, tests, then checks every criterion with evidence. Escalate to big-feature when the change turns out larger.
argument-hint: "[demande]"
---

# small-feature — a small change, still verified

The request is in `$ARGUMENTS`. Talk to the engineer in **French**; code, docs and comments stay in English.

## 1. Understand (no file written)

- Restate the request in one sentence and list **3 to 8 acceptance criteria** (`C1`…), each observable: a printed value, a refusal, a test. Include the documentation a change of behaviour needs (`docs/` section, `CHANGELOG.md`) and, for a sheet, its three languages.
- Read the `docs/` file that covers the area (`docs/README.md`) and the code concerned.
- If an open point would change the criteria, ask it (one round). Otherwise proceed.

**Escalate** to `big-feature` (say so in one line) as soon as the change needs a new command, argument or data shape, touches several families of sheets or the engine and the sheets together, or raises an architectural choice.

## 2. Implement

- **A bug starts with a red test**: reproduce it, read the failure, fix, see it green; the test stays.
- A sheet is changed in `source/` (and `source/labels.json` for a word), then `python tools/generate.py` rewrites `sheets/`. Never edit `sheets/` by hand.
- Respect `docs/architecture/principles.md`: one source, norm values read from `woodwork/data/`, the engine inside `woodwork/`, three languages.
- Targeted edits; never `git checkout --`, `stash`, `reset`, `clean`.

## 3. Test

`python tests/run_tests.py -k <name>` or `--related <changed files>` from `Woodwork/`. Report failures by name with their output.

## 4. Verify

Re-read `git diff` against each criterion:

| Critère | Verdict | Preuve |
|---|---|---|
| C1 | ✅ / ⚠️ / ❌ | fichier:ligne, test, sortie |

Fix what is ⚠️/❌ once; report what remains.

## 5. Finish

Follow the **`finish`** skill.
