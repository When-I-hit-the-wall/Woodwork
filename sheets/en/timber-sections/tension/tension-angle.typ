#import "/woodwork/woodwork.typ": *

= Tension at an angle to the grain (SIA 265)

#domain("tension-angle",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_t_d", 20, "kN",
	label: "Tensile force")
  #var("alpha", 10, "°",
	label: "Angle to the grain")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("A", `b * h`,
	label: "Cross-sectional area")
  #eq("f_t_alpha_d", `f_t_90_d * f_t_0_d / (f_t_0_d * sin(alpha)^2 + f_t_90_d * cos(alpha)^2)`,
	label: "Tensile strength at the angle",
	norm-section: "4.2.1.3 (9)")
  #eq("sigma_t_alpha_d", `N_t_d / A`,
	label: "Tensile stress",
	norm-section: "4.2.1.3")
  #verify(`sigma_t_alpha_d <= f_t_alpha_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Tension check",
	norm-section: "4.2.1.3 (8)")
]
