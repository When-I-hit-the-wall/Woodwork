#import "/woodwork/woodwork.typ": *

= Druck rechtwinklig zur Faserrichtung (SIA 265)

#domain("compression-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1,
	case: "generell")
  #var("F_c_90_d", 35, "kN",
	label: "Auflagerkraft")
  #var("l_c", 160, "mm",
	label: "Auflagerlänge")
  #var("w_c", 140, "mm",
	label: "Auflagerbreite")
  #eq("A_c", `l_c * w_c`,
	label: "Auflagerfläche")
  #eq("sigma_c_90_d", `F_c_90_d / A_c`,
	label: "Druckspannung",
	norm-section: "4.2.2.2")
  #verify(`sigma_c_90_d <= f_c_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Druck",
	norm-section: "4.2.2.2 (11)")
]
