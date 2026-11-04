---
name: big-feature
description: Full Woodwork workflow for a substantial change — requirements extraction into a spec file, clarification questions, independent architecture review, one approval, implementation, tests and independent verification against the spec. Use for a new command or argument, a new family of sheets, a change to data/'s shape or to a rule of docs/architecture/principles.md, and for every dictated request. Also resumes an interrupted spec when given a path in docs/requirements/active/.
argument-hint: "[transcription ou demande | docs/requirements/active/<fichier>.md]"
---

# big-feature — from a request to a verified change

The engineer's request is in `$ARGUMENTS`. Talk to him in **French**; write the spec in French and code, docs and comments in English.

This skill orchestrates; each step's method lives in its own skill. Keep the spec file current at every step: it is what makes the work resumable.

## 0. Start or resume

- If `$ARGUMENTS` is a path under `docs/requirements/active/`, read it, its frontmatter `status` and its **§16 Journal d'avancement**, say in one line where it stopped, and jump to the matching step. Never redo a finished step unless the engineer asks.
- Otherwise start at step 1. If the request turns out to be small (one sheet or one engine function, no new command, argument or data shape), say so and offer `small-feature`.

## 1. Requirements → `status: draft`

Follow the **`requirements`** skill.

## 2. Clarification → `status: specified`

Ask the open questions of §10 together, in one round (AskUserQuestion, recommended option first), only those that change requirements, architecture, implementation or acceptance criteria. Record the answers in §10, the decisions in §7. A new command, argument or data shape is always the engineer's choice (`CLAUDE.md`).

## 3. Architecture review and plan → `status: reviewed`

Follow the **`architecture-review`** skill, then write **§14 Plan d'implémentation**: ordered steps, files touched, which REQ/UI/ARCH each realises, the test that proves it. Apply every risk the review raised, or say why not.

## 4. The one approval → `status: approved`

Present briefly: the objective, the requirements (IDs, one line each), the decisions, the review's verdict and main risks, the plan's steps, what will **not** be done. Ask once: *Approuver et implémenter* / *Modifier* / *Arrêter* (→ `rejected/` with the reason). No code before the approval.

## 5. Implementation → `status: implementation` then `testing`

Follow the **`implementation`** skill; update §16 after each plan step.

## 6. Verification → `status: verification` then `completed`

- Follow the **`verify-requirements`** skill. For every ⚠️ or ❌: fix it, verify again — at most two rounds; what remains is reported, never hidden.
- When every criterion is ✅: tick §11, set `completed`, `git mv` the file to `docs/requirements/completed/`, and report in French: what was done, the tests and their result, what was left out, the decisions added to `docs/decisions.md`.
- Then follow the **`finish`** skill.

## Rules through every step

- Never `git checkout --`, `stash`, `reset` or `clean`.
- `sheets/` is generated: change `source/` and run `python tools/generate.py`.
- Delegate only where it pays: `code-scout` (Haiku) to locate, the three Sonnet agents for their roles; the implementation stays in the main session.
- Every status change is a line in §16 with the date (`mis_a_jour` too).
