// {title-neutral-about}

// @insert title-fields

#page(header: none, footer: none)[
  #align(center)[
    #v(4cm)
    #text(size: 20pt, weight: "bold", document)
    #v(0.5cm)
    #text(size: 14pt, project)
    #if number != "" [
      #v(0.2cm)
      #text(size: 11pt, number)
    ]
    #v(2cm)
    #set text(size: 11pt)
    #grid(columns: (auto, auto), column-gutter: 1.2em, row-gutter: 0.8em, align: (right + top, left + top),
      ..rows.filter(r => r.at(1).len() > 0).map(r => (r.at(0), r.at(1).map(x => [#x]).join(linebreak()))).flatten())
    #if day != none [
      #v(1.5cm)
      #day
    ]
  ]
]
