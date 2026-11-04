#import "/woodwork/woodwork.typ": *

= Flexion combinée avec traction (SIA 265)

Contraintes de flexion et de traction parallèles au fil.

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [Flexion combinée avec traction])

#domain("bending-tension",
	preset: "report",
	norm: "SIA 265")[
  #emph[Matériau]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_t_0_d"))

  #emph[Sollicitation et section]
  #var("N_t_d", 60, "kN",
	label: "Effort de traction")
  #var("M_y_d", 12, "kNm",
	label: "Moment de flexion (axe y)")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("W_y", `b * h^2 / 6`,
	label: "Module de flexion (axe y)")
  #eq("A", `b * h`,
	label: "Aire de la section")
  #var("h_ref",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.reference_height",
	unit: "mm",
	label: "Hauteur de référence")
  #var("k_h_exp",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.exponent",
	label: "Exposant")
  #var("k_h_max",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.maximum",
	label: "Valeur maximale")

  #emph[Vérification]
  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "Coefficient de hauteur",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Résistance à la flexion")
  #eq("sigma_t_0_d", `N_t_d / A`,
	label: "Contrainte de traction")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Contrainte de flexion")
  #verify(`sigma_t_0_d / f_t_0_d + sigma_m_y_d / f_m_y_d <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification combinée",
	norm-section: "4.2.4.1 (21)")
]
