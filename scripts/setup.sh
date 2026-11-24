#!/usr/bin/env bash
# Fetch shared libraries, install dev tools + git hooks, verify the environment.
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
echo "Fetching libraries (git submodules)…"
git submodule update --init --recursive
if command -v mise >/dev/null 2>&1; then
  echo "Installing dev tools (mise.toml) and git hooks (lefthook.yml)…"
  mise trust --quiet "$ROOT/mise.toml"
  mise install
  mise exec -- lefthook install
else
  echo "mise not found — install it (https://mise.jdx.dev) to get the formatter and git hooks." >&2
fi
exec "$ROOT/scripts/check-openscad.sh"
