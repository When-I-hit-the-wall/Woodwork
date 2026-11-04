// Gerüst aus der Vorlage von Woodcore: Ergänzen Sie den Text in eckigen Klammern, fügen Sie Ihre Rechenblätter dort ein, wo ein Kommentar es verlangt. Legen Sie die Titelseite (titel-bfh.typ) in den Ordner über diesem und den Ordner woodwork/ in das Wurzelverzeichnis des Projekts.
#import "/woodwork/woodwork.typ": *
#import "/woodwork/forms/bfh.typ": bfh
#set text(lang: "de")
#show: bfh

#include "../titel-bfh.typ"

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
