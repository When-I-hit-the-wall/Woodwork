  #eq("sigma_t_0_d", `N_t_d / A`,
	label: "{tensile-stress}",
	norm-section: "4.2.1.1")
  #verify(`sigma_t_0_d <= f_t_0_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{tension-check}",
	norm-section: "4.2.1.1 (6)")
