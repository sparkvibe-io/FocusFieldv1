#!/usr/bin/env bash
# Wrapper for backward compatibility. New location: scripts/build/build-prod.sh
set -euo pipefail
ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
exec "$ROOT_DIR/scripts/build/build-prod.sh" "$@"