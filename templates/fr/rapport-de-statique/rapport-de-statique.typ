// Squelette tiré du modèle de Woodcore : complétez le texte entre crochets, collez vos feuilles de calcul là où un commentaire le demande. Placez la page de titre (titre-bfh.typ) dans le dossier au-dessus de celui-ci, et le dossier woodwork/ à la racine du projet.
#import "/woodwork/woodwork.typ": *
#import "/woodwork/forms/bfh.typ": bfh
#set text(lang: "fr")
#show: bfh

#include "../titre-bfh.typ"

#outline()
#pagebreak()

#include "Sections/001-einleitung.typ"
#include "Sections/002-grundlagen.typ"
#include "Sections/003-baustoffe.typ"
#include "Sections/004-einwirkungen.typ"
#include "Sections/005-tragwerksanalyse.typ"
#include "Sections/006-nachweise.typ"
#include "Sections/007-literatur.typ"
#include "Sections/008-journal.typ"
// #include "Sections/009-anhang.typ"
