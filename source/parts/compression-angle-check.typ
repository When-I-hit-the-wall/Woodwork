  #eq("f_c_alpha_d", `f_c_90_d * f_c_0_d / (f_c_0_d * sin(alpha)^2 + f_c_90_d * cos(alpha)^2)`,
	label: "{compressive-strength-angle}",
	norm-section: "4.2.2.3 (13)")
  #eq("sigma_c_alpha_d", `F_c_alpha_d / A_c`,
	label: "{compressive-stress}",
	norm-section: "4.2.2.3")
  #verify(`sigma_c_alpha_d <= f_c_alpha_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{compression-check}",
	norm-section: "4.2.2.3 (12)")
