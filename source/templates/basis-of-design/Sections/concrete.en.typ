#import "/woodwork/woodwork.typ": *

== Concrete

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, left, right, right, right, right),
    table.hline(stroke: 1pt),
    table.header([*Member*], [*Strength class*], [*Characteristic strength $f_"ck"$*], [*Design strength $f_"cd"$*], [*Design shear stress $tau_"cd"$*], [*Unit weight $gamma$*]),
    table.hline(stroke: 0.5pt),
    [[Member]], [C25/30], [25], [[…]], [[…]], [25],
    [[Member]], [C30/37], [30], [[…]], [[…]], [25],
    table.hline(stroke: 1pt),
  ),
  caption: [Reinforced concrete (SIA 262)],
)

Design values in accordance with SIA 262:2025. The durability requirements (exposure classes) are given in the section “Durability”.
