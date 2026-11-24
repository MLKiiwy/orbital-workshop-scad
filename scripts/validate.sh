#!/usr/bin/env bash
# Strict validation of .scad files with the openscad Claude skill's validator
# (.claude/skills/openscad/scripts/openscad-validate.sh): full render with
# --hardwarnings and Customizer parameter/range checks; any warning fails.
#
# Usage: scripts/validate.sh [--render] [file.scad ...]
#   no files  : all tracked project .scad files (scripts/scad-files.sh)
#   --render  : also export each project's main model (scripts/export.sh) and,
#               when makerworld.json exists, generate and render its MakerWorld copy
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

render=0
if [ "${1:-}" = "--render" ]; then render=1; shift; fi

files=()
if [ $# -gt 0 ]; then
  files=("$@")
else
  while IFS= read -r f; do files+=("$f"); done < <(scripts/scad-files.sh)
fi
[ ${#files[@]} -eq 0 ] && { echo "validate: no .scad files"; exit 0; }

validator="$ROOT/.claude/skills/openscad/scripts/openscad-validate.sh"
if [ ! -f "$validator" ]; then
  echo "✘ openscad skill missing — run: git submodule update --init --recursive" >&2
  exit 1
fi

if [ -z "${OPENSCAD_BIN:-}" ]; then
  OPENSCAD_BIN="$(command -v openscad || true)"
  [ -z "$OPENSCAD_BIN" ] && [ -x /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD ] \
    && OPENSCAD_BIN=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
  [ -z "$OPENSCAD_BIN" ] && { scripts/check-openscad.sh; exit 1; }
fi
export OPENSCAD_BIN
export OPENSCADPATH="$ROOT/libs${OPENSCADPATH:+:$OPENSCADPATH}"

failed=0
for f in "${files[@]}"; do
  out="$(bash "$validator" "$f" 2>&1)"
  rc=$?
  if [ $rc -eq 0 ] && grep -qx 'Category: OK' <<<"$out"; then
    echo "✔ valid: $f"
  else
    echo "✘ invalid: $f (exit $rc)"
    grep -v '^ECHO:' <<<"$out" | sed 's/^/    /'
    failed=1
  fi
done

if [ $render -eq 1 ]; then
  for f in "${files[@]}"; do
    dir="$(dirname "$f")"; name="$(basename "$dir")"
    [ "$f" = "$dir/$name.scad" ] || continue   # project main models only
    scripts/export.sh "$f" || failed=1
    if [ -f "$dir/makerworld.json" ]; then
      python3 scripts/makerworld.py "$f" && scripts/export.sh "$dir/makerworld/$name.scad" stl || failed=1
    fi
  done
fi

exit $failed
