# Woodwork

[Français](#français) · [Deutsch](#deutsch) · [English](#english)

## Français

Feuilles de calcul pour les structures en bois (SIA 260, 261, 265), écrites en Typst, à copier dans un projet et à adapter. Chaque vérification existe en version standard et détaillée, en français, allemand et anglais. Seul Typst (0.15) est nécessaire.

**Utiliser une feuille**

1. Copiez le dossier `woodwork/` à la racine de votre projet Typst : il contient le moteur, les tables de normes (`woodwork/data/`) et les formes.
2. Copiez une feuille de `sheets/fr/`, par exemple `sections-bois/traction/traction-axe.typ`, à côté de votre document, et incluez-la : `#include "traction-axe.typ"`.
3. Changez les valeurs : efforts, dimensions, classe de résistance. Les valeurs de la norme sont lues dans `woodwork/data/`, jamais tapées.

```typ
#import "/woodwork/woodwork.typ": *

= Traction parallèle au fil (SIA 265)

#domain("tension-parallel",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_t_d", 180, "kN",
	label: "Effort de traction")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 200, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Aire de la section")
  #eq("sigma_t_0_d", `N_t_d / A`,
	label: "Contrainte de traction",
	norm-section: "4.2.1.1")
  #verify(`sigma_t_0_d <= f_t_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification traction",
	norm-section: "4.2.1.1 (6)")
]
```

Ce que `#domain` reçoit vaut pour chacune de ses lignes ; une ligne peut l'écraser pour elle seule.

**Formes et fonds** — une forme règle l'apparence : `#import "/woodwork/forms/bfh.typ": bfh` puis `#show: bfh` (aussi `neutral` et `compact`). Les pages de titre (`templates/fr/titre-bfh.typ`, `titre-neutre.typ`) et les documents (convention d'utilisation, base de projet, rapport de statique) sont des fonds à copier et remplir.

**Contenu** — 18 vérifications de SIA 265 4.2 : traction, compression, flexion, effort tranchant, flambage, déversement. Les commandes sont décrites dans [`docs/typst/commands.md`](docs/typst/commands.md).

## Deutsch

Rechenblätter für Holztragwerke (SIA 260, 261, 265), in Typst geschrieben, zum Kopieren in ein Projekt und Anpassen. Jeder Nachweis existiert in einer Standard- und einer ausführlichen Fassung, auf Französisch, Deutsch und Englisch. Nur Typst (0.15) wird benötigt.

**Ein Blatt verwenden**

1. Kopieren Sie den Ordner `woodwork/` in das Wurzelverzeichnis Ihres Typst-Projekts: er enthält den Rechenkern, die Normtabellen (`woodwork/data/`) und die Formen.
2. Kopieren Sie ein Blatt aus `sheets/de/`, zum Beispiel `holzquerschnitte/zug/zug-parallel.typ`, neben Ihr Dokument und binden Sie es ein: `#include "zug-parallel.typ"`.
3. Ändern Sie die Werte: Kräfte, Abmessungen, Festigkeitsklasse. Die Werte der Norm werden aus `woodwork/data/` gelesen, nie getippt.

Was `#domain` erhält, gilt für jede seiner Zeilen; eine Zeile kann es für sich allein überschreiben. Eine Form bestimmt das Aussehen (`#show: bfh`, `neutral`, `compact`); Titelseiten und Dokumente (Nutzungsvereinbarung, Projektbasis, statischer Bericht) liegen als Vorlagen in `templates/de/`. Die Befehle sind in [`docs/typst/commands.md`](docs/typst/commands.md) beschrieben.

## English

Calculation sheets for timber structures (SIA 260, 261, 265), written in Typst, to copy into a project and adapt. Every check exists in a standard and a detailed version, in French, German and English. Only Typst (0.15) is needed.

**Using a sheet**

1. Copy the folder `woodwork/` to the root of your Typst project: it holds the engine, the norm tables (`woodwork/data/`) and the forms.
2. Copy a sheet of `sheets/en/`, for instance `timber-sections/tension/tension-parallel.typ`, beside your document and include it: `#include "tension-parallel.typ"`.
3. Change the values: forces, dimensions, strength class. The norm's values are read from `woodwork/data/`, never typed.

What `#domain` is given holds for each of its lines; a line may override it for itself. A form sets the look (`#show: bfh`, `neutral`, `compact`); title pages and documents (service criteria agreement, basis of design, statical report) are content templates in `templates/en/`. The commands are described in [`docs/typst/commands.md`](docs/typst/commands.md).

---

Woodwork's engine was taken from Woodcore on 4 November 2026 and lives on its own since. Licence: GPL-3.0 (see `LICENSE`). The tables of `woodwork/data/` transcribe values of SIA norms with their source; the norms themselves are the SIA's.
