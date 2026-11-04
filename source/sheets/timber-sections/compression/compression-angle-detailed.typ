#import "/woodwork/woodwork.typ": *

= {title-compression-angle} (SIA 265)

{text-compression-angle}

#figure(
	image("/woodwork/figures/compression-angle.svg", width: 9cm),
	caption: [{title-compression-angle}])

#domain("compression-angle",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_c_0_d", "f_c_90_d"))

  #emph[{heading-action-and-section}]
  // @insert compression-angle-action

  #emph[{heading-check}]
  // @insert compression-angle-check
]
