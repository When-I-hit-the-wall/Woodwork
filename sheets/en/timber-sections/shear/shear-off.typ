#import "/woodwork/woodwork.typ": *

= Shear-off (SIA 265)

#domain("shear-off",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("F_a_d", 35, "kN",
	label: "Shear-off force")
  #var("l_a", 200, "mm",
	label: "Sheared length")
  #var("w_a", 140, "mm",
	label: "Sheared width")
  #var("l_a_min",
	from: "sia265/4.2.6-abscheren",
	path: "clause.min_shear_length",
	unit: "mm",
	label: "Minimum sheared length")
  #var("k_a",
	from: "sia265/4.2.6-abscheren",
	path: "clause.factor.Brettschichtholz",
	label: "Shear-off factor")
  #verify(`l_a >= l_a_min`,
	name-calc: "l_a_ok",
	name-visible: "l_a_ok",
	label: "Sheared length",
	norm-section: "4.2.6")
  #eq("tau_a_d", `F_a_d / (l_a * w_a)`,
	label: "Shear stress",
	norm-section: "4.2.6")
  #verify(`tau_a_d <= k_a * f_v_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Shear-off check",
	norm-section: "4.2.6 (27)")
]
