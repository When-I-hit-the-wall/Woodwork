#import "/woodwork/woodwork.typ": *

= Bending with tension (SIA 265)

Tension and bending stresses parallel to the grain.

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [Bending with tension])

#domain("bending-tension",
	preset: "report",
	norm: "SIA 265")[
  #emph[Material]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_t_0_d"))

  #emph[Action effect and cross-section]
  #var("N_t_d", 60, "kN",
	label: "Tensile force")
  #var("M_y_d", 12, "kNm",
	label: "Bending moment (axis y)")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("W_y", `b * h^2 / 6`,
	label: "Section modulus (axis y)")
  #eq("A", `b * h`,
	label: "Cross-sectional area")
  #var("h_ref",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.reference_height",
	unit: "mm",
	label: "Reference height")
  #var("k_h_exp",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.exponent",
	label: "Exponent")
  #var("k_h_max",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.maximum",
	label: "Maximum")

  #emph[Check]
  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "Size factor",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Bending strength")
  #eq("sigma_t_0_d", `N_t_d / A`,
	label: "Tensile stress")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Bending stress")
  #verify(`sigma_t_0_d / f_t_0_d + sigma_m_y_d / f_m_y_d <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Interaction check",
	norm-section: "4.2.4.1 (21)")
]
