#!/usr/bin/env bash
# List the tracked project .scad files, one per line (relative to the repo root).
# Skips libs/ and anything git-ignored (exports/, generated makerworld/ copies).
# SPDX-License-Identifier: CC-BY-NC-SA-4.0
set -eu
cd "$(dirname "$0")/.."
git ls-files -- 'projects/**.scad'
