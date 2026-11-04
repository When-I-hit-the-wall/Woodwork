#import "/woodwork/woodwork.typ": *

= Compression at an angle to the grain (SIA 265)

#domain("compression-angle",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("F_c_alpha_d", 80, "kN",
	label: "Bearing force")
  #var("alpha", 30, "°",
	label: "Angle to the grain")
  #var("l_c", 160, "mm",
	label: "Bearing length")
  #var("w_c", 140, "mm",
	label: "Bearing width")
  #eq("A_c", `l_c * w_c`,
	label: "Bearing area")
  #eq("f_c_alpha_d", `f_c_90_d * f_c_0_d / (f_c_0_d * sin(alpha)^2 + f_c_90_d * cos(alpha)^2)`,
	label: "Compressive strength at the angle",
	norm-section: "4.2.2.3 (13)")
  #eq("sigma_c_alpha_d", `F_c_alpha_d / A_c`,
	label: "Compressive stress",
	norm-section: "4.2.2.3")
  #verify(`sigma_c_alpha_d <= f_c_alpha_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Compression check",
	norm-section: "4.2.2.3 (12)")
]
