#import "/woodwork/woodwork.typ": *

== Vibrations

Vibrations must neither restrict the functionality of the building nor impair the comfort of its users. The following minimum eigenfrequencies are standard values; different values are permitted if a more exact dynamic analysis taking damping into account is carried out. [Particular criteria for light (timber) floors: …]

Equipment that generates vibrations is mounted on a floating base in accordance with the building physicist's instructions. [Vibrations from rail or road traffic: to be clarified by the owner.]

#figure(
  table(
    columns: (1fr, auto, auto),
    align: (left, right, left),
    table.hline(stroke: 1pt),
    table.header([*Use*], [*Minimum eigenfrequency $f$*], [*Basis*]),
    table.hline(stroke: 0.5pt),
    [Gymnasiums and sports halls], [> 8.0], [SIA 260, Tab. 5],
    [Dance and concert halls], [> 7.0], [SIA 260, Tab. 5],
    table.hline(stroke: 1pt),
  ),
  caption: [Minimum eigenfrequencies],
)
