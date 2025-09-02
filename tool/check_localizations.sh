#!/usr/bin/env bash
set -euo pipefail

## NOTE: Avoid bash 4+ only features (macOS runner uses bash 3.2). Using portable loops instead of mapfile/readarray.

echo "[check_localizations] Running flutter gen-l10n..."
flutter gen-l10n

# Detect uncommitted diffs after generation, but only fail if they are l10n related.
diff_files=$(git diff --name-only || true)
if [[ -n "$diff_files" ]]; then
  loc_changed=$(echo "$diff_files" | grep -E '^(lib/l10n/.*\.arb$|lib/l10n/.*\.dart$)' || true)
  if [[ -n "$loc_changed" ]]; then
    echo "::error::Localization artifacts are outdated. Run 'flutter gen-l10n' and commit changes. Changed l10n files:" >&2
    echo "$loc_changed" | tr '\n' '\n' >&2
    exit 1
  fi
  # Show ignored non-l10n changes (noise from plugin registrants, lockfiles, etc.)
  echo "[check_localizations] Ignoring non-localization diffs after gen-l10n:" >&2
  echo "$diff_files" >&2
fi

# Validate ARB key parity across locales (ignore metadata keys starting with @)
ARB_DIR="lib"
arb_files=()
while IFS= read -r f; do
  arb_files+=("$f")
done < <(git ls-files '*.arb')
if (( ${#arb_files[@]} == 0 )); then
  echo "No ARB files found (skipping parity check)"
  exit 0
fi

ref_file="lib/l10n/app_en.arb"
if [[ ! -f "$ref_file" ]]; then ref_file=${arb_files[0]}; fi
extract_keys() {
  local file="$1"
  if command -v jq >/dev/null 2>&1; then
    # jq prints all top-level keys; filter out metadata starting with @
    jq -r 'keys[]' "$file" | grep -v '^@' | sort -u
  else
    # Fallback grep/sed parsing (format dependent)
    grep '".*":' "$file" | sed -E 's/^\s*,?\s*"([^"]+)":.*/\1/' | grep -v '^@' | sort -u
  fi
}

ref_keys=()
while IFS= read -r k; do ref_keys+=("$k"); done < <(extract_keys "$ref_file")
missing_report=()
for f in "${arb_files[@]}"; do
  keys=()
  while IFS= read -r k; do keys+=("$k"); done < <(extract_keys "$f")
  for k in "${ref_keys[@]}"; do
    if ! printf '%s\n' "${keys[@]}" | grep -qx "$k"; then
        # Double-check directly in file to avoid false positives due to parsing edge cases
        if ! grep -q '"'"$k"'"[[:space:]]*:' "$f"; then
          missing_report+=("$f -> missing key: $k")
        fi
    fi
  done
  # Also ensure no extra keys (excluding metadata) compared to ref
  for k in "${keys[@]}"; do
    if ! printf '%s\n' "${ref_keys[@]}" | grep -qx "$k"; then
      missing_report+=("$f -> extra key (not in reference): $k")
    fi
  done
done

if (( ${#missing_report[@]} > 0 )); then
  echo '::error::Localization key parity failure:' >&2
  for line in "${missing_report[@]}"; do echo "$line" >&2; done
  exit 1
fi

echo "[check_localizations] All localization artifacts up to date and keys consistent."
