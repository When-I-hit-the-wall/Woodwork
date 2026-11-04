#import "/woodwork/woodwork.typ": *

= Traction perpendiculaire au fil (SIA 265)

#domain("tension-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_t_d", 3, "kN",
	label: "Effort de traction")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Aire de la section")
  #eq("sigma_t_90_d", `N_t_d / A`,
	label: "Contrainte de traction",
	norm-section: "4.2.1.2")
  #verify(`sigma_t_90_d <= f_t_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification traction",
	norm-section: "4.2.1.2 (7)")
]
