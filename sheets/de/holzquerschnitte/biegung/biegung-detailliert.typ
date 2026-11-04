#import "/woodwork/woodwork.typ": *

= Biegung in Faserrichtung (SIA 265)

Biegung um die starke Achse, Rechteckquerschnitt; k_h für Brettschichtholz unter der Bezugshöhe (3.4.2.3). Für Vollholz ist k_h = 1.

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [Biegung in Faserrichtung])

#domain("bending",
	preset: "report",
	norm: "SIA 265")[
  #emph[Baustoff]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d",))

  #emph[Beanspruchung und Querschnitt]
  #var("M_y_d", 12, "kNm",
	label: "Biegemoment (Achse y)")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 240, "mm",
	label: "Höhe")
  #eq("W_y", `b * h^2 / 6`,
	label: "Widerstandsmoment (Achse y)")
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
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Biegespannung",
	norm-section: "4.2.3.1")
  #verify(`sigma_m_y_d <= f_m_y_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Biegung",
	norm-section: "4.2.3.1 (14)")
]
