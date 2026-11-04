  #eq("f_t_alpha_d", `f_t_90_d * f_t_0_d / (f_t_0_d * sin(alpha)^2 + f_t_90_d * cos(alpha)^2)`,
	label: "{tensile-strength-angle}",
	norm-section: "4.2.1.3 (9)")
  #eq("sigma_t_alpha_d", `N_t_d / A`,
	label: "{tensile-stress}",
	norm-section: "4.2.1.3")
  #verify(`sigma_t_alpha_d <= f_t_alpha_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{tension-check}",
	norm-section: "4.2.1.3 (8)")
