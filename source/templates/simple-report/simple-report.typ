// {simple-report-about}
#import "/woodwork/woodwork.typ": *
#import "/woodwork/forms/bfh.typ": bfh, bfh-grey, bfh-yellow, muted
#set text(lang: "{language-code}")
#show: bfh.with(chapter-break: false)

// @insert title-fields

#block(below: 1cm)[
  #line(length: 2.5cm, stroke: 3pt + bfh-yellow)
  #v(0.3cm)
  #text(size: 10pt, fill: muted, tracking: 0.12em, upper(document))
  #v(0.1cm)
  #block(text(size: 22pt, weight: "bold", fill: bfh-grey, project))
  #if number != "" [
    #block(text(size: 11pt, fill: muted, number))
  ]
  #v(0.4cm)
  #set text(size: 10pt)
  #grid(columns: (3.8cm, 1fr), row-gutter: 0.6em,
    ..rows.filter(r => r.at(1).len() > 0).map(r => (text(fill: muted, r.at(0)), r.at(1).map(x => [#x]).join(linebreak()))).flatten())
  #if day != none [
    #v(0.3cm)
    #text(size: 10pt, day)
  ]
]

= {heading-section}

// {simple-report-calc-help}

= {heading-appendices}

// {simple-report-annex-help}
