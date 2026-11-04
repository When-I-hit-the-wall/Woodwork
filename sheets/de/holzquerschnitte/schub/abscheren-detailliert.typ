#import "/woodwork/woodwork.typ": *

= Abscheren (SIA 265)

Kraft F auf der Abscherfläche l · w; k_a für Brettschichtholz (27), für Vollholz (26).

#figure(
	image("/woodwork/figures/shear-off.svg", width: 9cm),
	caption: [Abscheren])

#domain("shear-off",
	preset: "report",
	norm: "SIA 265")[
  #emph[Baustoff]
  #material("GL24h",
	moisture: 1,
	print: ("f_v_d",))

  #emph[Beanspruchung und Querschnitt]
  #var("F_a_d", 35, "kN",
	label: "Abscherkraft")
  #var("l_a", 200, "mm",
	label: "Abscherlänge")
  #var("w_a", 140, "mm",
	label: "Abscherbreite")
  #var("l_a_min",
	from: "sia265/4.2.6-abscheren",
	path: "clause.min_shear_length",
	unit: "mm",
	label: "Mindestabscherlänge")
  #var("k_a",
	from: "sia265/4.2.6-abscheren",
	path: "clause.factor.Brettschichtholz",
	label: "Abscherbeiwert")

  #emph[Nachweis]
  #verify(`l_a >= l_a_min`,
	name-calc: "l_a_ok",
	name-visible: "l_a_ok",
	label: "Abscherlänge",
	norm-section: "4.2.6")
  #eq("tau_a_d", `F_a_d / (l_a * w_a)`,
	label: "Schubspannung",
	norm-section: "4.2.6")
  #verify(`tau_a_d <= k_a * f_v_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Abscheren",
	norm-section: "4.2.6 (27)")
]
