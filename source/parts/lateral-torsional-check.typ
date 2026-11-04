  #eq("k_h_y",
	cases: (
		(`h >= h_ref`, `1`),
		(auto, `min((h_ref / h)^k_h_exp, k_h_max)`)),
	label: "{height-factor}",
	norm-section: "3.4.2.3 (5)")
  #eq("f_m_y_d", `k_h_y * f_m_d`,
	label: "{bending-strength}")
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
  #verify(`sigma_m_y_d <= k_m * f_m_y_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{lateral-check}",
	norm-section: "4.2.9.1 (38)")
