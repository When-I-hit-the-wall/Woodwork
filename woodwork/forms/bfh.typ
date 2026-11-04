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

  // The formulas keep Typst's math font.
  show math.equation: set text(font: "New Computer Modern Math")

  // A `*` typed in math prints as the multiplication dot, as `#eq` and `#verify` print it (v0.87): $q * L$ reads q · L. A star in a sub- or superscript stays a star -- F* of the most unfavourable superposition, x* -- and so does one in the text.
  show math.equation: it => { show "∗": sym.dot.op; it }
  show math.attach: it => { show "⋅": sym.ast; it }

  // Display math as "display" (shows better in text)
  show math.frac: it => $display(it)$

  doc
}
