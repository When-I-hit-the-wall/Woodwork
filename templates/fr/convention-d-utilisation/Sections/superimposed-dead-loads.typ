#import "/woodwork/woodwork.typ": *

== Poids propres non structuraux (charges superposées)

Les charges superposées comprennent les compositions de sol, les cloisons non porteuses et les plafonds suspendus [ainsi que les installations et la façade]. Les valeurs suivantes sont des valeurs caractéristiques, déterminantes pour le dimensionnement.

#figure(
  table(
    columns: (auto, auto, 1fr, auto),
    align: (left, left, left, right),
    table.hline(stroke: 1pt),
    table.header([*Zone*], [*Niveau*], [*Utilisation / composition*], [*Poids propre non-structural*]),
    table.hline(stroke: 0.5pt),
    [[…]], [[…]], [[Composition du sol, cloisons non porteuses, plafonds suspendus]], [[…]],
    [[…]], [[Toiture]], [[Composition de toiture, végétalisation, installation photovoltaïque]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Charges superposées par zone et par niveau],
)

Si les épaisseurs de remblai ou de revêtement prévues sont dépassées, une partie du matériau doit être remplacée par un matériau léger (isolant, argile expansée, béton cellulaire), uniquement en accord avec l'ingénieur ; le terrain ou le sol fini est relevé après exécution et les résultats sont remis à l'ingénieur pour contrôle (SIA 261, ch. 2.3.4). Les effets d'un retrait éventuel de la charge superposée sont examinés (ch. 2.3.5). [Mesures particulières : …]
