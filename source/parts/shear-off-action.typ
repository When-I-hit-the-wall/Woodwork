  #var("F_a_d", 35, "kN",
	label: "{shear-off-force}")
  #var("l_a", 200, "mm",
	label: "{shear-off-length}")
  #var("w_a", 140, "mm",
	label: "{shear-off-width}")
  #var("l_a_min",
	from: "sia265/4.2.6-abscheren",
	path: "clause.min_shear_length",
	unit: "mm",
	label: "{shear-off-length-min}")
  #var("k_a",
	from: "sia265/4.2.6-abscheren",
	path: "clause.factor.Brettschichtholz",
	label: "{shear-off-factor}")
