#import "/woodwork/woodwork.typ": *

= Bending at an angle to the grain (SIA 265)

Bending of fibres inclined at an angle α: tension and compression side.

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [Bending at an angle to the grain])

#domain("bending-angle",
	preset: "report",
	norm: "SIA 265")[
  #emph[Material]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d", "f_t_90_d", "f_c_90_d"))

  #emph[Action effect and cross-section]
  #var("M_y_d", 10, "kNm",
	label: "Bending moment (axis y)")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("W_y", `b * h^2 / 6`,
	label: "Section modulus (axis y)")
  #var("alpha", 5, "°",
	label: "Angle to the grain")
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
  #eq("k_mt_alpha", `f_t_90_d / (f_m_y_d * sin(alpha)^2 + f_t_90_d * cos(alpha)^2)`,
	label: "Factor, tension side",
	norm-section: "4.2.3.3 (19)")
  #eq("k_mc_alpha", `f_c_90_d / (f_m_y_d * sin(alpha)^2 + f_c_90_d * cos(alpha)^2)`,
	label: "Factor, compression side",
	norm-section: "4.2.3.3 (20)")
  #eq("sigma_m_alpha_d", `M_y_d / W_y`,
	label: "Bending stress",
	norm-section: "4.2.3.3")
  #verify(`sigma_m_alpha_d <= k_mt_alpha * f_m_y_d`,
	name-calc: "eta_m_t",
	name-visible: "eta",
	label: "Tension side",
	norm-section: "4.2.3.3 (17)")
  #verify(`sigma_m_alpha_d <= k_mc_alpha * f_m_y_d`,
	name-calc: "eta_m_c",
	name-visible: "eta",
	label: "Compression side",
	norm-section: "4.2.3.3 (18)")
]
