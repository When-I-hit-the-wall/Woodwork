#import "/woodwork/woodwork.typ": *

= Shear (SIA 265)

#domain("shear",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("V_z_d", 25, "kN",
	label: "Shear force")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("A", `b * h`,
	label: "Cross-sectional area")
  #eq("tau_d", `1.5 * V_z_d / A`,
	label: "Shear stress",
	norm-section: "4.2.5.1")
  #verify(`tau_d <= f_v_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Shear check",
	norm-section: "4.2.5.1 (23)")
]
