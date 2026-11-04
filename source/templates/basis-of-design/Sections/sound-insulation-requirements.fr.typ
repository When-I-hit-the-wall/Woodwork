#import "/woodwork/woodwork.typ": *

== Exigences relatives aux éléments de construction

#figure(rect(width: 100%, height: 5cm, stroke: 0.5pt + luma(60%))[[Plan ou coupe avec la numérotation des éléments de séparation]], caption: [Repérage des éléments de séparation [niveau]])

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Élément*], [*Base*], [*Exigence jour / nuit*], [*Exécution / valeurs*]),
    table.hline(stroke: 0.5pt),
    [[Façade des chambres]], [SIA 181, tab. 2], [[…] / […]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Bruit aérien extérieur],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Zone / élément*], [*Base*], [*Exigence*], [*Exécution / valeurs*]),
    table.hline(stroke: 0.5pt),
    [[Chambre / chambre]], [SIA 181, tab. 3], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Bruit aérien intérieur],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Zone / élément*], [*Base*], [*Exigence*], [*Exécution / valeurs*]),
    table.hline(stroke: 0.5pt),
    [[Terrasse / chambre]], [SIA 181, tab. 5], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Bruit de choc],
)

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Type de bruit*], [*Zone / élément*], [*Base*], [*Exigence*], [*Exécution / valeurs*]),
    table.hline(stroke: 0.5pt),
    [Bruits isolés], [[Cuisine / restaurant]], [SIA 181, tab. 6], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Bruits des installations techniques],
)
