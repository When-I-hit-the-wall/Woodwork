#import "/woodwork/woodwork.typ": *

= Biegung unter einem Winkel zur Faserrichtung (SIA 265)

Biegung bei unter dem Winkel α geneigten Fasern: Biegezug- und Biegedruckseite.

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [Biegung unter einem Winkel zur Faserrichtung])

#domain("bending-angle",
	preset: "report",
	norm: "SIA 265")[
  #emph[Baustoff]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_t_90_d", "f_c_90_d"))

  #emph[Beanspruchung und Querschnitt]
  #var("M_y_d", 10, "kNm",
	label: "Biegemoment (Achse y)")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 240, "mm",
	label: "Höhe")
  #eq("W_y", `b * h^2 / 6`,
	label: "Widerstandsmoment (Achse y)")
  #var("alpha", 5, "°",
	label: "Winkel zur Faserrichtung")
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

  #emph[Nachweis]
  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "Höhenbeiwert",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Biegefestigkeit")
  #eq("k_mt_alpha", `f_t_90_d / (f_m_y_d * sin(alpha)^2 + f_t_90_d * cos(alpha)^2)`,
	label: "Beiwert Biegezugseite",
	norm-section: "4.2.3.3 (19)")
  #eq("k_mc_alpha", `f_c_90_d / (f_m_y_d * sin(alpha)^2 + f_c_90_d * cos(alpha)^2)`,
	label: "Beiwert Biegedruckseite",
	norm-section: "4.2.3.3 (20)")
  #eq("sigma_m_alpha_d", `M_y_d / W_y`,
	label: "Biegespannung",
	norm-section: "4.2.3.3")
  #verify(`sigma_m_alpha_d <= k_mt_alpha * f_m_y_d`,
	name-calc: "eta_m_t",
	name-visible: "eta",
	label: "Biegezugseite",
	norm-section: "4.2.3.3 (17)")
  #verify(`sigma_m_alpha_d <= k_mc_alpha * f_m_y_d`,
	name-calc: "eta_m_c",
	name-visible: "eta",
	label: "Biegedruckseite",
	norm-section: "4.2.3.3 (18)")
]
