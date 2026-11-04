#import "/woodwork/woodwork.typ": *

= {title-lateral-torsional-tension} (SIA 265)

{text-lateral-torsional-tension}

#figure(
	image("/woodwork/figures/lateral.svg", width: 9cm),
	caption: [{title-lateral-torsional-tension}])

#domain("lateral-torsional-tension",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_t_0_d", "E_0_05"))

  #emph[{heading-action-and-section}]
  // @insert lateral-torsional-tension-action

  #emph[{heading-check}]
  // @insert lateral-torsional-tension-check
]
