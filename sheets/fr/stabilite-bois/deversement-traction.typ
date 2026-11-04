#import "/woodwork/woodwork.typ": *

= Déversement avec traction (SIA 265)

#domain("lateral-torsional-tension",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_t_d", 40, "kN",
	label: "Effort de traction")
  #var("M_y_d", 40, "kNm",
	label: "Moment de flexion (axe y)")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 400, "mm",
	label: "Hauteur")
  #eq("W_y", `b * h^2 / 6`,
	label: "Module de flexion (axe y)")
  #var("a", 3000, "mm",
	label: "Distance entre appuis latéraux")
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
  #eq("A", `b * h`,
	label: "Aire de la section")
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
  #var("k_crit",
	from: "sia265/4.2.9-kippen",
	path: "clause.sigma_m_crit_factor",
	label: "Coefficient de la relation (41)")
  #eq("sigma_m_crit", `k_crit * E_0_05 * b^2 / (a * h)`,
	label: "Contrainte critique de flexion",
	norm-section: "4.2.9.3 (41)")
  #eq("lambda_rel_m", `sqrt(f_m_k / sigma_m_crit)`,
	label: "Élancement relatif de déversement",
	norm-section: "4.2.9.3 (40)")
  #eq("k_m",
	cases: (
		(`lambda_rel_m <= 0.75`, `1`),
		(`lambda_rel_m <= 1.4`, `1.56 - 0.75 * lambda_rel_m`),
		(auto, `1 / lambda_rel_m^2`)),
	label: "Coefficient de déversement",
	norm-section: "4.2.9.2 (39)")
  #verify(`sigma_t_0_d / f_t_0_d + sigma_m_y_d / f_m_y_d <= 1`,
	name-calc: "eta_s",
	name-visible: "eta",
	label: "Vérification de la section",
	norm-section: "4.2.4.1 (21)")
  #verify(`sigma_m_y_d <= k_m * f_m_y_d`,
	name-calc: "eta_m",
	name-visible: "eta",
	label: "Vérification déversement",
	norm-section: "4.2.9.1 (38)")
]
