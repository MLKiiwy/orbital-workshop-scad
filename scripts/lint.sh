#!/usr/bin/env bash
# Lint the project .scad files against the repo rules in CLAUDE.md:
#   - two-line header: "// <Project name> — <purpose>" then the SPDX license
#     (CC-BY-NC-SA-4.0; GPL-3.0-or-later when the file uses NopSCADlib);
#   - libraries in libs/ are included with a relative path (../../libs/<lib>/…),
#     never by bare name, so VSCode, the GUI and the CLI all resolve them;
#   - each project directory has a README.md, a <name>.scad, and a row in the
#     root README Projects table.
# (No generic OpenSCAD linter is used: sca2d cannot parse BOSL2.)
#
# Usage: scripts/lint.sh [file.scad ...]   (default: all tracked project .scad files)
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

files=()
if [ $# -gt 0 ]; then
  files=("$@")
else
  while IFS= read -r f; do files+=("$f"); done < <(scripts/scad-files.sh)
fi

failed=0
err() { echo "✘ $*"; failed=1; }

# Library names = directories in libs/ (BOSL2, NopSCADlib, …), as a regex alternation.
libs_re="$(cd libs && ls -d */ | sed 's#/$##; s/[.]/\\./g' | paste -sd'|' -)"

projects=()
for f in "${files[@]}"; do
  [ -f "$f" ] || continue
  l1="$(sed -n 1p "$f")"
  l2="$(sed -n 2p "$f")"
  [[ "$l1" =~ ^//\ .+\ —\ .+ ]] || err "$f:1: first line must be '// <Project name> — <one-line purpose>'"
  if grep -qE '^[[:space:]]*(include|use)[[:space:]]*<[^>]*NopSCADlib/' "$f"; then
    spdx="GPL-3.0-or-later"
  else
    spdx="CC-BY-NC-SA-4.0"
  fi
  [ "$l2" = "// SPDX-License-Identifier: $spdx" ] || err "$f:2: second line must be '// SPDX-License-Identifier: $spdx'"

  while IFS= read -r hit; do
    err "$f:${hit%%:*}: include libraries with a relative path, e.g. <../../libs/${hit#*<}"
  done < <(grep -nE "^[[:space:]]*(include|use)[[:space:]]*<($libs_re)/" "$f" | sed -E 's/^([0-9]+):.*<(.*)$/\1:<\2/')

  dir="$(dirname "$f")"
  case " ${projects[*]-} " in *" $dir "*) ;; *) projects+=("$dir") ;; esac
done

for dir in ${projects[@]+"${projects[@]}"}; do
  name="$(basename "$dir")"
  [ "$name" = "_template" ] && continue
  [ "$(dirname "$dir")" = "projects" ] || continue
  [ -f "$dir/README.md" ] || err "$dir: missing README.md (start from projects/_template/README.md)"
  [ -f "$dir/$name.scad" ] || err "$dir: main model must be named $name.scad"
  grep -qF "](projects/$name/)" README.md || err "$dir: add a row to the Projects table in README.md"
done

[ $failed -eq 0 ] && echo "✔ lint: ${#files[@]} file(s) OK"
exit $failed
