#import "/woodwork/woodwork.typ": *

= Druck in Faserrichtung (SIA 265)

#domain("compression-parallel",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_c_d", 250, "kN",
	label: "Druckkraft")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 240, "mm",
	label: "Höhe")
  #eq("A", `b * h`,
	label: "Querschnittsfläche")
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "Druckspannung",
	norm-section: "4.2.2.1")
  #verify(`sigma_c_0_d <= f_c_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Druck",
	norm-section: "4.2.2.1 (10)")
]
