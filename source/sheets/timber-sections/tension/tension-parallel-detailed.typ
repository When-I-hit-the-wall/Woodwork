#import "/woodwork/woodwork.typ": *

= {title-tension-parallel} (SIA 265)

{text-tension-parallel}

#figure(
	image("/woodwork/figures/tension-parallel.svg", width: 9cm),
	caption: [{title-tension-parallel}])

#domain("tension-parallel",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_t_0_d",))

  #emph[{heading-action-and-section}]
  // @insert tension-parallel-action

  #emph[{heading-check}]
  // @insert tension-parallel-check
]
