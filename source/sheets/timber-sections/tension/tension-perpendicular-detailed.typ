#import "/woodwork/woodwork.typ": *

= {title-tension-perpendicular} (SIA 265)

{text-tension-perpendicular}

#figure(
	image("/woodwork/figures/tension-perpendicular.svg", width: 9cm),
	caption: [{title-tension-perpendicular}])

#domain("tension-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_t_90_d",))

  #emph[{heading-action-and-section}]
  // @insert tension-perpendicular-action

  #emph[{heading-check}]
  // @insert tension-perpendicular-check
]
