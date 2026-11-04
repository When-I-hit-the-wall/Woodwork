#import "/woodwork/woodwork.typ": *

== Structural steel and fasteners

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, right, right),
    table.hline(stroke: 1pt),
    table.header([*Grade*], [*Thickness*], [*Yield strength $f_y$*], [*Tensile strength $f_u$*]),
    table.hline(stroke: 0.5pt),
    [S235], [t ≤ 40 mm], [235], [360],
    [S355], [t ≤ 40 mm], [355], [510],
    table.hline(stroke: 1pt),
  ),
  caption: [Structural steel (SIA 263)],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, right, right, left),
    table.hline(stroke: 1pt),
    table.header([*Strength class*], [*Yield strength $f_"yb"$*], [*Tensile strength $f_"ub"$*], [*Use*]),
    table.hline(stroke: 0.5pt),
    [4.6], [240], [400], [Bolts, lag screws],
    [8.8], [640], [800], [Wood screws (minimum class)],
    table.hline(stroke: 1pt),
  ),
  caption: [Bolts, lag screws and wood screws (SIA 263)],
)

Dowels of S355 steel are calculated with $f_(u,k)$ = 510 N/mm² (SN EN 14592).
