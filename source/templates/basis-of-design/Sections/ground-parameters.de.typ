#import "/woodwork/woodwork.typ": *

== Baugrundkennwerte

Die Baugrundkennwerte sind im geotechnischen Bericht [Verfasser, Datum] ersichtlich. Für die Bemessung werden folgende charakteristische Werte angenommen (vorsichtige Erwartungswerte nach SIA 260, Ziffer 3.3.3.5 und SIA 267):

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, right, right, right, right),
    table.hline(stroke: 1pt),
    table.header([*Schicht*], [*Raumlast $gamma$*], [*Reibungswinkel $phi'$*], [*Kohäsion $c'$*], [*Steifemodul $E_s$*]),
    table.hline(stroke: 0.5pt),
    [[…]], [[…]], [[…]], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Charakteristische Baugrundkennwerte],
)
