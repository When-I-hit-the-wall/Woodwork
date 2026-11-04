  #var("F_c_alpha_d", 80, "kN",
	label: "{bearing-force}")
  #var("alpha", 30, "°",
	label: "{angle-to-grain}")
  #var("l_c", 160, "mm",
	label: "{bearing-length}")
  #var("w_c", 140, "mm",
	label: "{bearing-width}")
  #eq("A_c", `l_c * w_c`,
	label: "{bearing-area}")
