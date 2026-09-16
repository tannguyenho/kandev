#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export HOME="${KANDEV_REPLIT_HOME:-$ROOT_DIR/.kandev-home}"
export PATH="$ROOT_DIR/scripts/bin:$PATH"
mkdir -p "$HOME"

exec npx --yes kandev@0.94.0 run \
  --port "${PORT:-5000}" \
  --headless \
  --verbose