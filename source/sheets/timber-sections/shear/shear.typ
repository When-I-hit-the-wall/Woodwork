#import "/woodwork/woodwork.typ": *

= {title-shear} (SIA 265)

#domain("shear",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  // @insert shear-action
  // @insert shear-check
]
