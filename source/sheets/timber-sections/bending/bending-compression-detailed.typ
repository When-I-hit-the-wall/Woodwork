#import "/woodwork/woodwork.typ": *

= {title-bending-compression} (SIA 265)

{text-bending-compression}

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [{title-bending-compression}])

#domain("bending-compression",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_c_0_d"))

  #emph[{heading-action-and-section}]
  // @insert bending-compression-action

  #emph[{heading-check}]
  // @insert bending-compression-check
]
