// {title-bfh-about}
#import "/woodwork/forms/bfh.typ": sans, bfh-grey, bfh-yellow, muted

// @insert title-fields

#page(header: none, footer: none, margin: (top: 2cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm))[
  #set text(font: sans)
  #image("/woodwork/forms/bfh-logo.png", width: 7.5cm)
  #v(0.6cm)
  #text(size: 10pt, fill: bfh-grey)[{bfh-department} \ {bfh-programme}]

  #v(1fr)

  #line(length: 2.5cm, stroke: 3pt + bfh-yellow)
  #v(0.5cm)
  #text(size: 11pt, fill: muted, tracking: 0.12em, upper(document))
  #v(0.2cm)
  #block(text(size: 28pt, weight: "bold", fill: bfh-grey, project))
  #if number != "" [
    #v(0.1cm)
    #block(text(size: 12pt, fill: muted, number))
  ]

  #v(1.5cm)

  #set text(size: 10pt)
  #grid(columns: (3.8cm, 1fr), row-gutter: 0.7em,
    ..rows.filter(r => r.at(1).len() > 0).map(r => (text(fill: muted, r.at(0)), r.at(1).map(x => [#x]).join(linebreak()))).flatten())

  #v(1fr)

  #if day != none [{bfh-place}, #day]
]
