  #var("V_z_d", 25, "kN",
	label: "{shear-force}")
  #var("b", 140, "mm",
	label: "{section-width}")
  #var("h", 240, "mm",
	label: "{section-height}")
  #eq("A", `b * h`,
	label: "{cross-sectional-area}")
