// Page de titre de la forme neutre : un template de fond. Copiez ce fichier à côté de votre document, remplissez les champs ci-dessous et incluez-le en premier : #include "titre-neutre.typ".

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
