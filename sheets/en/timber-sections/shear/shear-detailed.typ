#import "/woodwork/woodwork.typ": *

= Shear (SIA 265)

Shear parallel to the grain, rectangular section: τ_d = 1.5 · V_d / A at the centroid.

#figure(
	image("/woodwork/figures/shear.svg", width: 9cm),
	caption: [Shear])

#domain("shear",
	preset: "report",
	norm: "SIA 265")[
  #emph[Material]
  #material("GL24h",
	moisture: 1,
	print: ("f_v_d",))

  #emph[Action effect and cross-section]
  #var("V_z_d", 25, "kN",
	label: "Shear force")
  #var("b", 140, "mm",
	label: "Width")
  #var("h", 240, "mm",
	label: "Height")
  #eq("A", `b * h`,
	label: "Cross-sectional area")

  #emph[Check]
  #eq("tau_d", `1.5 * V_z_d / A`,
	label: "Shear stress",
	norm-section: "4.2.5.1")
  #verify(`tau_d <= f_v_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Shear check",
	norm-section: "4.2.5.1 (23)")
]
