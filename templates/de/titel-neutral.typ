// Titelseite der neutralen Form: eine Inhaltsvorlage. Kopieren Sie diese Datei neben Ihr Dokument, füllen Sie die Felder unten aus und binden Sie sie als Erstes ein: #include "titel-neutral.typ".

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
