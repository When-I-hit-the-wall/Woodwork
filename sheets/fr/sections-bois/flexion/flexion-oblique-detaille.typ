#import "/woodwork/woodwork.typ": *

= Flexion biaise par rapport au fil (SIA 265)

Flexion de fibres inclinées d'un angle α : côté tendu et côté comprimé.

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [Flexion biaise par rapport au fil])

#domain("bending-angle",
	preset: "report",
	norm: "SIA 265")[
  #emph[Matériau]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_t_90_d", "f_c_90_d"))

  #emph[Sollicitation et section]
  #var("M_y_d", 10, "kNm",
	label: "Moment de flexion (axe y)")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("W_y", `b * h^2 / 6`,
	label: "Module de flexion (axe y)")
  #var("alpha", 5, "°",
	label: "Angle par rapport au fil")
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
  #eq("k_mt_alpha", `f_t_90_d / (f_m_y_d * sin(alpha)^2 + f_t_90_d * cos(alpha)^2)`,
	label: "Coefficient côté tendu",
	norm-section: "4.2.3.3 (19)")
  #eq("k_mc_alpha", `f_c_90_d / (f_m_y_d * sin(alpha)^2 + f_c_90_d * cos(alpha)^2)`,
	label: "Coefficient côté comprimé",
	norm-section: "4.2.3.3 (20)")
  #eq("sigma_m_alpha_d", `M_y_d / W_y`,
	label: "Contrainte de flexion",
	norm-section: "4.2.3.3")
  #verify(`sigma_m_alpha_d <= k_mt_alpha * f_m_y_d`,
	name-calc: "eta_m_t",
	name-visible: "eta",
	label: "Côté tendu",
	norm-section: "4.2.3.3 (17)")
  #verify(`sigma_m_alpha_d <= k_mc_alpha * f_m_y_d`,
	name-calc: "eta_m_c",
	name-visible: "eta",
	label: "Côté comprimé",
	norm-section: "4.2.3.3 (18)")
]
