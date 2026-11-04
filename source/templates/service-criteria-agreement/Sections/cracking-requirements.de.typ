#import "/woodwork/woodwork.typ": *

== Anforderungen an die Rissbildung

Die Norm SIA 262 unterscheidet bezüglich Rissbildung zwischen normalen, erhöhten und hohen Anforderungen: normale, wenn Risse toleriert und keine besonderen Ansprüche an Dichtigkeit und Aussehen gestellt werden; erhöhte, wenn besondere Ansprüche an Funktionstüchtigkeit und Aussehen bestehen und eine gute Rissverteilung angestrebt wird; hohe, wenn eine Begrenzung der Rissbreiten erwünscht ist. Diese Anforderungen gelten sowohl für Beanspruchungen aus Zwang (z. B. Schwinden) als auch aus Biegung; erhöhte oder hohe Anforderungen reduzieren die zulässigen Stahlspannungen und führen zu einem erhöhten Bewehrungsgehalt.

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.hline(stroke: 1pt),
    table.header([*Bereich*], [*Anforderung*]),
    table.hline(stroke: 0.5pt),
    [[Allgemein]], [Normale],
    [[Sichtbetonbauteile]], [Erhöhte],
    table.hline(stroke: 1pt),
  ),
  caption: [Anforderungen nach Bereich],
)

Zu erwartende Rissweiten bei den drei Anforderungsstufen: $w_m$ = 0.7 / 0.5 / 0.25 mm und $w_"max"$ = 1.2 / 0.9 / 0.4 mm ($w_"max"$ = 1.7 · $w_m$, 95 %-Fraktile), nach dem Zuggurtmodell (Dokumentation SIA D 0182).
