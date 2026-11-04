#import "/woodwork/woodwork.typ": *

= Druck unter einem Winkel zur Faserrichtung (SIA 265)

Kontakt unter einem Winkel α zur Faserrichtung, auf der Fläche l · w.

#figure(
	image("/woodwork/figures/compression-angle.svg", width: 9cm),
	caption: [Druck unter einem Winkel zur Faserrichtung])

#domain("compression-angle",
	preset: "report",
	norm: "SIA 265")[
  #emph[Baustoff]
  #material("GL24h",
	moisture: 1,
	print: ("f_c_0_d", "f_c_90_d"))

  #emph[Beanspruchung und Querschnitt]
  #var("F_c_alpha_d", 80, "kN",
	label: "Auflagerkraft")
  #var("alpha", 30, "°",
	label: "Winkel zur Faserrichtung")
  #var("l_c", 160, "mm",
	label: "Auflagerlänge")
  #var("w_c", 140, "mm",
	label: "Auflagerbreite")
  #eq("A_c", `l_c * w_c`,
	label: "Auflagerfläche")

  #emph[Nachweis]
  #eq("f_c_alpha_d", `f_c_90_d * f_c_0_d / (f_c_0_d * sin(alpha)^2 + f_c_90_d * cos(alpha)^2)`,
	label: "Druckfestigkeit unter dem Winkel",
	norm-section: "4.2.2.3 (13)")
  #eq("sigma_c_alpha_d", `F_c_alpha_d / A_c`,
	label: "Druckspannung",
	norm-section: "4.2.2.3")
  #verify(`sigma_c_alpha_d <= f_c_alpha_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Druck",
	norm-section: "4.2.2.3 (12)")
]
