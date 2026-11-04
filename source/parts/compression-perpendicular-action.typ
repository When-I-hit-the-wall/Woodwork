  #var("F_c_90_d", 35, "kN",
	label: "{bearing-force}")
  #var("l_c", 160, "mm",
	label: "{bearing-length}")
  #var("w_c", 140, "mm",
	label: "{bearing-width}")
  #eq("A_c", `l_c * w_c`,
	label: "{bearing-area}")
