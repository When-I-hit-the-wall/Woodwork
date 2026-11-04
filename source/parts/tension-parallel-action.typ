  #var("N_t_d", 180, "kN",
	label: "{tension-force}")
  #var("b", 140, "mm",
	label: "{section-width}")
  #var("h", 200, "mm",
	label: "{section-height}")
  #eq("A", `b * h`,
	label: "{cross-sectional-area}")
