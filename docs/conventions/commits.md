# Commits, changelog, versions

- **One commit per finished task or plan step**, staged by name (`git add <path>…`), never `git add -A` while another session may be working in the tree.
- **Message**: a title that says what is now true, in plain English (`Sheets of tension and compression in three languages`), a blank line, then a paragraph on why and what it costs. End with the attribution lines the session gives.
- **`CHANGELOG.md`**: one entry per version, newest first; what a user of the sheets notices first, then what the maintainer notices.
- **Versions**: `0.MINOR.PATCH`, the minor for a new family of sheets or a new command or argument, the patch for a fix. The version is written in `woodwork/woodwork.typ` (`woodwork-version`) and in `CHANGELOG.md`.
- **Pushing**: to `origin/main` of `git@github.com:When-I-hit-the-wall/Woodwork.git`. The engineer authorised pushing Woodwork's work; the `finish` skill still asks once before each push. Before pushing, `git log origin/main..HEAD` shows what will go.
