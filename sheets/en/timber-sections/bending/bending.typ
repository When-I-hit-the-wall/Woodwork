#import "/woodwork/woodwork.typ": *

= Bending parallel to the grain (SIA 265)

#domain("bending",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("M_y_d", 12, "kNm",
	label: "Bending moment (axis y)")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("W_y", `b * h^2 / 6`,
	label: "Section modulus (axis y)")
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
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Bending stress",
	norm-section: "4.2.3.1")
  #verify(`sigma_m_y_d <= f_m_y_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Bending check",
	norm-section: "4.2.3.1 (14)")
]
