#import "/woodwork/woodwork.typ": *

== Anforderungen an die Bauteile

#figure(rect(width: 100%, height: 5cm, stroke: 0.5pt + luma(60%))[[Plan oder Schnitt mit der Nummerierung der Trennbauteile]], caption: [Bezeichnung der Trennbauteile [Geschoss]])

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Bauteil*], [*Grundlage*], [*Anforderung Tag / Nacht*], [*Ausführung / Werte*]),
    table.hline(stroke: 0.5pt),
    [[Fassade Zimmer]], [SIA 181, tab. 2], [[…] / […]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Luftschall aussen],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Bereich / Bauteil*], [*Grundlage*], [*Anforderung*], [*Ausführung / Werte*]),
    table.hline(stroke: 0.5pt),
    [[Zimmer / Zimmer]], [SIA 181, tab. 3], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Luftschall innen],
)

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Bereich / Bauteil*], [*Grundlage*], [*Anforderung*], [*Ausführung / Werte*]),
    table.hline(stroke: 0.5pt),
    [[Terrasse / Zimmer]], [SIA 181, tab. 5], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Trittschall],
)

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Geräuschart*], [*Bereich / Bauteil*], [*Grundlage*], [*Anforderung*], [*Ausführung / Werte*]),
    table.hline(stroke: 0.5pt),
    [Einzelne Geräusche], [[Küche / Restaurant]], [SIA 181, tab. 6], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Geräusche haustechnischer Anlagen],
)
