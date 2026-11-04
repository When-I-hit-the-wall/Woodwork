#import "/woodwork/woodwork.typ": *

= Schub und Normalkraft rechtwinklig zur Faserrichtung (SIA 265)

#domain("shear-compression-perp",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("V_z_d", 20, "kN",
	label: "Querkraft")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 240, "mm",
	label: "Höhe")
  #eq("A", `b * h`,
	label: "Querschnittsfläche")
  #var("sigma_90_d", -0.8, "N/mm²",
	label: "Spannung rechtwinklig zur Faserrichtung")
  #var("k_t_90_t",
	from: "sia265/4.2.7-schub-querdruck",
	path: "clause.k_t_90.querzug",
	label: "Beiwert Querzug")
  #var("k_t_90_c",
	from: "sia265/4.2.7-schub-querdruck",
	path: "clause.k_t_90.querdruck",
	label: "Beiwert Querdruck")
  #eq("tau_d", `1.5 * V_z_d / A`,
	label: "Schubspannung",
	norm-section: "4.2.5.1")
  #eq("k_t_90",
	cases: (
		(`sigma_90_d >= 0 "N/mm²"`, `k_t_90_t`),
		(auto, `k_t_90_c`)),
	label: "Beiwert k_t,90",
	norm-section: "4.2.7.1")
  #verify(`((f_c_90_d + sigma_90_d) / (f_c_90_d + k_t_90 * f_t_90_d))^2 + (tau_d / f_v_d)^2 * (1 - (f_c_90_d / (f_c_90_d + k_t_90 * f_t_90_d))^2) <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Interaktionsnachweis",
	norm-section: "4.2.7.1 (28)")
]
