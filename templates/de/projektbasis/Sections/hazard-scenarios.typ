#import "/woodwork/woodwork.typ": *

== Gefährdungsbilder

Mögliche Gefährdungsbilder wurden durchgedacht, und geeignete Massnahmen sind festgelegt, um die Gefährdungen unter Kontrolle zu halten oder auf ein akzeptierbar kleines Mass zu beschränken (SIA 260, Ziffer 2.4.4). Die betrachteten Gefährdungsbilder mit Massnahmen, Weiterbearbeitung und Bemessungsannahmen sind:

*Einflüsse, die eine Gefährdung darstellen können (SIA 260, Ziffer 2.4.5)*:
- *Abweichungen von den angenommenen Werten der Einwirkungen*
- *Physikalische Einwirkungen, z. B. Feuchtigkeit oder Temperatur*
- *Biologische Einwirkungen, z. B. durch Insekten oder Pilze*
- *Beeinträchtigung des Tragwiderstands durch Brand, Explosion, Anprall, Leitungsbruch oder Erdbeben*

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, left, left),
    table.hline(stroke: 1pt),
    table.header([*Gefährdungsbild*], [*Massnahmen*], [*Weiterbearbeitung*], [*Bemessungsannahmen*]),
    table.hline(stroke: 0.5pt),
    [[Brand]], [[Brandabschnitte, Feuerwiderstand, ausreichende Bauteilabmessungen, Brandschutzverkleidung]], [[Brandschutzkonzept; Brandfallplanung]], [[R 60]],
    [[Erdbeben]], [[Bemessung; konstruktive Massnahmen nach SIA 261]], [[Statische Berechnung]], [[Zone, Baugrundklasse, Bauwerksklasse, q]],
    table.hline(stroke: 1pt),
  ),
  caption: [Gefährdungsbilder und Massnahmen],
)
