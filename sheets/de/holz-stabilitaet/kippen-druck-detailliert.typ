#import "/woodwork/woodwork.typ": *

= Knicken und Kippen: Biegung mit Druck (SIA 265)

Gedrückter und um die starke Achse gebogener Stab: (37) um die Achse y, mit k_m; um die Achse z, ohne Biegung um z, das Knicken allein (29).

#figure(
	image("/woodwork/figures/lateral.svg", width: 9cm),
	caption: [Knicken und Kippen: Biegung mit Druck])

#domain("lateral-torsional-compression",
	preset: "report",
	norm: "SIA 265")[
  #emph[Baustoff]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_c_0_d", "E_0_05"))

  #emph[Beanspruchung und Querschnitt]
  #var("N_c_d", 80, "kN",
	label: "Druckkraft")
  #var("M_y_d", 40, "kNm",
	label: "Biegemoment (Achse y)")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 400, "mm",
	label: "Höhe")
  #eq("W_y", `b * h^2 / 6`,
	label: "Widerstandsmoment (Achse y)")
  #var("a", 3000, "mm",
	label: "Abstand der seitlichen Halterungen")
  #var("h_ref",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.reference_height",
	unit: "mm",
	label: "Bezugshöhe")
  #var("k_h_exp",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.exponent",
	label: "Exponent")
  #var("k_h_max",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.maximum",
	label: "Höchstwert")
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

  #emph[Nachweis]
  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "Höhenbeiwert",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Biegefestigkeit")
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "Druckspannung")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Biegespannung")
  #var("k_crit",
	from: "sia265/4.2.9-kippen",
	path: "clause.sigma_m_crit_factor",
	label: "Beiwert der Beziehung (41)")
  #eq("sigma_m_crit", `k_crit * E_0_05 * b^2 / (a * h)`,
	label: "Kritische Biegespannung",
	norm-section: "4.2.9.3 (41)")
  #eq("lambda_rel_m", `sqrt(f_m_k / sigma_m_crit)`,
	label: "Relative Kippschlankheit",
	norm-section: "4.2.9.3 (40)")
  #eq("k_m",
	cases: (
		(`lambda_rel_m <= 0.75`, `1`),
		(`lambda_rel_m <= 1.4`, `1.56 - 0.75 * lambda_rel_m`),
		(auto, `1 / lambda_rel_m^2`)),
	label: "Kippbeiwert",
	norm-section: "4.2.9.2 (39)")
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
  #verify(`(sigma_c_0_d / f_c_0_d)^2 + sigma_m_y_d / f_m_y_d <= 1`,
	name-calc: "eta_s",
	name-visible: "eta",
	label: "Querschnittsnachweis",
	norm-section: "4.2.4.2 (22)")
  #verify(`sigma_c_0_d / (k_c_y * f_c_0_d) + sigma_m_y_d / (k_m * f_m_y_d) <= 1`,
	name-calc: "eta_y",
	name-visible: "eta",
	label: "Nachweis Knicken (Achse y)",
	norm-section: "4.2.8.5 (37)")
  #verify(`sigma_c_0_d <= k_c_z * f_c_0_d`,
	name-calc: "eta_z",
	name-visible: "eta",
	label: "Nachweis Knicken (Achse z)",
	norm-section: "4.2.8.1 (29)")
]
