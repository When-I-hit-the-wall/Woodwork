  #var("N_t_d", 20, "kN",
	label: "{tension-force}")
  #var("alpha", 10, "°",
	label: "{angle-to-grain}")
  #var("b", 140, "mm",
	label: "{section-width}")
  #var("h", 240, "mm",
	label: "{section-height}")
  #eq("A", `b * h`,
	label: "{cross-sectional-area}")
