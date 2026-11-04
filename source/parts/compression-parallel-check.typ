  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "{compressive-stress}",
	norm-section: "4.2.2.1")
  #verify(`sigma_c_0_d <= f_c_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{compression-check}",
	norm-section: "4.2.2.1 (10)")
