  #eq("tau_d", `1.5 * V_z_d / A`,
	label: "{shear-stress}",
	norm-section: "4.2.5.1")
  #eq("k_t_90",
	cases: (
		(`sigma_90_d >= 0 "N/mm²"`, `k_t_90_t`),
		(auto, `k_t_90_c`)),
	label: "{factor-transverse}",
	norm-section: "4.2.7.1")
  #verify(`((f_c_90_d + sigma_90_d) / (f_c_90_d + k_t_90 * f_t_90_d))^2 + (tau_d / f_v_d)^2 * (1 - (f_c_90_d / (f_c_90_d + k_t_90 * f_t_90_d))^2) <= 1`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{interaction-check}",
	norm-section: "4.2.7.1 (28)")
