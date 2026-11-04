  #var("N_t_d", 3, "kN",
	label: "{tension-force}")
  #var("b", 140, "mm",
	label: "{section-width}")
  #var("h", 240, "mm",
	label: "{section-height}")
  #eq("A", `b * h`,
	label: "{cross-sectional-area}")
