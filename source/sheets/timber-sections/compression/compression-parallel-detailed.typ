#import "/woodwork/woodwork.typ": *

= {title-compression-parallel} (SIA 265)

{text-compression-parallel}

#figure(
	image("/woodwork/figures/compression-parallel.svg", width: 9cm),
	caption: [{title-compression-parallel}])

#domain("compression-parallel",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_c_0_d",))

  #emph[{heading-action-and-section}]
  // @insert compression-parallel-action

  #emph[{heading-check}]
  // @insert compression-parallel-check
]
