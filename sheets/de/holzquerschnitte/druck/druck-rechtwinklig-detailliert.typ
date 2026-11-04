#import "/woodwork/woodwork.typ": *

= Druck rechtwinklig zur Faserrichtung (SIA 265)

Auflager: die Kraft auf der Auflagerfläche l · w, f_c,90,d des Falls «generell» der Tabellen 8 und 9.

#figure(
	image("/woodwork/figures/compression-perpendicular.svg", width: 9cm),
	caption: [Druck rechtwinklig zur Faserrichtung])

#domain("compression-perpendicular",
	preset: "report",
	norm: "SIA 265")[
  #emph[Baustoff]
  #material("GL24h",
	moisture: 1,
	case: "generell",
	print: ("f_c_90_d",))

  #emph[Beanspruchung und Querschnitt]
  #var("F_c_90_d", 35, "kN",
	label: "Auflagerkraft")
  #var("l_c", 160, "mm",
	label: "Auflagerlänge")
  #var("w_c", 140, "mm",
	label: "Auflagerbreite")
  #eq("A_c", `l_c * w_c`,
	label: "Auflagerfläche")

  #emph[Nachweis]
  #eq("sigma_c_90_d", `F_c_90_d / A_c`,
	label: "Druckspannung",
	norm-section: "4.2.2.2")
  #verify(`sigma_c_90_d <= f_c_90_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Druck",
	norm-section: "4.2.2.2 (11)")
]
