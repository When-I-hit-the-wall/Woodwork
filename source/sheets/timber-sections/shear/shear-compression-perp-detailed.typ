#import "/woodwork/woodwork.typ": *

= {title-shear-compression-perp} (SIA 265)

{text-shear-compression-perp}

#figure(
	image("/woodwork/figures/shear.svg", width: 9cm),
	caption: [{title-shear-compression-perp}])

#domain("shear-compression-perp",
	preset: "report",
	norm: "SIA 265")[
  #emph[{heading-material}]
  #material("GL24h",
	moisture: 1,
	print: ("f_v_d", "f_t_90_d", "f_c_90_d"))

  #emph[{heading-action-and-section}]
  // @insert shear-compression-perp-action

  #emph[{heading-check}]
  // @insert shear-compression-perp-check
]
