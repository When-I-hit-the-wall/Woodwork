  #verify(`l_a >= l_a_min`,
	name-calc: "l_a_ok",
	name-visible: "l_a_ok",
	label: "{shear-off-length}",
	norm-section: "4.2.6")
  #eq("tau_a_d", `F_a_d / (l_a * w_a)`,
	label: "{shear-stress}",
	norm-section: "4.2.6")
  #verify(`tau_a_d <= k_a * f_v_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{shear-off-check}",
	norm-section: "4.2.6 (27)")
