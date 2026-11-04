#import "/woodwork/woodwork.typ": *

= Stabilität von Druckstäben (Knicken) (SIA 265)

#domain("buckling",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_c_d", 150, "kN",
	label: "Druckkraft")
  #var("b", 160, "mm",
	label: "Breite")
  #var("h", 160, "mm",
	label: "Höhe")
  #eq("A", `b * h`,
	label: "Querschnittsfläche")
  #var("l_y", 3200, "mm",
	label: "Systemlänge (Achse y)")
  #var("l_z", 3200, "mm",
	label: "Systemlänge (Achse z)")
  #var("beta_y", 1.0, "",
	label: "Knicklängenbeiwert (y)")
  #var("beta_z", 1.0, "",
	label: "Knicklängenbeiwert (z)")
  #var("beta_c",
	from: "sia265/4.2.8-knicken",
	path: "clause.beta_c.Brettschichtholz",
	label: "Imperfektionsbeiwert")
  #var("k_0",
	from: "sia265/4.2.8-knicken",
	path: "clause.k_factor",
	label: "Konstante der Beziehung (31)")
  #var("lambda_0",
	from: "sia265/4.2.8-knicken",
	path: "clause.lambda_rel_offset",
	label: "Schlankheitsversatz")
  #var("lambda_lim",
	from: "sia265/4.2.8-knicken",
	path: "clause.lambda_rel_limit",
	label: "Grenze der relativen Schlankheit")
  #eq("i_y", `h / sqrt(12)`,
	label: "Trägheitsradius (Achse y)")
  #eq("l_k_y", `beta_y * l_y`,
	label: "Knicklänge (Achse y)")
  #eq("lambda_y", `l_k_y / i_y`,
	label: "Schlankheit (Achse y)")
  #eq("lambda_rel_y", `lambda_y / pi * sqrt(f_c_0_k / E_0_05)`,
	label: "Relative Schlankheit (Achse y)",
	norm-section: "4.2.8.4 (34)")
  #eq("k_y", `k_0 * (1 + beta_c * (lambda_rel_y - lambda_0) + lambda_rel_y^2)`,
	label: "Hilfswert (Achse y)",
	norm-section: "4.2.8.2 (31)")
  #eq("k_c_y",
	cases: (
		(`lambda_rel_y <= lambda_lim`, `1`),
		(auto, `1 / (k_y + sqrt(k_y^2 - lambda_rel_y^2))`)),
	label: "Knickbeiwert (Achse y)",
	norm-section: "4.2.8.2 (30)")
  #eq("i_z", `b / sqrt(12)`,
	label: "Trägheitsradius (Achse z)")
  #eq("l_k_z", `beta_z * l_z`,
	label: "Knicklänge (Achse z)")
  #eq("lambda_z", `l_k_z / i_z`,
	label: "Schlankheit (Achse z)")
  #eq("lambda_rel_z", `lambda_z / pi * sqrt(f_c_0_k / E_0_05)`,
	label: "Relative Schlankheit (Achse z)",
	norm-section: "4.2.8.4 (34)")
  #eq("k_z", `k_0 * (1 + beta_c * (lambda_rel_z - lambda_0) + lambda_rel_z^2)`,
	label: "Hilfswert (Achse z)",
	norm-section: "4.2.8.2 (31)")
  #eq("k_c_z",
	cases: (
		(`lambda_rel_z <= lambda_lim`, `1`),
		(auto, `1 / (k_z + sqrt(k_z^2 - lambda_rel_z^2))`)),
	label: "Knickbeiwert (Achse z)",
	norm-section: "4.2.8.2 (30)")
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "Druckspannung")
  #verify(`sigma_c_0_d <= k_c_y * f_c_0_d`,
	name-calc: "eta_y",
	name-visible: "eta",
	label: "Nachweis Knicken (Achse y)",
	norm-section: "4.2.8.1 (29)")
  #verify(`sigma_c_0_d <= k_c_z * f_c_0_d`,
	name-calc: "eta_z",
	name-visible: "eta",
	label: "Nachweis Knicken (Achse z)",
	norm-section: "4.2.8.1 (29)")
]
