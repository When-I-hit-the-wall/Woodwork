  #var("N_c_d", 80, "kN",
	label: "{compression-force}")
  #var("M_y_d", 40, "kNm",
	label: "{bending-moment-y}")
  #var("b", 140, "mm",
	label: "{section-width}")
  #var("h", 400, "mm",
	label: "{section-height}")
  #eq("W_y", `b * h^2 / 6`,
	label: "{section-modulus-y}")
  #var("a", 3000, "mm",
	label: "{lateral-support-distance}")
  #var("h_ref",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.reference_height",
	unit: "mm",
	label: "{reference-height}")
  #var("k_h_exp",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.exponent",
	label: "{height-factor-exponent}")
  #var("k_h_max",
	from: "sia265/3.4.2.3-k-h",
	path: "clause.maximum",
	label: "{height-factor-maximum}")
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
