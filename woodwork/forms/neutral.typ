// woodwork/forms/neutral.typ -- the form «neutral», taken from Woodcore's templates/forms/neutral (4 Nov 2026): A4, margins of 2.5 cm, justified 11 pt text, numbered headings, the page number centred in the footer, no colour and no decoration.
//
// A form is the look of a document and nothing else (decisions D-17): fonts, colours, sizes, spacing, headings, captions, margins, header and footer. It prints no title page -- that is a content template, templates/<lang>/<title page>.typ. In a document:
//
//   #import "/woodwork/forms/neutral.typ": neutral
//   #show: neutral
//
// `#show: neutral.with(lang: "fr")` also sets the language Typst works in (hyphenation, «Figure»); without it the form keeps the document's own `#set text(lang: …)`.

/// The look of a document: `#show: neutral`, or `#show: neutral.with(lang: "fr")`.
/// - doc (content): the document.
/// - lang (str, none): none keeps the document's language; else the language Typst itself works in -- the hyphenation patterns, the quotation marks, the words it writes of its own accord («Abbildung»/«Fig.», the outline's title).
/// - region (str): its region.
/// -> content
#let neutral(doc, lang: none, region: "CH") = {
  set page(
    paper: "a4",
    margin: (top: 3cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
    numbering: "1",
    footer: context align(center, counter(page).display("1")),
  )

  set text(size: 11pt)
  set text(lang: lang, region: region) if lang != none
  set par(justify: true)
  set heading(numbering: "1.1")
  // The white before and after a heading (v0.100, the engineer: «augmente les espacements avant une nouvelle section, sous-section, ===, ====»). A show-set rule per level rather than one `set heading(above:, below:)`, because each level wants its own: a section is set apart from what precedes it more than a sub-sub-section is, which is what makes the structure readable at a glance. Typst's own default is about 1.2em above and 0.55em below at every level, which is what made a «===» sit as close to its text as a «=» did.
  show heading.where(level: 1): set block(above: 2em, below: 1em)
  show heading.where(level: 2): set block(above: 1.6em, below: 0.8em)
  show heading.where(level: 3): set block(above: 1.2em, below: 0.6em)
  show heading.where(level: 4): set block(above: 1em, below: 0.5em)

  // A `*` typed in math prints as the multiplication dot, as `#eq` and `#verify` print it (v0.87): $q * L$ reads q · L. A star in a sub- or superscript stays a star -- F* of the most unfavourable superposition, x* -- and so does one in the text.
  show math.equation: it => { show "∗": sym.dot.op; it }
  show math.attach: it => { show "⋅": sym.ast; it }

  // Display math as "display" (shows better in text)
  show math.frac: it => $display(it)$

  doc
}
