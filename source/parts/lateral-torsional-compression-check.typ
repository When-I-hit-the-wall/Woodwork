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
  #var("k_crit",
	from: "sia265/4.2.9-kippen",
	path: "clause.sigma_m_crit_factor",
	label: "{critical-stress-factor}")
  #eq("sigma_m_crit", `k_crit * E_0_05 * b^2 / (a * h)`,
	label: "{critical-bending-stress}",
	norm-section: "4.2.9.3 (41)")
  #eq("lambda_rel_m", `sqrt(f_m_k / sigma_m_crit)`,
	label: "{relative-slenderness-m}",
	norm-section: "4.2.9.3 (40)")
  #eq("k_m",
	cases: (
		(`lambda_rel_m <= 0.75`, `1`),
		(`lambda_rel_m <= 1.4`, `1.56 - 0.75 * lambda_rel_m`),
		(auto, `1 / lambda_rel_m^2`)),
	label: "{lateral-factor}",
	norm-section: "4.2.9.2 (39)")
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
  #verify(`(sigma_c_0_d / f_c_0_d)^2 + sigma_m_y_d / f_m_y_d <= 1`,
	name-calc: "eta_s",
	name-visible: "eta",
	label: "{section-check}",
	norm-section: "4.2.4.2 (22)")
  #verify(`sigma_c_0_d / (k_c_y * f_c_0_d) + sigma_m_y_d / (k_m * f_m_y_d) <= 1`,
	name-calc: "eta_y",
	name-visible: "eta",
	label: "{buckling-check-y}",
	norm-section: "4.2.8.5 (37)")
  #verify(`sigma_c_0_d <= k_c_z * f_c_0_d`,
	name-calc: "eta_z",
	name-visible: "eta",
	label: "{buckling-check-z}",
	norm-section: "4.2.8.1 (29)")
