---
name: architecture-review
description: Review a Woodwork specification against the existing engine, data and sheets before any code is written — affected files, code to reuse, duplication, hardcoded values, paths leaving woodwork/, the inheritance of #domain, three languages, the generated sheets, the rules of docs/architecture/principles.md — and give a verdict with the risks to address. Step 3 of big-feature; usable alone on any spec in docs/requirements/active/.
argument-hint: "docs/requirements/active/<fichier>.md"
---

# architecture-review — check the spec against what exists

Input: a spec (`$ARGUMENTS`). Output: spec **§13 Revue d'architecture**, and the verdict in the chat.

## 1. Delegate the review

Spawn the **`architecture-reviewer`** agent (Sonnet, read-only) with the spec path, the `docs/` files of its frontmatter `docs:`, `docs/architecture/principles.md` and `docs/architecture/layout.md`, and the instruction to read the **code** (`woodwork/lib/`, `source/`, `tools/`, `tests/`), not only the docs.

## 2. What the review must answer

1. **Affected files** — with `path:line` and what each owns today.
2. **Existing code to reuse** — engine functions (`push-frame`, `resolve-display`, `set-unit`, `calc-defaults`, `evaluate-formula`, `render-table`), `#material`, the generator. A new helper beside an existing one is a finding.
3. **Risks**, `ARCH-RISK-001…`, severity (bloquant / important / mineur), place, fix:
   - a value, word, label or formula written twice; a sheet edited in `sheets/` instead of `source/`;
   - a norm value outside `woodwork/data/`, a word outside `strings.json` or `labels.json`;
   - a path of `woodwork/lib/` leaving `woodwork/`, or written from the project root (`/woodwork/…`) inside the engine;
   - a new `state` where the registry or a domain frame would do; Typst `context` and convergence;
   - a command or argument added without the engineer's choice, inconsistent with its siblings, or missing its section in `docs/typst/commands.md`;
   - a sheet that no longer compiles alone (`woodwork/` + the sheet in an empty project);
   - a rule of `docs/architecture/principles.md` broken, a decision of `docs/decisions.md` contradicted;
   - dead code, needless abstraction, anything that works now and will hurt later.
4. **Recommended approach**, 5. **Tests** (`tests/test_*.py`), 6. **Verdict** — APPROUVER / APPROUVER AVEC RÉSERVES / REVOIR.

## 3. Record

Write it into §13 (French headings, English code names), add any requirement the review made necessary as `ARCH-xxx` with source «revue», set `status: reviewed` once the plan (§14) is written, log it in §16. A REVOIR goes back to the engineer before the plan.
