#import "/woodwork/woodwork.typ": *

= {title-shear-off} (SIA 265)

#domain("shear-off",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  // @insert shear-off-action
  // @insert shear-off-check
]
