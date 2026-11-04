  #var("V_z_d", 20, "kN",
	label: "{shear-force}")
  #var("b", 140, "mm",
	label: "{section-width}")
  #var("h", 240, "mm",
	label: "{section-height}")
  #eq("A", `b * h`,
	label: "{cross-sectional-area}")
  #var("sigma_90_d", -0.8, "N/mm²",
	label: "{transverse-stress}")
  #var("k_t_90_t",
	from: "sia265/4.2.7-schub-querdruck",
	path: "clause.k_t_90.querzug",
	label: "{factor-transverse-tension}")
  #var("k_t_90_c",
	from: "sia265/4.2.7-schub-querdruck",
	path: "clause.k_t_90.querdruck",
	label: "{factor-transverse-compression}")
