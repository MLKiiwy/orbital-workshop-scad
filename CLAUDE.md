# CLAUDE.md

Monorepo of parametric OpenSCAD models for 3D printing. License: CC BY-NC-SA 4.0 (see LICENSE).

## Structure
- One directory per project: `projects/<kebab-case-name>/` containing
  - `README.md` — what we build and **why**, parameters, print settings, hardware (BOM), status. Start from `projects/_template/README.md`.
  - `<kebab-case-name>.scad` — main model (extra `.scad` parts allowed for multi-part builds).
  - `exports/` — generated STL/3MF, git-ignored. Never commit exports.
- Shared libraries live in `libs/` as git submodules. Project-shared helper modules go in `libs/common/` if they ever emerge.
- When a project is added, add a row to the Projects table in the root `README.md`.

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
- **Use libraries, don't reinvent:** prefer BOSL2 (`include <../../libs/BOSL2/std.scad>`, plus e.g. `threading.scad`, `screws.scad`, `rounding.scad` as needed) for shapes, rounding/chamfers, attachments, threads, screws, gears, hinges. Include with a path **relative to the .scad file** so the VSCode preview and CLI both resolve it.
  - Need another library? Add it as a git submodule under `libs/` and document it in `libs/README.md` (name, URL, license, purpose). Check its license is compatible with CC BY-NC-SA use.
- Small, named modules with parameters; the top level only composes them. Use `$fn`/`$fa`/`$fs` via parameters (low for preview, high for export — `$preview` helps).
- **Target printer and material:** Bambu Lab H2D, 0.4 mm nozzle, SUNLU PETG High Speed Matte, unless the project says otherwise. [docs/print-setup.md](docs/print-setup.md) holds the design limits (build volume, wall and layer steps, clearances, heat) and the Bambu Studio profiles to name in a project README (usually `0.20mm Balanced Strength @BBL H2D` for mechanical parts, `0.16mm Balanced Quality @BBL H2D` for detailed models). Keep it updated when the printer, filament or profiles change.
- **Printability:** model in print orientation when possible, avoid unsupported overhangs > 45°, respect minimum wall thickness (≥ 2 × nozzle width), add chamfers on the bed-facing edges instead of fillets.
- Every `.scad` file starts with:
  ```
  // <Project name> — <one-line purpose>
  // SPDX-License-Identifier: CC-BY-NC-SA-4.0
  ```

## Checks before declaring done
- `./scripts/check-openscad.sh` passes.
- `./scripts/export.sh projects/<name>/<name>.scad` renders without errors or warnings (also try a couple of non-default `-D` values).
- Project README's parameter table matches the `.scad` parameters.
