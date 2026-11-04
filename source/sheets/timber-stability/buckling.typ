#import "/woodwork/woodwork.typ": *

= {title-buckling} (SIA 265)

#domain("buckling",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  // @insert buckling-action
  // @insert buckling-check
]
