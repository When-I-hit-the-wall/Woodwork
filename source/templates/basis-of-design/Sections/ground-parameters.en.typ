#import "/woodwork/woodwork.typ": *

== Ground parameters

The ground parameters are given in the geotechnical report [author, date]. The following characteristic values are assumed for the design (prudent estimates in accordance with SIA 260, 3.3.3.5 and SIA 267):

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, right, right, right, right),
    table.hline(stroke: 1pt),
    table.header([*Layer*], [*Unit weight $gamma$*], [*Friction angle $phi'$*], [*Cohesion $c'$*], [*Constrained modulus $E_s$*]),
    table.hline(stroke: 0.5pt),
    [[…]], [[…]], [[…]], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Characteristic ground parameters],
)
