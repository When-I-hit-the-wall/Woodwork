#import "/woodwork/woodwork.typ": *

= {title-tension-parallel} (SIA 265)

#domain("tension-parallel",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("f_t_0_d",
	label: "{tensile-strength}")
  // @insert tension-parallel-action
  // @insert tension-parallel-check
]
