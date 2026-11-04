#import "/woodwork/woodwork.typ": *

= Compression perpendicular to the grain (SIA 265)

#domain("compression-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1,
	case: "generell")
  #var("F_c_90_d", 35, "kN",
	label: "Bearing force")
  #var("l_c", 160, "mm",
	label: "Bearing length")
  #var("w_c", 140, "mm",
	label: "Bearing width")
  #eq("A_c", `l_c * w_c`,
	label: "Bearing area")
  #eq("sigma_c_90_d", `F_c_90_d / A_c`,
	label: "Compressive stress",
	norm-section: "4.2.2.2")
  #verify(`sigma_c_90_d <= f_c_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Compression check",
	norm-section: "4.2.2.2 (11)")
]
