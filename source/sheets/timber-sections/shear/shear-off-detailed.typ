#import "/woodwork/woodwork.typ": *

= {title-shear-off} (SIA 265)

{text-shear-off}

#figure(
	image("/woodwork/figures/shear-off.svg", width: 9cm),
	caption: [{title-shear-off}])

#domain("shear-off",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_v_d",))

  #emph[{heading-action-and-section}]
  // @insert shear-off-action

  #emph[{heading-check}]
  // @insert shear-off-check
]
