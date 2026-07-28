#!/usr/bin/env bash
# pdf/render.sh — compile a résumé content file to PDF and per-page PNG previews.
# Usage: bash pdf/render.sh "pdf/output/<name>.typ"
set -euo pipefail

SRC="$1"
STEM="${SRC%.typ}"

if [ ! -f "$SRC" ]; then
  echo "ERROR: $SRC not found" >&2
  exit 1
fi

# Style rule enforced mechanically: no em-dashes anywhere in the document.
if grep -n $'—' "$SRC"; then
  echo "ERROR: em-dash found in $SRC (lines above). Remove before rendering." >&2
  exit 1
fi

rm -f "${STEM}"-preview-*.png

# --root pins Typst's sandbox to the repo root (the directory this script is
# invoked from), since by default it's the input file's own parent directory,
# which is too narrow to let pdf/output/*.typ import ../template.typ.
typst compile --root . "$SRC" "${STEM}.pdf"
typst compile --root . --format png --ppi 96 "$SRC" "${STEM}-preview-{p}.png"

echo "PDF: ${STEM}.pdf"
echo "Previews:"
ls -1 "${STEM}"-preview-*.png
