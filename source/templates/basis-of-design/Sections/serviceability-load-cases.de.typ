#import "/woodwork/woodwork.typ": *

== Lastfälle: Gebrauchstauglichkeit

Für die Gebrauchstauglichkeit wird $E_d$ im Allgemeinen mit $γ_F$ = $γ_m$ = 1.0 ermittelt (SIA 260, Ziffer 4.4.4.3). Es werden drei Typen von Lastfällen unterschieden (Ziffer 4.4.4.4):

- seltene Lastfälle: veränderliche Leiteinwirkung mit ihrem charakteristischen Wert, Begleiteinwirkungen mit ψ₀;
- häufige Lastfälle: veränderliche Leiteinwirkung mit ψ₁, Begleiteinwirkungen mit ψ₂;
- quasi-ständige Lastfälle: alle veränderlichen Einwirkungen mit ψ₂.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, left, right, right, right, center),
    table.hline(stroke: 1pt),
    table.header([*Bauteil*], [*Lastfall*], [*Eigengewicht und ständige Lasten*], [*Nutzlast [Kategorie]*], [*Schnee*], [*Wind*]),
    table.hline(stroke: 0.5pt),
    [[Dach]], [CC 1], [1.0], [–], [1.0], [$ψ_0$],
    [[Regelgeschoss]], [CC 2], [1.0], [1.0], [–], [$ψ_0$],
    table.hline(stroke: 1pt),
  ),
  caption: [Lastfälle: Gebrauchstauglichkeit],
)
