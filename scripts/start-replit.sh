#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export HOME="${KANDEV_REPLIT_HOME:-$ROOT_DIR/.kandev-home}"
# Keep Kandev-managed tools isolated from Replit's shared XDG config. In
# particular, a pre-existing ~/.config/code-server/config.yaml can otherwise
# override the embedded editor's port/auth settings.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
mkdir -p "$HOME"

# Kandev's Host terminal inherits this environment. npm's default global
# prefix points into the immutable Nix store, so `npm install -g` would fail
# with EACCES. Keep agent CLIs in persistent, writable project storage.
NPM_GLOBAL_PREFIX="$HOME/.npm-global"
NPM_CACHE_DIR="${npm_config_cache:-$HOME/.npm}"
NPM_REGISTRY_URL="${npm_config_registry:-${NPM_CONFIG_REGISTRY:-}}"

# pnpm exports its workspace-only settings as npm_config_* variables. They
# are not valid npm settings and make npm print "Unknown env config" warnings.
while IFS='=' read -r config_name _; do
  unset "$config_name"
done < <(env | sed -n 's/^\(NPM_CONFIG_[A-Za-z0-9_]*\|npm_config_[A-Za-z0-9_]*\)=.*/\1/p')

export NPM_CONFIG_PREFIX="$NPM_GLOBAL_PREFIX"
export npm_config_prefix="$NPM_GLOBAL_PREFIX"
export npm_config_cache="$NPM_CACHE_DIR"
export npm_config_userconfig="$HOME/.npmrc"
if [[ -n "$NPM_REGISTRY_URL" ]]; then
  export NPM_CONFIG_REGISTRY="$NPM_REGISTRY_URL"
  export npm_config_registry="$NPM_REGISTRY_URL"
fi
export PATH="$NPM_GLOBAL_PREFIX/bin:$ROOT_DIR/scripts/bin:$PATH"
mkdir -p "$NPM_GLOBAL_PREFIX" "$NPM_GLOBAL_PREFIX/bin" "$NPM_CACHE_DIR" \
  "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME"

# Kandev receives its listener through the explicit --port argument below.
# Leaving Replit's PORT in the child environment makes code-server reuse the
# Kandev port, ignoring its own allocated --bind-addr and exiting with
# EADDRINUSE.
KANDEV_PORT="${PORT:-5000}"
unset PORT

exec npx --yes kandev@0.94.0 run \
  --port "$KANDEV_PORT" \
  --headless \
  --verbose