#import "/woodwork/woodwork.typ": *

= Zug rechtwinklig zur Faserrichtung (SIA 265)

#domain("tension-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_t_d", 3, "kN",
	label: "Zugkraft")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 240, "mm",
	label: "Höhe")
  #eq("A", `b * h`,
	label: "Querschnittsfläche")
  #eq("sigma_t_90_d", `N_t_d / A`,
	label: "Zugspannung",
	norm-section: "4.2.1.2")
  #verify(`sigma_t_90_d <= f_t_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Zug",
	norm-section: "4.2.1.2 (7)")
]
