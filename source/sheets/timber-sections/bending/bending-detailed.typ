#import "/woodwork/woodwork.typ": *

= {title-bending} (SIA 265)

{text-bending}

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [{title-bending}])

#domain("bending",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d",))

  #emph[{heading-action-and-section}]
  // @insert bending-action

  #emph[{heading-check}]
  // @insert bending-check
]
