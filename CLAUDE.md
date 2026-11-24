# CLAUDE.md

Monorepo of parametric OpenSCAD models for 3D printing. License: CC BY-NC-SA 4.0 (see LICENSE).

## Structure
- One directory per project: `projects/<kebab-case-name>/` containing
  - `README.md` — what we build and **why**, parameters, print settings, hardware (BOM), status. Start from `projects/_template/README.md`.
  - `<kebab-case-name>.scad` — main model (extra `.scad` parts allowed for multi-part builds).
  - `exports/` — generated STL/3MF, git-ignored. Never commit exports.
- Shared libraries live in `libs/` as git submodules. Project-shared helper modules go in `libs/common/` if they ever emerge.
- When a project is added, add a row to the Projects table in the root `README.md`.
- MakerWorld uploads: never upload the main `.scad`. Generate a single-file copy with `scripts/makerworld.py` (config in `projects/<name>/makerworld.json`, output in `projects/<name>/makerworld/`, git-ignored — never commit it), following [docs/makerworld-parametric.md](docs/makerworld-parametric.md). Regenerate it whenever the main model changes.

## Modeling rules
- **OpenSCAD only.**
- **Units — metric / SI, everywhere** (`.scad` files, READMEs, comments, echo output):
  - Every dimension (length, diameter, offset, clearance, thickness) is in **millimetres**. No inches, no conversion factors, no other length unit in geometry.
  - All other quantities use **SI units**: mass in kg (or g), force in N, torque in N·m, temperature in °C, time in s, volume in cm³ / mm³.
  - Angles are in degrees (OpenSCAD's native unit, accepted for use with SI).
  - Imperial units are not allowed. If a source spec is imperial (e.g. a ¼" bolt), convert it to mm and keep the original only as a comment.
- **Parametric first:** every meaningful dimension is a top-level variable. No magic numbers in geometry.
  - Group parameters with Customizer sections `/* [Section] */` and annotate ranges/choices (`// [10:1:200]`, `// [round, square]`) with a short description comment above each.
  - Put derived values and internals after `/* [Hidden] */`.
  - Printing tolerances are parameters (e.g. `clearance = 0.2;`), never hard-coded.
  - Use `assert()` to validate parameter combinations that would produce broken geometry.
- **Use libraries as much as possible, don't reinvent:** before writing geometry or math by hand, check whether a library in `libs/` already does it, and use it. Pick by job ([libs/README.md](libs/README.md) has licenses and include lines):
  - **BOSL2** — the default for everything: shapes, attachments, rounding/chamfers, threads, screws, gears, hinges, paths (`include <../../libs/BOSL2/std.scad>`, plus e.g. `threading.scad`, `screws.scad`, `rounding.scad`).
  - **Round-Anything** — 2D profiles with a radius per vertex (`polyRound`), when BOSL2's rounding is awkward.
  - **threads-scad** — simple metric threads/bolts/nuts/threaded holes (load with `use`, not `include`).
  - **gridfinity-rebuilt-openscad** — anything Gridfinity (bins, baseplates).
  - **LEGO.scad** — LEGO-compatible bricks/plates (`use`, then `block()`).
  - **NopSCADlib** — real-world vitamins (screws, nuts, bearings, electronics) for fit checks. It is **GPL-3.0-or-later**: ask the user for explicit OK before using it. A project that uses it is GPL-3.0-or-later (header `// SPDX-License-Identifier: GPL-3.0-or-later`, said in its README), not CC BY-NC-SA.
  - MakerWorld's Customize only bundles BOSL2, threads-scad and gridfinity-rebuilt-openscad (`scripts/makerworld.py` refuses the others): prefer those for models meant to be customizable on MakerWorld.
  - Include with a path **relative to the .scad file** (`<../../libs/<lib>/…>`), never by bare name, so the VSCode preview and CLI both resolve it (`scripts/lint.sh` enforces it).
  - Need another library? Add it as a git submodule under `libs/` and document it in `libs/README.md` and the root README Libraries table (name, URL, license, purpose). Check its license is compatible with CC BY-NC-SA use.
- **openscad skill:** the project-level skill in `.claude/skills/openscad` (submodule) is available for designing, previewing (multi-angle PNGs) and validating. In this repo its scripts are at `.claude/skills/openscad/scripts/` (not `~/.claude/skills/openscad/…` as its SKILL.md says), and models still go in `projects/<name>/` following this file, never in `~/openscad-projects/`.
- Small, named modules with parameters; the top level only composes them. Use `$fn`/`$fa`/`$fs` via parameters (low for preview, high for export — `$preview` helps).
- **Target printer and material:** Bambu Lab H2D, 0.4 mm nozzle, SUNLU PETG High Speed Matte, unless the project says otherwise. [docs/print-setup.md](docs/print-setup.md) holds the design limits (build volume, wall and layer steps, clearances, heat) and the Bambu Studio profiles to name in a project README (usually `0.20mm Balanced Strength @BBL H2D` for mechanical parts, `0.16mm Balanced Quality @BBL H2D` for detailed models). Keep it updated when the printer, filament or profiles change.
- **Printability:** model in print orientation when possible, avoid unsupported overhangs > 45°, respect minimum wall thickness (≥ 2 × nozzle width), add chamfers on the bed-facing edges instead of fillets.
- Every `.scad` file starts with:
  ```
  // <Project name> — <one-line purpose>
  // SPDX-License-Identifier: CC-BY-NC-SA-4.0
  ```
- **Formatting:** `scadfmt` with [.scadfmt.yaml](.scadfmt.yaml). Run `mise run fmt` after editing a model; don't hand-format against it.

## Tooling
- Dev tools are pinned in [mise.toml](mise.toml) (python, scadfmt, lefthook); setup is `./scripts/setup.sh` (or `mise install && mise run setup`). Add any new tool there, never as an undeclared global install.
- Git hooks ([lefthook.yml](lefthook.yml)): pre-commit runs format check, lint and validation on staged models; pre-push runs `mise run check`. CI ([.github/workflows/ci.yml](.github/workflows/ci.yml)) runs the same plus full renders.

## Git workflow
- `main` is protected on GitHub: never commit or push to it. Do every piece of work on a new branch from an up-to-date `main`: `feature/<topic>` for new work, `fix/<topic>` for bug fixes.
- As soon as the branch has its first commit, push it and open a pull request with `gh pr create` — ready for review, **not** a draft. Keep pushing later commits to the same PR.
- **Never merge a PR yourself** (no `gh pr merge`, no merge into `main`); the user merges.
- **Never skip the git hooks**: no `--no-verify`, no `LEFTHOOK=0`, no disabling hooks. If a hook fails, fix the cause.
- **Never force push** (no `--force`, `--force-with-lease`, or rewriting pushed history).

## Checks before declaring done
- `mise run check` passes (format, lint, strict validation by the openscad skill).
- `scripts/validate.sh --render projects/<name>/<name>.scad` renders the model (and its MakerWorld copy) without errors or warnings; also try a couple of non-default `-D` values with `./scripts/export.sh`.
- Project README's parameter table matches the `.scad` parameters.
