  #var("N_c_d", 150, "kN",
	label: "{compression-force}")
  #var("b", 160, "mm",
	label: "{section-width}")
  #var("h", 160, "mm",
	label: "{section-height}")
  #eq("A", `b * h`,
	label: "{cross-sectional-area}")
  #var("l_y", 3200, "mm",
	label: "{system-length-y}")
  #var("l_z", 3200, "mm",
	label: "{system-length-z}")
  #var("beta_y", 1.0, "",
	label: "{length-coefficient-y}")
  #var("beta_z", 1.0, "",
	label: "{length-coefficient-z}")
  #var("beta_c",
	from: "sia265/4.2.8-knicken",
	path: "clause.beta_c.Brettschichtholz",
	label: "{imperfection-factor}")
  #var("k_0",
	from: "sia265/4.2.8-knicken",
	path: "clause.k_factor",
	label: "{buckling-constant}")
  #var("lambda_0",
	from: "sia265/4.2.8-knicken",
	path: "clause.lambda_rel_offset",
	label: "{slenderness-offset}")
  #var("lambda_lim",
	from: "sia265/4.2.8-knicken",
	path: "clause.lambda_rel_limit",
	label: "{slenderness-limit}")
