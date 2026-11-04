#import "/woodwork/woodwork.typ": *

= Stabilité des barres comprimées (flambage) (SIA 265)

#domain("buckling",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_c_d", 150, "kN",
	label: "Effort de compression")
  #var("b", 160, "mm",
	label: "Largeur")
  #var("h", 160, "mm",
	label: "Hauteur")
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
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "Contrainte de compression")
  #verify(`sigma_c_0_d <= k_c_y * f_c_0_d`,
	name-calc: "eta_y",
	name-visible: "eta",
	label: "Vérification flambage (axe y)",
	norm-section: "4.2.8.1 (29)")
  #verify(`sigma_c_0_d <= k_c_z * f_c_0_d`,
	name-calc: "eta_z",
	name-visible: "eta",
	label: "Vérification flambage (axe z)",
	norm-section: "4.2.8.1 (29)")
]
