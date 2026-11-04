#import "/woodwork/woodwork.typ": *

== Exigences relatives à la fissuration

La norme SIA 262 distingue trois niveaux d'exigences relatives à la fissuration : normales lorsque les fissures sont tolérées et qu'aucune exigence particulière d'étanchéité ou d'aspect n'est posée ; accrues lorsqu'il existe des exigences particulières de fonctionnalité et d'aspect et qu'une bonne répartition des fissures est recherchée ; élevées lorsqu'une limitation des ouvertures de fissures est souhaitée. Ces exigences valent pour les sollicitations de contrainte imposée (retrait, p. ex.) comme pour celles de flexion ; des exigences accrues ou élevées réduisent les contraintes admissibles de l'acier et augmentent la quantité d'armature.

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.hline(stroke: 1pt),
    table.header([*Zone*], [*Exigence*]),
    table.hline(stroke: 0.5pt),
    [[Général]], [Normale],
    [[Béton apparent]], [Accrues],
    table.hline(stroke: 1pt),
  ),
  caption: [Exigences par zone],
)

Ouvertures de fissures attendues pour les trois niveaux : $w_m$ = 0.7 / 0.5 / 0.25 mm et $w_"max"$ = 1.2 / 0.9 / 0.4 mm ($w_"max"$ = 1.7 · $w_m$, valeur à 95 %), d'après le modèle du tirant (documentation SIA D 0182).
