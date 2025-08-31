#!/usr/bin/env bash
set -euo pipefail

echo "[check_localizations] Running flutter gen-l10n..."
flutter gen-l10n

# Detect uncommitted localization diffs after generation
diff_files=$(git diff --name-only)
if [[ -n "$diff_files" ]]; then
  echo "::error::Localization artifacts are outdated. Run 'flutter gen-l10n' and commit changes. Changed files:" >&2
  echo "$diff_files" >&2
  exit 1
fi

# Validate ARB key parity across locales (ignore metadata keys starting with @)
ARB_DIR="lib"
mapfile -t arb_files < <(git ls-files '*.arb')
if (( ${#arb_files[@]} == 0 )); then
  echo "No ARB files found (skipping parity check)"
  exit 0
fi

ref_file=${arb_files[0]}
readarray -t ref_keys < <(grep '".*":' "$ref_file" | sed -E 's/^\s*"([^"]+)":.*/\1/' | grep -v '^@' | sort -u)
missing_report=()
for f in "${arb_files[@]}"; do
  readarray -t keys < <(grep '".*":' "$f" | sed -E 's/^\s*"([^"]+)":.*/\1/' | grep -v '^@' | sort -u)
  for k in "${ref_keys[@]}"; do
    if ! printf '%s\n' "${keys[@]}" | grep -qx "$k"; then
      missing_report+=("$f -> missing key: $k")
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
  printf '::error::Localization key parity failure:\n' >&2
  printf '%s\n' "${missing_report[@]}" >&2
  exit 1
fi

echo "[check_localizations] All localization artifacts up to date and keys consistent."
