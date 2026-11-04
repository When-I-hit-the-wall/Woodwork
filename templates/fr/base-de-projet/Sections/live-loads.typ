#import "/woodwork/woodwork.typ": *

=== Charges utiles

Les charges utiles admissibles dépendent de l'affectation prévue sur le sol de l'étage concerné ; elles sont fixées par la norme SIA 261, chapitre 8, tableau 8. 1 kN/m² correspond à environ 100 kg/m² et 10 kN à environ une tonne.

Les valeurs suivantes sont des valeurs maximales : elles servent au dimensionnement et ne doivent pas être dépassées pendant la durée d'utilisation. [Pour les éléments porteurs verticaux de bâtiments à plusieurs niveaux, la charge utile peut être réduite selon SIA 261, ch. 8.3 : à préciser.]

#figure(
  table(
    columns: (auto, auto, 1fr, auto, auto, auto),
    align: (left, left, left, center, right, right),
    table.hline(stroke: 1pt),
    table.header([*Zone*], [*Niveau*], [*Utilisation*], [*Catégorie*], [*$q_k$ [kN/m²]*], [*$Q_k$ [kN]*]),
    table.hline(stroke: 0.5pt),
    [[…]], [[…]], [[Locaux d'habitation]], [A1], [[…]], [[…]],
    [[…]], [[Toiture]], [[Accessible pour l'entretien uniquement]], [H], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Charges utiles par zone et par niveau],
)

$Q_k$ : surface d'appui 50 × 50 mm ; en général, $Q_k$ n'est pas combinée avec $q_k$. Pour les surfaces avec rayonnages ou parcourues par des engins de levage, $Q_k$ est à fixer pour le projet (SIA 261, tableau 8, note 1). Catégories F et G : $Q_k$ et $q_k$ agissent simultanément ; deux charges ponctuelles de $Q_k$/2 à 1.8 m d'entraxe sur des surfaces d'appui de 200 × 200 mm (SIA 261, tableau 8, notes 3 et 4). Catégorie E : les valeurs sont à fixer pour le projet (SIA 261, ch. 8.2.2) et à consigner dans la convention d'utilisation et dans la base de projet. Les toitures praticables ou carrossables sont traitées selon leur utilisation comme des surfaces des catégories A à G ; la catégorie H ne vaut que pour les toitures accessibles uniquement pour l'entretien (SIA 261, tableau 8, note 5).

Mesures particulières (SIA 261, ch. 8.4) : les surfaces de catégorie E sont signalées, dans les locaux concernés, par la valeur maximale de la charge utile convenue ici ; l'accès aux surfaces de catégorie F est limité par des mesures constructives ; les surfaces des catégories F et G sont signalées de manière appropriée. [Surfaces carrossables : limitation de vitesse et signalisation à l'entrée.]
