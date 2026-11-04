#import "/woodwork/woodwork.typ": *

= Doppelbiegung (SIA 265)

#domain("bending-biaxial",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("M_y_d", 12, "kNm",
	label: "Biegemoment (Achse y)")
  #var("M_z_d", 3, "kNm",
	label: "Biegemoment (Achse z)")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 240, "mm",
	label: "Höhe")
  #eq("W_y", `b * h^2 / 6`,
	label: "Widerstandsmoment (Achse y)")
  #eq("W_z", `h * b^2 / 6`,
	label: "Widerstandsmoment (Achse z)")
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
  #eq("k_h_z",
	cases: (
		(`b >= h_ref`, `1`),
		(auto, `min((h_ref / b)^k_h_exp, k_h_max)`)),
	label: "Höhenbeiwert",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Biegefestigkeit")
  #eq("f_m_z_d", `k_h_z * f_m_d`,
	label: "Biegefestigkeit")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Biegespannung",
	norm-section: "4.2.3.1")
  #eq("sigma_m_z_d", `M_z_d / W_z`,
	label: "Biegespannung",
	norm-section: "4.2.3.1")
  #verify(`sigma_m_y_d / f_m_y_d + sigma_m_z_d / f_m_z_d <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Biegung",
	norm-section: "4.2.3.1 (14)")
]
