#import "/woodwork/woodwork.typ": *

= Zug unter einem Winkel zur Faserrichtung (SIA 265)

Zugbeanspruchung unter einem Winkel α zur Faserrichtung.

#figure(
	image("/woodwork/figures/tension-angle.svg", width: 9cm),
	caption: [Zug unter einem Winkel zur Faserrichtung])

#domain("tension-angle",
	preset: "report",
	norm: "SIA 265")[
  #emph[Baustoff]
  #material("GL24h",
	moisture: 1,
	print: ("f_t_0_d", "f_t_90_d"))

  #emph[Beanspruchung und Querschnitt]
  #var("N_t_d", 20, "kN",
	label: "Zugkraft")
  #var("alpha", 10, "°",
	label: "Winkel zur Faserrichtung")
  #var("b", 140, "mm",
	label: "Breite")
  #var("h", 240, "mm",
	label: "Höhe")
  #eq("A", `b * h`,
	label: "Querschnittsfläche")

  #emph[Nachweis]
  #eq("f_t_alpha_d", `f_t_90_d * f_t_0_d / (f_t_0_d * sin(alpha)^2 + f_t_90_d * cos(alpha)^2)`,
	label: "Zugfestigkeit unter dem Winkel",
	norm-section: "4.2.1.3 (9)")
  #eq("sigma_t_alpha_d", `N_t_d / A`,
	label: "Zugspannung",
	norm-section: "4.2.1.3")
  #verify(`sigma_t_alpha_d <= f_t_alpha_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Nachweis Zug",
	norm-section: "4.2.1.3 (8)")
]
