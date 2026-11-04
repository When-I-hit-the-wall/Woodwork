#import "/woodwork/woodwork.typ": *

== Load factors

Type of building: [building]. The load factors of SIA 260, Table 1, apply to the verification of structural safety. For a building, the values of the limit state of Type 2 (reaching the ultimate resistance of the structure or one of its structural members) are generally governing.

#figure(
  table(
    columns: (1fr, auto, auto, auto),
    align: (left, right, right, right),
    table.hline(stroke: 1pt),
    table.header([*Actions*], [*Limit state Type 1*], [*Limit state Type 2*], [*Limit state Type 3*]),
    table.hline(stroke: 0.5pt),
    [Permanent actions, acting unfavourably: $γ_(G,"sup")$], [1.1], [1.35], [1.0],
    [Permanent actions, acting favourably: $γ_(G,"inf")$], [0.9], [0.8], [1.0],
    [Variable actions in general: $γ_Q$], [1.5], [1.5], [1.3],
    table.hline(stroke: 1pt),
  ),
  caption: [Load factors for the verification of structural safety],
)

G is multiplied by $γ_(G,"sup")$ or $γ_(G,"inf")$ depending on whether the overall effect is unfavourable or favourable (SIA 260, Table 1, note 1). The factors for actions from the ground and from traffic are given in the standard.
