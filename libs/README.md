# Libraries

Shared OpenSCAD libraries, added as **git submodules** so versions are pinned.
Each library's recommended install is "put it in a folder on the OpenSCAD
library path". Here that folder is `libs/`: `scripts/export.sh`, `mise.toml` and
the VSCode terminal all set `OPENSCADPATH=libs/`. Project files still include
libraries with a path relative to the file, so every tool resolves them.

| Library | Path | License | MakerWorld | Purpose |
|---------|------|---------|:---:|---------|
| [BOSL2](https://github.com/BelfrySCAD/BOSL2) | `libs/BOSL2` | BSD-2-Clause | ✅ | Default toolbox: shapes, attachments, rounding/chamfers, threads, screws, gears, hinges, paths… ([docs](https://github.com/BelfrySCAD/BOSL2/wiki)) |
| [Round-Anything](https://github.com/Irev-Dev/Round-Anything) | `libs/Round-Anything` | MIT | ❌ | `polyRound()`: 2D profiles with a radius per vertex, extruded with rounded edges |
| [threads-scad](https://github.com/rcolyer/threads-scad) | `libs/threads-scad` | CC0-1.0 | ✅ | Simple ISO metric threads: `ScrewThread`, `ScrewHole`, `MetricBolt`, `MetricNut`… |
| [gridfinity-rebuilt-openscad](https://github.com/kennetek/gridfinity-rebuilt-openscad) | `libs/gridfinity-rebuilt-openscad` | MIT | ✅ | Gridfinity bins and baseplates ([docs](https://kennetek.github.io/gridfinity-rebuilt-openscad/)) |
| [LEGO.scad](https://github.com/cfinke/LEGO.scad) | `libs/LEGO.scad` | MIT | ❌ | LEGO/DUPLO-compatible bricks, plates and tiles: `block(...)` |
| [NopSCADlib](https://github.com/nophead/NopSCADlib) | `libs/NopSCADlib` | **GPL-3.0-or-later** | ❌ | Real-world "vitamins" (screws, nuts, bearings, motors, electronics…) for fit-check assemblies ([docs](https://github.com/nophead/NopSCADlib/blob/master/readme.md)) |

**MakerWorld**: ✅ = bundled by MakerWorld's Parametric Model Maker, so a model
using it can still get a Customize button. `scripts/makerworld.py` refuses the
others. See [docs/makerworld-parametric.md](../docs/makerworld-parametric.md).

## License notes

- BOSL2, Round-Anything, threads-scad, gridfinity-rebuilt-openscad and
  LEGO.scad have permissive licenses, compatible with this repo's CC BY-NC-SA 4.0.
- **NopSCADlib is GPL-3.0-or-later.** A model that includes it is a derived
  work, which must be published under the GPL. The GPL does not allow the
  NonCommercial restriction. So:
  - Use NopSCADlib only with the repo owner's explicit OK.
  - A project that uses it is licensed **GPL-3.0-or-later** (its `.scad`
    header says `// SPDX-License-Identifier: GPL-3.0-or-later`, enforced by
    `scripts/lint.sh`), and its README says so.

## Using a library in a project

Include it with a path relative to the project's `.scad` file:

```openscad
include <../../libs/BOSL2/std.scad>
include <../../libs/BOSL2/threading.scad>            // optional BOSL2 extras
include <../../libs/Round-Anything/polyround.scad>   // polyRound(...)
use <../../libs/threads-scad/threads.scad>           // `use`: the file renders a demo when included
use <../../libs/LEGO.scad/LEGO.scad>                 // block(width = 2, length = 4);
include <../../libs/gridfinity-rebuilt-openscad/src/core/standard.scad>
use <../../libs/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>
use <../../libs/gridfinity-rebuilt-openscad/src/core/bin.scad>   // new_bin(...), bin_render(...)
include <../../libs/NopSCADlib/core.scad>            // GPL — see above
include <../../libs/NopSCADlib/vitamins/screws.scad> // screw(M3_cap_screw, 10);
```

Don't include by bare name (`<BOSL2/std.scad>`); `scripts/lint.sh` rejects it.
The MakerWorld copy rewrites the relative paths for you.

## The openscad Claude skill

[openscad_claude_skill](https://github.com/andreahaku/openscad_claude_skill)
(MIT) is a submodule at `.claude/skills/openscad`. It is a project-level
Claude Code skill, and its scripts are used by the checks:

- `scripts/validate.sh` runs its `scripts/openscad-validate.sh` (strict render,
  parameter-range checks, any warning fails).
- `scripts/openscad-render.sh` makes PNG previews and exports.

Its STL Reconstruct and Replicate modes need extra Python packages (trimesh,
numpy, scipy, rtree, shapely). They are not installed here.

## Commands

```sh
# fetch libraries after cloning
git submodule update --init --recursive

# update a library to its latest version (then commit the new pointer)
git submodule update --remote libs/BOSL2

# add a new library
git submodule add <git-url> libs/<Name>
```

When adding a library, add it to the table above and verify its license allows
use in a CC BY-NC-SA project.
