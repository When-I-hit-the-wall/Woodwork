#import "/woodwork/woodwork.typ": *

= {title-buckling} (SIA 265)

{text-buckling}

#figure(
	image("/woodwork/figures/buckling.svg", width: 9cm),
	caption: [{title-buckling}])

#domain("buckling",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_c_0_d", "E_0_05"))

  #emph[{heading-action-and-section}]
  // @insert buckling-action

  #emph[{heading-check}]
  // @insert buckling-check
]
