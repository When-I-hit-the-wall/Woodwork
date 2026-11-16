// Einfacher Bericht: eine Inhaltsvorlage ohne eigene Titelseite, ohne Inhaltsverzeichnis und ohne Literaturverzeichnis. Legen Sie diesen Ordner in Ihr Projekt und den Ordner woodwork/ in dessen Wurzel, füllen Sie die Felder unten aus und schreiben Sie Ihre Berechnungen unter «Abschnitt».
#import "/woodwork/woodwork.typ": *
#import "/woodwork/forms/bfh.typ": bfh, bfh-grey, bfh-yellow, muted
#set text(lang: "de")
#show: bfh.with(chapter-break: false)

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

= Abschnitt

// AUSZUFÜLLEN: Fügen Sie hier Ihre Berechnungsblätter (sheets/de/…) ein oder schreiben Sie Ihre Berechnungen mit #domain, #var, #eq und #verify.

= Anhang

// AUSZUFÜLLEN: Ihre Anhänge (Pläne, Auszüge, Ergebnisse einer Software).
