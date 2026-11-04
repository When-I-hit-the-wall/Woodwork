---
id: 2026-11-04-woodwork-feuilles-de-calcul
titre: Woodwork — bibliothèque autonome de feuilles de calcul Typst
status: implementation
cree: 2026-11-04
mis_a_jour: 2026-11-04
source: message écrit (session du 04.11.2026, six messages) et artefact https://claude.ai/artifact/AAHzf9iDRPehnrmTQk7V8q (version 6)
docs: [docs/typst/formulas.md, docs/typst/api-conventions.md, docs/architecture/principles.md, docs/domain/member-checks.md]
---

# Woodwork — Spécification

> Écrite dans Woodcore (`docs/requirements/active/`) puis déplacée ici à l'étape 1 du plan. Les chemins de code nus (`lib/formula.typ`, `calc/domains/member_check.py`, `tests/test_member_check.py`) désignent les fichiers **de Woodcore** au 04.11.2026, dont Woodwork a été tiré.

## 1. Objectif

Sortir le moteur de calcul Typst de Woodcore dans un projet autonome, `../Woodwork`, qui est une bibliothèque de **feuilles de calcul types** (`.typ`) : l'ingénieur copie une vérification (par ex. la traction dans l'axe) dans son projet, change quelques valeurs et la compile. Les commandes `#var`, `#eq` et `#verify` sont allégées : les réglages communs sont écrits une fois sur `#domain` et hérités par chaque ligne. Les valeurs des normes sont dans un dossier `data/` lisible, au premier niveau. Le rendu est celui des rapports de Woodcore (captures 4.4 Schneelast, 4.5 Windlast, Biegung).

## 2. Source

Messages de l'ingénieur, mot pour mot (session du 04.11.2026). Les quatre captures d'écran du premier message montrent le rendu attendu.

> **T1** — « je souhaite exporter le moteur de calcule de woodcore dans un nouveau projet appelé woodowrk (C:\Users\Quebec\001-NextCloud\001-Documents\003-Etudes\005-BFH_Ba_Holztechnik\305-typst-static-report\Woodwork). »
>
> **T2** — « Je souhaite exporter des feuilles de calcul .typ. Ce sont des feuilles de calcul type qui me permettent les copier-coller dans un projet pour pouvoir facilement faire des vérifications. Donc par exemple, il devrait y avoir la feuille de calcul traction avec force normale dans l'axe. Et je peux juste le copier-coller dans un projet et modifier quelques valeurs rapidement. »
>
> **T3** — « l'idée, ce serait que tu me fasses déjà un artefact qui propose une arborescence de toutes les vérifications qui sont possibles de faire, ou en tout cas tous les fichiers qui étaient TYP qui seraient nécessaires. »
>
> **T4** — « Également pour chaque vérification, par exemple la traction avec la force dans l'axe. Il faudrait en avoir deux ou trois différents qui présentent des niveaux de détail différents. »
>
> **T5** — « Les screenshots que je t'ai envoyés, c'est un peu la base de à quoi ça doit ressembler, de comment ça doit être présenté de base. »
>
> **T6** — « ce que je trouverais bien, ce soit que les commandes VAR, EQ et Verify soient simplifiées, et que donc, vu que très souvent ce sont les mêmes arguments qui sont donnés, et bien que tout cela soit défini une seule fois pour le domaine, de manière à alléger toutes ces commandes. »
>
> **T7** — « Également, il ne faudrait plus appeler l'argument du level dans ces commandes-là. Je ne souhaite plus vraiment utiliser le level, sauf cas très particulier. »
>
> **T8** — « on aurait des arguments définis généralement pour tout le domaine, et par ligne, je peux ensuite, moi, décider d'écraser certains arguments pour une commande en particulier. L'idée derrière tout ça, c'est que l'utilisateur peut très facilement lui-même copier-coller des fichiers de vérification et les utiliser chez lui. »
>
> **T9** — « il doit également, je pense que ce serait très bien s'il était mis en avant à quelque part un dossier qui s'appelle peut-être data, où dedans il y a tous les JSON qui sont spécifiques aux normes. Donc par exemple les JSON qui contiennent les valeurs de résistance des matériaux. Je trouverais bien que ce document soit mis en avant et soit très proche des fichiers de l'utilisateur, et non pas enfoui dans d'autres documents. »
>
> **T10** — « Réfléchis également à comment pourraient être solutionnées les différentes couches des matériaux, à quoi ça pourrait ressembler dans le fichier TYP, pour que cela reste dynamique. »
>
> **T11** — « Je souhaiterais également que lorsque l'utilisateur clique sur une des normes, eh bien le PDF de la norme s'ouvre. Fais également cette variante-là dans ton artefact pour savoir si ça rajoute beaucoup de complexité. »
>
> **T12** — « montre-moi un fichier Python qui est en fait le moteur de calcul de Woodcore qui montre comment est écrit en Python la vérification par exemple à la traction ou à la compression pour que je me rende compte de la complexité d'un de ces fichiers Python. »
>
> **T13** — « V1 + préréglage »
>
> **T14** — « Pour les niveaux de détail: seulement niveau B (stantard) et C (détaillé). Je ne souhaite donc pas avoir l'argument "mode" comme nouvel argument. »
>
> **T15** — « Pour la syntaxe: j'imaginais plus quelque chose comme ça (réglages hérités par chaque ligne avec écrasage possible): `#domain("traction-p12", norm: "SIA 265", label-position: "left", norm-position: "right")[ #var("N_t_d", 180, "kN", label: "Effort de traction") … #eq("A", `b * h`, label: "Section") #eq("sigma_t_0_d", `N_t_d / A`, label: "Contrainte de traction", norm-section: "4.2.1.1") #verify(`sigma_t_0_d <= f_t_0_d`, label: "Nachweis Zug", norm-section: "4.2.1.1 (6)") ]` »
>
> **T16** — « et même, je trouverais bien que le texte soit facilement lisible dans typst » (même exemple, un argument par ligne, en retrait).
>
> **T17** — « Pour l'instant, laisse tomber les couches de plancher et qu'un clic ouvre la norme dans le pdf »
>
> **T18** — « Explique-moi ce que la commande #eq("A", `b * h`, label: "Section") fait exactement. Est-ce que typst calcule qqch ? Est-ce qu'un scripte python est exécuté lorsque la commande est écrite ? Quel est le workflow »
>
> **T19** — « question 5: woodwork est une copie qui vit seule »
>
> **T20** — « question 6: oui » (ordre d'écriture : d'abord les sections de bois et la stabilité, puis les actions, puis les assemblages).
>
> **T21** — « question 3: tout en anglais »
>
> **T22** — « triples toutes les vérifications (fr, all, de), avec trois arborescences, chacune dans sa propre langue afin de pouvoir avoir les label dans les trois langue. C'est l'utilisateur qui choisit quel fichier copier/coller dans son projet »
>
> **T23** — « unit peut être défini par domaine (e.g. tous les moments du domaine sont affichés en "Nm" au lieu de "kNm" »
>
> **T24** — « Préréglage. … => oui dès la première version »
>
> **T25** — « Nom de #domain. … => oui » (Woodwork n'a que `#domain`, pas `#var-domain`).
>
> **T26** — « Générées » (les trois arborescences sont générées depuis une source unique).
>
> **T27** — « 1. oui 2. une liste » (fr/en/de avec dossiers et fichiers traduits ; `units:` est une liste).
>
> **T28** — « le repo sur github est créé et public (git@github.com:When-I-hit-the-wall/Woodwork.git). Comme pour woodcore, je souhaite avoir des skills implémentés dans le projet pour le développement du projet (voir …\Woodcore\.claude\skills). Peut-être existe-t-il des skills qui peuvent être utiles pour écrire du typst ? »
>
> **T29** — « donc pousse sur github ce que tu fais dans woodwork »
>
> **T30** — « de plus, créer les templates de formes et de fond déjà disponibles dans woodcore dans woodwork. Les templates de forme doivent être une uniquement commande à appeler qui règle les couleurs, les polices, les tailles de texte, les espaces, etc... Cela ne doit pas régler, par exemple, la page de titre. La page de titre doit être dans un template de fond 'titre-bfh' »
>
> **T31** — Réponses du 04.11.2026 : Q-007 « n'est-il pas possible d'utiliser la fonction de base #import "bfh.typ": bfh » ; Q-008 l'en-tête et le pied de page dans la forme ; Q-009 des squelettes à remplir ; Q-010 « titre-bfh et titre-neutral ».

## 3. Exigences fonctionnelles

### REQ-001 — Un projet Woodwork autonome
- **Exigence** : Woodwork doit être un dépôt autonome `../Woodwork`. Il contient `woodwork/`, le dossier que l'utilisateur copie dans son projet (`woodwork.typ`, `lib/`, `data/`), et à côté `source/`, `sheets/`, `figures/`, `examples/`, `tools/`, `tests/` et `docs/`. Chaque feuille importe `"/woodwork/woodwork.typ"` (D-10). Une fois créé, Woodwork ne lit rien dans Woodcore, et Woodcore ne lit rien de lui.
- **Source** : T1, T19, Q-001
- **Priorité** : doit
- **Critère d'acceptation** : `grep -r "Woodcore" Woodwork/woodwork` ne trouve aucun chemin. Un projet vide où l'on copie `woodwork/` et une feuille de `sheets/fr/` compile, hors de `305-typst-static-report/` (test).

### REQ-002 — Deux niveaux par vérification : standard et détaillé
- **Exigence** : chaque vérification doit exister en deux feuilles : standard (`<name>.typ`) et détaillée (`<name>-detailed.typ`, `-detaille`, `-detailliert`). La détaillée ajoute du texte, une figure, des sous-titres et le calcul des valeurs de calcul du matériau ; ses lignes de calcul sont celles de la standard.
- **Source** : T4, T14
- **Priorité** : doit
- **Critère d'acceptation** : pour chaque vérification de la phase 1, les deux feuilles compilent et donnent le même `eta` (test de `examples/`).

### REQ-003 — Trois arborescences, une par langue
- **Exigence** : `sheets/fr/`, `sheets/de/` et `sheets/en/` doivent contenir chacune toutes les feuilles, avec les dossiers, les noms de fichiers et les libellés dans leur langue (`sections-bois/traction/traction-axe.typ`, `holzquerschnitte/zug/zug-parallel.typ`, `timber-sections/tension/tension-parallel.typ`). Les clés de variables, les commandes et leurs arguments restent en anglais.
- **Source** : T21, T22, T27
- **Priorité** : doit
- **Critère d'acceptation** : les trois arborescences ont le même nombre de feuilles ; une même feuille dans les trois langues donne les mêmes valeurs ; aucun libellé de `sheets/fr/` n'est la chaîne anglaise (test).

### REQ-004 — Feuilles générées depuis une source unique
- **Exigence** : chaque feuille doit être écrite une seule fois dans `source/`, chaque libellé y étant une clé entre accolades (`label: "{tension-force}"`). `source/labels.json` donne, pour chaque clé, ses trois traductions et les noms traduits des dossiers et des fichiers. `tools/generate.py` écrit les trois arborescences de `sheets/`. Une clé absente de la table ou une langue manquante arrête la génération en nommant la clé et le fichier.
- **Source** : T26
- **Priorité** : doit
- **Critère d'acceptation** : un test régénère `sheets/` dans un dossier temporaire et le compare octet par octet à `sheets/` ; une clé manquante donne une erreur qui nomme la clé et le fichier (test).

### REQ-005 — Les arguments de `#domain` sont hérités par les lignes
- **Exigence** : les arguments de présentation écrits sur `#domain` doivent valoir pour chaque `#var`, `#eq` et `#verify` du bloc, et une ligne qui écrit le même argument l'emporte pour elle seule. `#domain` prend, en plus de son id, `preset`, `norm`, `label-position`, `label-width`, `descr-position`, `norm-position`, `display`, `display-formula`, `display-equation`, `style`, `stack` et `units`, et les transmet tous aux lignes. Il n'imprime pas de titre : il ne prend ni `label`, ni `descr`, ni `norm-section` (D-11). `unit` reste propre à la ligne. L'ordre de priorité est : la ligne, puis le domaine, puis le préréglage, puis les défauts de Woodwork.
- **Source** : T6, T8, T15
- **Priorité** : doit
- **Critère d'acceptation** : l'exemple de T15 compile et chaque ligne a son libellé à gauche et sa norme « SIA 265 » à droite ; une ligne écrivant `norm-position: "footnote"` met sa citation en note et les autres non (test).

### REQ-006 — `units:` par domaine
- **Exigence** : `#domain(…, units: ("Nm", "cm²"))` doit afficher chaque résultat du domaine dont la dimension est celle d'une des unités dans cette unité. Une ligne garde `unit:` pour elle seule. Deux unités de même dimension dans la liste arrêtent la compilation en nommant les deux.
- **Source** : T23, T27
- **Priorité** : doit
- **Critère d'acceptation** : `#var("M_d", 12.4, "kNm")` dans un domaine `units: ("Nm",)` imprime 12 400 Nm ; `#eq(…, unit: "kNm")` dans ce domaine imprime en kNm ; `units: ("Nm", "kNm")` panique en nommant les deux (tests).

### REQ-007 — Préréglage nommé dès la première version
- **Exigence** : `#domain(…, preset: "report")` doit lire le jeu de réglages `report` dans `data/presets.json`. Ses valeurs comptent comme celles du domaine, qui les écrase. Un préréglage inconnu arrête la compilation en le nommant et en listant ceux qui existent.
- **Source** : T13, T24
- **Priorité** : doit
- **Critère d'acceptation** : deux domaines identiques, l'un avec `preset: "report"` et l'autre avec les mêmes réglages écrits, impriment la même chose ; `preset: "inconnu"` panique avec la liste (tests).

### REQ-008 — Plus de `level` dans les feuilles
- **Exigence** : aucune feuille livrée ne doit écrire `level`. L'affichage par défaut des lignes est celui de tes captures : la formule, puis les valeurs, puis le résultat, avec le libellé et la citation (ce qu'affiche aujourd'hui le niveau 3). Le moteur accepte encore `level` pour un cas particulier. Il n'y a pas d'argument `mode`.
- **Source** : T7, T14
- **Priorité** : doit
- **Critère d'acceptation** : `grep -r "level:" Woodwork/source Woodwork/sheets` ne trouve rien ; la ligne `#eq("A", `b * h`)` sans autre argument imprime `A = b · h = 140 mm · 200 mm = 28 000 mm²` (test).

### REQ-009 — `#material` et ses couches
- **Exigence** : `#material("GL24h", moisture: 1, duration: "normal")` doit lire la classe dans `data/` (la norme), puis dans `data/my-materials/` (le bureau) si la norme ne la donne pas. Il applique η_w (SIA 265 Tab. 4) et η_t (SIA 265 2.2.6), et publie dans le domaine les valeurs de calcul (`f_t_0_d`, `f_c_0_d`, `f_m_d`…) comme des variables. Chaque valeur porte sa provenance, imprimée dans la colonne de droite. Une valeur écrite (`f_t_0_d: 11.0`) remplace celle de la table et est imprimée comme valeur de l'ingénieur. `as: "1"` suffixe les clés (`f_c_90_d_1`) pour deux matériaux dans un domaine. `print: ("f_t_0_d",)` imprime le calcul de ces valeurs (feuille détaillée).
- **Source** : T10
- **Priorité** : doit
- **Critère d'acceptation** : GL24h, classe d'humidité 1 donne `f_t_0_d` = 12.8 N/mm² (SIA 265 Tab. 9) ; classe 2 donne 10.24 N/mm² ; une classe inconnue panique en nommant les fichiers lus ; `as:` évite la collision de deux matériaux (tests).

### REQ-010 — `data/` au premier niveau
- **Exigence** : `data/` doit être au premier niveau du dossier distribué, `woodwork/data/`, donc à côté des fichiers de l'utilisateur une fois copié (D-10), avec un sous-dossier par norme (`sia265/`, `sia265-1/`, `sia261/`, `sia260/`, `sia263/`, `szs-c5/`), `my-materials/`, `norms.json` et `presets.json`. Les JSON de norme sont des copies de ceux de `Woodcore/calc/norms/`, prises le jour de la création, avec leur `_source` intact et un nom de fichier qui dit le numéro de table (`table-09-glulam.json`).
- **Source** : T9
- **Priorité** : doit
- **Critère d'acceptation** : chaque JSON de `data/` (hors `my-materials/` et `presets.json`) a un `_source` qui nomme l'édition et la page ; ses valeurs sont égales à celles du fichier de Woodcore dont il est la copie (test à la création).

### REQ-011 — Catalogue des vérifications, phase 1
- **Exigence** : la première version doit livrer les vérifications de la phase 1 : sections de bois (traction ×3, compression ×3, flexion ×5, cisaillement ×3) et stabilité (flambage, déversement ×3), soit 18 vérifications × 2 niveaux × 3 langues. Les phases suivantes (actions, puis assemblages, puis incendie, détails, aptitude au service, panneaux, acier) restent au catalogue de l'artefact.
- **Source** : T3, T20
- **Priorité** : doit (phase 1), pourrait (phases suivantes)
- **Critère d'acceptation** : `sheets/fr|de|en` contiennent chacun 36 feuilles de la phase 1, toutes compilées par `examples/` ; chaque formule et chaque article cité correspond à celui de `Woodcore/calc/domains/member_check.py` pour le même cas (relu, et test sur les valeurs de `tests/test_member_check.py`).

### REQ-012 — Un dépôt git publié sur GitHub
- **Exigence** : `../Woodwork` doit être un dépôt git dont le dépôt distant `origin` est `git@github.com:When-I-hit-the-wall/Woodwork.git` (public), sur la branche `main`. Le travail fait dans Woodwork y est poussé.
- **Source** : T28, T29
- **Priorité** : doit
- **Critère d'acceptation** : `git -C ../Woodwork remote get-url origin` donne l'adresse ; `git log origin/main` contient le dernier commit de chaque étape du plan.

### REQ-013 — Les outils de développement de Woodwork : CLAUDE.md, skills et agents
- **Exigence** : Woodwork doit avoir, comme Woodcore, un `CLAUDE.md` court et un `docs/` de référence. Il a aussi ses skills dans `.claude/skills/` : `requirements`, `big-feature`, `small-feature`, `architecture-review`, `implementation`, `verify-requirements`, `finish` et `issue`. Il a enfin ses agents dans `.claude/agents/` : `code-scout`, `requirements-analyst`, `architecture-reviewer` et `requirements-verifier`. Tous sont adaptés à Woodwork : pas de fenêtre ni de Qt, et des règles propres à Woodwork (générer `sheets/` depuis `source/`, compiler `examples/`, valeurs lues dans `data/`, dépôt `When-I-hit-the-wall/Woodwork`). Les specs de Woodwork vivent dans `Woodwork/docs/requirements/`, et cette spécification y est déplacée quand le dépôt est créé.
- **Source** : T28
- **Priorité** : doit
- **Critère d'acceptation** : chaque skill et chaque agent de Woodwork se lance depuis une session ouverte dans `Woodwork/`. Aucun ne cite un fichier de Woodcore (`grep -r "calc/domains\|PySide" Woodwork/.claude Woodwork/CLAUDE.md` ne trouve rien). `finish` pousse vers `origin/main` après la question de confirmation.

### REQ-014 — Un skill pour écrire du Typst
- **Exigence** : Woodwork doit avoir un skill qui guide l'écriture d'une feuille et du moteur en Typst : la syntaxe de Typst 0.15, les commandes de Woodwork (`#domain`, `#var`, `#eq`, `#verify`, `#material`), les pièges connus (`state` et `context`, chemins d'import, format des panics), et le format d'une source (`{clé}` de libellé). Le skill de base reste à choisir (Q-004).
- **Source** : T28
- **Priorité** : devrait
- **Critère d'acceptation** : `.claude/skills/typst-sheet/SKILL.md` existe et est utilisé par `implementation` pour écrire une feuille de la phase 1.

### REQ-015 — Les templates de forme : un fichier, une fonction
- **Exigence** : Woodwork doit livrer les trois formes de Woodcore (`neutral`, `compact`, `bfh`) dans `woodwork/forms/`, chacune un fichier qui exporte une fonction de son nom, appelée par la règle de Typst : `#import "/woodwork/forms/bfh.typ": bfh` puis `#show: bfh` (ou `#show: bfh.with(lang: "fr")`). Une forme règle les polices, les couleurs, les tailles, les espacements, les titres, les légendes, les marges, l'en-tête et le pied de page. Elle ne règle pas la page de titre.
- **Source** : T30, T31 (Q-007, Q-008)
- **Priorité** : doit
- **Critère d'acceptation** : un document `#show: bfh` compile avec Lucida Sans (ou son remplacement), le gris de la BFH sur les titres, le logo en en-tête ; les trois formes compilent seules dans un projet vide (test) ; aucune forme n'imprime de page de titre.

### REQ-016 — Les pages de titre sont des templates de fond
- **Exigence** : Woodwork doit livrer `titre-bfh` et `titre-neutral`, des fichiers que l'utilisateur copie et remplit. Les champs de la page de titre de Woodcore (nom du projet, numéro, client, adresse, bureau, auteur, vérificateur, date, document) y sont écrits, plus lus dans `project.json`. La page de titre n'a ni en-tête ni pied de page. Elle existe en fr, de et en, et elle est générée depuis `source/`.
- **Source** : T30, T31 (Q-010)
- **Priorité** : doit
- **Critère d'acceptation** : `titre-bfh` et `titre-neutral` compilent dans les trois langues avec la forme correspondante ; changer un champ dans le fichier le change sur la page (test).

### REQ-017 — Les fonds de document en squelettes
- **Exigence** : Woodwork doit livrer la convention d'utilisation, la base de projet et le rapport de statique de Woodcore en squelettes, en fr, de et en, générés depuis `source/`. Ils gardent les mêmes chapitres et le même texte. Là où Woodcore bouclait sur l'export (plans, positions, charges, modèles), il y a un emplacement commenté où l'utilisateur colle ses feuilles.
- **Source** : T30, T31 (Q-009)
- **Priorité** : doit
- **Critère d'acceptation** : chacun des 9 squelettes compile avec la forme `bfh` et la page `titre-bfh` (test) ; aucun ne lit de fichier d'un projet Woodcore.

## 4. Exigences d'interface (rapport)

### UI-001 — Le rendu des captures
- **Exigence** : une feuille standard doit imprimer, pour chaque ligne, le libellé dans une colonne à gauche, la formule en lettres, puis en nombres avec leurs unités, puis le résultat, et la citation de norme alignée à droite. `#verify` imprime le rapport, `⩽ 1` et ✓ avec le double trait vert. C'est la présentation des captures 4.4, 4.5 et « Nachweis Biegung ».
- **Source** : T5, T15
- **Langues** : fr / de / en. Les libellés des feuilles viennent de `source/labels.json`. Les mots du moteur (« voir », « stale »…) suivent `text.lang` du document.
- **Critère d'acceptation** : la feuille `tension-parallel` compilée (PDF de `examples/`) correspond au rendu « Standard » de l'artefact (relu par l'ingénieur) ; changer `#set text(lang: "de")` change les mots du moteur (test).

### UI-002 — Une feuille lisible dans Typst
- **Exigence** : les feuilles générées doivent écrire un argument par ligne, en retrait sous la commande (T16).
- **Source** : T16
- **Langues** : —
- **Critère d'acceptation** : dans `sheets/`, aucune ligne `#var`, `#eq`, `#verify` ou `#domain` ne porte plus d'un argument nommé (test).

## 5. Exigences d'architecture

### ARCH-001 — Typst seul pour utiliser une feuille
- **Exigence** : compiler une feuille ne doit demander que Typst (0.15.1). Python ne sert qu'aux outils du mainteneur (`tools/generate.py`, tests).
- **Source** : T18, T12 (l'explication de `#eq` a conclu que Typst calcule tout)
- **Critère d'acceptation** : `examples/all.typ` compile sur une machine sans Python (ou avec `PATH` sans Python).

### ARCH-002 — Un moteur détaché des données de projet de Woodcore
- **Exigence** : le `lib/` de Woodwork doit être extrait du `lib/` de Woodcore sans ce qui lit un projet Woodcore : `../data/project.json`, positions, plans, feuilles de plan, liaisons, `calculations.json`, journal, `../calc/i18n/strings.json`. Les mots dont le moteur a besoin sont copiés dans `lib/strings.json` (trois langues). La langue est `text.lang`, et non plus `data/project.json`.
- **Source** : T1, T19 ; principe « Domain logic is independent » et règle de copie autonome (inférée)
- **Critère d'acceptation** : aucun `json(` ni `read(` de `lib/` ne vise un chemin hors de `Woodwork/` ; `grep "../data/\|../calc/" Woodwork/lib` ne trouve rien.

### ARCH-003 — L'héritage passe par le mécanisme existant
- **Exigence** : l'héritage des arguments de `#domain` (REQ-005), `units:` (REQ-006) et `preset:` (REQ-007) doivent passer par les cadres de domaine qui existent déjà dans le moteur (`push-frame`, `#calc-defaults(scope: "domain")`, `#unit(scope: "domain")`, `lib/formula.typ` l. 1001, 1890, 1927), sans nouvel état Typst. `norm` s'ajoute à ce qu'un cadre peut porter.
- **Source** : T6, T8 ; inféré de la lecture de `lib/formula.typ`
- **Critère d'acceptation** : un seul `state(` de plus au plus dans `lib/` par rapport au `lib/` copié (revue) ; les tests de REQ-005 à REQ-007 passent.

### ARCH-004 — Une seule source pour les feuilles
- **Exigence** : `sheets/` n'est jamais corrigé à la main ; il est toujours le produit de `source/` par `tools/generate.py` (REQ-004).
- **Source** : T26 ; principe « One source of truth »
- **Critère d'acceptation** : le test de REQ-004.

## 6. Contraintes

- **CON-001** — Typst 0.15.1, la version de Woodcore (`typst-version.txt`). Source : inférée.
- **CON-002** — Toute valeur de norme vient d'un JSON de `data/` qui nomme son édition et sa page ; aucune valeur n'est écrite de mémoire (principes, règle 13). Source : CLAUDE.md.
- **CON-003** — Un article qui n'est pas déjà cité par Woodcore est lu dans le PDF de `ExternalFiles/000-Normes/` au moment d'écrire la feuille. Source : CLAUDE.md, artefact (« § à lire »).
- **CON-004** — Fichiers texte en LF ; prose sans retour à la ligne forcé ; code et commentaires en anglais. Source : CLAUDE.md, T21.
- **CON-005** — Woodcore n'est pas modifié par ce travail, à l'exception de cette spécification, d'une entrée de `docs/decisions.md` et du `CHANGELOG.md`. Source : T19 (inférée).
- **CON-006** — Le dossier `../Woodwork` est hors du dépôt git de Woodcore. Source : T1.
- **CON-007** — Le dépôt est public (T28). Il ne contient ni PDF de norme ni texte de norme recopié. Les `*-excerpts.json` de Woodcore, qui citent le texte des articles, ne sont pas copiés : le lien vers le PDF est mis de côté (T17), ils ne servent donc à rien. Les tables de valeurs transcrites sont copiées telles que Woodcore les a, avec leur `_source`, leurs titres et leurs libellés (D-13). Source : inférée de T28, amendée par Q-005.

## 7. Décisions prises

- **D-1** — Woodwork est une copie qui vit seule, sans lien de retour avec Woodcore (T19). Prix : une correction du moteur dans Woodcore ne profite plus à Woodwork, et inversement.
- **D-2** — Deux niveaux : standard et détaillé ; pas d'argument `mode` ; `level` n'est plus écrit (T14, T7).
- **D-3** — Syntaxe : les noms d'arguments actuels de Woodcore, écrits sur `#domain` et hérités ; un argument par ligne (T15, T16). Le préréglage nommé est disponible dès la première version (T13, T24).
- **D-4** — Seul `#domain` existe dans Woodwork, sans `#var-domain` (T25).
- **D-5** — Code en anglais (T21). Feuilles en trois langues, fr, de et en, avec dossiers, fichiers et libellés traduits (T22, T27).
- **D-6** — Les feuilles sont générées depuis une source unique (T26). Prix : un script et un test de plus pour le mainteneur.
- **D-7** — `units:` est une liste, où chaque unité dit sa dimension (T27).
- **D-8** — Ordre d'écriture : sections de bois et stabilité, puis actions, puis assemblages (T20).
- **D-10** — Le moteur se distribue en dossier : l'utilisateur copie `woodwork/` (`woodwork.typ`, `lib/`, `data/`) une fois à la racine de son projet, et chaque feuille importe `"/woodwork/woodwork.typ"` (Q-001).
- **D-11** — `#domain` n'imprime pas de titre. Le titre est écrit à la main, `= Traction dans l'axe (SIA 265)`. Les arguments de présentation de `#domain` ne valent que pour ses lignes (Q-003).
- **D-12** — L'affichage par défaut de Woodwork est le rendu des captures : la famille `block`, avec le libellé à gauche, la citation à droite, et la formule puis les valeurs puis le résultat. C'est aussi le préréglage `report`. Cela découle de REQ-008, où l'ingénieur a demandé ce rendu sans `level` ; la revue a montré que le niveau 3 actuel ne le donne pas (§13).
- **D-13** — Les JSON de table sont publiés tels que Woodcore les a, avec leurs titres, libellés et notes ; seules les `_note` qui citent des chemins de Woodcore sont nettoyées (Q-005). Prix accepté : des libellés de la norme SIA sont publics.
- **D-14** — La citation à droite s'écrit `norm-position: "right"` ; `"line-right"` est refusé avec un message qui donne le nouveau nom (Q-006).
- **D-17** — Une forme est un fichier qui exporte une fonction de son nom, appelée par `#show:` (Q-007 : « la fonction de base ») ; la forme règle aussi l'en-tête et le pied de page (Q-008) ; les pages de titre et les documents sont des templates de fond (T30) ; deux pages de titre, BFH et neutre (Q-010) ; les documents en squelettes (Q-009).
- **D-9** — Le travail fait dans Woodwork est poussé sur `origin/main` du dépôt public `When-I-hit-the-wall/Woodwork` (T29). L'autorisation vaut pour ce dépôt seul. Rien n'est poussé avant l'approbation de cette spécification, puisqu'il n'y a rien à pousser avant.

## 8. Hors périmètre

- Les couches d'un complexe de plancher (`#layers`) (T17).
- L'ouverture du PDF de la norme d'un clic (T17).
- Le niveau A « court » et l'argument `mode` (T14).
- Toute fenêtre ou interface graphique ; tout calcul en Python ; la synchronisation avec Woodcore (D-1).
- Les vérifications des phases 2 et suivantes (REQ-011).

## 9. Idées non retenues comme exigences

- T11, T17 : le lien vers le PDF a été étudié (artefact) puis mis de côté. La page de chaque article existe déjà dans les `*-excerpts.json`, ce qui le rendrait faisable plus tard.
- T12, T18 : l'extrait Python et l'explication de `#eq` étaient des questions de compréhension, pas des demandes.
- Option V2 (`#calc-set` de fichier), V3 (commandes configurées) : écartées (T13).

## 10. Questions

### Q-001 — Comment une feuille copiée trouve-t-elle le moteur et `data/` ?
- **Pourquoi elle compte** : une feuille commence par `#import …`. Le chemin de cet import décide où vivent `lib/` et `data/` chez l'utilisateur, et donc si `data/` est « très proche des fichiers de l'utilisateur » (T9).
- **Options** :
  - **A (recommandée)** : l'utilisateur copie le dossier `woodwork/` (moteur et `data/`) une fois à la racine de son projet, et chaque feuille importe `"/woodwork/woodwork.typ"`. `data/` est alors visible dans son projet. Un projet a sa propre copie et peut corriger ses données.
  - **B** : Woodwork est installé comme paquet Typst local (`@local/woodwork:0.1.0`) et l'import est `#import "@local/woodwork:0.1.0": *`. Une seule installation sert à tous les projets. Mais `data/` est enfoui dans le dossier des paquets, et un paquet ne lit pas les fichiers du projet, donc pas de `my-materials/` par projet.
- **Réponse** : A, le dossier dans le projet (04.11.2026). → REQ-001, REQ-010, D-10.

### Q-002 — Woodwork a-t-il son propre dépôt git ?
- **Pourquoi elle compte** : on peut suivre ses versions, et le test de génération compare `sheets/` à ce qui est enregistré.
- **Options** : A un dépôt git à lui ; B pas de git.
- **Réponse** : A, avec un dépôt distant : l'ingénieur a créé le dépôt public `git@github.com:When-I-hit-the-wall/Woodwork.git` et demande que le travail y soit poussé (T28, T29, 04.11.2026). → REQ-012, D-9.

### Q-003 — Que deviennent les arguments de présentation propres au titre du domaine ?
- **Pourquoi elle compte** : dans Woodcore, `label-position`, `descr-position` et `norm-position` écrits sur `#domain` règlent **son titre** (et `label-position: "left"` y est refusé). Dans ta syntaxe, ils règlent **les lignes**.
- **Options** :
  - **A (recommandée)** : sur `#domain`, ces arguments ne valent que pour les lignes. Le titre garde une présentation fixe (titre de section, norme du domaine en fin de titre), réglable seulement par le préréglage.
  - **B** : des arguments distincts pour le titre (`title-norm-position:`…).
- **Réponse** : « lignes seulement. Le titre est fait manuellement avec '= Titre (norme)'. » (04.11.2026). `#domain` n'imprime donc plus de titre. Il ne prend plus `label`, `descr`, `norm-section` ni leurs positions pour lui-même, et `norm` sert seulement de défaut aux lignes. → REQ-005, D-11.

### Q-004 — Quel skill Typst prendre comme base ?
- **Pourquoi elle compte** : un skill externe apporte la syntaxe générale de Typst ; celui de Woodwork doit y ajouter ses commandes et ses pièges. Installer un skill externe télécharge du contenu tiers.
- **Options** (recherche `npx skills find typst`, 04.11.2026) :
  - **A (recommandée)** : écrire `typst-sheet` nous-mêmes, à partir de la documentation de Woodcore (`docs/typst/*.md`) et des pièges déjà connus. Rien d'externe : c'est le plus précis pour nos commandes.
  - **B** : A, plus le skill général `lucifer1004/claude-skill-typst@typst` (2 100 installations, le plus utilisé), installé dans le projet après lecture de son contenu.
  - **C** : A, plus `myriad-dreamin/tinymist@typst-writing-document` (41 installations, mais publié par l'auteur de Tinymist, le serveur de langage Typst).
- **Réponse** : C, le nôtre plus celui de Tinymist (04.11.2026). Le skill de Tinymist est téléchargé dans `Woodwork/.claude/skills/` et lu en entier avant d'être enregistré dans le dépôt. → REQ-014.

### Q-005 — Que publie-t-on des tables de norme dans un dépôt public ?
- **Pourquoi elle compte** : Woodcore est privé, Woodwork sera public. Les JSON de table portent les valeurs, mais aussi les titres, les libellés et les notes recopiés de la norme SIA.
- **Options** : A (recommandée) publier les valeurs et la référence (`_source` : norme, table, page), en retirant les titres, les libellés et les notes recopiés mot pour mot ; B publier les JSON tels que Woodcore les a ; C ne publier aucune table (`data/` hors du dépôt, l'utilisateur la remplit depuis sa norme).
- **Réponse** : B, tels que Woodcore (04.11.2026). Seules les `_note` qui citent des chemins de Woodcore sont nettoyées. → CON-007 (amendé), D-13.

### Q-006 — Le nom de la valeur « citation à droite »
- **Pourquoi elle compte** : ton exemple écrit `norm-position: "right"`, alors que le moteur nomme cette valeur `"line-right"` (`lib/display-presets.json`). C'est un choix de la surface de commande.
- **Options** : A (recommandée) `"right"` dans Woodwork, `"line-right"` refusé avec un message qui donne le nouveau nom ; B garder `"line-right"` ; C accepter les deux.
- **Réponse** : A, `"right"` (04.11.2026). → D-14.

### Q-011 — Comment une feuille lit-elle une constante d'article ?
- **Pourquoi elle compte** : 11 des 18 vérifications lisent des constantes (k_h, β_c, λ_rel limite, k_a, k_t,90) que la règle interdit de taper à la main.
- **Réponse** : `#var(…, from:, path:)` (04.11.2026). → D-18.

### Q-012 — Comment écrire une formule par morceaux ?
- **Pourquoi elle compte** : k_m (39) ne s'écrit pas exactement avec `min` et `max`.
- **Réponse** : `#eq(…, cases:)` (04.11.2026). → D-19.

## 11. Critères d'acceptation

- [ ] REQ-001 — Woodwork compile hors de `305-typst-static-report/`, sans aucun chemin vers Woodcore.
- [ ] REQ-002 — standard et détaillé compilent pour chaque vérification et donnent le même `eta`.
- [ ] REQ-003 — trois arborescences de même taille, libellés traduits, mêmes valeurs.
- [ ] REQ-004 — régénérer `sheets/` donne des fichiers identiques ; une clé manquante est nommée.
- [ ] REQ-005 — héritage et écrasement par ligne vérifiés par test.
- [ ] REQ-006 — `units: ("Nm",)` imprime 12 400 Nm ; deux unités de même dimension paniquent.
- [ ] REQ-007 — `preset:` égale les réglages écrits ; un préréglage inconnu panique avec la liste.
- [ ] REQ-008 — aucun `level:` dans `source/` ni `sheets/` ; affichage par défaut formule, puis valeurs, puis résultat.
- [ ] REQ-009 — `#material("GL24h", moisture: 1)` donne 12.8 N/mm², `moisture: 2` 10.24 N/mm², et `as:` évite les collisions.
- [ ] REQ-010 — `data/` au premier niveau, `_source` intact, valeurs égales à Woodcore.
- [ ] REQ-011 — 18 vérifications de la phase 1 × 2 × 3 compilées, formules et articles égaux à `member_check.py`.
- [ ] REQ-012 — `origin` = `When-I-hit-the-wall/Woodwork`, chaque étape poussée sur `main`.
- [ ] REQ-013 — CLAUDE.md, `docs/`, 8 skills et 4 agents propres à Woodwork ; la spec déplacée dans `Woodwork/docs/requirements/`.
- [ ] REQ-014 — skill `typst-sheet` présent et utilisé.
- [ ] REQ-015 — trois formes, `#show: bfh`, sans page de titre.
- [ ] REQ-016 — `titre-bfh`, `titre-neutral` en fr/de/en, champs écrits dans le fichier.
- [ ] REQ-017 — 9 squelettes de documents qui compilent.
- [ ] UI-001 — rendu conforme aux captures ; mots du moteur selon `text.lang`.
- [ ] UI-002 — un argument nommé par ligne dans `sheets/`.
- [ ] ARCH-001 — compile sans Python.
- [ ] ARCH-002 — aucun chemin hors de `Woodwork/` dans `lib/`.
- [ ] ARCH-003 — héritage par les cadres existants.
- [ ] ARCH-004 — `sheets/` toujours généré.
- [ ] Documentation : `Woodwork/README.md` (fr, de, en : copier une feuille, les arguments du domaine, `#material`, `data/`), `docs/` de Woodwork pour le mainteneur (générer, tester) ; dans Woodcore : `docs/decisions.md` (la séparation) et `CHANGELOG.md`.
- [ ] Tests : `Woodwork/tests/` (génération, compilation de `examples/`, héritage, `units`, `preset`, `#material`, égalité avec les valeurs de `tests/test_member_check.py`).

## 12. Traçabilité

| Source | Élément | Statut |
|---|---|---|
| T1 | REQ-001, ARCH-002, CON-006 | capturé |
| T2 | REQ-001, REQ-011 | capturé |
| T3 | REQ-011 | capturé |
| T4 | REQ-002 | capturé (précisé par T14) |
| T5 | UI-001 | capturé |
| T6 | REQ-005, ARCH-003 | capturé |
| T7 | REQ-008, D-2 | capturé |
| T8 | REQ-005 | capturé |
| T9 | REQ-010, Q-001 | capturé ; où vit `data/` → question |
| T10 | REQ-009 | capturé |
| T11 | §8, §9 | mis de côté par T17 |
| T12 | §9 | question de compréhension |
| T13 | D-3, REQ-007 | décision |
| T14 | REQ-002, REQ-008, D-2 | décision |
| T15 | REQ-005, UI-001, D-3, Q-003 | capturé ; titre du domaine → question |
| T16 | UI-002 | capturé |
| T17 | §8 | hors périmètre |
| T18 | ARCH-001, §9 | question de compréhension, conclusion reprise |
| T19 | D-1, REQ-001, CON-005 | décision |
| T20 | D-8, REQ-011 | décision |
| T21 | D-5, CON-004 | décision |
| T22 | REQ-003, D-5 | décision |
| T23 | REQ-006 | capturé |
| T24 | REQ-007 | décision |
| T25 | D-4 | décision |
| T26 | REQ-004, ARCH-004, D-6 | décision |
| T27 | REQ-003, REQ-006, D-5, D-7 | décision |
| T28 | REQ-012, REQ-013, REQ-014, CON-007, Q-004 | capturé ; skill Typst de base → question |
| T29 | REQ-012, D-9 | décision |
| T30 | REQ-015, REQ-016, REQ-017 | capturé |
| T31 | D-17 | décision |

### Points de la source non résolus

Aucun : Q-001 à Q-004 ont reçu leur réponse le 04.11.2026.

## 13. Revue d'architecture

Revue par l'agent `architecture-reviewer`, 04.11.2026, sur le code de Woodcore.

**Modules concernés.**
- `lib/formula.typ` (2 589 l.) possède `var`, `eq`, `verify`, `domain` (l. 2023), `unit` (l. 1890), `calc-defaults` (l. 1927), `push-frame` (l. 1002) et `resolve-display` (l. 1044–1096).
- `lib/calc-engine-core.typ` possède les états de niveau, `cite-text`, `norm-text`, `find-calculation` (l. 521) et tous les `json("../data/…")` du projet (l. 175–425).
- La chaîne d'import est `calc-engine → connections → records → display → drawings → core → i18n/number/subscript`, et `formula.typ:18-28` importe aussi `distance`, `bibliography`, `document`, `sheet` et `positions`.

**Code à réutiliser.**
- Le moteur à garder fait environ 3 500 à 4 000 lignes :
  - `formula.typ`, `i18n.typ`, `number.typ`, `subscript.typ` ;
  - `units.json`, `display-presets.json` ;
  - une version amputée de `core` et de `display`.
- À couper : `drawings`, `connections`, `records`, `sheet`, `positions`, `distance` et `document`.
- L'héritage existe déjà par les cadres de domaine : `push-frame`, l'ordre ligne > domaine > document de `default-layers` (l. 1015), `calc-defaults(scope: "domain")` et `set-unit` (l. 740). Il ne faut aucun état nouveau.
- Les formules et les articles des vérifications sont en Python : `member_check.py`, `member_check_stability.py`, et `unfold._generate_member` (l. 230), qui écrit déjà ces vérifications en `#domain/#var/#eq/#verify`. Il n'y a aucun Typst de vérification à reprendre, car `lib/timber.typ` n'existe plus.
- `#material` est du code neuf en Typst, dont l'oracle Python est `member_check_material.resistance` (l. 281). Les tables 8 et 9 de SIA 265 donnent déjà des **valeurs de calcul** : la feuille détaillée imprime f<sub>d,tab</sub> · η<sub>w</sub> · η<sub>t</sub>, et non f<sub>k</sub>/γ<sub>M</sub>.
- Oracle des valeurs : `tests/test_member_check.py`, l. 356, 461, 495, 798 et 835.

**Risques.**
- **ARCH-RISK-001 (bloquant)** : `calc-engine.typ` ne peut pas être copié tel quel, car sa chaîne lit `../data/`. → Réécrire `calc-engine.typ` en ré-exports minimaux, couper `formula.typ:18-28`, et tester la compilation dans un dossier vide (ARCH-005).
- **ARCH-RISK-002 (important)** : `strings.json` est copié. → Le réduire aux clés du moteur, et tester que chaque `t-str("…")` de `lib/` existe en fr, de et en.
- **ARCH-RISK-003 (important)** : la langue vient de `report-lang()`, un état dont le défaut est `"de"`. → La lire depuis `text.lang` dans un `context`. Un appel hors `context` (`colon-str`, `core:661`) est à rendre sûr. Tester les trois langues.
- **ARCH-RISK-004 (important)** : `domain-heading`, `load-domain-state` et `wc-meta` deviennent morts, puisque D-11 supprime le titre. → Les supprimer, ce qui réduit aussi le risque de non-convergence de Typst.
- **ARCH-RISK-005 (important)** : `norm` n'est pas une couche (`calc-default-names`, l. 1905). → L'ajouter aux défauts du cadre et le lire dans `var`, `eq` et `verify`. Tester une ligne qui écrase `norm-position` seule.
- **ARCH-RISK-006 (important)** : le dépôt Woodcore est **privé**, Woodwork sera **public**. Les JSON de table portent des `title`, `labels` et `notes` recopiés de la norme, et des `_note` qui citent des chemins de Woodcore. → Nettoyer les `_note`. Ce qui est publié des tables est à décider par l'ingénieur (Q-005).
- **ARCH-RISK-007 (mineur)** : `bib-note` (`bibliography.typ`) lit `norms.json` et `../data/*.json`. → Garder une version minimale sur `woodwork/data/norms.json`, émise hors `context`.
- **ARCH-RISK-008 (mineur)** : le format des panics de Typst 0.15. → Recopier l'aide `panic_message` dans les tests.
- **ARCH-RISK-009 (mineur)** : les skills et les agents citent des chemins de Woodcore. → Les adapter, ce qui est de l'écriture, pas de la copie.
- **ARCH-RISK-010 (mineur)** : le test de régénération compare octet par octet. → `.gitattributes` en LF, et `encoding="utf-8"`, `newline="\n"` à l'écriture.
- **ARCH-RISK-012 (mineur)** : les chemins du moteur sont relatifs à `lib/` (`../data/…`), jamais `/woodwork/…`. Seules les feuilles importent `"/woodwork/woodwork.typ"`.
- **Défaut d'affichage (point de décision)** : « défaut = niveau 3 » n'est pas une ligne de code. Le niveau 3 de la famille `inline` met libellé et citation en note. Le rendu des captures (libellé à gauche, norme à droite, formule puis valeurs puis résultat) correspond à la famille `block`, avec `label-position: "left"` et `norm-position: "line-right"`. → Ce rendu devient le défaut de Woodwork et le préréglage `report` (D-12). Ton exemple écrit `norm-position: "right"`, alors que la valeur du moteur est `"line-right"` (Q-006).

**Approche recommandée.**
1. Copier puis couper le moteur, réécrire `calc-engine.typ`, retirer le titre du domaine.
2. Ajouter à `domain` les défauts hérités, `norm`, `units:` et `preset:`.
3. Écrire `#material` en Typst.
4. Écrire les 18 vérifications d'après `unfold._generate_member` et `member_check.py`, puis les générer depuis `source/`.

**Verdict : APPROUVER AVEC RÉSERVES.** Les réserves sont ARCH-RISK-001, le défaut d'affichage (D-12, Q-006) et la publication des tables (Q-005). Elles sont reprises ci-dessous et dans le plan.

### Exigences ajoutées par la revue

#### ARCH-005 — Le moteur compile sans Woodcore
- **Exigence** : `woodwork/lib/calc-engine.typ` est réécrit en ré-exports minimaux. Aucun fichier de `woodwork/` ne lit, par `json(` ou `read(`, un chemin hors de `woodwork/`. Les fonctions qui servaient un projet Woodcore sont supprimées, pas laissées mortes : `find-calculation`, `load-domain-state`, `wc-meta`, `domain-heading`, `uniform-level` et les loaders de `core`.
- **Source** : revue (ARCH-RISK-001, 004)
- **Critère d'acceptation** : test qui compile `examples/all.typ` dans un dossier temporaire ne contenant que `woodwork/` et `examples/` ; `grep` de ces noms dans `woodwork/lib` vide.

#### ARCH-006 — Les mots du moteur suivent `text.lang`
- **Exigence** : `report-lang()` lit `text.lang` (fr, de, en, sinon en). `woodwork/lib/strings.json` ne garde que les clés que `lib/` appelle.
- **Source** : revue (ARCH-RISK-002, 003)
- **Critère d'acceptation** : test que chaque `t-str("…")` de `lib/` a ses trois langues, et que `#set text(lang: "de")` change un mot du moteur.

#### ARCH-007 — `norm` est une couche des défauts
- **Exigence** : `norm` s'ajoute à ce qu'un cadre de domaine et un préréglage portent, et `var`, `eq` et `verify` le lisent par `default-layers` quand la ligne n'en écrit pas.
- **Source** : revue (ARCH-RISK-005)
- **Critère d'acceptation** : test de REQ-005.

## 14. Plan d'implémentation

Chaque étape se termine par un commit poussé sur `origin/main` du dépôt Woodwork (D-9).

1. **Créer le dépôt.**
   - `git init` dans `../Woodwork`, `origin` = `git@github.com:When-I-hit-the-wall/Woodwork.git`, branche `main`.
   - `.gitattributes` en LF, `.gitignore`, `README.md` d'attente.
   - Déplacer cette spec dans `Woodwork/docs/requirements/active/`. Dans Woodcore, elle est remplacée par un renvoi d'une ligne dans `docs/decisions.md` (étape 9).
   - Réalise : REQ-012, en partie REQ-013.
2. **Outils de développement.**
   - `CLAUDE.md` court et `docs/` de référence : `README.md`, `architecture/principles.md`, `architecture/layout.md`, `conventions/testing.md`, `conventions/writing.md`, `typst/commands.md`.
   - `.claude/skills/` : les 8 skills de Woodcore réécrits pour Woodwork (`finish` pousse sur `origin/main` après sa question), et `typst-sheet`, écrit à partir de `Woodcore/docs/typst/*.md` et des pièges connus.
   - Le skill `myriad-dreamin/tinymist@typst-writing-document`, téléchargé puis lu en entier avant d'être enregistré.
   - `.claude/agents/` : les 4 agents réécrits.
   - `tests/run_tests.py` et `tests/conftest.py` (avec `panic_message`).
   - Réalise : REQ-013, REQ-014, ARCH-RISK-008 et 009. Test : `grep` du critère de REQ-013.
3. **Extraire le moteur.**
   - Copier dans `woodwork/lib/` : `formula.typ`, `calc-engine-core.typ`, `calc-engine-display.typ`, `i18n.typ`, `number.typ`, `subscript.typ`, `bibliography.typ`, `units.json` et `display-presets.json`.
   - Réécrire `calc-engine.typ`, couper les imports et supprimer ce que liste ARCH-005.
   - `strings.json` réduit, langue tirée de `text.lang`, `woodwork.typ` comme point d'entrée.
   - Réalise : ARCH-002, ARCH-005, ARCH-006, ARCH-001. Tests : `test_engine_standalone.py` (compilation dans un dossier vide, aucun chemin externe, clés `t-str`, langue).
4. **Héritage sur `#domain`.**
   - `domain` sans titre ; défauts hérités, `norm` comme couche, `units:` converti en `set-unit` (deux unités de même dimension paniquent), `preset:` lu dans `data/presets.json`.
   - Défaut de Woodwork = rendu des captures (D-12), et la valeur de Q-006.
   - Réalise : REQ-005 à REQ-008, ARCH-003, ARCH-007. Tests : `test_domain_defaults.py`, `test_units.py`, `test_preset.py`, `test_eq_render.py` (`A = b · h = 140 mm · 200 mm = 28 000 mm²`).
5. **`data/`.**
   - Copier les tables utiles à la phase 1 (SIA 265 Tab. 1, 4, 8, 9, 2.2.6, ainsi que celles de flambage et de déversement que lit `member_check_stability.py`) sous des noms qui disent le numéro de table.
   - `_note` nettoyées, publication selon Q-005, `norms.json`, `presets.json` et `my-materials/` avec un exemple.
   - Réalise : REQ-010, CON-007. Tests : `test_data.py` (égalité des valeurs avec la copie de Woodcore, prise une fois par `tools/import_norms.py` qui garde la correspondance des noms ; `_source` présent ; aucun chemin Woodcore).
6. **`#material`.**
   - Lecture de la norme, puis de `my-materials/` ; η<sub>w</sub>, η<sub>t</sub> ; valeurs publiées avec leur provenance ; écrasement par valeur ; `as:` ; `print:`.
   - Réalise : REQ-009. Tests : `test_material.py` (GL24h 12.8 et 10.24 N/mm², classe inconnue, `as:`).
7. **Générateur.**
   - `tools/generate.py`, `source/labels.json` avec les chemins traduits ; une feuille par ligne d'argument (UI-002).
   - Réalise : REQ-003, REQ-004, ARCH-004, UI-002. Tests : `test_generate.py` (octet par octet, clé manquante nommée, trois arborescences égales en nombre, un argument nommé par ligne).
8. **Les 18 vérifications de la phase 1**, en quatre commits : traction et compression, flexion, cisaillement, stabilité.
   - Pour chacune : la source standard et la détaillée (lignes de calcul communes incluses), une figure SVG, et l'entrée dans `examples/all.typ`.
   - Formules et articles tirés de `member_check.py` et `unfold._generate_member` ; un article que Woodcore ne cite pas est lu dans le PDF (CON-003).
   - Réalise : REQ-002, REQ-011, UI-001. Tests : `test_sheets.py` (chaque feuille compile, standard = détaillée pour `eta`, valeurs égales aux cas de `tests/test_member_check.py` l. 356, 461, 495, 798 et 835, recopiés avec leur source).
9. **Documentation et clôture.**
   - Woodwork : `README.md` en fr, de et en (copier `woodwork/` et une feuille, les arguments de `#domain`, `#material`, `data/`), `docs/` du mainteneur, `CHANGELOG.md` 0.1.0.
   - Woodcore : une entrée dans `docs/decisions.md` (la séparation, ce qu'elle coûte) et dans `CHANGELOG.md`.
   - Vérification indépendante (`verify-requirements`), puis `finish`.

### Ajout au plan (T30, 04.11.2026)

7b. **Formes, pages de titre, documents** (après le générateur, qui les génère comme les feuilles) : `woodwork/forms/{neutral,compact,bfh}.typ` tirés de `Woodcore/templates/forms/*/template.typ` (une fonction par fichier, le logo dans `woodwork/forms/`) ; `source/templates/titre-bfh.typ`, `titre-neutral.typ` tirés des `title.typ`, les champs en arguments écrits dans le fichier ; `source/templates/{cu,bp,rs}/` tirés de `Woodcore/templates/documents/*/standard/`, les boucles sur l'export remplacées par des emplacements commentés. Réalise REQ-015 à REQ-017. Tests : `test_templates.py`.

## 15. Vérification

_(à écrire par `verify-requirements`)_

## 16. Journal d'avancement

| Date | Statut | Fait / reste |
|---|---|---|
| 2026-11-04 | draft | spécification extraite des messages du 04.11.2026 et de l'artefact v6 ; T28–T29 ajoutés (dépôt GitHub, skills, poussée) ; Q-002 répondue ; Q-001, Q-003, Q-004 ouvertes |
| 2026-11-04 | specified | Q-001 (dossier dans le projet), Q-003 (pas de titre, lignes seulement), Q-004 (notre skill + tinymist) répondues ; D-10, D-11 |
| 2026-11-04 | reviewed | revue d'architecture : APPROUVER AVEC RÉSERVES (§13) ; ARCH-005 à 007, D-12 ajoutés ; plan en 9 étapes (§14) ; Q-005 et Q-006 posées avec l'approbation |
| 2026-11-04 | approved | approuvé par l'ingénieur ; Q-005 = tables telles que Woodcore (D-13), Q-006 = `"right"` (D-14). Reste : étapes 1 à 9 du plan |
| 2026-11-04 | implementation | étape 1 (af5a4e6, poussé) : dépôt `../Woodwork` créé (`main`, `origin` = When-I-hit-the-wall/Woodwork), `.gitattributes` LF, `.gitignore`, `README.md`, `LICENSE` GPL-3 (repris de Woodcore, dont le moteur dérive), spec déplacée ici. REQ-012 en partie. Reste : étapes 2 à 9 |
| 2026-11-04 | implementation | étape 2 : `CLAUDE.md`, `docs/` (README, principles, layout, conventions, typst/commands et engine en ébauche, decisions, TEMPLATE), `CHANGELOG.md` ; skills `requirements`, `big-feature`, `small-feature`, `architecture-review`, `implementation`, `verify-requirements`, `finish`, `issue`, `typst-sheet`, et `typst-writing-document` de Tinymist (Apache-2.0, `NOTICE.md`) ; 4 agents ; `tests/run_tests.py`, `conftest.py`, `test_tooling.py` (4 passés). REQ-013, REQ-014 en partie (le skill est utilisé à l'étape 8). Reste : étapes 3 à 9 |
| 2026-11-04 | implementation | étape 3 : moteur tiré du `lib/` de Woodcore (1bf6093f, 28.10.2026) dans `woodwork/lib/` : `formula`, `calc-engine-core`, `calc-engine-display`, `i18n`, `number`, `subscript`, `bibliography` + JSON ; `calc-engine.typ` réécrit (ré-exports + constantes de `#verify`) ; coupés : lectures de `../data/` d'un projet Woodcore, `find-calculation`, `find`, `sync`, `uniform-level`, `show-masked`, `domain-heading`, `from-level`, `load-domain-state`, `bib-of-data`, le nom de la pièce jointe ; langue = `text.lang` ; `strings.json` réduit à 16 clés ; `woodwork.typ` n'exporte que les commandes. 4 160 lignes de Typst. Fait aussi, en avance sur l'étape 4 : `#domain` réécrit (sans titre, défauts hérités, `norm`, `units:`, `preset:`), `"right"` (D-14), rendu par défaut des captures (D-12), indices `N_(t,d)` (D-15, décision ajoutée), norme du domaine citée seulement avec un article (D-16). Tests : `test_engine_standalone.py` (6). ARCH-002, ARCH-005, ARCH-006. Reste : tests de l'étape 4, puis 5 à 9 ; les blocs `///` du moteur citent encore des exemples de Woodcore (`domain: ("snow-load", "SL")`), à nettoyer à l'étape 9 |
| 2026-11-04 | implementation | étape 4 : `units:` vaut aussi pour les valeurs écrites (`to-domain-unit` : 12.4 kNm → 12 400 Nm), la ligne garde `unit:` ; `woodwork/data/presets.json` avec `report` ; `docs/typst/commands.md` écrit pour `#domain`, `#var`, `#eq`, `#verify`, les clés. Tests : `test_domain_defaults.py` (8), `test_units.py` (3), `test_preset.py` (4) — 25 passés en tout. REQ-005 à REQ-008, ARCH-003, ARCH-007. Reste : étapes 5 à 9 |
| 2026-11-04 | implementation | étape 5 : `tools/import_norms.py` copie textuellement 57 tables de Woodcore (SIA 265:2021, SIA 265/1:2018, SIA 260:2013, SN EN 14592:2022, `norms.json`) dans `woodwork/data/<norme>/`, sans les extraits ; seules les `_note` qui citent du code ou des docs de Woodcore perdent la phrase ou la parenthèse ; `imported.json` garde l'origine et le commit. Écart au critère de REQ-010 : les noms gardent le titre allemand de Woodcore (`tab09-brettschichtholz.json`), le numéro de table y est, le nom anglais de l'exemple (`table-09-glulam.json`) n'est pas repris pour ne pas traduire 57 noms à la main. SIA 261, 263 et SZS C5 viendront avec les phases 2 et 3. Tests : `test_data.py` (5). REQ-010, CON-007. Reste : étapes 6 à 9 |
| 2026-11-04 | implementation | étape 6 : `woodwork/lib/material.typ`, `#material` (Tab. 8 et 9, η_w Tab. 4, η_t 2.2.6, `my-materials/materials.json` livré vide, valeur de l'ingénieur, cas de f_c,90,d, `print:`), règle de Woodcore `Strengths._grade` ; écart à la spec : `as:` est un mot réservé de Typst, l'argument s'appelle `suffix:` (à confirmer par l'ingénieur) ; une ligne sans libellé garde la colonne des libellés vide. Le refus de C16 en traction (Tab. 8 note 2) n'est pas encore porté. Tests : `test_material.py` (11) — 41 passés. REQ-009. Reste : étapes 7 à 9 |
| 2026-11-04 | implementation | étape 7 : `tools/generate.py` (`sheets/` et `templates/` en fr/de/en depuis `source/`, `--check`, clés `{mot-mot}` à deux mots au moins, `// @insert` des lignes partagées depuis `source/parts/`, noms traduits par `paths`) ; première feuille `tension-parallel` standard et détaillée, termes lus dans SIA 265:2021 FR et DE p. 31 ; figure dans `woodwork/figures/` (copiée avec le moteur). Ajout T30 (templates de forme et de fond) : REQ-015 à REQ-017, D-17, étape 7b. Tests : `test_generate.py` (7) — 48 passés. REQ-003, REQ-004, ARCH-004, UI-002. Reste : 7b, 8, 9 |
| 2026-11-04 | implementation | étape 7b : formes `woodwork/forms/{neutral,compact,bfh}.typ` tirées de Woodcore, une fonction par fichier (`#show: bfh`), `lang: none` par défaut (la langue du document), logo BFH ; pages de titre `titre-bfh`, `titre-neutre` (de : `titel-*`, en : `title-*`) en templates de fond générés, champs en tête de fichier, mots repris du `title.typ` de Woodcore ; les trois documents de Woodcore en squelettes (`tools/import_documents.py`, 519 fichiers, une source par langue `nom.<lang>.typ` que le générateur envoie à sa langue seule) : imports, balises et commentaires de Woodcore retirés, boucles sur l'export, `#sync`, valeurs de l'export, annexes et journal remplacés par un commentaire « À COMPLÉTER » ; `#show-norm-list` repris de `lib/document.typ`. Écarts : nom français « titre-neutre » (l'ingénieur a écrit « titre-neutral ») ; la page de titre ne choisit pas le document (champ `document` à remplir). Tests : `test_templates.py` (6). REQ-015 à REQ-017. Reste : 8, 9 |
| 2026-11-04 | implementation | étape 8 commencée : il manquait au moteur la lecture d'une constante d'article et les formules par morceaux ; questions Q-011, Q-012 posées et répondues ; `#var(…, from:, path:)` (`data-value`, unité tirée des `units` de la table, citation de l'objet le plus proche qui a un `norm_ref`) et `#eq(…, cases:)` (`check-cases`, `pick-case`, la branche retenue imprimée seule) ; tests `test_from_and_cases.py` (6). Reste : les 17 feuilles, 9 |
| 2026-11-04 | implementation | étape 8 : les 17 vérifications restantes, sources dans `source/sheets/` et `source/parts/` (un `-action` et un `-check` par vérification, partagés par la feuille standard et la détaillée), 9 figures SVG, ~80 libellés en fr/de/en ; titres des feuilles = intitulés de SIA 265:2021 FR et DE (4.2.1 à 4.2.9) ; formules et articles de `member_check.py` et `member_check_stability.py` de Woodcore ; constantes lues par `from:` (k_h 3.4.2.3, β_c, k, λ_rel 4.2.8, facteur de (41), k_a et longueur minimale 4.2.6, k_t,90 4.2.7) ; k_c (30), k_m (39), k_h (5) et k_t,90 par `cases:`. Le moteur lit maintenant un exposant variable (k_h = (h_ref/h)^0.1, l'exposant lu dans la table). `#material` publie f_c,0,k, η_w,E et E_0,05 (Anhang B, Tab. 47 et 48). Exemples ajustés pour que chaque feuille parte d'un cas vérifié (η de 0.17 à 0.87). (37) sur l'axe z sans flexion autour de z = (29), comme Woodcore. Tests : `test_sheets.py` (3) : 108 feuilles compilent, standard = détaillée, les 18 η égaux à `member_check.compute` de Woodcore à 1e-9. REQ-002, REQ-011, UI-001. Reste : étape 9 (README fr/de/en, nettoyage des `///` du moteur, decisions/CHANGELOG de Woodcore, vérification indépendante) |
