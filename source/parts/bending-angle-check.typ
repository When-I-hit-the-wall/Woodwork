  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "{height-factor}",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "{bending-strength}")
  #eq("k_mt_alpha", `f_t_90_d / (f_m_y_d * sin(alpha)^2 + f_t_90_d * cos(alpha)^2)`,
	label: "{factor-tension-side}",
	norm-section: "4.2.3.3 (19)")
  #eq("k_mc_alpha", `f_c_90_d / (f_m_y_d * sin(alpha)^2 + f_c_90_d * cos(alpha)^2)`,
	label: "{factor-compression-side}",
	norm-section: "4.2.3.3 (20)")
  #eq("sigma_m_alpha_d", `M_y_d / W_y`,
	label: "{bending-stress}",
	norm-section: "4.2.3.3")
  #verify(`sigma_m_alpha_d <= k_mt_alpha * f_m_y_d`,
	name-calc: "eta_m_t",
	name-visible: "eta",
	label: "{tension-side}",
	norm-section: "4.2.3.3 (17)")
  #verify(`sigma_m_alpha_d <= k_mc_alpha * f_m_y_d`,
	name-calc: "eta_m_c",
	name-visible: "eta",
	label: "{compression-side}",
	norm-section: "4.2.3.3 (18)")
