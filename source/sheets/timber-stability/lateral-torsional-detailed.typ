#import "/woodwork/woodwork.typ": *

= {title-lateral-torsional} (SIA 265)

{text-lateral-torsional}

#figure(
	image("/woodwork/figures/lateral.svg", width: 9cm),
	caption: [{title-lateral-torsional}])

#domain("lateral-torsional",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "E_0_05"))

  #emph[{heading-action-and-section}]
  // @insert lateral-torsional-action

  #emph[{heading-check}]
  // @insert lateral-torsional-check
]
