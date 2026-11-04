#import "/woodwork/woodwork.typ": *

== Caractéristiques du terrain de fondation

Les caractéristiques du terrain de fondation sont indiquées dans le rapport géotechnique [auteur, date]. Les valeurs caractéristiques suivantes sont admises pour le dimensionnement (valeurs prudentes selon SIA 260, ch. 3.3.3.5 et SIA 267) :

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, right, right, right, right),
    table.hline(stroke: 1pt),
    table.header([*Couche*], [*Poids volumique $gamma$*], [*Angle de frottement $phi'$*], [*Cohésion $c'$*], [*Module de compressibilité $E_s$*]),
    table.hline(stroke: 0.5pt),
    [[…]], [[…]], [[…]], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Valeurs caractéristiques du terrain de fondation],
)
