---
id: 2026-11-05-style-tableaux-bfh
titre: Style de tableau BFH (« Schiefer-Kopf ») dans la forme bfh
status: completed
cree: 2026-11-05
mis_a_jour: 2026-11-05
source: message écrit (fil « Rendre lisibles les tableaux de charges », projet Dome Oberalppass)
docs: [docs/typst/commands.md, woodwork/forms/bfh.typ]
---

# Style de tableau BFH — Spécification

## 1. Objectif

Donner aux tableaux d'un document en forme `bfh` le style choisi par l'ingénieur le 05.11.2026 pour les tableaux de charges du Dome Oberalppass (variante B « Schiefer-Kopf »), afin qu'il soit réutilisable dans tout document Woodwork et ne vive plus seulement dans un fichier du projet (`000-Typst-Config/bfh-table.typ`).

## 2. Source

> **T1** — « Je valide la variante B, Schieferkopf, mais le titre doit se trouver au-dessus du tableau, de manière plus grand en tout cas que le texte qui est écrit dans la première ligne. »
>
> **T2** — « Un tableau, ça a toujours un nouveau numéro. Donc, c'est tableau 5, ensuite tableau 6. Et il doit être centré par rapport au tableau. »
>
> **T3** — « Et sous le tableau, il doit y avoir la note ou la légende, si c'est nécessaire d'avoir une légende. »
>
> **T4** — « Il faut vraiment qu'on ait Dicke, Breite et Distance comme trois colonnes différentes. Mais tu peux resserrer les colonnes si elles sont trop larges […] On ne doit pas perdre cette information-là. »
>
> **T5** — « tu peux ajouter ce style non pas à Woodcore, mais à Woodwork […] lis le Claude MD pour savoir comment ça fonctionne et ajoute ce template pour les tableaux BFH. À quelque part, si c'est possible de le faire, mais peut-être c'est pas possible de le faire. »

Variante B (artifact « Lasttabellen Dome Oberalppass ») : kopfzeile gris ardoise BFH (#697D91) à texte blanc gras, lignes alternées gris clair (#EEF1F4), filet ardoise au-dessus des totaux, totaux en gras avec une marque jaune BFH (#FAC300) à gauche, filet ardoise plus épais en fin de tableau.

## 3. Exigences fonctionnelles

### REQ-001 — Style appliqué aux tableaux d'un document en forme bfh
Woodwork doit donner à tout tableau placé dans une figure (`figure(table(...))`) d'un document en forme `bfh` le style de la variante B. Source : T1, T5. Critère : un tableau d'exemple compilé avec `#show: bfh` montre l'en-tête ardoise, les lignes alternées et les filets (test de rendu dans `tests/`).

### REQ-002 — Lignes de total
Woodwork doit imprimer les lignes de total en gras, précédées d'un filet ardoise, avec une marque jaune à gauche de la première cellule. Le moyen de désigner ces lignes est la question Q-001. Source : variante B. Critère : exemple avec deux totaux.

## 4. Exigences d'interface (feuilles, rendu)

### UI-001 — Titre au-dessus, centré, plus grand que l'en-tête
Le titre d'un tableau doit être placé au-dessus, centré sur le tableau, plus grand que le texte de l'en-tête (10.5 pt gras contre 9 pt). Source : T1, T2.

### UI-002 — Numérotation continue
Les tableaux doivent être numérotés « Tabelle N » de façon continue dans le document (pas de numérotation par chapitre « 5.1 »). Source : T2. C'est déjà le comportement de Typst ; la forme ne doit pas le changer.

### UI-003 — Légende sous le tableau
Une note ou légende, si elle est donnée, doit être placée sous le tableau, en petit (8 pt), alignée à gauche. Source : T3.

### UI-004 — Colonnes étroites, pas de coupure de mots
Les cellules ne doivent pas couper les mots (pas de césure) ; les unités d'en-tête peuvent passer à la ligne pour garder des colonnes étroites. Source : T4.

## 5. Exigences d'architecture

### ARCH-001 — Dans la forme, pas dans le moteur
Le style doit vivre dans `woodwork/forms/bfh.typ` (« une forme est l'apparence d'un document », D-17) ; les formes `neutral` et `compact` ne changent pas. Source : T5 (inférée de D-17).

## 6. Contraintes

- CON-001 (inférée, principles.md) : Typst seul ; rien dans `woodwork/` ne lit un chemin hors de `woodwork/`.
- CON-002 (inférée) : les feuilles déjà copiées par les utilisateurs continuent de compiler.
- CON-003 (inférée) : documentation dans `docs/typst/commands.md` avec un exemple qui compile, entrée `CHANGELOG.md`.

## 7. Décisions prises

- D-c (05.11.2026, Q-001) : option A, style automatique dans la forme bfh ; les totaux sont les lignes de `table.footer` ; aucune commande nouvelle.
- D-d (Q-002, suit D-c) : la légende est écrite dans la figure, après le tableau ; elle reste avec lui au saut de page.
- D-e : seul un tableau écrit directement dans la figure (ou dans son corps) prend le style ; un tableau du moteur, posé dans un bloc de sa figure, garde le sien.

- D-a (05.11.2026) : variante B retenue, avec titre au-dessus centré et légende dessous (T1–T3).
- D-b : Dicke, Breite et Abstand restent trois colonnes ; c'est une règle de contenu des tableaux de charges, pas du style (T4).

## 8. Hors périmètre

- Woodcore (T5 : « non pas à Woodcore »).
- Le contenu des tableaux de charges du Dome (colonnes, valeurs) : il reste dans le projet.

## 9. Idées non retenues comme exigences

- Une option pour désactiver le style tableau par tableau.

## 10. Questions

### Q-001 — Comment écrire un tableau BFH ?
Pourquoi : c'est une surface de commande nouvelle, décision de l'ingénieur (CLAUDE.md).
- **Option A (recommandée) — règles `show` dans la forme + `table.footer` pour les totaux.** On écrit un `figure(table(...), caption: …)` Typst ordinaire ; la forme bfh le met en style. Les totaux sont les lignes de `table.footer(...)`. La légende : un argument de figure n'existe pas, donc elle s'écrit sous la figure, ou via Q-002. Avantage : aucune commande nouvelle, tout tableau existant prend le style. Perte : un tableau qu'on ne veut pas styler doit s'en échapper avec une règle `show` locale.
- **Option B — une commande `#bfh-table(caption:, header:, rows:, totals:, note:)` exportée par la forme bfh** (le helper du Dome). Avantage : légende et totaux explicites. Perte : une commande de plus à documenter, qui n'a de sens que pour la forme bfh ; un tableau Typst ordinaire ne change pas.

### Q-002 — La légende fait-elle partie de la figure ?
Si oui (recommandé), elle reste avec le tableau au saut de page. Option A : la légende est le dernier élément du corps de la figure, après le tableau ; Option B : argument `note:`.

## 11. Critères d'acceptation

- [x] REQ-001, REQ-002, UI-001 à UI-004 visibles sur l'exemple de `docs/typst/commands.md` compilé en forme bfh.
- [x] Les formes neutral et compact rendent un tableau comme avant.
- [ ] `python tests/run_tests.py` passe.

## 12. Traçabilité

| Point | Élément |
|---|---|
| T1 | REQ-001, UI-001, D-a |
| T2 | UI-001, UI-002 |
| T3 | UI-003 |
| T4 | UI-004, D-b |
| T5 | ARCH-001, §8, Q-001 |

### Points de la source non résolus
Q-001, Q-002.

## 13. Revue d'architecture

Revue faite dans la session (pas d'agent). Risque principal : restyler les tableaux du moteur (`table-figure` les pose dans un `block`) → la règle ne s'applique qu'à un tableau enfant direct du corps de la figure (D-e). Second risque : la règle `show table` se réappliquant au tableau reconstruit → étiquette `<bfh-table-done>`.

## 14. Plan d'implémentation

1. `woodwork/forms/bfh.typ` : `bfh-table` et les règles `show figure.where(kind: table)` (REQ-001, REQ-002, UI-001 à UI-004, ARCH-001).
2. `tests/test_templates.py` : `test_the_bfh_form_sets_a_table_its_title_above_and_its_legend_below` (ordre titre → tableau → totaux → légende en bfh ; légende sous le tableau en neutral).
3. `docs/typst/commands.md` (« Tables in the form bfh », exemple), `CHANGELOG.md`.

## 15. Vérification

- Rendu vérifié sur un exemple (titre centré au-dessus, en-tête ardoise, zébrage, totaux avec marque jaune, légende à gauche ; petit tableau centré ; tableau dans un bloc inchangé).
- La logique du nouveau test vérifiée avec typst-py 0.15.0 et pypdf hors du dépôt ; `python tests/run_tests.py` n'a pas pu être lancé (pas de Typst 0.15.1 dans l'environnement de la session) : à lancer par l'ingénieur.

## 16. Journal d'avancement

- 2026-11-05 — `draft` : spécification écrite depuis le fil du projet Dome Oberalppass ; prototype existant dans `008-Projektarbeit2-HS26/Dome Oberalppass/000-Typst-Config/bfh-table.typ`. En attente de Q-001/Q-002.
- 2026-11-05 — Q-001 tranchée (option A), approbation donnée par le même choix ; `implementation` puis `completed` (tests du dépôt à lancer).
