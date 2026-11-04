# The engine

How `woodwork/lib/` works, for its maintainer. Completed at plan step 3 (the extraction from Woodcore).

- **The registry** (`var-registry`, a Typst `state`) holds every variable, the stack of open domains (their frames: id, defaults, units) and the document's defaults. A command writes in its `update` and prints in a `context`; an update cannot read another state, which is why everything a line needs lives in the registry's own dictionary.
- **A line resolves its display** through `resolve-display`: the line's own arguments, then the frames of the open domains (innermost first), then the document's defaults, then the preset family.
- **A formula is computed by Typst** (`evaluate-formula`, `tokenize`, `parse-expr`): values in base units, dimensions multiplied, the result's unit chosen by `units.json`, a domain's `units:` or the line's `unit:`.
