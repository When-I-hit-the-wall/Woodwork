#import "/woodwork/woodwork.typ": *

= Flexion déviée (SIA 265)

Flexion autour des deux axes ; les deux rapports s'additionnent.

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [Flexion déviée])

#domain("bending-biaxial",
	preset: "report",
	norm: "SIA 265")[
  #emph[Matériau]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d",))

  #emph[Sollicitation et section]
  #var("M_y_d", 12, "kNm",
	label: "Moment de flexion (axe y)")
  #var("M_z_d", 3, "kNm",
	label: "Moment de flexion (axe z)")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("W_y", `b * h^2 / 6`,
	label: "Module de flexion (axe y)")
  #eq("W_z", `h * b^2 / 6`,
	label: "Module de flexion (axe z)")
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
  #eq("k_h_z",
	cases: (
		(`b >= h_ref`, `1`),
		(auto, `min((h_ref / b)^k_h_exp, k_h_max)`)),
	label: "Coefficient de hauteur",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Résistance à la flexion")
  #eq("f_m_z_d", `k_h_z * f_m_d`,
	label: "Résistance à la flexion")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Contrainte de flexion",
	norm-section: "4.2.3.1")
  #eq("sigma_m_z_d", `M_z_d / W_z`,
	label: "Contrainte de flexion",
	norm-section: "4.2.3.1")
  #verify(`sigma_m_y_d / f_m_y_d + sigma_m_z_d / f_m_z_d <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification flexion",
	norm-section: "4.2.3.1 (14)")
]
