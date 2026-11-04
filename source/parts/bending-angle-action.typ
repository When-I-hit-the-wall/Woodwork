  #var("M_y_d", 10, "kNm",
	label: "{bending-moment-y}")
  #var("b", 140, "mm",
	label: "{section-width}")
  #var("h", 240, "mm",
	label: "{section-height}")
  #eq("W_y", `b * h^2 / 6`,
	label: "{section-modulus-y}")
  #var("alpha", 5, "°",
	label: "{angle-to-grain}")
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
