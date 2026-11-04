#import "/woodwork/woodwork.typ": *

== Assurance qualité et contrôles

La garantie d'une fiabilité adéquate exige des mesures d'assurance qualité durant l'élaboration du projet, l'exécution, l'utilisation et la maintenance (SIA 260, ch. 2.3.6), avec responsabilités, démarches, contrôles et mécanismes de correction (ch. 2.5.2). Le système porteur est choisi de manière à offrir une redondance suffisante (insensibilité à une défaillance locale, ch. 2.4.6). Les instruments essentiels sont [le plan de contrôle du projeteur et le plan d'essais de l'entreprise, selon le mémento SIA 2007 « Qualität im Bauwesen »].

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Phase*], [*Mesure*], [*Responsable*], [*Contrôle / preuve*]),
    table.hline(stroke: 0.5pt),
    [Élaboration du projet], [[Vérification $E_d$ ≤ $R_d$ selon les normes SIA ; contrôle de plausibilité des résultats]], [[Ingénieur]], [[Contrôle par un tiers]],
    [Exécution], [[Programme d'assurance qualité de l'entreprise ; contrôle et surveillance des matériaux utilisés]], [[Entreprise / direction des travaux]], [[Plan de contrôle]],
    table.hline(stroke: 1pt),
  ),
  caption: [Mesures et contrôles],
)
