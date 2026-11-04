#import "/woodwork/woodwork.typ": *

= Traction biaise par rapport au fil (SIA 265)

Contrainte de traction biaise (angle α) par rapport au fil.

#figure(
	image("/woodwork/figures/tension-angle.svg", width: 9cm),
	caption: [Traction biaise par rapport au fil])

#domain("tension-angle",
	preset: "report",
	norm: "SIA 265")[
  #emph[Matériau]
  #material("GL24h",
	moisture: 1,
	print: ("f_t_0_d", "f_t_90_d"))

  #emph[Sollicitation et section]
  #var("N_t_d", 20, "kN",
	label: "Effort de traction")
  #var("alpha", 10, "°",
	label: "Angle par rapport au fil")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Aire de la section")

  #emph[Vérification]
  #eq("f_t_alpha_d", `f_t_90_d * f_t_0_d / (f_t_0_d * sin(alpha)^2 + f_t_90_d * cos(alpha)^2)`,
	label: "Résistance à la traction biaise",
	norm-section: "4.2.1.3 (9)")
  #eq("sigma_t_alpha_d", `N_t_d / A`,
	label: "Contrainte de traction",
	norm-section: "4.2.1.3")
  #verify(`sigma_t_alpha_d <= f_t_alpha_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification traction",
	norm-section: "4.2.1.3 (8)")
]
