#import "@preview/cetz:0.4.2"

#figure(cetz.canvas({
import cetz.draw: *
set-style(content: (padding: 5pt))

let t = 2mm
let h = 14mm
let w = 12mm

// Coordinate Axes
line((0, 0), (1, 0), mark: (end: ">"))
content((), anchor: "south", $z$)
line((0, 0), (0, 1), mark: (end: ">"))
content((), anchor: "north-west", $y$)

line(
  (0, h), (-w, h), (-w, h - t), (-t/2, h - t), // top left flange
  (-t/2, - h + t), (-w, -h + t), (-w, -h), // bottom left flange
  (w, -h), (w, -h + t), (t/2, -h + t), // bottom right flange
  (t/2, h - t), (w, h - t), (w, h), (0, h) // top right flange
)

// Centerline
group({
  set-style(stroke: (dash: "dashed"))
  line((-w, h - t/2), (w, h - t/2))
  line((-w, - h + t/2), (w, - h + t/2))
  line((0, - h + t), (0, h - t))
})

// Markings
group({
  set-style(mark: (start: ">", end: ">"))
  line((-1.2*w, h), (-1.2*w, -h), name: "h")
  content("h.mid", $H$, anchor: "east")

  line((-w, 1.2*h), (w, 1.2*h), name: "w")
  content("w.mid", $W$, anchor: "south")
})

// Mark the width t at a specified height (y)
let y = -.7*h
line((-3*t, y), (-t/2, y), mark: (end: ">"))
line((5*t, y), (t/2, y), mark: (end: ">"), name: "t")
content((name: "t", anchor: 35%), $t$, anchor: "south")
line((-t/2, y), (t/2, y))

translate((0, -4))

line((-2, 0), (-2, 2))
for y in range(0, 21, step: 2) {
  line((-2, y/10.0), (rel: (-.15, -.15)))
}
rect((-2, .8), (2, 1.2))

line((2, 1.3), (2, 2), mark: (start: ">"))
content((), anchor: "west", $F$)

line((-2, .5), (2, .5), mark: (symbol: ">"), name: "l")
content("l.mid", $l$, anchor: "north")

}), caption: [I-beam profile (simplified)])