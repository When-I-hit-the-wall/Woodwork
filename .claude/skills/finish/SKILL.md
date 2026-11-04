---
name: finish
description: End of a Woodwork task — the sheets regenerated, the whole test suite and a repair loop until it is green, one commit, one question «Pousser ?», the push to origin/main of When-I-hit-the-wall/Woodwork, and the GitHub issues the task worked on closed with a comment. Last step of small-feature and big-feature; usable alone on finished work.
argument-hint: "[#issues…]"
---

# finish — green, committed, pushed, issues closed

Talk to the engineer in **French**; issue comments in French too. Run everything from `Woodwork/`.

## 1. The issues

Those named in `$ARGUMENTS`, the request or the spec. None named → none closed. Read each with `gh issue view <N> -R When-I-hit-the-wall/Woodwork --comments` (`gh` may be `"/c/Program Files/GitHub CLI/gh.exe"`) and note which of its points this task did.

## 2. Regenerate, then test

1. `python tools/generate.py` — `sheets/` must be what the generator writes.
2. `python tests/run_tests.py` (the suite is small; run it in the background if it passes two minutes and wait for its notification).
3. **Red** → for each failure decide whether this task caused it (`git diff`); fix what it broke, rerun `--related <changed files>` plus `--failed`. At most three rounds; what is still red is reported by name with its output and nothing is committed.

## 3. Commit

Stage the task's own files by name (`git add <path>…`, never `-A`); one commit per `docs/conventions/commits.md`, naming the issues, ending with the session's attribution lines. A failing hook is fixed, never skipped.

## 4. One question, then push and close

Show the commit (hash, title), the test result, `git log origin/main..HEAD`, and for each issue whether it will be closed or commented. Ask once (AskUserQuestion, header «Pousser», «Pousser et fermer les issues ?»): **Pousser et fermer** / **Pousser seulement** / **Ne rien envoyer**.

On a push: `git push origin main`. A refused push (behind) → say so and ask; no silent `pull --rebase`. For each issue: the comment written to a UTF-8 file in the scratchpad (Write tool), `gh issue comment <N> -R When-I-hit-the-wall/Woodwork --body-file <file>`, then `gh issue close <N> … --reason completed` when every point is done:

```markdown
Fait dans <hash court> (v0.x.y).

- <point> — <ce qui a été fait, fichier ou feuille>

Tests : <N> passés, <M> ignorés.
```

## 5. Report

Issue → fermée / commentée (link), the commit and the push, the test result; one line for anything not done.
