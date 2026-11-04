#import "/woodwork/woodwork.typ": *

= {title-lateral-torsional-tension} (SIA 265)

#domain("lateral-torsional-tension",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  // @insert lateral-torsional-tension-action
  // @insert lateral-torsional-tension-check
]
