# Commands

The commands a sheet uses, once `#import "/woodwork/woodwork.typ": *` is written. This page is completed as each command lands (founding spec, plan steps 3, 4 and 6).

## `#domain` — the frame of a calculation

```typ
#domain("tension-p12",
	preset: "report",
	norm: "SIA 265",
	label-position: "left",
	norm-position: "right",
	units: ("Nm",))[
  …lines…
]
```

`#domain` prints no heading (the sheet writes `= Title (norm)`). Every argument after the id is a default of the lines of its body — `preset`, `norm`, `label-position`, `label-width`, `descr-position`, `norm-position`, `display`, `display-formula`, `display-equation`, `style`, `stack`, `units` — and a line that writes the same argument overrides it for itself. Order: the line, the domain, the preset, Woodwork's defaults.

## `#var`, `#eq`, `#verify`

`#var("key", value, "unit", label: …)` declares a value; `#eq("key", `formula`, label: …)` computes one from the variables above it; `#verify(`a <= b`, label: …)` checks a relation and prints ✓ or ✘. Their arguments are Woodcore's, without `level` in the sheets.

## `#material`

Reads a strength class from `woodwork/data/` and publishes its design values as variables (founding spec REQ-009).
