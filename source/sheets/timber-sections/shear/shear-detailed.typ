#import "/woodwork/woodwork.typ": *

= {title-shear} (SIA 265)

{text-shear}

#figure(
	image("/woodwork/figures/shear.svg", width: 9cm),
	caption: [{title-shear}])

#domain("shear",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_v_d",))

  #emph[{heading-action-and-section}]
  // @insert shear-action

  #emph[{heading-check}]
  // @insert shear-check
]
