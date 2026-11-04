// woodwork/lib/calc-engine.typ -- what lib/formula.typ and lib/bibliography.typ import of the engine: the registry, the levels, the numbers and their display (calc-engine-core.typ), the tables (calc-engine-display.typ), and what #verify prints through.
// Taken from Woodcore's lib/calc-engine.typ on 4 November 2026 and rewritten: Woodcore's was a façade over five files that read a Woodcore project's data/ (positions, plans, connections, the journal); Woodwork reads no project, so it keeps the two files a sheet needs and the four constants of #verify that lived in calc-engine-connections.typ (founding spec, ARCH-005).

#import "calc-engine-display.typ": *

// Green where a relation holds, red where it does not: the colour of #verify's double rule and mark.
#let test-ok = rgb("#1a7f37")
#let test-nok = rgb("#c0392b")

// A value shown otherwise than it is held is written in orange.
#let override-colour = rgb("#b35c00")

// Two numbers closer than this, relatively, are the same number: float noise must not fail a check that holds exactly (0.1 + 0.2 against 0.3). The absolute floor of 1 keeps that meaningful near zero.
#let test-tolerance = 1e-9
#let test-slack(a, b) = test-tolerance * calc.max(1, calc.abs(a), calc.abs(b))

// The relations #verify accepts: the predicate it applies, and how the relation is set in math. A strict < or > takes the slack off the other side, so that two numbers the same within noise fail it.
#let test-relations = (
  "<=": (holds: (a, b) => a <= b + test-slack(a, b), math: "lt.eq.slant"),
  ">=": (holds: (a, b) => a >= b - test-slack(a, b), math: "gt.eq.slant"),
  "<": (holds: (a, b) => a < b - test-slack(a, b), math: "<"),
  ">": (holds: (a, b) => a > b + test-slack(a, b), math: ">"),
  "=": (holds: (a, b) => calc.abs(a - b) <= test-slack(a, b), math: "="),
  "!=": (holds: (a, b) => calc.abs(a - b) > test-slack(a, b), math: "eq.not"),
)

// The same relations as they may also be written.
#let test-aliases = ("≤": "<=", "≥": ">=", "≠": "!=", "==": "=")
