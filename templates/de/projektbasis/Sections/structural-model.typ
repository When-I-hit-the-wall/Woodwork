#import "/woodwork/woodwork.typ": *

== Tragwerks- und Berechnungsmodell

#figure(
  table(
    columns: (auto, 1fr),
    align: (left, left),
    table.hline(stroke: 1pt),
    [Software und Berechnungsmodell], [[Berechnungsprogramm, Modelltyp (Stab-, Finite-Elemente-Modell), Detaillierungsgrad.]],
    [Statisches System und Lagerung], [[…]],
    [Angenommene Steifigkeiten], [[Steifigkeit von Baugrund, Verbindungen (Verschiebungsmoduln), Verbundbauteilen, Rissbildung.]],
    [Effekte 2. Ordnung], [[…]],
    [Interaktion Baugrund-Tragwerk], [[…]],
    [Holzfeuchte und Lasteinwirkungsdauer (Holz)], [[…]],
    [Plausibilitätskontrolle], [[Die Ergebnisse der Tragwerksanalyse werden auf ihre Plausibilität geprüft (SIA 260, Ziffer 3.1.4).]],
    table.hline(stroke: 1pt),
  ),
  caption: [Modellannahmen],
)
