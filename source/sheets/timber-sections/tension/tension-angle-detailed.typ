#import "/woodwork/woodwork.typ": *

= {title-tension-angle} (SIA 265)

{text-tension-angle}

#figure(
	image("/woodwork/figures/tension-angle.svg", width: 9cm),
	caption: [{title-tension-angle}])

#domain("tension-angle",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_t_0_d", "f_t_90_d"))

  #emph[{heading-action-and-section}]
  // @insert tension-angle-action

  #emph[{heading-check}]
  // @insert tension-angle-check
]
