#import "/woodwork/woodwork.typ": *

== Beton

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, left, right, right, right, right),
    table.hline(stroke: 1pt),
    table.header([*Bauteil*], [*Festigkeitsklasse*], [*Charakteristische Festigkeit $f_"ck"$*], [*Bemessungswert der Festigkeit $f_"cd"$*], [*Bemessungswert der Schubspannung $tau_"cd"$*], [*Raumlast $gamma$*]),
    table.hline(stroke: 0.5pt),
    [[Bauteil]], [C25/30], [25], [[…]], [[…]], [25],
    [[Bauteil]], [C30/37], [30], [[…]], [[…]], [25],
    table.hline(stroke: 1pt),
  ),
  caption: [Stahlbeton (SIA 262)],
)

Bemessungswerte nach der Norm SIA 262:2025. Die Anforderungen an die Dauerhaftigkeit (Expositionsklassen) sind im Abschnitt «Dauerhaftigkeit» festgehalten.
