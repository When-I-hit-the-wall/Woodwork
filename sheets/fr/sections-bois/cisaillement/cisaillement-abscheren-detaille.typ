#import "/woodwork/woodwork.typ": *

= Cisaillement (SIA 265)

Force F sur la surface cisaillée l · w ; k_a du lamellé-collé (27), du bois massif (26).

#figure(
	image("/woodwork/figures/shear-off.svg", width: 9cm),
	caption: [Cisaillement])

#domain("shear-off",
	preset: "report",
	norm: "SIA 265")[
  #emph[Matériau]
  #material("GL24h",
	moisture: 1,
	print: ("f_v_d",))

  #emph[Sollicitation et section]
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

  #emph[Vérification]
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
