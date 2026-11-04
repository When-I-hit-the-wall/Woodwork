  #eq("sigma_c_90_d", `F_c_90_d / A_c`,
	label: "{compressive-stress}",
	norm-section: "4.2.2.2")
  #verify(`sigma_c_90_d <= f_c_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{compression-check}",
	norm-section: "4.2.2.2 (11)")
