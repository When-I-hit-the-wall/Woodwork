#import "/woodwork/woodwork.typ": *

= Traction perpendiculaire au fil (SIA 265)

Contrainte de traction uniforme perpendiculaire au fil.

#figure(
	image("/woodwork/figures/tension-perpendicular.svg", width: 9cm),
	caption: [Traction perpendiculaire au fil])

#domain("tension-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #emph[Matériau]
  #material("GL24h",
	moisture: 1,
	print: ("f_t_90_d",))

  #emph[Sollicitation et section]
  #var("N_t_d", 3, "kN",
	label: "Effort de traction")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Aire de la section")

  #emph[Vérification]
  #eq("sigma_t_90_d", `N_t_d / A`,
	label: "Contrainte de traction",
	norm-section: "4.2.1.2")
  #verify(`sigma_t_90_d <= f_t_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification traction",
	norm-section: "4.2.1.2 (7)")
]
