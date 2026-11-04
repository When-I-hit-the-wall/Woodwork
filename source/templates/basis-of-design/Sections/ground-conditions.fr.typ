#import "/woodwork/woodwork.typ": *

== Terrain de fondation

[Nature du terrain de fondation, stratigraphie, conditions hydrogéologiques (nappe phréatique, eaux de pente ou de couche) et source de ces informations : rapport géotechnique (auteur, date). Si les investigations ne sont pas terminées, indiquer celles qui restent nécessaires avant l'étude du projet.]

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, right),
    table.hline(stroke: 1pt),
    table.header([*Couche*], [*Description*], [*Profondeur / épaisseur*]),
    table.hline(stroke: 0.5pt),
    [[…]], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Couches de terrain],
)

#figure(
  table(
    columns: (auto, auto),
    align: (left, right),
    table.hline(stroke: 1pt),
    table.header([*Niveau d'eau*], [*Cote (m s.m. / m ü. M. / m a.s.l.)*]),
    table.hline(stroke: 0.5pt),
    [Crue (HW)], [[…]],
    [Niveau moyen (MW)], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Niveaux d'eau déterminants],
)

#figure(rect(width: 100%, height: 5cm, stroke: 0.5pt + luma(60%))[[Figure avec légende et source]], caption: [Profil géologique / extrait du rapport géotechnique])
