#import "/woodwork/woodwork.typ": *

= Tension parallel to the grain (SIA 265)

#domain("tension-parallel",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("f_t_0_d",
	label: "Tensile strength")
  #var("N_t_d", 180, "kN",
	label: "Tensile force")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 200, "mm",
	label: "Height")
  #eq("A", `b * h`,
	label: "Cross-sectional area")
  #eq("sigma_t_0_d", `N_t_d / A`,
	label: "Tensile stress",
	norm-section: "4.2.1.1")
  #verify(`sigma_t_0_d <= f_t_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Tension check",
	norm-section: "4.2.1.1 (6)")
]
