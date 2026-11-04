#import "/woodwork/woodwork.typ": *

== Baustahl und Verbindungsmittel

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, right, right),
    table.hline(stroke: 1pt),
    table.header([*Stahlsorte*], [*Dicke*], [*Streckgrenze $f_y$*], [*Zugfestigkeit $f_u$*]),
    table.hline(stroke: 0.5pt),
    [S235], [t ≤ 40 mm], [235], [360],
    [S355], [t ≤ 40 mm], [355], [510],
    table.hline(stroke: 1pt),
  ),
  caption: [Baustahl (SIA 263)],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, right, right, left),
    table.hline(stroke: 1pt),
    table.header([*Festigkeitsklasse*], [*Streckgrenze $f_"yb"$*], [*Zugfestigkeit $f_"ub"$*], [*Verwendung*]),
    table.hline(stroke: 0.5pt),
    [4.6], [240], [400], [Bolzen, Schlüsselschrauben],
    [8.8], [640], [800], [Holzschrauben (Mindestklasse)],
    table.hline(stroke: 1pt),
  ),
  caption: [Schrauben und Holzschrauben (SIA 263)],
)

Stabdübel aus Stahl S355 werden mit $f_(u,k)$ = 510 N/mm² berechnet (SN EN 14592).
