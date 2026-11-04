#import "/woodwork/woodwork.typ": *

= Biaxial bending (SIA 265)

Bending about both axes; the two ratios are added.

#figure(
	image("/woodwork/figures/bending.svg", width: 9cm),
	caption: [Biaxial bending])

#domain("bending-biaxial",
	preset: "report",
	norm: "SIA 265")[
  #emph[Material]
  #material("GL24h",
	moisture: 1,
	print: ("f_m_d",))

  #emph[Action effect and cross-section]
  #var("M_y_d", 12, "kNm",
	label: "Bending moment (axis y)")
  #var("M_z_d", 3, "kNm",
	label: "Bending moment (axis z)")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("W_y", `b * h^2 / 6`,
	label: "Section modulus (axis y)")
  #eq("W_z", `h * b^2 / 6`,
	label: "Section modulus (axis z)")
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
  #eq("k_h_z",
	cases: (
		(`b >= h_ref`, `1`),
		(auto, `min((h_ref / b)^k_h_exp, k_h_max)`)),
	label: "Size factor",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "Bending strength")
  #eq("f_m_z_d", `k_h_z * f_m_d`,
	label: "Bending strength")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "Bending stress",
	norm-section: "4.2.3.1")
  #eq("sigma_m_z_d", `M_z_d / W_z`,
	label: "Bending stress",
	norm-section: "4.2.3.1")
  #verify(`sigma_m_y_d / f_m_y_d + sigma_m_z_d / f_m_z_d <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Bending check",
	norm-section: "4.2.3.1 (14)")
]
