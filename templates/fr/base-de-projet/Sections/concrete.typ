#import "/woodwork/woodwork.typ": *

== Béton

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, left, right, right, right, right),
    table.hline(stroke: 1pt),
    table.header([*Élément*], [*Classe de résistance*], [*Résistance caractéristique $f_"ck"$*], [*Résistance de calcul $f_"cd"$*], [*Résistance au cisaillement de calcul $tau_"cd"$*], [*Poids volumique $gamma$*]),
    table.hline(stroke: 0.5pt),
    [[Élément]], [C25/30], [25], [[…]], [[…]], [25],
    [[Élément]], [C30/37], [30], [[…]], [[…]], [25],
    table.hline(stroke: 1pt),
  ),
  caption: [Béton armé (SIA 262)],
)

Valeurs de calcul selon la norme SIA 262:2025. Les exigences de durabilité (classes d'exposition) sont indiquées dans la section « Durabilité ».
