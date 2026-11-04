#import "/woodwork/woodwork.typ": *

= Effort tranchant (SIA 265)

Effort tranchant parallèle au fil, section rectangulaire : τ_d = 1.5 · V_d / A au centre de gravité.

#figure(
	image("/woodwork/figures/shear.svg", width: 9cm),
	caption: [Effort tranchant])

#domain("shear",
	preset: "report",
	norm: "SIA 265")[
  #emph[Matériau]
  #material("GL24h",
	moisture: 1,
	print: ("f_v_d",))

  #emph[Sollicitation et section]
  #var("V_z_d", 25, "kN",
	label: "Effort tranchant")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Aire de la section")

  #emph[Vérification]
  #eq("tau_d", `1.5 * V_z_d / A`,
	label: "Contrainte de cisaillement",
	norm-section: "4.2.5.1")
  #verify(`tau_d <= f_v_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification effort tranchant",
	norm-section: "4.2.5.1 (23)")
]
