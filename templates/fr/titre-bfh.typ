// Page de titre de la forme BFH : un template de fond. Copiez ce fichier à côté de votre document, remplissez les champs ci-dessous et incluez-le en premier : #include "titre-bfh.typ".
#import "/woodwork/forms/bfh.typ": sans, bfh-grey, bfh-yellow, muted

// ===== À REMPLIR =====
// Tout ce qui est entre guillemets est imprimé tel quel ; un champ vide n'imprime pas de ligne.

// Le document, le projet et son numéro.
#let document = "Rapport de statique"
#let project = "Nom du projet"
#let number = "N° 0000"

// Une ligne par rubrique : son libellé, puis une liste de valeurs, une par ligne. Supprimez une rubrique, ou laissez sa liste vide : ().
#let rows = (
  ("Rédigé par", ("Prénom Nom",)),
  ("Encadrement", ("Prénom Nom",)),
  ("Mandant", ("Mandant",)),
  ("Lieu du projet", ("Rue 1, 0000 Lieu",)),
)

// La date : auto est le jour de la compilation ; datetime(year: 2026, month: 11, day: 4) un jour choisi ; none aucune date.
#let date = auto

// ===== MISE EN PAGE (Typst ordinaire, modifiable aussi) =====

#let months = "janvier,février,mars,avril,mai,juin,juillet,août,septembre,octobre,novembre,décembre".split(",")
#let long-date(d) = (if d.day() == 1 { "1er" } else { str(d.day()) }) + " " + months.at(d.month() - 1) + " " + str(d.year())
#let day = if date == auto { long-date(datetime.today()) } else if type(date) == datetime { long-date(date) } else { date }

#page(header: none, footer: none, margin: (top: 2cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm))[
  #set text(font: sans)
  #image("/woodwork/forms/bfh-logo.png", width: 7.5cm)
  #v(0.6cm)
  #text(size: 10pt, fill: bfh-grey)[Architecture, bois et génie civil \ BSc Technique du bois]

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

  #if day != none [Bienne, #day]
]
