#import "/woodwork/woodwork.typ": *

== Holz und Holzwerkstoffe

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, right, right, right, right),
    table.hline(stroke: 1pt),
    table.header([*Bezeichnung*], [*Biegung $f_"md"$*], [*Druck parallel zur Faser $f_(c,0,d)$*], [*Schub $f_"vd"$*], [*Mittlerer Elastizitätsmodul $E_(0,"mean")$*]),
    table.hline(stroke: 0.5pt),
    [C24], [14.1], [12.4], [1.5], [11000],
    [GL24h], [16.0], [16.0], [1.8], [11500],
    table.hline(stroke: 1pt),
  ),
  caption: [Vollholz und Brettschichtholz (SIA 265, Bemessungswerte für Feuchteklasse 1)],
)

Die Festigkeits- und Steifigkeitseigenschaften, die Widerstandsbeiwerte und die Beiwerte zur Berücksichtigung der Lasteinwirkungsdauer werden nach den jeweils gültigen SIA-Normen angewendet. Für Holzwerkstoffe (Platten, Brettsperrholz) gelten die Werte der Norm SIA 265/1.
