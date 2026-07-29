// pdf/template.typ
// Layout and styling for all generated résumés.
// NEVER edit this file during résumé generation. Per-run tuning happens
// only through the parameters of resume(), set from the content file.
//
// Tunable parameters and their ALLOWED RANGES (do not exceed):
//   font-size:  9.5pt – 10.5pt   (default 10pt)
//   leading:    0.65em – 1.0em   (default 0.75em; approx 1.2x–1.5x line spacing)
//   margin:     1.4cm – 2.0cm per side (default x: 1.7cm, y: 1.6cm)

// Space between any heading (section or entry) and the content that follows
// it. Shared so a section heading and an item heading read with the same
// rhythm rather than two independently-tuned magic numbers.
#let heading-gap = 0.4em

#let resume(
  name: "",
  contact-line: "",
  font-size: 10pt,
  leading: 0.75em,
  margin: (x: 1.7cm, y: 1.6cm),
  body
) = {
  set page(paper: "us-letter", margin: margin)
  set text(
    font: ("Georgia", "Noto Serif", "Libertinus Serif"),
    size: font-size,
  )
  set par(leading: leading, justify: false)
  set list(marker: [•], indent: 0.5em, body-indent: 0.5em, spacing: leading)

  // Header: name centered, contact info on one line beneath it.
  align(center)[
    #text(size: font-size * 1.7, weight: "bold")[#name]
    #v(0.4em)
    #text(size: font-size * 0.95)[#contact-line]
  ]
  v(0.6em)
  body
}

// Section header: bold uppercase title with a thin rule beneath.
//
// Note: spacing here is intentionally NOT `weak: true`. Typst collapses weak
// spacing to zero when it sits between two non-breakable `block()` elements
// (as title/org/dates and section-header blocks are), so weak v() silently
// vanished instead of producing a gap. Resolved (non-weak) v() is required.
#let section(title) = {
  v(1em)
  block(breakable: false)[
    #text(size: 1.05em, weight: "bold", tracking: 0.03em)[#upper(title)]
    #v(-0.55em)
    #line(length: 100%, stroke: 0.6pt)
  ]
  v(heading-gap)
}

// One job, project, or education entry.
// Usage: #entry("Title", "Organization", "2021 - Present")[ ...bullets... ]
// Pass an empty body for entries with no bullets: #entry(...)[]
// See the note on section() above re: why this spacing is not `weak: true`.
#let entry(title, org, dates, body) = {
  v(0.55em)
  block(breakable: false, grid(
    columns: (1fr, auto),
    column-gutter: 1em,
    [*#title*, #org],
    text(size: 0.95em)[#dates],
  ))
  v(heading-gap)
  body
}
