#import "/woodwork/woodwork.typ": *

= {title-lateral-torsional-compression} (SIA 265)

#domain("lateral-torsional-compression",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  // @insert lateral-torsional-compression-action
  // @insert lateral-torsional-compression-check
]
