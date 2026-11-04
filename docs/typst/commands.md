# Commands

The commands a sheet uses, once it has imported Woodwork from the root of its project:

```typ
#import "/woodwork/woodwork.typ": *
```

`woodwork.typ` gives `domain`, `var`, `eq`, `verify`, `unit`, `calc-defaults`, `var-table`, `show-bibliography`, `cite-norm`, `get`, `report-level`, `number-digits` and `woodwork-version` — nothing of the engine's helpers.

## `#domain` — the frame of a calculation, and the defaults of its lines

```typ
= Traction dans l'axe (SIA 265)

#domain("tension-p12",
	norm: "SIA 265",
	label-position: "left",
	norm-position: "right")[
  #var("N_t_d", 180, "kN",
	label: "Effort de traction")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 200, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Section")
  #eq("sigma_t_0_d", `N_t_d / A`,
	label: "Contrainte de traction",
	norm-section: "4.2.1.1")
]
```

- **No heading.** The sheet writes its title by hand (`= Title (norm)`); `#domain` takes no `label`, `descr` or `norm-section` of its own (decisions D-11).
- **What it is given holds for its lines.** `preset`, `norm`, `label-position`, `label-width`, `descr-position`, `norm-position`, `display`, `display-formula`, `display-equation`, `style`, `stack` and `units` are the defaults of every `#var`, `#eq` and `#verify` of its body. A line that writes the same argument overrides it, for itself only.
- **Order**: the line, then the domain (the innermost first), then its preset, then Woodwork's defaults.
- **`norm`**: the norm a line cites when it writes a clause (`norm-section:`) and no norm of its own. A line without a clause cites nothing (D-16).
- **`units`**: a list, one unit per dimension — `units: ("Nm", "cm²")`. Every value written and every result of that dimension in the domain is held and printed in it: `#var("M_d", 12.4, "kNm")` is 12 400 Nm. A line keeps `unit:` for itself. Two units of one dimension stop the compile, naming both (D-7).
- **`preset`**: a name in `woodwork/data/presets.json`, whose entry may set any of the defaults above, `units` and `norm` included. An unknown preset stops the compile with the list of presets. `report` ships with Woodwork.
- **`norm-position`** takes `"none"`, `"in-line"`, `"right"` (the right-hand column) and `"footnote"`; `"line-right"`, Woodcore's name, is refused with the new one (D-14).
- **`level`** is still accepted for a special case; no sheet writes it.
- A domain keeps its variables apart: a name is looked up in the innermost domain, then outside every domain; `#var("F", domain: "other")` reads one of another domain.

### Woodwork's defaults (D-12)

Without anything written, a line prints its label in a column at the left, then the formula in letters, the same in numbers with their units, and the result; its citation in the right-hand column. This is the `block` family of the display presets at level 3, with `label-position: "left"` and `norm-position: "right"`.

## `#var`, `#eq`, `#verify`

- `#var("key", value, "unit", label: …)` declares a value. `#var("key", "symbol", value, "unit")` prints another symbol.
- `#eq("key", `formula`, label: …)` computes a value from the variables above it, in Typst, with units; `unit:` converts the result, `value:` gives it for a formula Typst cannot evaluate.
- `#verify(`a <= b`, label: …)` checks a relation and marks it ✓ or ✘ under a double rule. With `name-calc: "eta", name-visible: "eta"` it prints the ratio against 1, `η = σ/f = 6.429/12.8 = 0.502 ⩽ 1`, and stores `eta`.
- Their arguments are Woodcore's: `label`, `label-position`, `label-width`, `descr`, `descr-position`, `norm`, `norm-section`, `norm-position`, `display`/`display-formula`/`display-equation`, `style`, `stack`, `role`, `id`, `level`.

### Keys and symbols (D-15)

A key prints as a symbol: the part before the first `_` is the letter, a Greek name being its letter (`sigma` σ); every part after it is an index, separated by commas — `N_t_d` N<sub>t,d</sub>, `sigma_t_0_d` σ<sub>t,0,d</sub>, `f_t_alpha_d` f<sub>t,α,d</sub>. An index that is a word is upright: `E_0_mean` E<sub>0,mean</sub>, `k_dens` k<sub>dens</sub>.

## `#material`

Reads a strength class from `woodwork/data/` and publishes its design values as variables (founding spec REQ-009; plan step 6).
