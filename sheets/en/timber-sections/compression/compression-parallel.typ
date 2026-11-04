#import "/woodwork/woodwork.typ": *

= Compression parallel to the grain (SIA 265)

#domain("compression-parallel",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_c_d", 250, "kN",
	label: "Compressive force")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("A", `b * h`,
	label: "Cross-sectional area")
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "Compressive stress",
	norm-section: "4.2.2.1")
  #verify(`sigma_c_0_d <= f_c_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Compression check",
	norm-section: "4.2.2.1 (10)")
]
