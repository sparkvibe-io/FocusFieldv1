#!/usr/bin/env bash
# Summarize line coverage from coverage/lcov.info with per-file ranking.
# Outputs: overall coverage, top N lowest covered source files.
set -euo pipefail

LCOV_FILE="coverage/lcov.info"
TOP_N="${TOP_N:-15}"

if [[ ! -f "$LCOV_FILE" ]]; then
  echo "No coverage file at $LCOV_FILE (run tests with --coverage first)" >&2
  exit 0
fi

# Overall stats
TOTAL_LINES=$(grep -h '^DA:' "$LCOV_FILE" | wc -l | tr -d ' ')
  COVERED_LINES=$(grep -h '^DA:' "$LCOV_FILE" | awk -F',' '{ if($2>0) c++ } END {print c+0}')
PCT=0
if [[ "$TOTAL_LINES" -gt 0 ]]; then
  PCT=$(( 100 * COVERED_LINES / TOTAL_LINES ))
fi

echo "==== Coverage Summary ===="
echo "Overall line coverage: ${PCT}% (${COVERED_LINES}/${TOTAL_LINES})"

echo "Collecting per-file coverage..." >&2
TMP_ALL=$(mktemp)
awk -F',' '
  /^SF:/ {if (f!="") { printf "%s\t%d\t%d\n", f, covered, total; } f=$0; sub(/^SF:/, "", f); total=0; covered=0 }
  /^DA:/ { total++; if ($2 > 0) covered++ }
  /^end_of_record/ { if (f!="") { printf "%s\t%d\t%d\n", f, covered, total; } f=""; total=0; covered=0 }
  END { if (f!="") { printf "%s\t%d\t%d\n", f, covered, total; } }
' "$LCOV_FILE" > "$TMP_ALL"

# Filter out generated & external files
FILTERED=$(mktemp)
grep -v -E '(/build/|\.g\.dart$|\.freezed\.dart$|generated_plugin_registrant|_localizations.dart$)' "$TMP_ALL" > "$FILTERED" || true

# Compute percentages and sort ascending by coverage
TMP_PCT=$(mktemp)
awk '
  { f=$1; cov=$2; tot=$3; pct=(tot>0? (100*cov/tot):0); printf "%s\t%.2f\t%d/%d\n", f, pct, cov, tot }
' "$FILTERED" | sort -k2,2n > "$TMP_PCT"

COUNT=$(wc -l < "$TMP_PCT" | tr -d ' ')
if [[ "$COUNT" -eq 0 ]]; then
  echo "No non-generated files to report." >&2
  rm -f "$TMP_ALL" "$FILTERED" "$TMP_PCT"
  exit 0
fi

echo "\nLowest covered files (bottom ${TOP_N}):"
head -n "$TOP_N" "$TMP_PCT" | awk -F'\t' '{ printf "  %-6s %s (%s)\n", $2"%", $1, $3 }'

echo -e "\nHighest covered files (top ${TOP_N}):"
if command -v tac >/dev/null 2>&1; then
  tac "$TMP_PCT" | head -n "$TOP_N" | awk -F'\t' '{ printf "  %-6s %s (%s)\n", $2"%", $1, $3 }'
else
  # Fallback for systems without tac (e.g., macOS default)
  tail -r "$TMP_PCT" | head -n "$TOP_N" | awk -F'\t' '{ printf "  %-6s %s (%s)\n", $2"%", $1, $3 }'
fi

rm -f "$TMP_ALL" "$FILTERED" "$TMP_PCT"

echo "==== End Coverage Summary ===="
