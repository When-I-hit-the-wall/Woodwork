#import "/woodwork/woodwork.typ": *

= Flambage et déversement : flexion avec compression (SIA 265)

#domain("lateral-torsional-compression",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_c_d", 80, "kN",
	label: "Effort de compression")
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
  #var("l_y", 3200, "mm",
	label: "Longueur du système (axe y)")
  #var("l_z", 3200, "mm",
	label: "Longueur du système (axe z)")
  #var("beta_y", 1.0, "",
	label: "Coefficient de longueur de flambage (y)")
  #var("beta_z", 1.0, "",
	label: "Coefficient de longueur de flambage (z)")
  #var("beta_c",
	from: "sia265/4.2.8-knicken",
	path: "clause.beta_c.Brettschichtholz",
	label: "Coefficient d'imperfection")
  #var("k_0",
	from: "sia265/4.2.8-knicken",
	path: "clause.k_factor",
	label: "Constante de la relation (31)")
  #var("lambda_0",
	from: "sia265/4.2.8-knicken",
	path: "clause.lambda_rel_offset",
	label: "Décalage de l'élancement")
  #var("lambda_lim",
	from: "sia265/4.2.8-knicken",
	path: "clause.lambda_rel_limit",
	label: "Limite de l'élancement relatif")
  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "Coefficient de hauteur",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Résistance à la flexion")
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "Contrainte de compression")
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
  #eq("i_y", `h / sqrt(12)`,
	label: "Rayon de giration (axe y)")
  #eq("l_k_y", `beta_y * l_y`,
	label: "Longueur de flambage (axe y)")
  #eq("lambda_y", `l_k_y / i_y`,
	label: "Élancement (axe y)")
  #eq("lambda_rel_y", `lambda_y / pi * sqrt(f_c_0_k / E_0_05)`,
	label: "Élancement relatif (axe y)",
	norm-section: "4.2.8.4 (34)")
  #eq("k_y", `k_0 * (1 + beta_c * (lambda_rel_y - lambda_0) + lambda_rel_y^2)`,
	label: "Valeur auxiliaire (axe y)",
	norm-section: "4.2.8.2 (31)")
  #eq("k_c_y",
	cases: (
		(`lambda_rel_y <= lambda_lim`, `1`),
		(auto, `1 / (k_y + sqrt(k_y^2 - lambda_rel_y^2))`)),
	label: "Coefficient de flambage (axe y)",
	norm-section: "4.2.8.2 (30)")
  #eq("i_z", `b / sqrt(12)`,
	label: "Rayon de giration (axe z)")
  #eq("l_k_z", `beta_z * l_z`,
	label: "Longueur de flambage (axe z)")
  #eq("lambda_z", `l_k_z / i_z`,
	label: "Élancement (axe z)")
  #eq("lambda_rel_z", `lambda_z / pi * sqrt(f_c_0_k / E_0_05)`,
	label: "Élancement relatif (axe z)",
	norm-section: "4.2.8.4 (34)")
  #eq("k_z", `k_0 * (1 + beta_c * (lambda_rel_z - lambda_0) + lambda_rel_z^2)`,
	label: "Valeur auxiliaire (axe z)",
	norm-section: "4.2.8.2 (31)")
  #eq("k_c_z",
	cases: (
		(`lambda_rel_z <= lambda_lim`, `1`),
		(auto, `1 / (k_z + sqrt(k_z^2 - lambda_rel_z^2))`)),
	label: "Coefficient de flambage (axe z)",
	norm-section: "4.2.8.2 (30)")
  #verify(`(sigma_c_0_d / f_c_0_d)^2 + sigma_m_y_d / f_m_y_d <= 1`,
	name-calc: "eta_s",
	name-visible: "eta",
	label: "Vérification de la section",
	norm-section: "4.2.4.2 (22)")
  #verify(`sigma_c_0_d / (k_c_y * f_c_0_d) + sigma_m_y_d / (k_m * f_m_y_d) <= 1`,
	name-calc: "eta_y",
	name-visible: "eta",
	label: "Vérification flambage (axe y)",
	norm-section: "4.2.8.5 (37)")
  #verify(`sigma_c_0_d <= k_c_z * f_c_0_d`,
	name-calc: "eta_z",
	name-visible: "eta",
	label: "Vérification flambage (axe z)",
	norm-section: "4.2.8.1 (29)")
]
