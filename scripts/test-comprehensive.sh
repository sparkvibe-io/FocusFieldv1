#!/usr/bin/env bash
# Wrapper for backward compatibility. New location: scripts/testing/test-comprehensive.sh
set -euo pipefail
ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
exec "$ROOT_DIR/scripts/testing/test-comprehensive.sh" "$@"