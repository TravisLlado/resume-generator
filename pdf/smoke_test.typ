// pdf/smoke_test.typ - verifies the toolchain end-to-end. Not a real résumé.
#import "template.typ": resume, section, entry

#show: resume.with(
  name: "Smoke Test",
  contact-line: "test@example.com | (555) 000-0000 | Nowhere, XX",
)

#section("Summary")
This document exists only to verify that Typst, the template, and the render
script all work on this machine. If this compiles to a PDF and a PNG preview,
the toolchain is functional.

#section("Professional Experience")
#entry("Test Engineer", "Toolchain Verification Inc.", "2026 - Present")[
  - Compiled a document containing a list, an entry, and a section header.
  - Confirmed special characters render when escaped: C\#, 100\%, \$1M, R\&D.
]

#section("Education")
#entry("B.S. Existence", "University of Smoke Tests", "2020")[]
