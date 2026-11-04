#import "/woodwork/woodwork.typ": *

== Cas de charge : sécurité structurale

Chaque cas de charge est caractérisé par une action prépondérante et les actions concomitantes qui agissent en même temps (SIA 260, ch. 4.2.6). Les valeurs ci-dessous sont les facteurs appliqués aux valeurs caractéristiques ; pour une action concomitante, le facteur est $γ_Q$ · ψ₀ [indiquer $γ_Q$ et ψ₀ ou leur produit].

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, left, right, right, right, center),
    table.hline(stroke: 1pt),
    table.header([*Élément*], [*Cas*], [*Poids propre et charges permanentes*], [*Charge utile [catégorie]*], [*Neige*], [*Vent*]),
    table.hline(stroke: 0.5pt),
    [[Toiture]], [CC 1], [1.35], [–], [1.5], [$γ_Q · ψ_0$],
    [[Toiture]], [CC 2], [0.8], [–], [–], [1.5],
    table.hline(stroke: 1pt),
  ),
  caption: [Cas de charge : sécurité structurale],
)
