  #eq("tau_d", `1.5 * V_z_d / A`,
	label: "{shear-stress}",
	norm-section: "4.2.5.1")
  #verify(`tau_d <= f_v_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "{shear-check}",
	norm-section: "4.2.5.1 (23)")
