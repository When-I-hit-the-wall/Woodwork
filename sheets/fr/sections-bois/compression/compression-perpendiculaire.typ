#import "/woodwork/woodwork.typ": *

= Compression perpendiculaire au fil (SIA 265)

#domain("compression-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1,
	case: "generell")
  #var("F_c_90_d", 35, "kN",
	label: "Force d'appui")
  #var("l_c", 160, "mm",
	label: "Longueur d'appui")
  #var("w_c", 140, "mm",
	label: "Largeur d'appui")
  #eq("A_c", `l_c * w_c`,
	label: "Surface d'appui")
  #eq("sigma_c_90_d", `F_c_90_d / A_c`,
	label: "Contrainte de compression",
	norm-section: "4.2.2.2")
  #verify(`sigma_c_90_d <= f_c_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification compression",
	norm-section: "4.2.2.2 (11)")
]
