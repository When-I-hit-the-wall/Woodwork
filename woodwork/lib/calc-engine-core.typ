// lib/calc-engine-core.typ -- the report's level, the numbers, the data and its access (`ids`, `get`, `find`), the formula laid out on its rows, the position and connector summary lines.
// Split out of lib/calc-engine.typ by subject, its text moved and not rewritten (spec docs/requirements/active/2026-10-19-base-saine-nettoyage.md, G9). Each part imports the one before it, so a name reads everything defined above it as it did in one file; lib/calc-engine.typ imports the last and is what every caller names.

// The registry, the levels, the numbers and their display: the core of the engine Woodwork took from Woodcore.

// Every word this file prints comes out of one glossary, in the report's language (docs/typst/language.md §4bis). `t-str` is the engine's own word by a key, `tl-str` a string the data carries -- translated if the glossary knows it, left alone if not, which is what keeps a material's name and an Excel description in the engineer's own words. Imported here rather than in each section, so commands.typ re-exports it with the rest.
#import "i18n.typ": *
// how a number is written: the one display rule, and the rounding it is built on (UI-002, UI-003, v0.120)
#import "number.typ": *
// how a subscript is written: every symbol and formula is evaluated through `math-eval` (UI-001, spec 2026-10-20-indices-et-niveaux)
#import "subscript.typ": *

// --- Report level (docs/typst/report-engine.md §4) -----------------------------------
/// The report's default level of detail, 1, 2 or 3 (section 3.7). Set once in a document — `#report-level.update(2)` — from `--input level=`; any call overrides it locally with `level:`.
///
/// ```typ
/// #report-level.update(3)
/// #var("s_k", 1.48, "kN/m²")
/// ```
///
/// ```typ
/// #report-level.update(1)
/// #var("s_k", 1.48, "kN/m²")
/// ```
///
/// -> state
#let report-level = state("report-level", 3)

/// The level a show-* call actually renders at (docs/typst/report-engine.md §4). Three sources, in order: the uniform level if one is forced, else the call's own `level:` when it states one, else the global report level. Call inside `context` -- it reads two states.
/// - level (int, auto): the `level:` the calling show-* function was given.
/// -> int
#let resolve-level(level) = {
  let from-state = if level == auto { report-level.get() } else { none }
  if from-state == none { return level }
  // ⚠️ The two states are checked where they are read (v0.86): `#report-level.update(0)` hid every #var and #val while show-calc went on printing, `update(4)` printed level 3 without a word, and `update("2")` failed on «cannot compare string and integer». 0 is a level of one call, never of a report (section 4).
  if not (from-state in (1, 2, 3)) {
    panic("the report level is " + repr(from-state) + " -- report-level takes 1, 2 or 3; "
      + "0, which prints nothing, is given to one call as level: 0 (docs/typst/report-engine.md §4)")
  }
  from-state
}

// --- The level of a figure, a table or a list (spec 2026-10-20-indices-et-niveaux, UI-003, D-04, D-07) ----
// Every command that prints takes `level:` (Q-007 of the base saine): 1 the figure, the table or the list alone; 2 with its legend and its titles -- what a document printed until v0.120, its own level 2 being unchanged --; 3 with its sources and its citations, where it has any (build_reference_lib.LEVELS_CONFOUNDED names those that have none, and why).

/// The level a figure, a table or a list prints at: its call's `level:` -- auto, 1, 2 or 3 -- resolved as every command's is (`resolve-level`: the uniform level, else the call's, else the report's). Call inside `context`.
///
/// ```typ
/// #context print-level("image-positions-plan", auto)
/// ```
///
/// ```typ
/// #context print-level("image-positions-plan", 3)
/// ```
///
/// - fn (str): the command's name, for the message where `level` is not one of auto, 1, 2, 3.
/// - level (auto, int): the call's `level:`.
/// -> int
#let print-level(fn, level) = {
  if not (level in (auto, 1, 2, 3)) { panic(fn + ": invalid level " + repr(level) + " -- use auto, 1, 2 or 3") }
  resolve-level(level)
}

/// An argument whose default is `auto` decided by the level: what the call wrote where it wrote it -- `legend: false` stays false at every level --, else printed from level `from` on.
///
/// ```typ
/// #at-level(auto, 1, 2) -- #at-level(auto, 2, 2) -- #at-level(true, 1, 2)
/// ```
///
/// ```typ
/// #at-level(false, 3, 2)
/// ```
///
/// - arg (auto, bool): the argument as the call wrote it.
/// - lv (int): the level the command prints at (`print-level`).
/// - from (int): the level it is printed from when the call leaves it `auto`.
/// -> bool
#let at-level(arg, lv, from) = if arg == auto { lv >= from } else { arg }

// The figures' colours and font, woodwork/lib/figure-palette.json.
#let figure-palette = json("figure-palette.json")
#let figure-colour(token) = figure-palette.colours.at(token)

// A citation as the page sets it: in the palette's `ink-soft` grey, so that it draws the eye less than the calculation it cites (spec 2026-10-21-commandes-typst-refonte, UI-001, D-10) -- `ink-soft` and not `muted`, which is too pale to read at 8 pt. `size` is the citation column's 8 pt, and `auto` for a citation in a sentence, which keeps the size of its text.
#let cite-text(body, size: 8pt) = if size == auto { text(fill: rgb(figure-colour("ink-soft")), body) } else { text(size: size, fill: rgb(figure-colour("ink-soft")), body) }

// A coordinate as SVG text: `digits` decimals, and a hyphen for the sign -- Typst's str() writes a typographic minus, which an SVG parser does not read, so an element whose coordinate is negative would be dropped without a word. The one writer of a number into a figure's SVG; each figure keeps the precision its Python engine draws at (calc/domains/svg_draw.number_at): 2 for a plan, a schema and a connection, 3 for a static model (spec 2026-10-19-base-saine-nettoyage, D7, which merged plan-number, static-number, schema-number and the connections' own svg-number).
#let svg-number(x, digits: 2) = str(calc.round(x, digits: digits)).replace("−", "-")

// --- Number formatting (document-wide) ------------------------------------
// `number-digits` set how many decimals the report printed, until v0.120. Since then every number is printed by one rule (lib/number.typ, `display-number`: three decimals at most, powers of ten past 99 999 -- the engineer's decision of 19.10.2026, spec 2026-10-19-base-saine-nettoyage UI-003), and the setting changes nothing. The state stays so that a document written before -- every template set `#number-digits.update(3)` -- still compiles; it is no longer a command of the reference.
#let number-digits = state("number-digits", 3)

// --- The variables a report writes by hand (docs/typst/formulas.md §10quinquies) -
// One dictionary for the whole document: `#var` and `#eq` write into it, and `#eq`, `#verify` and `#val` read it back by name. That is what lets a formula name its own operands -- `` `F_Ed / R_d` `` -- instead of repeating them in a `where:`, which is what made v0.60's eq unreadable: a variable had *three* names (the Typst binding `R-k`, the `where:` key `R_k`, the printed symbol `R_"k"`), the three had to agree, and nothing checked that they did.
//
// ⚠️ A name here is a **string**, and this dictionary is where it lives: Typst gives a function no way to bind a name in its caller's scope -- there are no macros, and `eval(scope:)` evaluates in a fresh scope -- so `#var("R_k", 7, "kN")` cannot create a `#let R_k`. That is the whole reason for the registry, and it is not a limitation anyone can lift later.
//
// The domain stack lives *inside* the same dictionary rather than in a state of its own, and that is not tidiness: a state's update function cannot read another state, so `var-registry.update(d => ...)` -- which is where a variable is computed and stored, outside any `context` -- has to find the current domain in `d` itself. `var-domain` pushes and pops it exactly as calc-block pushes block-scope.
#let var-registry = state("var-registry", (stack: ("",), domains: (:), defaults: (presets: "block", label-position: "left", norm-position: "right")))

// The domain a variable written at this point belongs to: the innermost var-domain, or "" outside them all.
#let var-current(d) = d.stack.last()

// One variable by name: the current domain first, then the default domain "". That fallback is what lets R_d, declared at the level of a section, be named inside the columns of a grid that each declare a domain of their own. `none` when there is no such name.
#let var-lookup(d, key) = {
  let here = var-current(d)
  if here in d.domains and key in d.domains.at(here) { return d.domains.at(here).at(key) }
  if "" in d.domains and key in d.domains.at("") { return d.domains.at("").at(key) }
  none
}

// Every name a formula written at this point could cite, for the message of one that is not among them.
#let var-names(d) = {
  let here = var-current(d)
  let names = if "" in d.domains { d.domains.at("").keys() } else { () }
  if here != "" and here in d.domains { names += d.domains.at(here).keys() }
  names.dedup().sorted()
}

// Writes one variable into the current domain. A pure function of the dictionary, so that it runs inside `var-registry.update(...)` and never has to read a state.
#let var-store(d, key, record) = {
  let here = var-current(d)
  let dom = d.domains.at(here, default: (:))
  dom.insert(key, record)
  d.domains.insert(here, dom)
  d
}

// References of the block below (moved out of it, issue #115): spec 2026-10-19-base-saine-nettoyage, REQ-002; spec 2026-10-21-commandes-typst-refonte, REQ-009.
/// **One field of a variable already read** (`find`, a record's `vars`, or one the report declared, by its name) -- one command for the eight `get-*` of before v0.120. The rest of the engine reads a variable's fields through it, never `.value` or `.unit` directly, so a change of the variable's shape touches this one place (docs/typst/report-engine.md §6).
///
/// ```typ
/// #get((value: 1.394, unit: "kN/m²", symbol: "s_k"), "value")
/// ```
///
/// ```typ
/// #var("q_k", 3, "kN/m²", level: 0)
/// #context fmt-number(get("q_k", "value") * 0.7, get("q_k", "unit"))
/// ```
///
/// A variable the report declared is named by its name, read in the registry where the call stands -- a state, so in a `context`: a sentence that depends on a result.
///
/// ```typ
/// #var("eta", 0.75, level: 0)
/// #context if get("eta", "value") <= 1 [Die Bemessung ist ausreichend.] else [Die Bemessung genügt nicht.]
/// ```
///
/// - v (dictionary, str): a `var` object (docs/architecture/data-contracts.md §3.1), or the name of a variable the report declared -- in a `context`.
/// - field (str): `"value"`, `"unit"` (never implicit: "" for a dimensionless quantity), `"symbol"`, `"label"`, `"norm"`, `"norm_ref"`, `"description"`, `"choices"` or `"role"`. The description and the choices are optional in a variable and give none where it has none, the role is "data" where none was given; every other field is required, and an unknown one fails naming the valid ones.
/// - domain (str, none): for a name, the domain it is read in; none reads the current domain, then the default one.
/// -> any
#let get(v, field, domain: none) = {
  // a variable named rather than handed over: read in the registry where the call stands -- the domain named, else the current one and the default (spec 2026-10-21-commandes-typst-refonte, REQ-009). A state, so the call stands in a `context`.
  if type(v) == str {
    let d = var-registry.get()
    let found = if domain != none { d.domains.at(domain, default: (:)).at(v, default: none) } else { var-lookup(d, v) }
    if found == none { panic("get: no variable named " + repr(v) + (if domain != none { " in the domain " + repr(domain) } else { " here" }) + " -- declared here: " + var-names(d).join(", ")) }
    v = found
  }
  if field in ("description", "choices") { return v.at(field, default: none) }
  if field == "role" { return v.at("role", default: "data") }
  assert(field in ("value", "unit", "symbol", "label", "norm", "norm_ref"),
    message: "get: unknown field " + repr(field) + " -- value, unit, symbol, label, norm, norm_ref, description, choices, role")
  v.at(field)
}

// --- get-* abstraction (docs/typst/report-engine.md §6) ------------------------------
// The rest of this file, and report/*.typ, must go through these instead of reading .value/.unit/... directly, so a future schema change only touches this block.

// The same rule for a sentence the data carries (render-prose, a text cell of a table): a hyphen standing where a number's sign stands -- at the start, or after a space, a bracket, `=`, `:`, `;`, `,` or `/`, and right before a digit -- is a minus. «Δh = -200 m» out of the workbook's Dropdowns sheet prints «−200 m». A hyphen inside a word or between two digits is left alone, so «Holz-Holz», «EL+AL-Dach1» and «EN 1995-1-1» keep theirs.
#let sign-hyphen = regex("(^|[\s(\[=:;,/])-(\d)")
#let prose-minus(s) = if type(s) == str { s.replace(sign-hyphen, m => m.captures.at(0) + minus-sign + m.captures.at(1)) } else { s }

// `type` is a named parameter of `val` (lib/formula.typ), which shadows Typst's builtin `type()` inside its body -- captured here so the body can still ask what it was handed.
#let value-type = type

// A value that is text rather than a number is a word: the load model's name, the terrain category, the Art der Nutzfläche. So it follows the report's language where the glossary carries it -- the norm's own wording does -- and stays exactly as entered where it does not, which is every value read from a workbook (docs/typst/language.md §4bis).
#let value-word(v) = if value-type(v) == str { tl-str(v) } else { v }

// `fmt` stood here until v0.80: one value, from a var object or a bare number, in one of three parts. It is `val` now (lib/formula.typ), which prints the same value whether it is handed over, named in the report's registry or named in the export -- one command for one value, the engineer's own decision (docs/decisions.md §13). `fmt-number` and `fmt-decimals` below are the primitives it and every other display path print through, and they stay.

/// Formats a raw number and unit for display, e.g. "1.902 kN/m²" (bare "0.9" for an empty unit). The counterpart to fmt-value for a value computed in Typst, which has no `var` object to read from.
///
/// ```typ
/// #fmt-number(1.7291232, "kN/m²")
/// ```
///
/// ```typ
/// #fmt-number(0.9, "")
/// ```
///
/// - value (int, float, str): the value to print.
/// - unit (str): its unit, "" for dimensionless.
/// -> content
#let fmt-number(value, unit) = context {
  // the one display rule (lib/number.typ, UI-003); a value that is a word stays exactly as it was entered, through the glossary
  if value-type(value) == int or value-type(value) == float { return display-quantity(value, unit) }
  let s = value-word(value)
  // a no-break space: «Q_k = 20» at the end of a line and «kN» alone on the next was what a plain one allowed (v0.86)
  if unit == "" { s } else { s + unit-gap(unit) + unit }
}

/// Formats a var's value together with its unit for display, e.g. "26.916 kNm", or the bare number for a dimensionless value (empty unit). Decimals follow the document's number-digits setting.
///
/// ```typ
/// #fmt-value((value: 26.916, unit: "kNm"))
/// ```
///
/// ```typ
/// #fmt-value((value: 0.8, unit: ""))
/// ```
///
/// - v (dictionary): a `var` object (section 3.1).
/// -> content
#let fmt-value(v) = fmt-number(get(v, "value"), get(v, "unit"))

// --- Raw data access, for arithmetic done in Typst (docs/project/purpose.md §1) --
// The display functions above all end in content. To *compute* with a value -- a one-off arrangement the data does not carry -- the number itself is needed, in a plain `#let` that the rest of the document can reuse. These deliberately carry no calc-block scope guard (that guards what is printed under a header, not what is read into a variable), which is also what lets them work outside `context`.

// Norm references (docs/typst/citations.md §10): "SIA 261 5.2.6", no §, no comma, no brackets (the engineer, 20.10.2026: «Il ne doit pas y avoir de "§" avant le norm-ref»), in the citation grey (`cite-text`) -- rendered smaller in a dedicated right-hand column so it reads as a margin note level with the equation it cites.
// A document cited as a whole has no clause, and is printed without one -- a connection's design aid (section 3.3quinquies).
// A colon and a semicolon joining the engine's own parts, set the way each language sets them: French keeps a narrow no-break space before them, as `t-label` does for a word of the glossary (periodic audit 260916, AUD-3-12). Strings, so they join math and text alike; read inside a show-* function's context.
#let colon-str() = if report-lang() == "fr" { "\u{202f}:" } else { ":" }
#let semicolon-str() = if report-lang() == "fr" { "\u{202f};" } else { ";" }

// An annex is not a clause: «SIA 261 Anhang D», and «Anhang» is a word, printed in the report's language -- a term of the glossary, so a glossary without it (the frozen examples') prints the German (periodic audit 260916).
#let norm-text(v) = {
  // a script's result that names no norm is cited by its call -- «script beam.py, l. 12» (spec 2026-10-20-indices-et-niveaux, REQ-002): its file is the last part of its source, `python:Scripts/beam.py`
  if v.at("norm", default: "") in ("", none) and v.at("line", default: none) != none {
    let file = str(v.at("source", default: "")).split("/").last()
    return [#context t-str("script.line", file: file, line: str(v.line))]
  }
  let ref = get(v, "norm_ref")
  // a table, likewise (v0.88, the member checks cite Tabellen 4, 8, 9, 47 and 48): «SIA 265 Tabelle 8», as distance-cite prints one
  if ref == "" [#get(v, "norm")] else if ref.starts-with("Anhang ") [#get(v, "norm") #context tl-str("Anhang") #ref.slice("Anhang ".len())] else if ref.starts-with("Tabelle ") [#get(v, "norm") #context tl-str("Tabelle") #ref.slice("Tabelle ".len())] else [#get(v, "norm") #ref]
}

// The citation column's width and its gutter, shared by annotated-rows and by render-table, which centres a table in the space left of it.
#let note-column = 3.8cm
#let note-gutter = 0.6cm

// A formula that wraps onto a second line is two lines of one paragraph, kept apart by its leading -- and a line of inline math is not measured to its ink. A fraction set in display style (`show math.frac: it => $display(it)$` in the report's config.typ) reaches well above and below the line box its text edges give it, so the numerator of a second line ran into the first, and the denominator of the first into the second, whatever the leading: measured at 144 ppi, a 0.65 em leading left 0 to 4 px of white between the two lines, where two rows are 11 to 16 px apart, and doubling the leading bought 3 px on one side (the engineer, v0.87: «lorsqu'un calcul est sur 2 lignes, il n'y a plus assez d'espace entre les deux lignes»). So a row that is **taller than a line of roots and indices** -- measured on one line, what only a built-up fraction reaches -- **and wraps** is set with its lines measured to their ink (`top-edge`/`bottom-edge: "bounds"`), and its leading is then the white actually left between them: `wrapped-row-leading`, a little less than the gap between two rows, so the two lines still read as one formula. Every other row is left exactly as it was: a row that does not wrap, one of text or of small math, and every gap between rows.
#let row-spacing = 1em
#let tall-row-height = 1.2em
#let wrapped-row-leading = 0.5em
#let row-cell(content) = context {
  let line = measure(content).height
  if line <= tall-row-height.to-absolute() { return content }
  layout(size => {
    // one line wide enough for it: nothing to space
    if measure(content, width: size.width).height <= line + 0.5pt { return content }
    // in a block of its own: a paragraph takes its leading and its text edges from where it starts, which is outside this context, so a `set` in here would reach nothing without one
    block(width: 100%, {
      set text(top-edge: "bounds", bottom-edge: "bounds")
      set par(leading: wrapped-row-leading)
      content
    })
  })
}

// The citation of one row, small and right-aligned, level with the middle of its row.
#let note-cell(note-var) = if note-var == none { [] } else {
  align(right + horizon, cite-text(norm-text(note-var)))
}

// The same citation set **on the line** it cites, at the end of it: a box as wide as the citation column, pushed to the right edge. A stacked formula's first line is measured to its ink (chain-cell), and a fraction whose numerator is built higher than its denominator puts the middle of that ink well above the `=`, so a citation centred in its row sat level with the numerator; on the line, it stands on the formula's own baseline.
#let note-on-line(note-var) = h(1fr) + box(width: note-column, align(right, cite-text(norm-text(note-var))))

// --- A formula too wide for its row, stacked at its relation signs -----------
// A calculation printed in letters, in numbers and as its answer stands on one line -- `B_v = <letters> = <numbers> = 116.122 kN` -- and a display fraction is one atom that cannot break (`show math.frac: it => $display(it)$` in the report's config.typ). So a line wider than its row ran into the citation column and off the page (the engineer's exercise: «une longue fraction qui ne peut pas passer à la ligne déborde dans la colonne des références»), and one that could break broke wherever the width ran out, an `=` left dangling at the end of a line. Such a line is now set the classic way, **stacked at its relation signs**: `B_v = <letters>`, then `= <numbers>`, then `= 116.122 kN`, each `=` under the first -- as rows of the same grid, so the citation stays level with the first line. A line that fits is set exactly as it always was: what is measured decides, and nothing else changes.
//
// A row that may be stacked is a `formula-chain`: the one line it has always been (`line`), and what it is stacked into -- its first line (`first`, the left-hand side and the formula in letters), the segments after it (`rest`, math source, the numbers and the answer), the function that sets some of them as one line under the first (`build`, given them joined by ` = `), and what the last line ends on (`last`, a label or a footnote). `annotated-rows` measures the one line against the width the row has -- the column left of the citation, or the full width where the row carries none -- and stacks only where it does not fit.
// `forced` (issue #124, `#eq(..., stack: true)`): stacked whatever the width, and **one segment a line** rather than as many as fit -- the engineer's layout of a calculation, `A = b·h`, then `= 100 mm · 200 mm`, then `= 20000 mm²`.
#let formula-chain(line, first, rest, build, last: x => x, forced: false) = (chain: true, line: line, first: first, rest: rest, build: build, last: last, forced: forced)
#let is-chain(c) = type(c) == dictionary and c.at("chain", default: false) == true

// A line after the first of a stacked formula: its relation and what follows it, set where the first line's relation stands. The first line's left-hand side is **measured** and an empty box of that width stands in its place inside the same equation, so the space math sets around the `=` is the first line's own and the two signs fall one under the other to the point. `wrap` is what the line is set in -- `math.bold` for an answer -- and `side` what the first line's left-hand side was set in, `wrap` unless said otherwise: a bold B_v is wider than a regular one, and a step set on one row prints its letters regular and its numbers bold. Read inside a context, like everything that measures.
#let chain-line(lhs, rel, seg, scope: (:), wrap: x => x, side: auto) = {
  let side = if side == auto { wrap } else { side }
  let pad = box(width: measure(side(math-eval(lhs, scope: scope))).width)
  wrap(math-eval("#chain-pad " + rel + " " + seg, scope: scope + (chain-pad: pad)))
}

// The white between two lines of one stacked formula, measured to their ink: less than the gap between two rows, so the lines read as one formula, and measured to the ink because a display fraction reaches well past the line box its text edges give it (row-cell's own finding, v0.87). Only the edges **between** the lines are the ink's: the top of the first line and the foot of the last keep the text's own, so the formula stands as far from the rows around it as a line that fits does.
#let chain-leading = wrapped-row-leading
#let chain-cell(content, top: "bounds", bottom: "bounds") = block(width: 100%, {
  set text(top-edge: top) if top != auto
  set text(bottom-edge: bottom) if bottom != auto
  content
})

// The lines a `formula-chain` is stacked into: `column` wide -- the column left of the citation -- on the line the citation stands beside, where the row carries one (`noted`), and `wide` on every other. The first line is the left-hand side and the formula in letters, on its own; the segments after it are packed onto the lines under it **as many as fit** -- `= <numbers> = <answer>` on one line where the width holds both, which is where a checker reads the one against the other, and a line of its own each where it does not. The classic stacked form costs no more lines than the breaks it replaces. The citation stays beside the first line, unless that line alone is wider than the column left of it: it then moves down to the next, which is packed to the column, rather than be run over. Returns the lines and the index of the one carrying the citation (`none` for a row carrying none).
#let chain-lines(chain, fits, column, wide, noted) = {
  let lines = (chain.first,)
  let cited = if not noted { none } else if fits(chain.first, column) { 0 } else { 1 }
  let current = none
  for (k, s) in chain.rest.enumerate() {
    let candidate = if current == none { s } else { current + " = " + s }
    let room = if cited == lines.len() { column } else { wide }
    // measured as it would be set: the last segment carries what the line ends on
    let shaped(src) = if k == chain.rest.len() - 1 { (chain.last)((chain.build)(src)) } else { (chain.build)(src) }
    if current != none and (chain.at("forced", default: false) or not fits(shaped(candidate), room)) {
      lines.push((chain.build)(current))
      current = s
    } else {
      current = candidate
    }
  }
  if current != none { lines.push((chain.last)((chain.build)(current))) }
  (lines, if cited != none { calc.min(cited, lines.len() - 1) } else { none })
}

// The rows of `annotated-rows` where one of them is a `formula-chain`: laid out once the width is known. A chain whose one line fits the width its row has is set as it always was -- beside its citation, or, carrying none, spanning the citation column where only the full width holds it. One that does not fit is stacked (chain-lines): its lines take a row each, the citation beside the first, and every other line spans both columns, having no citation to leave room for.
//
// ⚠️ A single segment wider than even the full width is left as Typst sets it -- an inline equation breaks at its own relations and operators, never inside a fraction -- and may still run past the text. Setting such a fraction in inline style instead would overrule the engineer's own `show math.frac` rule of config.typ, which is his to make.
#let chain-rows(rows) = layout(size => {
  let has-notes = rows.any(pair => pair.at(1) != none)
  let column = if has-notes { size.width - note-column - note-gutter } else { size.width }
  let fits(c, room) = measure(c).width <= room + 0.01pt
  // each laid out as (content, note, spanning both columns, set close to the next line of the same formula)
  let cells = ()
  for (content, note) in rows {
    if not is-chain(content) { cells.push((content, note, false, false)); continue }
    let room = if note != none { column } else { size.width }
    if not content.at("forced", default: false) and fits(content.line, room) {
      cells.push((content.line, note, note == none and not fits(content.line, column), false))
      continue
    }
    let (lines, cited) = chain-lines(content, fits, column, size.width, note != none)
    for (i, l) in lines.enumerate() {
      // ink between the lines, the text's own edges above the first and below the last (chain-cell)
      let top = if i == 0 { auto } else { "bounds" }
      let bottom = if i == lines.len() - 1 { auto } else { "bounds" }
      // every line spans both columns, and the one the citation belongs to carries it at its end, on its own baseline (note-on-line)
      let line = if i == cited { l + note-on-line(note) } else { l }
      cells.push((chain-cell(line, top: top, bottom: bottom), none, has-notes, i < lines.len() - 1))
    }
  }
  let gutters = cells.slice(0, calc.max(cells.len() - 1, 0)).map(c => if c.at(3) { chain-leading } else { row-spacing })
  let gutter = if gutters.len() == 0 { row-spacing } else { gutters }
  if not has-notes {
    return grid(columns: (1fr,), row-gutter: gutter, ..cells.map(c => row-cell(c.at(0))))
  }
  grid(
    columns: (1fr, note-column),
    column-gutter: note-gutter,
    row-gutter: gutter,
    ..cells.map(c => if c.at(2) { (grid.cell(colspan: 2, row-cell(c.at(0))),) } else { (row-cell(c.at(0)), note-cell(c.at(1))) }).flatten()
  )
})

// One or more (content, norm-var-or-none) rows, laid out as a two-column grid: content on the left, the norm note (small, right-aligned) on the right. A single grid -- rather than one place() per row -- keeps every row's note reliably level with its own equation instead of drifting onto the next line.
// ⚠️ Where **no** row carries a note, the citation column is not laid out at all. The column is a fixed 3.8 cm, and with its gutter it takes 4.4 cm whatever it is put inside: in a `grid` cell at half the text width -- the two load cases of `Sections/005` sit side by side like that -- it swallowed more than half of the 7.4 cm available and the text wrapped after three centimetres, with an empty column beside it (v0.61.2). Reserving room for a note that does not exist is the whole of that bug. Rows that *do* carry one keep the fixed column, so cited lines go on lining up down the page.
// A row whose content is a `formula-chain` is laid out by chain-rows, which needs the width; every other set of rows is laid out here exactly as before.
#let annotated-rows(rows) = {
  if rows.any(pair => is-chain(pair.at(0))) { return chain-rows(rows) }
  let notes = rows.map(pair => pair.at(1))
  if notes.all(n => n == none) {
    return grid(columns: (1fr,), row-gutter: row-spacing, ..rows.map(pair => row-cell(pair.at(0))))
  }
  grid(
    columns: (1fr, note-column),
    column-gutter: note-gutter,
    row-gutter: row-spacing,
    ..rows
      .map(pair => (row-cell(pair.at(0)), note-cell(pair.at(1))))
      .flatten()
  )
}

// Symbol/formula strings in data/ are authored as Typst math source (e.g. "C_e", "gamma_M", "f_(m,k)") so they render with real subscripts and Greek glyphs instead of literal underscores -- never print get("symbol") or a formula string as plain text.

// A symbol that is nothing but a quoted word is a word, not a symbol: the load model, the terrain category, the category of Nutzfläche -- a var whose value is text has no letter to stand for it, so its own name is set in its place. Those follow the report's language like every other word; q_k, C_e and mu do not, being the norm's own letters in every language.
//
// ⚠️ The `///` block below must stay **flush against the `#let`**: a plain `//` line between the two detaches it, and the editor then shows no tooltip at all -- which is what this very comment was doing until v0.63.1.
/// Evaluates a var's `symbol` field as Typst math source and returns real rendered math (a real subscript / Greek glyph), not a string (section 6bis).
///
/// ```typ
/// #render-symbol((symbol: "q_(k,1)"))
/// ```
///
/// ```typ
/// #for s in ("h_\"ref\"", "C_e", "s_k") [ #render-symbol((symbol: s)) #h(1em) ]
/// ```
///
/// - v (dictionary): a `var` object (section 3.1) whose `symbol` field is valid Typst math source.
/// -> content
#let render-symbol(v) = {
  let src = get(v, "symbol")
  let word = src.match(regex("^\"([^\"]+)\"$"))
  // A symbol that is a word («Lastmodell») follows the report's language, which is a state: read inside a context of its own, so the call works in plain markup as var-of's own example writes it -- it failed there with «can only be used when context is known» (v0.86).
  if word != none {
    return context math-eval("\"" + tl-str(word.captures.first()) + "\"")
  }
  math-eval(src)
}

/// Evaluates a step's `formula` field as Typst math source and returns real rendered math (section 6bis).
///
/// ```typ
/// #render-formula((formula: "q_(k,11) = max(mu_11, 0.8) dot C_e dot C_T dot s_k"))
/// ```
///
/// ```typ
/// #render-formula((formula: "sigma_m = M_\"Ed\" / W"))
/// ```
///
/// - step (dictionary): a `step` object from a domain's `steps[]` (section 3.1) that carries a `formula` field.
/// -> content
#let render-formula(step) = math-eval(step.formula)

/// One sentence the data carries — a table's note, a var's or a step's description, a choice — with the symbols in it set as real math (section 6bis). A symbol inside a sentence is written between dollars, as it would be in a formula: `$c_"red"$ ist der Reduktionsfaktor` prints c with the subscript red where `cred` printed three letters.
///
/// ```typ
/// #render-prose("$c_\"red\"$ ist der Reduktionsfaktor der Bezugsfläche.")
/// ```
///
/// ```typ
/// #var("ce", 1, level: 0)
/// #context render-prose(tl-str(get("ce", "description")))
/// ```
///
/// The sentence is split on the dollars — the even parts are words, the odd parts math source — so nothing *else* it may carry is interpreted: an underscore stays an underscore, a `#` a hash, a `*` a star, which is what makes this safe on a description typed into Excel. An unpaired dollar leaves the sentence exactly as it came, and so does anything that is not a string (a note a show-* function built as content). One thing only is changed in the words: a hyphen standing for a number's sign, as in «Δh = -200 m», is printed as a minus sign.
/// - sentence (str, content, none): the sentence to set.
/// -> content
#let render-prose(sentence) = {
  if type(sentence) != str { return sentence }
  let parts = sentence.split("$")
  // an even number of parts means an odd number of dollars: one of them opens math that nothing closes, so the sentence is left as written rather than half-evaluated -- all but a number's sign, which is a minus in words as it is in math (prose-minus)
  if calc.even(parts.len()) { return [#prose-minus(sentence)] }
  parts
    .enumerate()
    .map(((i, part)) => if calc.even(i) { [#prose-minus(part)] } else { math-eval(part) })
    .join()
}

// --- Position summary line (docs/domain/positions.md §7-8) -----------------------
// Positions carry no shared section catalog and no load assignment -- just their own type, material, section and description, read directly off data/positions/<id>.json (there is no "var" object to go through get-* for these plain descriptive fields, unlike vars/steps/checks above). `#member` prints this line at level 1 and calc-block heads a block with it; `show-position`, which printed it on its own until v0.94, is gone, `#member` taking any position (lib/timber.typ).

// --- Connector summary display (docs/domain/connectors.md §7bis) -------------------
// A connector is a descriptive record like a position, read directly off data/connectors.json: what the connector's source says about it, and nothing it leaves empty.
