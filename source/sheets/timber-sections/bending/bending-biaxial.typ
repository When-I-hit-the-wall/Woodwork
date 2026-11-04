#import "/woodwork/woodwork.typ": *

= {title-bending-biaxial} (SIA 265)

#domain("bending-biaxial",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  // @insert bending-biaxial-action
  // @insert bending-biaxial-check
]
