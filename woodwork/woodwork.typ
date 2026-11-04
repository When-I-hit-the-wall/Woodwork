// woodwork/woodwork.typ -- the one file a sheet imports, from the root of the project it was copied into:
//
//   #import "/woodwork/woodwork.typ": *
//
// It gives a sheet the commands and nothing of the engine's helpers (docs/typst/commands.md).

#let woodwork-version = "0.1.0"

#import "lib/formula.typ": domain, var, eq, verify, unit, calc-defaults, var-table, show-bibliography, cite-norm
#import "lib/calc-engine.typ": get, report-level, number-digits
#import "lib/material.typ": material
#import "lib/norm-list.typ": show-norm-list
