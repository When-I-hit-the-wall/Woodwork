#import "/woodwork/woodwork.typ": *

=== Wind

Die Windeinwirkungen werden nach der Norm SIA 261, Kapitel 6, ermittelt. Der Staudruck beträgt:

$ q_p = c_h dot q_(p 0) $

wobei der Referenzwert $q_"p0"$ dem Anhang E, die Geländekategorie und der Profilbeiwert $c_h$ der Ziffer 6.2.1 (Tabelle 4) entnommen werden. Die Druck- und Kraftbeiwerte sind jene des Anhangs C.

#figure(
  table(
    columns: (1fr, auto, auto, auto),
    align: (left, center, right, left),
    table.hline(stroke: 1pt),
    table.header([*Parameter*], [*Symbol*], [*Wert*], [*Einheit*]),
    table.hline(stroke: 0.5pt),
    [Geländekategorie], [], [[…]], [],
    [Bezugshöhe über Boden], [$z$], [[…]], [m],
    [Profilbeiwert], [$c_h$], [[…]], [],
    [Referenzwert des Staudrucks], [$q_(p 0)$], [[…]], [kN/m²],
    [Staudruck], [$q_p$], [[…]], [kN/m²],
    table.hline(stroke: 1pt),
  ),
  caption: [Windparameter],
)
