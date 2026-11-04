#import "/woodwork/woodwork.typ": *

=== Schnee

Die Schneelast wird nach der Norm SIA 261, Kapitel 5, für den Projektstandort ermittelt. Der charakteristische Wert auf Dächern, bezogen auf die überdeckte Grundrissfläche, beträgt:

$ q_k = mu_i dot C_e dot C_T dot s_k $

mit dem Wert auf horizontalem Gelände (Ziffer 5.2.6), wobei die Bezugshöhe h₀ nach Anhang D zu ermitteln ist:

$ s_k = [1 + (h_0 / 350)^2] dot 0.4 " kN/m"^2 >= 0.9 " kN/m"^2 $

[Ein von der Bauherrschaft vereinbarter oder auf Messungen beruhender Wert ist hier zu begründen (Ziffer 5.2.1).]

#figure(
  table(
    columns: (1fr, auto, auto, auto),
    align: (left, center, right, left),
    table.hline(stroke: 1pt),
    table.header([*Parameter*], [*Symbol*], [*Wert*], [*Einheit*]),
    table.hline(stroke: 0.5pt),
    [Höhe über Meer], [], [[…]], [m],
    [Bezugshöhe], [$h_0$], [[…]], [m],
    [Expositionsbeiwert], [$C_e$], [[…]], [],
    [Thermischer Beiwert], [$C_T$], [[…]], [],
    [Dachformbeiwert], [$mu$], [[…]], [],
    [Schneelast auf horizontalem Gelände], [$s_k$], [[…]], [kN/m²],
    [Schneelast auf dem Dach], [$q_k$], [[…]], [kN/m²],
    table.hline(stroke: 1pt),
  ),
  caption: [Parameter der Schneelast],
)
