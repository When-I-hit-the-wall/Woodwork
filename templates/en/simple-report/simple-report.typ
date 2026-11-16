// Simple report: a content template with no title page of its own, no table of contents and no bibliography. Put this folder in your project and the folder woodwork/ at its root, fill in the fields below, then write your calculations under «Section».
#import "/woodwork/woodwork.typ": *
#import "/woodwork/forms/bfh.typ": bfh, bfh-grey, bfh-yellow, muted
#set text(lang: "en")
#show: bfh.with(chapter-break: false)

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

#block(below: 1cm)[
  #line(length: 2.5cm, stroke: 3pt + bfh-yellow)
  #v(0.3cm)
  #text(size: 10pt, fill: muted, tracking: 0.12em, upper(document))
  #v(0.1cm)
  #block(text(size: 22pt, weight: "bold", fill: bfh-grey, project))
  #if number != "" [
    #block(text(size: 11pt, fill: muted, number))
  ]
  #v(0.4cm)
  #set text(size: 10pt)
  #grid(columns: (3.8cm, 1fr), row-gutter: 0.6em,
    ..rows.filter(r => r.at(1).len() > 0).map(r => (text(fill: muted, r.at(0)), r.at(1).map(x => [#x]).join(linebreak()))).flatten())
  #if day != none [
    #v(0.3cm)
    #text(size: 10pt, day)
  ]
]

= Section

// TO FILL IN: paste your calculation sheets here (sheets/en/…) or write your calculations with #domain, #var, #eq and #verify.

= Appendices

// TO FILL IN: your appendices (drawings, extracts, results of a program).
