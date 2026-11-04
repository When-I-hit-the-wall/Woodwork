#import "/woodwork/woodwork.typ": *

= Zug in Faserrichtung (SIA 265)

#domain("tension-parallel",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("f_t_0_d",
	label: "Zugfestigkeit")
  #var("N_t_d", 180, "kN",
	label: "Zugkraft")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 200, "mm",
	label: "Höhe")
  #eq("A", `b * h`,
	label: "Querschnittsfläche")
  #eq("sigma_t_0_d", `N_t_d / A`,
	label: "Zugspannung",
	norm-section: "4.2.1.1")
  #verify(`sigma_t_0_d <= f_t_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Zug",
	norm-section: "4.2.1.1 (6)")
]
