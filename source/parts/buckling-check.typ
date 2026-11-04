  #eq("i_y", `h / sqrt(12)`,
	label: "{radius-of-gyration-y}")
  #eq("l_k_y", `beta_y * l_y`,
	label: "{buckling-length-y}")
  #eq("lambda_y", `l_k_y / i_y`,
	label: "{slenderness-y}")
  #eq("lambda_rel_y", `lambda_y / pi * sqrt(f_c_0_k / E_0_05)`,
	label: "{relative-slenderness-y}",
	norm-section: "4.2.8.4 (34)")
  #eq("k_y", `k_0 * (1 + beta_c * (lambda_rel_y - lambda_0) + lambda_rel_y^2)`,
	label: "{buckling-auxiliary-y}",
	norm-section: "4.2.8.2 (31)")
  #eq("k_c_y",
	cases: (
		(`lambda_rel_y <= lambda_lim`, `1`),
		(auto, `1 / (k_y + sqrt(k_y^2 - lambda_rel_y^2))`)),
	label: "{buckling-factor-y}",
	norm-section: "4.2.8.2 (30)")
  #eq("i_z", `b / sqrt(12)`,
	label: "{radius-of-gyration-z}")
  #eq("l_k_z", `beta_z * l_z`,
	label: "{buckling-length-z}")
  #eq("lambda_z", `l_k_z / i_z`,
	label: "{slenderness-z}")
  #eq("lambda_rel_z", `lambda_z / pi * sqrt(f_c_0_k / E_0_05)`,
	label: "{relative-slenderness-z}",
	norm-section: "4.2.8.4 (34)")
  #eq("k_z", `k_0 * (1 + beta_c * (lambda_rel_z - lambda_0) + lambda_rel_z^2)`,
	label: "{buckling-auxiliary-z}",
	norm-section: "4.2.8.2 (31)")
  #eq("k_c_z",
	cases: (
		(`lambda_rel_z <= lambda_lim`, `1`),
		(auto, `1 / (k_z + sqrt(k_z^2 - lambda_rel_z^2))`)),
	label: "{buckling-factor-z}",
	norm-section: "4.2.8.2 (30)")
  #eq("sigma_c_0_d", `N_c_d / A`,
	label: "{compressive-stress}")
  #verify(`sigma_c_0_d <= k_c_y * f_c_0_d`,
	name-calc: "eta_y",
	name-visible: "eta",
	label: "{buckling-check-y}",
	norm-section: "4.2.8.1 (29)")
  #verify(`sigma_c_0_d <= k_c_z * f_c_0_d`,
	name-calc: "eta_z",
	name-visible: "eta",
	label: "{buckling-check-z}",
	norm-section: "4.2.8.1 (29)")
