#!/usr/bin/env bash
# Fetch shared libraries and verify the environment.
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
set -eu
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
echo "Fetching libraries (git submodules)…"
git submodule update --init --recursive
exec "$ROOT/scripts/check-openscad.sh"
