#import "/woodwork/woodwork.typ": *

= Stabilität von Biegeträgern (Kippen) (SIA 265)

#domain("lateral-torsional",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
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
  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "Höhenbeiwert",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Biegefestigkeit")
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
  #verify(`sigma_m_y_d <= k_m * f_m_y_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Kippen",
	norm-section: "4.2.9.1 (38)")
]
