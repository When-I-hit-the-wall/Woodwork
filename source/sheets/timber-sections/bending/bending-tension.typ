#import "/woodwork/woodwork.typ": *

= {title-bending-tension} (SIA 265)

#domain("bending-tension",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  // @insert bending-tension-action
  // @insert bending-tension-check
]
