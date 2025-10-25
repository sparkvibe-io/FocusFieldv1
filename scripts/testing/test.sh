#!/usr/bin/env bash

set -euo pipefail

# Simple test runner with optional coverage
# Usage:
#   scripts/testing/test.sh                # run all tests
#   scripts/testing/test.sh --coverage     # run with coverage
#   scripts/testing/test.sh --filter name  # run tests matching name

ROOT_DIR=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT_DIR"

COVERAGE=false
FILTER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --coverage)
      COVERAGE=true
      shift
      ;;
    --filter)
      FILTER="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

echo "🔬 Running Flutter tests"
flutter --version >/dev/null
flutter pub get

if $COVERAGE; then
  if [[ -n "$FILTER" ]]; then
    flutter test --coverage --name "$FILTER"
  else
    flutter test --coverage
  fi
else
  if [[ -n "$FILTER" ]]; then
    flutter test --name "$FILTER"
  else
    flutter test
  fi
fi

echo "✅ Tests completed"
