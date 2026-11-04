#import "/woodwork/woodwork.typ": *

= {title-lateral-torsional} (SIA 265)

#domain("lateral-torsional",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  // @insert lateral-torsional-action
  // @insert lateral-torsional-check
]
