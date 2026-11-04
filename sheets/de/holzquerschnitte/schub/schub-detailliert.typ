#import "/woodwork/woodwork.typ": *

= Schub (SIA 265)

Schub parallel zur Faserrichtung, Rechteckquerschnitt: τ_d = 1.5 · V_d / A im Schwerpunkt.

#figure(
	image("/woodwork/figures/shear.svg", width: 9cm),
	caption: [Schub])

#domain("shear",
	preset: "report",
	norm: "SIA 265")[
  #emph[Baustoff]
  #material("GL24h",
	moisture: 1,
	print: ("f_v_d",))

  #emph[Beanspruchung und Querschnitt]
  #var("V_z_d", 25, "kN",
	label: "Querkraft")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 240, "mm",
	label: "Höhe")
  #eq("A", `b * h`,
	label: "Querschnittsfläche")

  #emph[Nachweis]
  #eq("tau_d", `1.5 * V_z_d / A`,
	label: "Schubspannung",
	norm-section: "4.2.5.1")
  #verify(`tau_d <= f_v_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Schub",
	norm-section: "4.2.5.1 (23)")
]
