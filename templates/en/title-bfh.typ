// Title page of the BFH form: a content template. Copy this file beside your document, fill in the fields below and include it first: #include "title-bfh.typ".
#import "/woodwork/forms/bfh.typ": sans, bfh-grey, bfh-yellow, muted

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

#page(header: none, footer: none, margin: (top: 2cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm))[
  #set text(font: sans)
  #image("/woodwork/forms/bfh-logo.png", width: 7.5cm)
  #v(0.6cm)
  #text(size: 10pt, fill: bfh-grey)[Architecture, Wood and Civil Engineering \ BSc Wood Technology]

  #v(1fr)

  #line(length: 2.5cm, stroke: 3pt + bfh-yellow)
  #v(0.5cm)
  #text(size: 11pt, fill: muted, tracking: 0.12em, upper(document))
  #v(0.2cm)
  #block(text(size: 28pt, weight: "bold", fill: bfh-grey, project))
  #if number != "" [
    #v(0.1cm)
    #block(text(size: 12pt, fill: muted, number))
  ]

  #v(1.5cm)

  #set text(size: 10pt)
  #grid(columns: (3.8cm, 1fr), row-gutter: 0.7em,
    ..rows.filter(r => r.at(1).len() > 0).map(r => (text(fill: muted, r.at(0)), r.at(1).map(x => [#x]).join(linebreak()))).flatten())

  #v(1fr)

  #if day != none [Biel/Bienne, #day]
]
