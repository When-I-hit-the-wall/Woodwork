#import "/woodwork/woodwork.typ": *

= Cisaillement (SIA 265)

#domain("shear-off",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("F_a_d", 35, "kN",
	label: "Force de cisaillement")
  #var("l_a", 200, "mm",
	label: "Longueur cisaillée")
  #var("w_a", 140, "mm",
	label: "Largeur cisaillée")
  #var("l_a_min",
	from: "sia265/4.2.6-abscheren",
	path: "clause.min_shear_length",
	unit: "mm",
	label: "Longueur cisaillée minimale")
  #var("k_a",
	from: "sia265/4.2.6-abscheren",
	path: "clause.factor.Brettschichtholz",
	label: "Coefficient de cisaillement")
  #verify(`l_a >= l_a_min`,
	name-calc: "l_a_ok",
	name-visible: "l_a_ok",
	label: "Longueur cisaillée",
	norm-section: "4.2.6")
  #eq("tau_a_d", `F_a_d / (l_a * w_a)`,
	label: "Contrainte de cisaillement",
	norm-section: "4.2.6")
  #verify(`tau_a_d <= k_a * f_v_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification cisaillement",
	norm-section: "4.2.6 (27)")
]
