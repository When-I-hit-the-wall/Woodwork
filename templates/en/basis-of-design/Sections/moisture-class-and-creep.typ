#import "/woodwork/woodwork.typ": *

== Timber moisture and creep

*Moisture class (SIA 265, Table 3)*: Moisture class 1: mean moisture content ≤ 12 %, protected from the weather

#figure(
  table(
    columns: (auto, 1fr),
    align: (left, left),
    table.hline(stroke: 1pt),
    [Strength reduction $η_w$], [[according to the moisture class chosen (SIA 265, Table 4)]],
    [Stiffness reduction $η_w$], [[according to the moisture class chosen (SIA 265, Table 4)]],
    [Creep coefficient φ, timber preconditioned to service moisture], [[…]],
    [Creep coefficient φ, timber installed wet or partly dried], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Moisture and creep factors],
)
