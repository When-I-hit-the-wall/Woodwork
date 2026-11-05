// woodwork/forms/bfh.typ -- the form «bfh», taken from Woodcore's templates/forms/bfh (4 Nov 2026): the Berner Fachhochschule's academic look -- its colours, its logo in the running header, the school's names in the footer, every text in Lucida Sans (Segoe UI, then Arial, where it is not installed), a chapter to a page.
//
// A form is the look of a document and nothing else (decisions D-17): fonts, colours, sizes, spacing, headings, captions, margins, header and footer. It prints no title page -- that is a content template, templates/<lang>/<title page>.typ. In a document:
//
//   #import "/woodwork/forms/bfh.typ": bfh
//   #show: bfh
//
// `#show: bfh.with(lang: "fr")` also sets the language Typst works in (hyphenation, «Figure»); without it the form keeps the document's own `#set text(lang: …)`.

#let school-names = ("Berner Fachhochschule", "Haute école spécialisée bernoise", "Bern University of Applied Sciences")

// --- BFH identity -----------------------------------------------------------
#let bfh-grey = rgb("#697D91")    // the grey-blue of the logo and of the BFH's Word template
#let bfh-yellow = rgb("#FAC300")  // the yellow of the F and the H, used once per chapter, never for text
#let muted = luma(95)

// Lucida Sans for everything, as the BFH's Word template; Segoe UI and Arial where Lucida Sans is not installed.
#let sans = ("Lucida Sans", "Segoe UI", "Arial")

// The running header of every page after the title page: the BFH logo on the left, the current chapter on the right -- the chapter starting on this page, else the last one started before it.
#let report-header() = {
  set text(font: sans, size: 7.5pt, fill: muted)
  grid(
    columns: (auto, 1fr),
    align: (left + bottom, right + bottom),
    image("bfh-logo.png", height: 0.95cm),
    context {
      let chapters = query(heading.where(level: 1, outlined: true))
      let here-page = here().page()
      let on-page = chapters.filter(h => h.location().page() == here-page)
      let before = chapters.filter(h => h.location().page() < here-page)
      let current = if on-page.len() > 0 { on-page.first() } else if before.len() > 0 { before.last() } else { none }
      if current != none {
        if current.numbering != none { numbering(current.numbering, ..counter(heading).at(current.location())) + "  " }
        current.body
      }
    },
  )
}

// The footer, as the BFH's Word template: the school's names on the left, the page on the right.
#let report-footer() = {
  set text(font: sans, size: 7.5pt, fill: muted)
  line(length: 100%, stroke: 0.4pt + bfh-grey)
  v(-0.5em)
  grid(
    columns: (1fr, auto),
    align(left, school-names.join("  |  ")),
    align(right, context counter(page).display()),
  )
}

// --- Tables -----------------------------------------------------------------
// The BFH table, «Schiefer-Kopf» (spec 2026-11-05-style-tableaux-bfh): a table written straight into a figure, `#figure(table(..), caption: [..])`, takes it -- its title above, centred, larger than the header; the header in the grey-blue, its text white and bold; the body's rows striped in a light grey; the rows of a `table.footer` are totals, set in bold after a grey-blue rule, a yellow mark on their first cell; a closing rule; no hyphenation in a cell. What the figure holds after the table -- a note, a legend -- stands under it, small and to the left. A table the engine lays out itself (`var-table`, a check's table) sits in a block of its figure, not straight in it, and keeps its own look.
#let bfh-mist = rgb("#EEF1F4")  // the light grey of the striped rows

// The number of columns a table's `columns` names: a count, or one track each.
#let _column-count(columns) = if type(columns) == array { columns.len() } else if type(columns) == int { columns } else { 1 }

// How many grid cells a child of a table takes: a cell its colspan, a line none, any other content one.
#let _span(child) = if child.func() == table.cell { child.at("colspan", default: 1) } else if child.func() in (table.hline, table.vline) { 0 } else { 1 }

// One table in the BFH style. It is laid out again with its own cells, so the rows of its header and its body can be counted; the label it then carries says it is done, so the rule does not take it twice.
#let bfh-table(it) = {
  if it.at("label", default: none) == <bfh-table-done> { return it }
  let fields = it.fields()
  let children = fields.remove("children")
  for key in ("label", "fill") { let _ = fields.remove(key, default: none) }
  let ncols = _column-count(fields.at("columns", default: 1))
  let header = children.filter(c => c.func() == table.header)
  let footer = children.filter(c => c.func() == table.footer)
  let body = children.filter(c => c.func() not in (table.header, table.footer))
  let header-rows = header.map(h => calc.ceil(h.children.map(_span).sum(default: 0) / ncols)).sum(default: 0)
  let body-rows = calc.ceil(body.map(_span).sum(default: 0) / ncols)
  // The totals: every cell bold, the first of each row with the yellow mark.
  let totals = ()
  let column = 0
  for c in footer.map(f => f.children).flatten() {
    let span = _span(c)
    if span == 0 { totals.push(c); continue }
    let args = if c.func() == table.cell { c.fields() } else { (body: c) }
    let inner = args.remove("body")
    if calc.rem(column, ncols) == 0 { args.insert("stroke", (left: 3pt + bfh-yellow)) }
    totals.push(table.cell(..args, strong(inner)))
    column += span
  }
  let closing = table.hline(stroke: 1.2pt + bfh-grey)
  show table.cell: cell => if cell.y < header-rows { set text(fill: white, weight: "bold"); cell } else { cell }
  [#table(
    ..fields,
    fill: (x, y) => if y < header-rows { bfh-grey } else if y < header-rows + body-rows and calc.odd(y - header-rows) { bfh-mist } else { none },
    ..header,
    ..body,
    ..if totals.len() > 0 { (table.footer(repeat: false, table.hline(stroke: 0.8pt + bfh-grey), ..totals, closing),) } else { (closing,) },
  )<bfh-table-done>]
}

/// The look of a document: `#show: bfh`, or `#show: bfh.with(lang: "fr")`.
/// - doc (content): the document.
/// - lang (str, none): none keeps the document's language; else the language Typst itself works in -- the hyphenation patterns, the quotation marks, the words it writes of its own accord («Abbildung»/«Fig.», the outline's title).
/// - region (str): its region.
/// -> content
#let bfh(doc, lang: none, region: "CH") = {
  set page(
    paper: "a4",
    margin: (top: 3.2cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
    header-ascent: 35%,
    numbering: "1",
    // The BFH's running header and footer on every page -- the logo and the current chapter above, the school's names and the page below. The title page (the content template titre-bfh) is a page of its own with neither.
    header: report-header(),
    footer: report-footer(),
  )

  set text(font: sans, size: 10.5pt)
  set text(lang: lang, region: region) if lang != none
  set par(justify: true, leading: 0.68em, spacing: 1.1em)
  set heading(numbering: "1.1")

  // Headings: in the BFH's grey-blue.
  show heading: set text(fill: bfh-grey, weight: "bold")
  show heading.where(level: 2): set text(size: 12pt)
  show heading.where(level: 2): set block(above: 1.8em, below: 0.9em)
  show heading.where(level: 3): set text(size: 10.5pt)
  show heading.where(level: 3): set block(above: 1.5em, below: 0.8em)

  // A chapter: a page of its own, its number beside its title in a lighter grey, a short yellow bar below. `weak`: no blank page where one already begins there.
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(0.3cm)
    block(below: 0.9cm, {
      set block(spacing: 0.7em)
      set text(font: sans, size: 18pt, weight: "bold")
      if it.numbering != none {
        text(fill: bfh-grey.lighten(45%), counter(heading).display(it.numbering))
        h(0.5em)
      }
      text(fill: bfh-grey, it.body)
      line(length: 1.5cm, stroke: 2pt + bfh-yellow)
    })
  }

  // The outline and the lists of figures and tables, a little smaller, the chapters in bold.
  show outline: set text(size: 10pt)
  show outline.entry.where(level: 1): set text(weight: "bold")
  show outline.entry.where(level: 1): set block(above: 1.1em)

  // Captions -- of a figure and of a table: «Fig. 1 — …», a little smaller than the text.
  show figure.caption: set text(size: 9pt)

  // Tables (spec 2026-11-05-style-tableaux-bfh): a table written straight into a figure takes the BFH style -- see `bfh-table` above. Its title above it, centred, a little larger than the text of its cells.
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): it => {
    let parts = if it.body.func() == table { (it.body,) } else if it.body.has("children") { it.body.children } else { () }
    if not parts.any(c => c.func() == table) { return it }
    set align(left)
    set text(size: 8pt, fill: muted)
    set par(justify: false)
    show figure.caption: c => block(width: 100%, align(center, c))
    show figure.caption: set text(size: 10.5pt, weight: "bold", fill: black)
    show table: set text(size: 9pt, fill: black, hyphenate: false)
    set table(stroke: none, inset: (x: 5pt, y: 4pt))
    show table: t => block(width: 100%, align(center, bfh-table(t)))
    it
  }

  // The formulas keep Typst's math font.
  show math.equation: set text(font: "New Computer Modern Math")

  // A `*` typed in math prints as the multiplication dot, as `#eq` and `#verify` print it (v0.87): $q * L$ reads q · L. A star in a sub- or superscript stays a star -- F* of the most unfavourable superposition, x* -- and so does one in the text.
  show math.equation: it => { show "∗": sym.dot.op; it }
  show math.attach: it => { show "⋅": sym.ast; it }

  // Display math as "display" (shows better in text)
  show math.frac: it => $display(it)$

  doc
}
