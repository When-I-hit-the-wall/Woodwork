#import "/woodwork/woodwork.typ": *

== Protection thermique et protection contre l'humidité

Les coefficients de transmission thermique maximaux $U_"max"$ selon la norme #cite-norm(norm: "SIA 180") doivent être respectés. Pour la preuve par performances ponctuelles, les valeurs de la réglementation cantonale sur l'énergie [canton, ordonnance] s'appliquent aux constructions neuves. [Label visé (Minergie …) ou non.]

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, right, left),
    table.hline(stroke: 1pt),
    table.header([*Élément*], [*Contre*], [*Coefficient de transmission thermique $U$*], [*Base*]),
    table.hline(stroke: 0.5pt),
    [Toiture], [Extérieur], [[…]], [[ordonnance cantonale]],
    [Paroi extérieure], [Extérieur], [[…]], [[ordonnance cantonale]],
    table.hline(stroke: 1pt),
  ),
  caption: [Valeurs limites des coefficients de transmission thermique],
)
