#import "/woodwork/woodwork.typ": *

= Effort tranchant combiné avec un effort normal perpendiculaire au fil (SIA 265)

#domain("shear-compression-perp",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("V_z_d", 20, "kN",
	label: "Effort tranchant")
  #var("b", 140, "mm",
	label: "Largeur")
  #var("h", 240, "mm",
	label: "Hauteur")
  #eq("A", `b * h`,
	label: "Aire de la section")
  #var("sigma_90_d", -0.8, "N/mm²",
	label: "Contrainte perpendiculaire au fil")
  #var("k_t_90_t",
	from: "sia265/4.2.7-schub-querdruck",
	path: "clause.k_t_90.querzug",
	label: "Coefficient, traction transversale")
  #var("k_t_90_c",
	from: "sia265/4.2.7-schub-querdruck",
	path: "clause.k_t_90.querdruck",
	label: "Coefficient, compression transversale")
  #eq("tau_d", `1.5 * V_z_d / A`,
	label: "Contrainte de cisaillement",
	norm-section: "4.2.5.1")
  #eq("k_t_90",
	cases: (
		(`sigma_90_d >= 0 "N/mm²"`, `k_t_90_t`),
		(auto, `k_t_90_c`)),
	label: "Coefficient k_t,90",
	norm-section: "4.2.7.1")
  #verify(`((f_c_90_d + sigma_90_d) / (f_c_90_d + k_t_90 * f_t_90_d))^2 + (tau_d / f_v_d)^2 * (1 - (f_c_90_d / (f_c_90_d + k_t_90 * f_t_90_d))^2) <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification combinée",
	norm-section: "4.2.7.1 (28)")
]
