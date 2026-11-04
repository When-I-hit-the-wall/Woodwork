#import "/woodwork/woodwork.typ": *

== Acier de construction et assemblages

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, right, right),
    table.hline(stroke: 1pt),
    table.header([*Nuance*], [*Épaisseur*], [*Limite d'élasticité $f_y$*], [*Résistance à la traction $f_u$*]),
    table.hline(stroke: 0.5pt),
    [S235], [t ≤ 40 mm], [235], [360],
    [S355], [t ≤ 40 mm], [355], [510],
    table.hline(stroke: 1pt),
  ),
  caption: [Acier de construction (SIA 263)],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, right, right, left),
    table.hline(stroke: 1pt),
    table.header([*Classe de résistance*], [*Limite d'élasticité $f_"yb"$*], [*Résistance à la traction $f_"ub"$*], [*Emploi*]),
    table.hline(stroke: 0.5pt),
    [4.6], [240], [400], [Boulons, tire-fonds],
    [8.8], [640], [800], [Vis à bois (classe minimale)],
    table.hline(stroke: 1pt),
  ),
  caption: [Boulons, tire-fonds et vis à bois (SIA 263)],
)

Les broches (goujons) en acier S355 se calculent avec $f_(u,k)$ = 510 N/mm² (SN EN 14592).
