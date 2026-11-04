#import "/woodwork/woodwork.typ": *

= Signatures

#figure(
  table(
    columns: (auto, auto, auto, 1fr),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Role*], [*Name*], [*Place, date*], [*Signature*]),
    table.hline(stroke: 0.5pt),
    [*Owner*], [], [], [],
    [Owner], [], [], [#v(1cm)#line(length: 100%, stroke: 0.5pt)],
    [Representative], [], [], [#v(1cm)#line(length: 100%, stroke: 0.5pt)],
    [*Project authors*], [], [], [],
    [Architect], [], [], [#v(1cm)#line(length: 100%, stroke: 0.5pt)],
    [Engineer], [], [], [#v(1cm)#line(length: 100%, stroke: 0.5pt)],
    table.hline(stroke: 1pt),
  ),
)
