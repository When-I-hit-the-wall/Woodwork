  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "{height-factor}",
	norm-section: "3.4.2.3 (5)")
  #eq("k_h_z",
	cases: (
		(`b >= h_ref`, `1`),
		(auto, `min((h_ref / b)^k_h_exp, k_h_max)`)),
	label: "{height-factor}",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "{bending-strength}")
  #eq("f_m_z_d", `k_h_z * f_m_d`,
	label: "{bending-strength}")
  #eq("sigma_m_y_d", `M_y_d / W_y`,
	label: "{bending-stress}",
	norm-section: "4.2.3.1")
  #eq("sigma_m_z_d", `M_z_d / W_z`,
	label: "{bending-stress}",
	norm-section: "4.2.3.1")
  #verify(`sigma_m_y_d / f_m_y_d + sigma_m_z_d / f_m_z_d <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{bending-check}",
	norm-section: "4.2.3.1 (14)")
