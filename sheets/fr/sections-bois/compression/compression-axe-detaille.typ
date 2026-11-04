#import "/woodwork/woodwork.typ": *

= Compression parallèle au fil (SIA 265)

Section seule, k_c = 1 : le flambage est la feuille « flambage ».

#figure(
	image("/woodwork/figures/compression-parallel.svg", width: 9cm),
	caption: [Compression parallèle au fil])

#domain("compression-parallel",
	preset: "report",
	norm: "SIA 265")[
  #emph[Matériau]
  #material("GL24h",
	moisture: 1,
	print: ("f_c_0_d",))

  #emph[Sollicitation et section]
  #var("N_c_d", 250, "kN",
	label: "Effort de compression")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Aire de la section")

  #emph[Vérification]
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "Contrainte de compression",
	norm-section: "4.2.2.1")
  #verify(`sigma_c_0_d <= f_c_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification compression",
	norm-section: "4.2.2.1 (10)")
]
