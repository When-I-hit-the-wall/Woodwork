#import "/woodwork/woodwork.typ": *

= Flexion parallèle au fil (SIA 265)

#domain("bending",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("M_y_d", 12, "kNm",
	label: "Moment de flexion (axe y)")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("W_y", `b * h^2 / 6`,
	label: "Module de flexion (axe y)")
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
  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "Coefficient de hauteur",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Résistance à la flexion")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Contrainte de flexion",
	norm-section: "4.2.3.1")
  #verify(`sigma_m_y_d <= f_m_y_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification flexion",
	norm-section: "4.2.3.1 (14)")
]
