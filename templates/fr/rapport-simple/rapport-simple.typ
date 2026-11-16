// Rapport simple : un template de fond sans page de titre séparée, sans table des matières ni bibliographie. Placez ce dossier dans votre projet et le dossier woodwork/ à la racine, remplissez les champs ci-dessous, puis écrivez vos calculs sous « Section ».
#import "/woodwork/woodwork.typ": *
#import "/woodwork/forms/bfh.typ": bfh, bfh-grey, bfh-yellow, muted
#set text(lang: "fr")
#show: bfh.with(chapter-break: false)

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

// À COMPLÉTER : collez ici vos feuilles de calcul (sheets/fr/…) ou écrivez vos calculs avec #domain, #var, #eq et #verify.

= Annexes

// À COMPLÉTER : vos annexes (plans, extraits, résultats d'un logiciel).
