#import "/woodwork/woodwork.typ": *

== Baugrund

[Art des Baugrunds, Schichtaufbau, hydrogeologische Verhältnisse (Grundwasser, Hang- und Schichtwasser) und Quelle dieser Angaben: geotechnischer Bericht (Verfasser, Datum). Sind die Untersuchungen nicht abgeschlossen, die vor der Projektierung noch nötigen Abklärungen angeben.]

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, right),
    table.hline(stroke: 1pt),
    table.header([*Schicht*], [*Beschreibung*], [*Tiefe / Mächtigkeit*]),
    table.hline(stroke: 0.5pt),
    [[…]], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Baugrundschichten],
)

#figure(
  table(
    columns: (auto, auto),
    align: (left, right),
    table.hline(stroke: 1pt),
    table.header([*Wasserstand*], [*Kote (m ü. M.)*]),
    table.hline(stroke: 0.5pt),
    [Hochwasser (HW)], [[…]],
    [Mittelwasser (MW)], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Massgebende Wasserstände],
)

#figure(rect(width: 100%, height: 5cm, stroke: 0.5pt + luma(60%))[[Abbildung mit Legende und Quelle]], caption: [Geologisches Profil / Auszug aus dem geotechnischen Bericht])
