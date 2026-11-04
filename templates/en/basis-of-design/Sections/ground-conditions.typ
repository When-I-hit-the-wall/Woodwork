#import "/woodwork/woodwork.typ": *

== Ground

[Type of ground, stratigraphy, hydrogeological conditions (groundwater, slope and seam water) and the source of this information: geotechnical report (author, date). If the investigations are not complete, state those still needed before the design.]

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, right),
    table.hline(stroke: 1pt),
    table.header([*Layer*], [*Description*], [*Depth / thickness*]),
    table.hline(stroke: 0.5pt),
    [[…]], [[…]], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Ground layers],
)

#figure(
  table(
    columns: (auto, auto),
    align: (left, right),
    table.hline(stroke: 1pt),
    table.header([*Water level*], [*Elevation (m a.s.l.)*]),
    table.hline(stroke: 0.5pt),
    [High water (HW)], [[…]],
    [Mean water (MW)], [[…]],
    table.hline(stroke: 1pt),
  ),
  caption: [Design water levels],
)

#figure(rect(width: 100%, height: 5cm, stroke: 0.5pt + luma(60%))[[Figure with caption and source]], caption: [Geological profile / extract from the geotechnical report])
