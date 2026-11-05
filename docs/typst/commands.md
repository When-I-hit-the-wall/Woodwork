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

### A constant of a clause or a table: `from:` and `path:` (Q-011)

```typ
#var("beta_c",
	from: "sia265/4.2.8-knicken",
	path: "clause.beta_c.Brettschichtholz")
#var("E_0_05",
	from: "sia265/tab48-druckfestigkeit-e005-brettschichtholz",
	path: "table_48.grades.GL24h.E_0_05")
```

`from:` names a file of `woodwork/data/` without `.json`; `path:` its keys joined by dots, an element of a list named by its `id`. The value is a number, or the `value` of the object the path ends on. Its unit is the one the table's `units` gives it, else the line's `unit:`, else none; its citation the norm and clause of the innermost object on the path that names one, unless the line writes its own. A path that leads nowhere stops the compile, listing what the file holds there. A norm value is never typed into a sheet: it is read so.

### A formula by cases: `cases:` (Q-012)

```typ
#eq("k_m",
	cases: (
		(`lambda_rel_m <= 0.75`, `1`),
		(`lambda_rel_m <= 1.4`, `1.56 - 0.75 * lambda_rel_m`),
		(auto, `1 / lambda_rel_m^2`)),
	norm-section: "4.2.9.2 (39)")
```

Each case is a pair: a condition -- a relation between two formulas, as `#verify` reads one -- and a formula. The first case whose condition holds is computed and printed, alone; the last case is `auto`, which always holds.

### Numbers (D-20)

A number is printed with at most three decimals, its thousands set apart by an apostrophe from 1'000 to 99'999 (`28'000 mm²`), and as a mantissa and a power of ten beyond (`1.235 · 10⁵`).

### Keys and symbols (D-15)

A key prints as a symbol: the part before the first `_` is the letter, a Greek name being its letter (`sigma` σ); every part after it is an index, separated by commas — `N_t_d` N<sub>t,d</sub>, `sigma_t_0_d` σ<sub>t,0,d</sub>, `f_t_alpha_d` f<sub>t,α,d</sub>. An index that is a word is upright: `E_0_mean` E<sub>0,mean</sub>, `k_dens` k<sub>dens</sub>.

## Forms and content templates

A **form** is the look of a document (decisions D-17): one file of `woodwork/forms/`, one function of its name, called by Typst's own rule.

```typ
#import "/woodwork/forms/bfh.typ": bfh
#set text(lang: "fr")
#show: bfh
```

`neutral` (A4, 2.5 cm margins, 11 pt, page number centred), `compact` (2 cm margins, 10 pt) and `bfh` (the Berner Fachhochschule's colours, Lucida Sans, its logo and the current chapter in the header, the school's names and the page in the footer, a chapter to a page). `#show: bfh.with(lang: "de")` also sets the language Typst works in; without it the form keeps the document's. A form prints no title page.

A **title page** is a content template: `templates/<lang>/titre-bfh.typ` (or `titre-neutre.typ`), copied beside the document, its fields filled at its top (document, project, number, rows of people, date), included first: `#include "titre-bfh.typ"`. It is a page of its own, with neither header nor footer.

The three **documents** -- convention d'utilisation, base de projet, rapport de statique -- are skeletons in `templates/<lang>/`: an entry file that sets the form and includes the title page and the sections, and `Sections/` with Woodcore's headings, prose and tables to fill; where Woodcore printed its export, a comment says what to paste.

### Tables in the form `bfh`

In a document set in the form `bfh`, a table written straight into a figure takes the BFH table style (spec 2026-11-05-style-tableaux-bfh): its title above it, centred, larger than its cells; the header in the BFH grey-blue, white and bold; the body's rows striped; the rows of a `table.footer` set as totals -- bold, after a rule, a yellow mark on their first cell; no hyphenation in a cell. Whatever the figure holds after the table -- a note, a legend -- stands under it, small and to the left, and stays with it across a page break. Nothing to call: the form does it. A table the engine lays out itself (`var-table`, a check's table) keeps its own look, and so do the forms `neutral` and `compact`.

```typst
#figure(caption: [Schichtaufbau Dach – ständige Lasten], {
  table(
    columns: (auto, 1fr, auto, auto, auto, auto, auto),
    align: (left, left, right, right, right, right, right),
    table.header([Typ], [Schicht], [Dicke \ \[mm\]], [Breite \ \[mm\]], [Abstand \ \[mm\]], [Gewicht], [Last \ \[kN/m²\]]),
    [$a_k$], [Latte C24], [40], [60], [2160], [5 kN/m³], [0.006],
    [$g_k$], [Brettschichtholz GL24h], [640], [220], [2000], [5 kN/m³], [0.352],
    table.footer(
      [$g_k$], table.cell(colspan: 5)[Total Eigengewicht], [0.352],
    ),
  )
  [$g_k$ Eigengewicht, $a_k$ Auflast. Last je Schicht = Wichte · Dicke · Breite / Abstand.]
})
```

## `#show-norm-list`

`#show-norm-list(keys: ("SIA 260", "SIA 261", "SIA 265"))` lists the documents named, in full -- designation, title, publisher and edition -- as `woodwork/data/norms.json` gives them, and cites each for the bibliography. A key may be content of one's own, `[Lärmschutz-Verordnung (LSV)]`. Taken from Woodcore's `lib/document.typ`.

## `#material` — a strength class and its design values

```typ
#domain("tension", norm: "SIA 265")[
  #material("GL24h",
	moisture: 2,
	print: ("f_t_0_d",))
  …
]
```

- Reads the class in SIA 265 Tabelle 8 (solid timber) or 9 (glulam), in `woodwork/data/sia265/`, else in the office's `woodwork/data/my-materials/materials.json` (a list under `materials`: `id`, `_source`, `norm`, `norm_ref` and the values under the keys of the tables). An unknown class stops the compile, naming both places and the classes they hold.
- Publishes, as variables of the domain: `eta_w` (Tabelle 4, its resistance column, for `moisture:` 1, 2 or 3), `eta_t` (2.2.6: 1.0, or 1.4 with `impact: true`), each design strength `f_m_d`, `f_t_0_d`, `f_c_0_d`, `f_t_90_d`, `f_c_90_d`, `f_v_d` as η<sub>w</sub> · η<sub>t</sub> · the table's value (the table's own as `<key>_tab`), and `f_m_k`, `E_m_mean`, `E_0_mean`, `E_90_mean`, `G_mean`, `rho_k` as the table gives them. SIA 265 Tabelle 8 and 9 give design values: nothing is divided by γ<sub>M</sub> (Woodcore's rule, `Strengths._grade`).
- `case:` the case of f<sub>c,90,d</sub> — `"generell"` (default), `"mit_vorholz"`, `"endauflagerung"`; `larger: true` the bracketed value.
- `f_t_0_d: 11.0` (any key above): a value of the engineer's own, replacing the table's, labelled so.
- `suffix: "1"`: every key suffixed (`f_c_90_d_1`, `eta_w_1`), for two materials in one domain. (`as`, the name first planned, is a word of Typst and cannot name an argument.)
- Prints nothing unless asked: `print: ("f_t_0_d",)` prints η<sub>w</sub>, η<sub>t</sub>, the table's value and the calculation of each key listed, cited.
