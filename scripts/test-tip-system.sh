#!/usr/bin/env bash
# Wrapper for backward compatibility. New location: scripts/testing/test-tip-system.sh
set -euo pipefail
ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
exec "$ROOT_DIR/scripts/testing/test-tip-system.sh" "$@"