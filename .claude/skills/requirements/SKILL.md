---
name: requirements
description: Turn a Woodwork request — a voice transcript, a long message or a file — into a traceable French specification in docs/requirements/active/, classifying every point of the source as requirement, constraint, decision, idea, question or ambiguity, without implementing anything. Step 1 of big-feature; also usable alone to write a spec.
argument-hint: "[transcription ou demande | chemin d'un fichier]"
---

# requirements — from a source to a specification

**Implement nothing in this skill.** The output is one spec file and, in the chat, its open questions.

## Procedure

1. **Read the whole source** (`$ARGUMENTS`, or the file it names). A transcript is read to the end before anything is written: a later sentence often corrects an earlier one.
2. **Number the source**: copy it verbatim into §2 of the spec, cut into points `T1, T2…` (one point = one request, remark or idea). Never paraphrase in §2.
3. **Classify every point** — each `T` ends up in exactly one place:
   - an explicit request → `REQ` (behaviour of a command or a sheet), `UI` (what a sheet prints, how it reads) or `ARCH` (structure);
   - something imposed (norm, edition, compatibility of sheets users already copied, «il ne faut pas…») → `CON`;
   - something the engineer has already settled → §7 Décisions;
   - «on pourrait», «peut-être», an example given to illustrate → §9 Idées (**not** a requirement);
   - unclear, contradictory or underspecified → `Q` question in §10, with why it matters and options (recommended first);
   - explicitly excluded → §8 Hors périmètre.
4. **Add the implicit constraints that matter**, each marked as inferred and pointing to its source: the rules of `docs/architecture/principles.md` the change touches (one source, Typst alone, the engine inside `woodwork/`, norm values read from `data/`, three languages), the regeneration of `sheets/`, the tests and docs it will need.
5. **Check against what exists** before writing a requirement: grep `woodwork/lib/`, `source/`, `woodwork/data/` and `docs/`, so a REQ says *what changes* rather than re-asking for what is built. Use `code-scout` (Haiku) when it is more than a quick grep.
6. **Write each item testably**: «Woodwork doit …», its source `T`, its priority, and an acceptance criterion someone else could check (which sheet, what value, which test).
7. **Fill §11 (checklist) and §12 (traceability)**: every `T` appears in §12 with its element or its classification; list the unresolved ones.
8. **Self-check**: every `T` is in §12; every REQ/UI/ARCH has a criterion in §11; no item invents something the source does not say. Set `status: draft`, write §16's first line.

## Delegation

For a long transcript (more than ~40 lines or several topics), give steps 2–3 to the **`requirements-analyst`** agent (Sonnet) with the full source and `docs/requirements/TEMPLATE.md`, then do steps 4–8 yourself.

## Output

- File: `docs/requirements/active/<YYYY-MM-DD>-<slug>.md`, from `docs/requirements/TEMPLATE.md`, in French, the engineer's words quoted exactly.
- In the chat: the path, a count (n REQ, n UI, n ARCH, n CON, n ideas, n questions) and the questions.
