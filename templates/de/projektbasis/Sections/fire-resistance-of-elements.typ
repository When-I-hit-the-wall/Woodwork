#import "/woodwork/woodwork.typ": *

== Feuerwiderstand der Bauteile

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Kategorie*], [*Bereich / Bauteil*], [*Grundlage*], [*Anforderung*], [*Ausführung / Werte*]),
    table.hline(stroke: 0.5pt),
    [Tragwerk], [[Untergeschoss – Erdgeschoss]], [VKF 15-15], [R 60], [[…]],
    [Brandabschnitte], [[Decke über Erdgeschoss]], [VKF 15-15], [REI 60], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Feuerwiderstand der Bauteile],
)
