#!/usr/bin/env bash
# Validates that all files in img/ follow the naming convention:
#   dots (.) in the domain are replaced with underscores (_)
#   hyphens (-) are preserved
#   Example: elearning.rcaap.pt -> elearning_rcaap_pt.png

set -euo pipefail

IMG_DIR="$(dirname "$0")/img"
ERRORS=()

if [[ ! -d "$IMG_DIR" ]]; then
  echo "ERROR: img/ directory not found at $IMG_DIR"
  exit 1
fi

for filepath in "$IMG_DIR"/*; do
  filename="$(basename "$filepath")"

  # Skip non-files (e.g. subdirectories)
  [[ -f "$filepath" ]] || continue

  # Valid pattern: lowercase letters, digits, underscores, hyphens — then a dot and extension
  if [[ ! "$filename" =~ ^[a-z0-9_-]+\.(png|jpg|jpeg|gif|svg)$ ]]; then
    ERRORS+=("  $filename")
  fi
done

if [[ ${#ERRORS[@]} -eq 0 ]]; then
  echo "All $(ls "$IMG_DIR" | wc -l | tr -d ' ') files follow the naming convention."
  exit 0
fi

echo "The following files do not follow the naming convention:"
echo "(dots in domain names must be replaced with underscores)"
echo ""
for err in "${ERRORS[@]}"; do
  echo "$err"
done
echo ""
echo "Example fix: 'example.gov.pt.png' should be 'example_gov_pt.png'"
exit 1
