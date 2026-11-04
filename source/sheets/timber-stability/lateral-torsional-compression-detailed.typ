#import "/woodwork/woodwork.typ": *

= {title-lateral-torsional-compression} (SIA 265)

{text-lateral-torsional-compression}

#figure(
	image("/woodwork/figures/lateral.svg", width: 9cm),
	caption: [{title-lateral-torsional-compression}])

#domain("lateral-torsional-compression",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_c_0_d", "E_0_05"))

  #emph[{heading-action-and-section}]
  // @insert lateral-torsional-compression-action

  #emph[{heading-check}]
  // @insert lateral-torsional-compression-check
]
