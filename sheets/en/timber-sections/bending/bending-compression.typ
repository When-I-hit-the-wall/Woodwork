#import "/woodwork/woodwork.typ": *

= Bending with compression (SIA 265)

#domain("bending-compression",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("N_c_d", 120, "kN",
	label: "Compressive force")
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
  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "Size factor",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Bending strength")
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "Compressive stress")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Bending stress")
  #verify(`(sigma_c_0_d / f_c_0_d)^2 + sigma_m_y_d / f_m_y_d <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Interaction check",
	norm-section: "4.2.4.2 (22)")
]
