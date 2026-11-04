  #var("N_c_d", 250, "kN",
	label: "{compression-force}")
  #var("b", 140, "mm",
	label: "{section-width}")
  #var("h", 240, "mm",
	label: "{section-height}")
  #eq("A", `b * h`,
	label: "{cross-sectional-area}")
