#import "/woodwork/woodwork.typ": *

== Requirements for building elements

#figure(rect(width: 100%, height: 5cm, stroke: 0.5pt + luma(60%))[[Plan or section with the numbering of the separating elements]], caption: [Identification of separating elements [storey]])

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Element*], [*Basis*], [*Requirement day / night*], [*Execution / values*]),
    table.hline(stroke: 0.5pt),
    [[Bedroom facade]], [SIA 181, tab. 2], [[…] / […]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Airborne sound from outside],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Zone / element*], [*Basis*], [*Requirement*], [*Execution / values*]),
    table.hline(stroke: 0.5pt),
    [[Bedroom / bedroom]], [SIA 181, tab. 3], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Airborne sound within the building],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Zone / element*], [*Basis*], [*Requirement*], [*Execution / values*]),
    table.hline(stroke: 0.5pt),
    [[Terrace / bedroom]], [SIA 181, tab. 5], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Impact sound],
)

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Type of noise*], [*Zone / element*], [*Basis*], [*Requirement*], [*Execution / values*]),
    table.hline(stroke: 0.5pt),
    [Isolated noises], [[Kitchen / restaurant]], [SIA 181, tab. 6], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Noise from technical installations],
)
