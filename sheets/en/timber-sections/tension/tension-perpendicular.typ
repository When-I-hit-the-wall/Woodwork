#import "/woodwork/woodwork.typ": *

= Tension perpendicular to the grain (SIA 265)

#domain("tension-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_t_d", 3, "kN",
	label: "Tensile force")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("A", `b * h`,
	label: "Cross-sectional area")
  #eq("sigma_t_90_d", `N_t_d / A`,
	label: "Tensile stress",
	norm-section: "4.2.1.2")
  #verify(`sigma_t_90_d <= f_t_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Tension check",
	norm-section: "4.2.1.2 (7)")
]
