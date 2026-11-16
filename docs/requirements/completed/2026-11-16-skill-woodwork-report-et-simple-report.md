---
id: 2026-11-16-skill-woodwork-report-et-simple-report
titre: Skill utilisateur « woodwork-report » et gabarit de fond « Simple Report »
status: completed
cree: 2026-11-16
mis_a_jour: 2026-11-16
source: message écrit (deux messages de l'ingénieur, 2026-11-16)
docs: [docs/typst/commands.md, docs/architecture/layout.md, docs/architecture/principles.md, docs/decisions.md]
---

# Skill « woodwork-report » et gabarit « Simple Report » — Spécification

## 1. Objectif

Donner à Claude un skill qui lui apprend à écrire, dans n'importe quel projet Typst, un rapport de calcul avec le moteur de Woodwork : installer `woodwork/`, choisir et adapter des feuilles, écrire des calculs libres, compiler et corriger. En même temps, ajouter un gabarit de fond « Simple Report » : un rapport court, sans page de titre séparée, sans table des matières ni bibliographie, en deux sections.

## 2. Source

> **T1** — « peux-tu faire de woodwork un skills utilisable par claude ? »
>
> **T2** — « L'idée est que Claude sache comment créer des documents typst en utilisant le moteur de woodwork. »
>
> **T3** — « Je choisis l'option 3. » (option 3 de la proposition : copie du skill dans `~/.claude/skills/`)
>
> **T4** — « 1: oui » (question 1 : mettre le moteur dans le skill, `assets/woodwork/`)
>
> **T5** — « 2: autoriiser des calculs libers » (question 2 : jusqu'où va le skill)
>
> **T6** — « 3.: uniquement woodwork » (question 3 : le lien avec le serveur MCP `woodcore`)
>
> **T7** — « toute la doc doit être en anglais. »
>
> **T8** — « Créé en même temps un nouveau template de fond pour le rapport de statique qui s'appelle "Simple Report". »
>
> **T9** — « Il n'y a pas une page de titre séparée, après le titre suit immédiatement le titre d'une section "Section 1", puis les calculs, puis les annexes. »
>
> **T10** — « Il y a donc deux sections (Section 1 et Annexes), pas de bibliographie, pas de table des matières »

## 3. Exigences fonctionnelles

### REQ-001 — Un skill utilisateur `woodwork-report`
- **Exigence** : Woodwork doit fournir un skill Claude `woodwork-report` (un dossier avec `SKILL.md`) qui apprend à Claude à créer un document Typst avec le moteur de Woodwork dans un projet quelconque, hors de ce dépôt.
- **Source** : T1, T2
- **Priorité** : doit
- **Critère d'acceptation** : le dossier du skill existe, son `SKILL.md` a un frontmatter `name: woodwork-report` et une `description` qui dit quand l'utiliser (rapport de calcul bois, vérification SIA 265, Typst) ; la méthode couvre : installer `woodwork/`, partir d'un gabarit, insérer et adapter une feuille, écrire un calcul libre, compiler, lire une panic.

### REQ-002 — Installation par copie dans `~/.claude/skills/`
- **Exigence** : le skill doit s'installer par copie de son dossier dans `~/.claude/skills/woodwork-report/` ; Woodwork doit donner le moyen de faire cette copie et de la refaire après une mise à jour.
- **Source** : T3
- **Priorité** : doit
- **Critère d'acceptation** : une commande documentée (voir Q-001) écrit `~/.claude/skills/woodwork-report/` ; refaite, elle remplace la copie précédente ; le skill installé porte la version de Woodwork dont il vient.

### REQ-003 — Le moteur dans le skill
- **Exigence** : le skill doit contenir le moteur complet (`assets/woodwork/` : `woodwork.typ`, `lib/`, `data/`, `forms/`, `figures/`), de sorte que Claude puisse installer Woodwork dans un projet vide sans le dépôt.
- **Source** : T4
- **Priorité** : doit
- **Critère d'acceptation** : `assets/woodwork/` est identique, fichier par fichier, au `woodwork/` du dépôt au moment de l'installation ; un projet vide où l'on copie `assets/woodwork/` compile un exemple du skill avec Typst seul.

### REQ-004 — Les feuilles et les gabarits dans le skill
- **Exigence** : le skill doit permettre de partir des feuilles de `sheets/<lang>/` et des gabarits de `templates/<lang>/`, et donner un catalogue : chaque vérification, son fichier standard et détaillé dans chaque langue, ses variables à changer.
- **Source** : T2 (inféré : « créer des documents » avec le moteur suppose les feuilles et gabarits que Woodwork fournit déjà)
- **Priorité** : doit
- **Critère d'acceptation** : le catalogue liste toutes les feuilles présentes dans `sheets/` et aucune autre ; les feuilles et gabarits sont dans le skill (voir Q-002) ; un test échoue si le catalogue ne correspond plus à `sheets/`.

### REQ-005 — Calculs libres autorisés
- **Exigence** : le skill doit apprendre à écrire un calcul libre avec `#domain`, `#var`, `#eq`, `#verify`, `#unit` et `#material`, quand aucune feuille n'existe pour la vérification demandée ; toute valeur de norme reste lue dans `woodwork/data/` (`#material`, `from:`/`path:`), jamais tapée de mémoire, et toute clause citée est une clause que l'utilisateur ou une feuille de Woodwork fournit.
- **Source** : T5
- **Priorité** : doit
- **Critère d'acceptation** : le `SKILL.md` contient la règle et un exemple de calcul libre qui compile (test) ; il dit quoi faire quand une valeur de norme n'est pas dans `data/` (le demander à l'utilisateur, ne pas l'inventer).

### REQ-006 — Uniquement Woodwork
- **Exigence** : le skill ne doit utiliser que Woodwork : pas les outils du serveur MCP `woodcore`, pas les fichiers de Woodcore.
- **Source** : T6
- **Priorité** : doit
- **Critère d'acceptation** : le `SKILL.md` dit explicitement de ne pas utiliser les outils `mcp__woodcore__*` pour ce travail ; aucun fichier du skill ne nomme un chemin de Woodcore.

### REQ-007 — Gabarit de fond « Simple Report »
- **Exigence** : Woodwork doit fournir un nouveau gabarit de fond « Simple Report », à côté de `statical-report`, dans `source/templates/` et généré dans les trois arbres de `templates/`.
- **Source** : T8
- **Priorité** : doit
- **Critère d'acceptation** : `source/templates/simple-report/` existe ; `python tools/generate.py` écrit le gabarit dans `templates/fr|de|en/` sous son nom traduit (Q-004) ; le gabarit compile dans les trois langues (`tests/test_templates.py`).

### REQ-008 — Argument `chapter-break` de la forme `bfh`
- **Exigence** : la forme `bfh` doit accepter `chapter-break:` (booléen, `true` par défaut, comportement actuel) ; avec `false`, un titre de niveau 1 ne commence plus une nouvelle page ; le Simple Report écrit `#show: bfh.with(chapter-break: false)`.
- **Source** : Q-005 (réponse de l'ingénieur), ARCH-RISK-006
- **Priorité** : doit
- **Critère d'acceptation** : sans l'argument, deux chapitres sont sur deux pages (inchangé) ; avec `chapter-break: false`, ils sont sur la même page ; une valeur qui n'est pas un booléen arrête la compilation en la nommant ; section des formes de `docs/typst/commands.md` mise à jour.

## 4. Exigences d'interface (feuilles, rendu)

### UI-001 — Pas de page de titre séparée, le titre puis « Section 1 »
- **Exigence** : le document commence sur la première page par le titre du rapport, suivi immédiatement du titre de section « Section » (imprimé « 1 Section », Q-003), puis des calculs ; aucune page de titre séparée, aucun saut de page entre le titre et la section.
- **Source** : T9
- **Langues** : fr / de / en (Q-004)
- **Critère d'acceptation** : dans le PDF compilé, le bloc de titre et « 1 Section » sont sur la page 1, dans cet ordre, avant le premier calcul.

### UI-002 — Deux sections seulement : « Section » et « Annexes »
- **Exigence** : le gabarit a exactement deux sections de premier niveau, numérotées : « 1 Section » (les calculs) puis « 2 Annexes ».
- **Source** : T9, T10
- **Langues** : fr / de / en
- **Critère d'acceptation** : le PDF contient deux titres de niveau 1, « 1 Section » puis « 2 Annexes » (de : « 1 Abschnitt », « 2 Anhang » ; en : « 1 Section », « 2 Appendices »), dans cet ordre.

### UI-003 — Pas de bibliographie, pas de table des matières
- **Exigence** : le gabarit n'imprime ni table des matières (`#outline`) ni bibliographie (`#show-bibliography`).
- **Source** : T10
- **Langues** : fr / de / en
- **Critère d'acceptation** : les fichiers générés ne contiennent ni `outline(` ni `show-bibliography` ; le PDF ne contient ni « Table des matières » ni « Bibliographie » (ni leurs traductions).

## 5. Exigences d'architecture

### ARCH-001 — Une seule source pour le skill
- **Exigence** : le skill est écrit une fois dans le dépôt ; ce qui recopie la documentation ou le moteur (la référence des commandes, le catalogue des feuilles, `assets/woodwork/`) est produit par un outil, jamais copié à la main, et un test échoue quand la copie ne correspond plus à sa source.
- **Source** : principe « One source of truth » (`docs/architecture/principles.md`), inféré de T3 (une copie dans `~/.claude/skills/` vieillit sans le dire)
- **Critère d'acceptation** : le dossier source du skill ne contient pas de copie à la main de `docs/typst/commands.md` ni de `woodwork/` ; le dépôt ne garde aucune copie (D-f : elles sont faites à l'installation), et `--check` échoue sur une copie installée dont `references/commands.md` diffère de `docs/typst/commands.md` (test). _(Critère précisé après la vérification, 2026-11-16 : la version d'origine supposait une copie versionnée, que le plan approuvé ne garde pas.)_

### ARCH-002 — Le moteur reste inchangé
- **Exigence** : ni le skill ni le gabarit ne changent `woodwork/lib/` ; le gabarit importe seulement `"/woodwork/woodwork.typ"` et une forme de `woodwork/forms/`.
- **Source** : principe « The engine stays inside `woodwork/` », inféré
- **Critère d'acceptation** : le diff ne touche pas `woodwork/lib/` ni `woodwork/data/`.

### ARCH-003 — Typst seul pour l'utilisateur
- **Exigence** : ce que Claude fait avec le skill dans le projet de l'utilisateur ne demande que Typst 0.15.1 (et la copie de fichiers) ; Python reste l'outil du mainteneur (l'installation du skill).
- **Source** : principe « Typst alone to use a sheet », inféré
- **Critère d'acceptation** : la méthode du `SKILL.md` ne demande aucune commande Python dans le projet de l'utilisateur.

## 6. Contraintes

- **CON-001** — Toute la documentation du skill est en anglais (le `SKILL.md`, ses références, ses commentaires). Source : T7, et `CLAUDE.md` (code, docs et commentaires en anglais).
- **CON-002** — Le dépôt est public : le skill ne contient aucun PDF de norme ni texte de norme au-delà des tables de `woodwork/data/` (D-13). Source : `CLAUDE.md`, inféré.
- **CON-003** — `templates/` est généré : le gabarit s'écrit dans `source/templates/` et ses noms dans `source/labels.json`, puis `python tools/generate.py`. Source : `CLAUDE.md`, inféré.
- **CON-004** — Fichiers LF, UTF-8 ; un paragraphe par ligne. Source : `CLAUDE.md`, inféré.
- **CON-005** — Typst 0.15.1. Source : `docs/architecture/principles.md`, inféré.

## 7. Décisions prises

- **D-a** — Distribution par copie dans `~/.claude/skills/` (option 3), plutôt qu'un plugin ou un zip pour claude.ai. Prix accepté : la copie installée ne se met pas à jour seule ; il faut refaire l'installation après une nouvelle version de Woodwork (REQ-002). Source : T3.
- **D-b** — Le skill contient le moteur (`assets/woodwork/`). Prix : le skill pèse le poids de `woodwork/` (données comprises). Source : T4.
- **D-c** — Le skill autorise les calculs libres, avec les valeurs de norme toujours lues dans `data/`. Source : T5.
- **D-d** — Uniquement Woodwork, pas le MCP `woodcore`. Source : T6.
- **D-f** — Source du skill dans le dépôt (`skill/woodwork-report/`), installée par `python tools/install_skill.py` qui assemble références générées et copies du moteur, des feuilles et des gabarits. Source : Q-001.
- **D-g** — Le skill emporte `woodwork/`, `sheets/` et `templates/` des trois langues. Source : Q-002.
- **D-h** — Simple Report : un bloc de titre non numéroté (titre, projet, auteur, date) en haut de la page 1, puis `= Section` (« 1 Section ») et `= Annexes` (« 2 Annexes »), mots et dossiers traduits. Source : Q-003, Q-004.
- **D-i** — La forme `bfh` reçoit l'argument `chapter-break` (défaut `true`) ; le Simple Report l'utilise à `false`. Source : Q-005.
- **D-e** — Le skill destiné à l'utilisateur est distinct du skill `typst-sheet` du mainteneur (qui écrit `source/` avec des clés `{label}` et lance le générateur). Source : proposition acceptée par l'ingénieur avec T3–T6.

## 8. Hors périmètre

- Un plugin Claude Code ou une marketplace (options 1 et 2 non retenues, T3).
- Un zip pour claude.ai.
- Les outils du MCP `woodcore` (T6).
- Une nouvelle commande, un nouvel argument ou une nouvelle forme de données du moteur.
- Les classeurs d'actions (`actions/`) dans le skill, sauf réponse contraire à Q-002.

## 9. Idées non retenues comme exigences

- Aucune.

## 10. Questions

### Q-001 — Où vit la source du skill, et comment s'installe-t-il ?
- **Pourquoi elle compte** : l'option 3 met le skill dans `~/.claude/skills/`, hors du dépôt ; s'il n'y vit que là, il n'est ni versionné ni testé, et vieillit sans le dire (ARCH-001).
- **Options** : A (recommandée) — la source dans le dépôt, `skill/woodwork-report/` (`SKILL.md` écrit à la main) ; `python tools/install_skill.py` assemble le skill (références générées, `assets/` copiés depuis `woodwork/`, `sheets/`, `templates/`) et l'écrit dans `~/.claude/skills/woodwork-report/` ; un test vérifie l'assemblage dans un dossier temporaire. B — le skill écrit directement dans `~/.claude/skills/`, sans source dans le dépôt.
- **Réponse** : A — source dans le dépôt et `tools/install_skill.py`. L'ingénieur, 2026-11-16.

### Q-002 — Qu'est-ce que le skill emporte en plus du moteur ?
- **Pourquoi elle compte** : sans les feuilles, Claude ne peut que faire des calculs libres ; avec elles, il part de vérifications déjà écrites et testées.
- **Options** : A (recommandée) — le moteur, les feuilles des trois langues (`sheets/`) et les gabarits (`templates/`). B — le moteur et les feuilles d'une seule langue, choisie à l'installation. C — le moteur seul.
- **Réponse** : A — le moteur, les feuilles et les gabarits des trois langues. L'ingénieur, 2026-11-16.

### Q-003 — Le titre du « Simple Report » : quoi et comment ?
- **Pourquoi elle compte** : les formes numérotent les titres (`1.1`) ; un titre écrit `= …` deviendrait « 1 Titre » et « Section 1 » deviendrait « 2 Section 1 ».
- **Options** : A (recommandée) — un bloc de titre non numéroté en haut de la page 1 (titre du document en gras, projet, auteur, date, quatre champs écrits en haut du fichier), puis `= Section 1` imprimé « 1 Section 1 » et `= Annexes` « 2 Annexes ». B — même bloc, mais les sections sans numéro (« Section 1 », « Annexes »). C — le titre seul, une ligne en gras, sans projet ni auteur ni date.
- **Réponse** : A, avec un changement : la section s'appelle « Section » et non « Section 1 », imprimée « 1 Section » ; puis « 2 Annexes ». L'ingénieur : « première option, mais renomme "1 Section 1" en "1 Section" », 2026-11-16.

### Q-004 — Le nom et les mots du gabarit dans les trois langues
- **Pourquoi elle compte** : chaque gabarit existe en fr, de et en, avec un nom de dossier traduit.
- **Options** : A (recommandée) — dossier `rapport-simple` / `einfacher-bericht` / `simple-report` ; sections « Section 1 » / « Abschnitt 1 » / « Section 1 » et « Annexes » / « Anhang » / « Appendices ». B — le nom « Simple Report » et les mots « Section 1 » / « Annexes » partout, sans traduction.
- **Réponse** : A — traduits : dossiers `rapport-simple` / `einfacher-bericht` / `simple-report` ; « Section » / « Abschnitt » / « Section » ; « Annexes » / « Anhang » / « Appendices ». L'ingénieur, 2026-11-16.

### Q-005 — Quelle forme par défaut ?
- **Pourquoi elle compte** : le rapport de statique utilise la forme `bfh` ; un rapport simple peut vouloir une forme sobre.
- **Options** : A (recommandée) — `bfh`, comme le rapport de statique, la ligne d'import étant la seule à changer pour `neutral` ou `compact`. B — `neutral`. C — `compact`.
- **Réponse** : la forme `bfh`, avec un nouvel argument qui supprime le saut de page avant un titre de niveau 1 (`bfh.with(chapter-break: false)`, REQ-008). L'ingénieur : « bfh + nouvel argument », 2026-11-16.

### Q-006 — Le skill part-il du « Simple Report » par défaut ?
- **Pourquoi elle compte** : quand l'utilisateur demande « un rapport » sans préciser, Claude doit choisir un squelette.
- **Options** : A (recommandée) — oui, le « Simple Report » par défaut, le rapport de statique complet quand l'utilisateur le demande. B — toujours demander.
- **Réponse** : A — le Simple Report par défaut, approuvé avec la spec, 2026-11-16.

## 11. Critères d'acceptation

- [x] REQ-001 — `SKILL.md` avec `name: woodwork-report`, description, méthode complète.
- [x] REQ-002 — une commande documentée installe et réinstalle le skill dans `~/.claude/skills/woodwork-report/`, version de Woodwork incluse.
- [x] REQ-003 — `assets/woodwork/` identique à `woodwork/` ; un projet vide compile l'exemple du skill avec Typst seul.
- [x] REQ-004 — le catalogue liste exactement les feuilles de `sheets/` ; test.
- [x] REQ-005 — règle et exemple de calcul libre qui compile ; conduite quand une valeur manque dans `data/`.
- [x] REQ-006 — `SKILL.md` exclut `mcp__woodcore__*` ; aucun chemin de Woodcore.
- [x] REQ-007 — `source/templates/simple-report/`, généré dans trois langues, compile.
- [x] REQ-008 — `bfh.with(chapter-break: false)` : pas de saut de page avant un titre de niveau 1 ; défaut inchangé ; refus d'un non-booléen.
- [x] UI-001 — bloc de titre (titre, projet, auteur, date) et « 1 Section » sur la page 1, avant le premier calcul.
- [x] UI-002 — deux titres de niveau 1, « 1 Section » puis « 2 Annexes », traduits en de et en.
- [x] UI-003 — ni `outline(` ni `show-bibliography` ; ni table des matières ni bibliographie dans le PDF.
- [x] ARCH-001 — rien de copié à la main ; un test échoue sur une référence périmée.
- [x] ARCH-002 — `woodwork/lib/` et `woodwork/data/` inchangés.
- [x] ARCH-003 — aucune commande Python dans le projet de l'utilisateur.
- [x] Documentation : `docs/architecture/layout.md` (le skill, le gabarit), `docs/README.md` si un fichier s'ajoute, `docs/decisions.md` (D-a à D-e), entrée `CHANGELOG.md`.
- [x] Tests : `tests/test_templates.py` étendu, un test du skill ajouté ; tous passent ; `templates/` régénéré.

## 12. Traçabilité

| Source | Élément | Statut |
|---|---|---|
| T1 | REQ-001 | capturé |
| T2 | REQ-001, REQ-004 | capturé |
| T3 | D-a, REQ-002, Q-001 | capturé ; source du skill → question |
| T4 | D-b, REQ-003, Q-002 | capturé ; contenu en plus → question |
| T5 | D-c, REQ-005 | capturé |
| T6 | D-d, REQ-006 | capturé |
| T7 | CON-001 | capturé |
| T8 | REQ-007, Q-004, Q-005 | capturé ; noms et forme → questions |
| T9 | UI-001, UI-002, Q-003 | capturé ; titre → question |
| T10 | UI-002, UI-003 | capturé |

### Points de la source non résolus

- T3 — où vit la source du skill (Q-001).
- T9 — ce que contient « le titre » et la numérotation des sections (Q-003).

## 13. Revue d'architecture

Revue par `architecture-reviewer`, 2026-11-16. Verdict : **APPROUVER AVEC RÉSERVES**.

**Fichiers concernés** :
- `tools/generate.py` : `plan()` aux lignes 92-125, et `KINDS = ("sheets","templates")` à la ligne 19.
- `source/parts/title-fields.typ` : les champs des pages de titre.
- `source/templates/statical-report/`.
- `woodwork/forms/bfh.typ` : lignes 117 et 127-134.
- `woodwork/woodwork.typ` : ligne 7 (`woodwork-version`).
- `source/labels.json`.
- Les tests `tests/test_templates.py`, `test_generate.py`, `test_tooling.py` et `conftest.py`.
- La documentation : `docs/typst/commands.md` (lignes 89-123), `docs/architecture/layout.md`, `docs/decisions.md` (dernière décision D-22) et `CHANGELOG.md`.

**À réutiliser** :
- `generate.plan()`, importé et non étendu, pour le catalogue des feuilles.
- La partie `title-fields` par `// @insert`. Le gabarit est donc un fichier à clés sans suffixe de langue, et non un `.fr.typ` qui recopierait les champs.
- Le calcul de `day`.
- `conftest.project()` et `compile_typ` pour les tests.

**Risques** :
- **ARCH-RISK-001 (bloquant)** — Une seule source pour le skill.
  - `tools/install_skill.py` expose une fonction pure `assemble() -> {chemin: octets}`.
  - Un test compare le résultat à `woodwork/`, `sheets/`, `templates/` et `docs/typst/commands.md`.
  - `skill/` ne contient aucune copie.
- **ARCH-RISK-002 (bloquant)** — Un test n'écrit jamais dans le vrai `~/.claude`.
  - `--dest` est utilisé par les tests ; seul le défaut est `Path.home()/.claude/skills`.
  - On ne supprime un dossier que s'il s'appelle `woodwork-report`.
  - Les chemins passent par `pathlib`.
- **ARCH-RISK-003 (important)** — La version vient de `woodwork-version` (`woodwork/woodwork.typ`), écrite dans le `SKILL.md` installé, sans second numéro.
- **ARCH-RISK-004 (important)** — `labels.json` reçoit les clés `{heading-section}` et `{heading-appendices}`, ainsi que le chemin `simple-report`.
- **ARCH-RISK-005 (important)** — La forme du gabarit : un dossier `simple-report/simple-report.typ` d'un seul fichier, sans `Sections/`, comme le veut le test des squelettes.
- **ARCH-RISK-006 (important)** — La forme `bfh` ouvre chaque titre de niveau 1 par `pagebreak(weak: true)` (`bfh.typ:128`). Après le bloc de titre, « 1 Section » partirait donc en page 2, ce qui contredit UI-001.
  - `neutral` et `compact` ne sautent pas de page.
  - La question est posée à l'approbation, voir Q-005.
- **ARCH-RISK-007 (mineur)** — `examples/` n'inclut que les feuilles : rien à changer.
- **ARCH-RISK-008 (mineur)** — Documentation à mettre à jour : `commands.md` (« trois documents » devient « quatre »), `layout.md` (`skill/`, `tools/install_skill.py`), `CHANGELOG.md`, décisions D-23 et suivantes.
  - `.claude/skills/` (le mainteneur) et `skill/` (l'utilisateur) restent distincts ; `test_tooling.py` n'est pas étendu.

**Approche** :
1. Le gabarit avec ses clés.
2. `install_skill.py` (`assemble`, `--dest`, `--check`).
3. Le `SKILL.md` écrit à la main.

**Tests** :
- `test_templates.py` : ajouter `simple-report` à `DOCUMENTS`, et un test du rendu (page 1, « 1 Section », « 2 Annexes », ni table des matières ni bibliographie).
- `tests/test_skill.py`, nouveau : il vérifie
  - l'assemblage dans `tests/.tmp` ;
  - le catalogue face à `sheets/`, et `assets/` face à `woodwork/` ;
  - la version ;
  - l'exemple du `SKILL.md` compilé dans un projet vide ;
  - l'exclusion de woodcore ;
  - l'absence de commande Python dans la méthode.

## 14. Plan d'implémentation

0. **Forme `bfh`** : argument `chapter-break` dans `woodwork/forms/bfh.typ`, refus d'un non-booléen. Réalise REQ-008. Prouvé par `tests/test_templates.py`.
1. **Gabarit Simple Report** :
   - `source/labels.json` : clés `heading-section`, `heading-appendices` et le chemin `simple-report`.
   - `source/templates/simple-report/simple-report.typ` : à clés, avec `// @insert title-fields`, un bloc de titre en ligne non numéroté, `= {heading-section}` et `= {heading-appendices}`, sans `outline` ni `show-bibliography`.
   - Lancer `python tools/generate.py`.
   - Réalise REQ-007, UI-001 à UI-003 et ARCH-002. Prouvé par `tests/test_templates.py`.
2. **Source du skill** : `skill/woodwork-report/SKILL.md`, en anglais. Il couvre la méthode, l'installation de `woodwork/`, le catalogue, le calcul libre avec un exemple, les panics, l'exclusion de woodcore et l'absence de Python. Réalise REQ-001, REQ-005, REQ-006, ARCH-003 et CON-001.
3. **`tools/install_skill.py`** :
   - `assemble()` produit :
     - `SKILL.md` avec la version ;
     - `references/commands.md`, copie de `docs/typst/commands.md` ;
     - `references/catalog.md`, généré depuis `generate.plan()` ;
     - `assets/woodwork/`, `assets/sheets/` et `assets/templates/`.
   - Options `--dest` (par défaut `~/.claude/skills`) et `--check` ; remplacement sûr d'une installation existante.
   - Réalise REQ-002 à REQ-004 et ARCH-001.
4. **`tests/test_skill.py`** : prouve ARCH-001, REQ-002 à REQ-006 et ARCH-003.
5. **Documentation** :
   - `docs/architecture/layout.md`, `docs/typst/commands.md` (le quatrième document), `docs/README.md` et `docs/conventions/testing.md` (le nouveau fichier de test).
   - `docs/decisions.md` : D-23 et suivantes, reprises de D-a à D-h.
   - `CHANGELOG.md`.
6. **Installation réelle** : `python tools/install_skill.py`, avec l'accord de l'ingénieur (ce qu'il a demandé, option 3). Puis la suite complète des tests.

## 15. Vérification

Par `requirements-verifier`, 2026-11-16, base `df78141`. Suite complète : 82 réussis, 0 échec. `install_skill.py --check` : à jour.

| Élément | Verdict | Preuve |
|---|---|---|
| REQ-001 | ✅ | `skill/woodwork-report/SKILL.md:1-4`, méthode `:29-40`, panics `:81-83` ; `test_the_skill_is_named_and_says_when_to_use_it` |
| REQ-002 | ✅ | `tools/install_skill.py` `install()`, `--dest`, `--check`, version ; `test_install_writes_only_where_it_is_told_and_replaces_an_earlier_copy`, `test_the_installed_skill_carries_the_engines_version` |
| REQ-003 | ✅ | `COPIES` ; `test_the_assembled_skill_is_the_repository_byte_for_byte`, `test_the_skills_examples_compile_in_an_empty_project_with_its_engine` |
| REQ-004 | ✅ | `catalog()` par `generate.plan()` ; `test_the_catalogue_lists_exactly_the_sheets` (dans les deux sens) |
| REQ-005 | ✅ | `SKILL.md:24-25`, exemple `:44-69` compilé par le test |
| REQ-006 | ✅ | `SKILL.md:22` ; `test_the_skill_keeps_to_woodwork_and_to_typst` |
| REQ-007 | ✅ | `source/templates/simple-report/simple-report.typ`, `labels.json` ; `test_the_twelve_document_skeletons_compile`, `test_generate` |
| REQ-008 | ✅ | `woodwork/forms/bfh.typ:104-105`, `:129` ; `test_the_bfh_form_lets_a_chapter_follow_on_the_same_page` |
| UI-001 | ✅ | `test_the_simple_report_prints_its_title_and_two_chapters_on_its_first_page` (page 1, titre avant « 1 Section », trois langues) |
| UI-002 | ✅ | même test : « 1 Section »/« 2 Annexes », « 1 Abschnitt »/« 2 Anhang », « 1 Section »/« 2 Appendices » |
| UI-003 | ✅ | même test : ni `outline(` ni `show-bibliography`, ni leurs mots dans le PDF |
| ARCH-001 | ⚠️ → ✅ | `skill/` ne contient que `SKILL.md` (test) ; le vérificateur notait qu'aucune copie versionnée ne peut être testée pour dérive. Le plan approuvé (D-f) n'en garde aucune ; la dérive d'une copie installée est prouvée par `test_install_…` (`commands.md` altéré → `--check` rend 1). Critère précisé dans ce sens. |
| ARCH-002 | ✅ | `git diff --stat -- woodwork` : seule `forms/bfh.typ` |
| ARCH-003 | ✅ | « Method » sans Python ; test |
| CON-001 à 005 | ✅ | anglais, pas de PDF de norme, `templates/` généré, fr/de/en |
| Documentation | ✅ | `layout.md`, `commands.md`, `testing.md`, `decisions.md` D-23/D-24, `CHANGELOG.md`, `README.md` (racine) |
| Tests | ✅ | `test_templates.py` étendu, `test_skill.py` ajouté ; 82 réussis |

Remarques mineures corrigées : `commands.md` disait « The three documents » (maintenant « Three of the four »).

## 16. Journal d'avancement

| Date | Statut | Fait / reste |
|---|---|---|
| 2026-11-16 | draft | spécification extraite des deux messages de l'ingénieur ; 6 questions ouvertes |
| 2026-11-16 | specified | Q-001 à Q-004 répondues ; Q-005 et Q-006 proposées à l'approbation |
| 2026-11-16 | reviewed | revue APPROUVER AVEC RÉSERVES ; plan en 6 étapes ; Q-005 liée à ARCH-RISK-006 |
| 2026-11-16 | approved | approuvée par l'ingénieur ; Q-005 → bfh + `chapter-break` (REQ-008), Q-006 → A |
| 2026-11-16 | implementation | étape 0 : `chapter-break` dans `woodwork/forms/bfh.typ` (REQ-008) ; étape 1 : `source/templates/simple-report/simple-report.typ`, clés `heading-section`, `heading-appendices`, `language-code`, `simple-report-*` et chemin `simple-report` dans `labels.json`, `templates/` régénéré (REQ-007, UI-001 à UI-003) |
| 2026-11-16 | implementation | étapes 2 à 4 : `skill/woodwork-report/SKILL.md`, `tools/install_skill.py` (`assemble`, `--dest`, `--check`), `tests/test_skill.py` (REQ-001 à REQ-006, ARCH-001, ARCH-003) |
| 2026-11-16 | testing | étape 5 : `docs/decisions.md` D-23, D-24 ; `commands.md`, `layout.md`, `testing.md`, `README.md`, `CHANGELOG.md` ; reste l'étape 6 (installation réelle) et la suite complète |
| 2026-11-16 | verification | étape 6 : skill installé dans `~/.claude/skills/woodwork-report/` (0.1.0, `--check` à jour) ; suite complète : 82 réussis, 0 échec |
| 2026-11-16 | completed | vérification : 15 ✅, 1 ⚠️ (ARCH-001, critère précisé selon D-f, preuve par `--check`) ; « three documents » corrigé ; `README.md` = celui de la racine |
