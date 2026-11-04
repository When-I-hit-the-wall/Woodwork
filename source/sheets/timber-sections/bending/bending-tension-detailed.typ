#import "/woodwork/woodwork.typ": *

= {title-bending-tension} (SIA 265)

{text-bending-tension}

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [{title-bending-tension}])

#domain("bending-tension",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_t_0_d"))

  #emph[{heading-action-and-section}]
  // @insert bending-tension-action

  #emph[{heading-check}]
  // @insert bending-tension-check
]
