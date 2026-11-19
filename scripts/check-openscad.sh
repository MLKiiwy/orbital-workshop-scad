#!/usr/bin/env bash
# Check that OpenSCAD and the shared libraries are available.
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ok=1

red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }

find_openscad() {
  if command -v openscad >/dev/null 2>&1; then command -v openscad; return; fi
  for p in "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" \
           "/Applications/OpenSCAD-Nightly.app/Contents/MacOS/OpenSCAD" \
           "$HOME/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"; do
    [ -x "$p" ] && { echo "$p"; return; }
  done
}

install_tips() {
  cat <<'EOF'

How to install OpenSCAD (a recent snapshot is recommended: much faster Manifold renderer):
  macOS   : brew install --cask openscad@snapshot   (stable: brew install --cask openscad)
  Debian/Ubuntu : sudo apt install openscad
  Fedora  : sudo dnf install openscad
  Any Linux: flatpak install flathub org.openscad.OpenSCAD
  Windows : winget install OpenSCAD.OpenSCAD
  Downloads: https://openscad.org/downloads.html  (snapshots: https://openscad.org/downloads.html#snapshots)

If installed as an app but not on PATH (macOS), add a symlink:
  ln -s /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD /usr/local/bin/openscad
EOF
}

bin="$(find_openscad)"
if [ -n "$bin" ]; then
  green "✔ OpenSCAD found: $bin"
  echo "  $("$bin" --version 2>&1 | head -1)"
  command -v openscad >/dev/null 2>&1 || echo "  (not on PATH — scripts will still use it)"
else
  red "✘ OpenSCAD not found"
  install_tips
  ok=0
fi

if [ -f "$ROOT/libs/BOSL2/std.scad" ]; then
  green "✔ BOSL2 library present (libs/BOSL2)"
else
  red "✘ BOSL2 library missing — run: git submodule update --init --recursive  (or ./scripts/setup.sh)"
  ok=0
fi

if [ "$ok" -eq 1 ]; then green "Environment OK"; exit 0; else exit 1; fi
