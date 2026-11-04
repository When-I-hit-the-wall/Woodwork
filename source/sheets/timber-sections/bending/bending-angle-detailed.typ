#import "/woodwork/woodwork.typ": *

= {title-bending-angle} (SIA 265)

{text-bending-angle}

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [{title-bending-angle}])

#domain("bending-angle",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_t_90_d", "f_c_90_d"))

  #emph[{heading-action-and-section}]
  // @insert bending-angle-action

  #emph[{heading-check}]
  // @insert bending-angle-check
]
