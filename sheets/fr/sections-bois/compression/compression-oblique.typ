#import "/woodwork/woodwork.typ": *

= Compression biaise par rapport au fil (SIA 265)

#domain("compression-angle",
	preset: "report",
	norm: "SIA 265")[
  #material("GL24h",
	moisture: 1)
  #var("F_c_alpha_d", 80, "kN",
	label: "Force d'appui")
  #var("alpha", 30, "°",
	label: "Angle par rapport au fil")
  #var("l_c", 160, "mm",
	label: "Longueur d'appui")
  #var("w_c", 140, "mm",
	label: "Largeur d'appui")
  #eq("A_c", `l_c * w_c`,
	label: "Surface d'appui")
  #eq("f_c_alpha_d", `f_c_90_d * f_c_0_d / (f_c_0_d * sin(alpha)^2 + f_c_90_d * cos(alpha)^2)`,
	label: "Résistance à la compression biaise",
	norm-section: "4.2.2.3 (13)")
  #eq("sigma_c_alpha_d", `F_c_alpha_d / A_c`,
	label: "Contrainte de compression",
	norm-section: "4.2.2.3")
  #verify(`sigma_c_alpha_d <= f_c_alpha_d`,
	name-calc: "eta",
	name-visible: "eta",
	label: "Vérification compression",
	norm-section: "4.2.2.3 (12)")
]
