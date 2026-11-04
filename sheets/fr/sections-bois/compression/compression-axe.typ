#import "/woodwork/woodwork.typ": *

= Compression parallèle au fil (SIA 265)

#domain("compression-parallel",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_c_d", 250, "kN",
	label: "Effort de compression")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Aire de la section")
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "Contrainte de compression",
	norm-section: "4.2.2.1")
  #verify(`sigma_c_0_d <= f_c_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification compression",
	norm-section: "4.2.2.1 (10)")
]
