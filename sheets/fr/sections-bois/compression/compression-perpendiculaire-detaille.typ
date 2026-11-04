#import "/woodwork/woodwork.typ": *

= Compression perpendiculaire au fil (SIA 265)

Appui : la force sur la surface d'appui l · w, f_c,90,d du cas « generell » des tableaux 8 et 9.

#figure(
	image("/woodwork/figures/compression-perpendicular.svg", width: 9cm),
	caption: [Compression perpendiculaire au fil])

#domain("compression-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #emph[Matériau]
  #material("GL24h",
	moisture: 1,
	case: "generell",
	print: ("f_c_90_d",))

  #emph[Sollicitation et section]
  #var("F_c_90_d", 35, "kN",
	label: "Force d'appui")
  #var("l_c", 160, "mm",
	label: "Longueur d'appui")
  #var("w_c", 140, "mm",
	label: "Largeur d'appui")
  #eq("A_c", `l_c * w_c`,
	label: "Surface d'appui")

  #emph[Vérification]
  #eq("sigma_c_90_d", `F_c_90_d / A_c`,
	label: "Contrainte de compression",
	norm-section: "4.2.2.2")
  #verify(`sigma_c_90_d <= f_c_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification compression",
	norm-section: "4.2.2.2 (11)")
]
