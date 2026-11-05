# docs/ — the map

Read only the file a task needs.

| File | What it holds |
|---|---|
| `architecture/principles.md` | The rules every change keeps: one source, Typst alone, the engine inside `woodwork/`, norm values read from `data/`, refusals as panics. |
| `architecture/layout.md` | Every folder of the repository and what lives in it; what the user copies and what stays with the maintainer. |
| `typst/commands.md` | The commands a sheet uses — `#domain`, `#var`, `#eq`, `#verify`, `#unit`, `#material` — their arguments, the inheritance from `#domain`, the presets, with examples. |
| `actions.md` | The Excel workbooks of the actions (snow, wind, permanent loads): what each computes, from which data, how they are built and checked. |
| `typst/engine.md` | How the engine is built: the registry, the domain frames, how a line resolves its display, the units, the language. For the maintainer of `woodwork/lib/`. |
| `conventions/testing.md` | The test runner, what each test file guards, how a test compiles Typst and reads a panic. |
| `conventions/writing.md` | Language, line endings, prose, how a sheet's source is written. |
| `conventions/commits.md` | Commit messages, `CHANGELOG.md`, versions, pushing. |
| `decisions.md` | Every settled decision, why, and what it costs. |
| `requirements/` | Specifications: `requirements/TEMPLATE.md`, `active/` (in progress), `completed/`, `rejected/`. |
