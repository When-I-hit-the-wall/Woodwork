#import "/woodwork/woodwork.typ": *

= Traction parallèle au fil (SIA 265)

#domain("tension-parallel",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("f_t_0_d",
	label: "Résistance à la traction")
  #var("N_t_d", 180, "kN",
	label: "Effort de traction")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 200, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Aire de la section")
  #eq("sigma_t_0_d", `N_t_d / A`,
	label: "Contrainte de traction",
	norm-section: "4.2.1.1")
  #verify(`sigma_t_0_d <= f_t_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification traction",
	norm-section: "4.2.1.1 (6)")
]
