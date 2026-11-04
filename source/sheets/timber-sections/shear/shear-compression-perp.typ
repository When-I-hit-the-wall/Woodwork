#import "/woodwork/woodwork.typ": *

= {title-shear-compression-perp} (SIA 265)

#domain("shear-compression-perp",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  // @insert shear-compression-perp-action
  // @insert shear-compression-perp-check
]
