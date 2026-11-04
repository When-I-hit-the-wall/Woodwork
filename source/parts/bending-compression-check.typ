  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "{height-factor}",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "{bending-strength}")
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "{compressive-stress}")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "{bending-stress}")
  #verify(`(sigma_c_0_d / f_c_0_d)^2 + sigma_m_y_d / f_m_y_d <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{interaction-check}",
	norm-section: "4.2.4.2 (22)")
