// Titelseite der Form BFH: eine Inhaltsvorlage. Kopieren Sie diese Datei neben Ihr Dokument, füllen Sie die Felder unten aus und binden Sie sie als Erstes ein: #include "titel-bfh.typ".
#import "/woodwork/forms/bfh.typ": sans, bfh-grey, bfh-yellow, muted

// ===== HIER AUSFÜLLEN =====
// Alles in Anführungszeichen wird so gedruckt; ein leeres Feld druckt keine Zeile.

// Das Dokument, das Projekt und seine Nummer.
#let document = "Statischer Bericht"
#let project = "Projektname"
#let number = "Nr. 0000"

// Eine Zeile pro Rubrik: ihre Bezeichnung, dann eine Liste von Werten, einer pro Zeile. Löschen Sie eine Rubrik oder lassen Sie ihre Liste leer: ().
#let rows = (
  ("Verfasst von", ("Vorname Name",)),
  ("Betreuung", ("Vorname Name",)),
  ("Auftraggeber", ("Auftraggeber",)),
  ("Projektort", ("Strasse 1, 0000 Ort",)),
)

// Das Datum: auto ist der Tag der Kompilierung; datetime(year: 2026, month: 11, day: 4) ein gewählter Tag; none kein Datum.
#let date = auto

// ===== SEITENGESTALTUNG (gewöhnliches Typst, ebenfalls anpassbar) =====

#let months = "Januar,Februar,März,April,Mai,Juni,Juli,August,September,Oktober,November,Dezember".split(",")
#let long-date(d) = str(d.day()) + ". " + months.at(d.month() - 1) + " " + str(d.year())
#let day = if date == auto { long-date(datetime.today()) } else if type(date) == datetime { long-date(date) } else { date }

#page(header: none, footer: none, margin: (top: 2cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm))[
  #set text(font: sans)
  #image("/woodwork/forms/bfh-logo.png", width: 7.5cm)
  #v(0.6cm)
  #text(size: 10pt, fill: bfh-grey)[Architektur, Holz und Bau \ BSc Holztechnik]

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

  #if day != none [Biel, #day]
]
