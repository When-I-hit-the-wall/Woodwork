// Title page of the neutral form: a content template. Copy this file beside your document, fill in the fields below and include it first: #include "title-neutral.typ".

// ===== FILL IN HERE =====
// Everything in quotes is printed as written; an empty field prints no line.

// The document, the project and its number.
#let document = "Statical report"
#let project = "Project name"
#let number = "No. 0000"

// One line per entry: its label, then a list of values, one per line. Delete an entry, or leave its list empty: ().
#let rows = (
  ("Written by", ("First name Last name",)),
  ("Supervision", ("First name Last name",)),
  ("Client", ("Client",)),
  ("Project location", ("Street 1, 0000 Place",)),
)

// The date: auto is the day the document is compiled; datetime(year: 2026, month: 11, day: 4) a day of your own; none no date.
#let date = auto

// ===== LAYOUT (plain Typst, yours to change as well) =====

#let months = "January,February,March,April,May,June,July,August,September,October,November,December".split(",")
#let long-date(d) = str(d.day()) + " " + months.at(d.month() - 1) + " " + str(d.year())
#let day = if date == auto { long-date(datetime.today()) } else if type(date) == datetime { long-date(date) } else { date }

#page(header: none, footer: none)[
  #align(center)[
    #v(4cm)
    #text(size: 20pt, weight: "bold", document)
    #v(0.5cm)
    #text(size: 14pt, project)
    #if number != "" [
      #v(0.2cm)
      #text(size: 11pt, number)
    ]
    #v(2cm)
    #set text(size: 11pt)
    #grid(columns: (auto, auto), column-gutter: 1.2em, row-gutter: 0.8em, align: (right + top, left + top),
      ..rows.filter(r => r.at(1).len() > 0).map(r => (r.at(0), r.at(1).map(x => [#x]).join(linebreak()))).flatten())
    #if day != none [
      #v(1.5cm)
      #day
    ]
  ]
]
