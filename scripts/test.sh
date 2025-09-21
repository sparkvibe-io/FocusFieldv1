#!/usr/bin/env bash
set -euo pipefail

# Focus Field test wrapper: formats, analyzes, then runs tests compactly.

echo "🔧 Formatting (check only)..."
dart format --set-exit-if-changed . || { echo "::error::Formatting issues found"; exit 2; }

echo "🔎 Analyzing..."
flutter analyze

echo "🧪 Running tests..."
flutter test -r compact

echo "✅ All checks passed"
