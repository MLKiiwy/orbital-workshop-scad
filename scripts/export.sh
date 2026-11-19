#!/usr/bin/env bash
# Export a .scad model to STL/3MF into <project>/exports/.
# Usage: scripts/export.sh <file.scad> [stl|3mf|png] [-D name=value ...]
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ $# -lt 1 ] || [ ! -f "$1" ]; then
  echo "Usage: $0 <file.scad> [stl|3mf|png] [-D name=value ...]" >&2
  exit 2
fi

src="$1"; shift
fmt="stl"
if [ $# -gt 0 ] && [[ "$1" != -* ]]; then fmt="$1"; shift; fi

bin="$(command -v openscad || true)"
[ -z "$bin" ] && [ -x /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD ] && bin=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
if [ -z "$bin" ]; then "$ROOT/scripts/check-openscad.sh"; exit 1; fi

dir="$(cd "$(dirname "$src")" && pwd)"
name="$(basename "$src" .scad)"
mkdir -p "$dir/exports"
out="$dir/exports/$name.$fmt"

# Prefer the Manifold backend when supported (much faster).
backend=()
"$bin" --help 2>&1 | grep -q -- '--backend' && backend=(--backend=manifold)

export OPENSCADPATH="$ROOT/libs${OPENSCADPATH:+:$OPENSCADPATH}"
echo "Rendering $src -> $out"
"$bin" ${backend[@]+"${backend[@]}"} --hardwarnings -o "$out" "$@" "$src"
echo "Done: $out"
