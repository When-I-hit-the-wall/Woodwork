  #eq("sigma_t_90_d", `N_t_d / A`,
	label: "{tensile-stress}",
	norm-section: "4.2.1.2")
  #verify(`sigma_t_90_d <= f_t_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{tension-check}",
	norm-section: "4.2.1.2 (7)")
