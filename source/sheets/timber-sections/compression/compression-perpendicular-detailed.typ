#import "/woodwork/woodwork.typ": *

= {title-compression-perpendicular} (SIA 265)

{text-compression-perpendicular}

#figure(
	image("/woodwork/figures/compression-perpendicular.svg", width: 9cm),
	caption: [{title-compression-perpendicular}])

#domain("compression-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	case: "generell",
	print: ("f_c_90_d",))

  #emph[{heading-action-and-section}]
  // @insert compression-perpendicular-action

  #emph[{heading-check}]
  // @insert compression-perpendicular-check
]
