# MakerWorld Parametric Model Maker — rules for .scad uploads

How to make a `.scad` file that MakerWorld accepts and that its **Customize**
button (the Parametric Model Maker, "PMM") can render, and how this repo does it.

Last checked: 2026-11-21.

> **Bambu has no official specification.** One forum post says there is no
> Bambu Lab wiki page for it, and the most complete reference is an
> unofficial, reverse-engineered site. Its author tags each claim as *Official
> release*, *Employee-confirmed* or *Community-discovered*. Those tags are
> repeated below. The most reliable check is the **Sample Code** icon (bottom
> left of the PMM editor), plus a test upload.

## Rules

| Topic | Rule | Confidence |
|---|---|---|
| Upload | Create a listing and upload the `.scad` under **Raw Model Files** instead of a 3MF. MakerWorld validates it ("Validating" → "Passed") and adds a **Customize** button. | Community, several sources |
| One file | PMM only reads the uploaded file. Local `include`/`use` of other files (e.g. `../../libs/...`) does not work. If parameters are moved into an included file, they vanish from the Customizer without warning. Flatten or inline local dependencies. | Employee-confirmed + community |
| Libraries | Only bundled libraries are available, included **by bare name**: `include <BOSL2/std.scad>`, `include <threads-scad/threads.scad>`, `include <gridfinity-rebuilt-openscad/...>`, `include <KeyV2/...>`, `include <ub.scad>`, `include <Getriebe.scad>`, `include <knurledFinishLib_v2.scad>`. | Official app endpoint |
| BOSL2 version | PMM v1.1.0 pins BOSL2 commit `99fcfc6867e739aa1cd8ffc49fe39276036681f1` (2025-09-08). It is older than our submodule, so test against it (see *How this repo does it*). | Official release (cited by the unofficial docs) |
| OpenSCAD version | A recent development snapshot, not 2021.01. One user found the **2026.01.14 snapshot** by rendering `version()`. The Manifold backend is enabled. | Employee-confirmed (Manifold), community (snapshot date) |
| File name | No spaces in the file name. One user reports it is rejected as if the contents were invalid. | Community |
| Render time | Heavy geometry times out even when local OpenSCAD finishes. **`minkowski()` is reported not to work** on MakerWorld (timeout). Keep `$fn` moderate and avoid heavy operations. No numeric limit is published. | Community |
| Part size | 3MF generation can fail when Bambu Studio's auto-arrange cannot fit the part. A practical limit of about 240 × 235 mm was mentioned. Use several plates for large models. | Employee-confirmed (forum) |
| Placement | The part lands on the bed where it is modelled. A part built out from the origin ends up in a bed corner, so centre it on the origin in X/Y with its bottom at Z = 0. The 3MF keeps the orientation from the file, so model in print orientation. | Community |
| Customizer syntax | PMM "mainly follows the OpenSCAD Customizer manual": simple top-level assignments, `/* [Section] */` groups, `//` help comment on the line above, `// [min:step:max]` sliders, `// [a, b, c]` and `// [10:Large, 5:Small]` dropdowns (test the `value:Label` form, one author saw it misbehave). Underscores in names are shown as spaces. | Employee-confirmed (partial) + community |
| Extra widgets | `name = "Roboto"; // font` gives a font picker (pre-installed fonts only). `c = "#FF0000"; // color` gives a color picker (hex strings only). `// preview[...]` is **not** used by PMM. | Official release |
| Unknown | Vector/list parameters, `[Hidden]` behaviour, `$preview`, `echo`/`assert` handling, file-size and time limits are not documented. **Keep vector parameters out of the Customizer.** | — |
| Uploaded files | A user-supplied file is only reachable under a fixed name: `default.png`, `default.svg` or `default.stl`. | Official release |
| Multi-plate | `module mw_plate_1() {…}`, `mw_plate_2()`, … give one 3MF plate each, but then there is no STL download. `module mw_assembly_view() {…}` is preview only. Don't call these modules yourself. | Official release |
| Colors | Parameterized colors (`// color`) drive the UI. Whether `color()` becomes separate filaments in the 3MF is not documented. | Official release / unknown |
| Source visibility | An uploaded `.scad` is closed source unless the listing's open-source setting is turned on. | Community |
| Passing validation | "Passed" only means the automated check passed. Try every option in the live Customize page before publishing. The OpenSCAD Playground uses its own parser, not MakerWorld's. | Community |

## How this repo does it

The main model stays the source of truth. A generated copy is uploaded.

- `projects/<name>/makerworld.json` lists what changes for MakerWorld:
  - `hide`: parameters taken out of the Customizer and re-declared after `/* [Hidden] */`. The value is `null` to keep the original value, or a new value. Use it for vector parameters, preview-only helpers and colors, and slow options such as a Minkowski fillet, which is forced to `0`.
  - `replace`: exact text substitutions, e.g. centring the part on the origin.
- `scripts/makerworld.py projects/<name>/<name>.scad` writes `projects/<name>/makerworld/<name>.scad`. It also rewrites `../../libs/<lib>/` includes to `<lib>/` and fails if any relative include is left. The output is generated and git-ignored (`projects/*/makerworld/`): regenerate it before every upload. `--check` only verifies that an existing copy matches the current model.
- Render the generated file with `./scripts/export.sh` (it sets `OPENSCADPATH` to `libs/`, so `<BOSL2/...>` resolves), and also against MakerWorld's pinned BOSL2:

  ```sh
  git -C libs/BOSL2 worktree add --detach /tmp/mwlibs/BOSL2 99fcfc6867e739aa1cd8ffc49fe39276036681f1
  OPENSCADPATH=/tmp/mwlibs openscad --backend=manifold --hardwarnings \
    -o /tmp/mw.stl projects/<name>/makerworld/<name>.scad
  git -C libs/BOSL2 worktree remove /tmp/mwlibs/BOSL2
  ```
- On the listing, upload the main model's 3MF as the ready-to-print profile (full quality, e.g. with fillets) and the generated `.scad` for **Customize**.

## Sources

- Unofficial MakerWorld PMM OpenSCAD docs (nelsonjchen), community-maintained:
  - API: <https://nelsonjchen.github.io/unofficial-makerworld-parametric-model-maker-openscad-docs/pmm-openscad-api/>
  - Feature reference: <https://nelsonjchen.github.io/unofficial-makerworld-parametric-model-maker-openscad-docs/feature-reference/>
  - Compatibility rules: <https://nelsonjchen.github.io/unofficial-makerworld-parametric-model-maker-openscad-docs/compatibility-rules/>
  - Gotchas: <https://nelsonjchen.github.io/unofficial-makerworld-parametric-model-maker-openscad-docs/gotchas/>
- MakerHacks, "OpenSCAD MakerWorld customizer" (2026): <https://www.makerhacks.com/openscad-makerworld-customizer/>
- Bambu Lab forum, "Create customizable models on MakerWorld using Parametric Model Maker" (FAQ, 2025): <https://forum.bambulab.com/t/create-customizable-models-on-maker-world-using-parametric-model-maker/156334>
- Bambu Lab forum, "Any documentation on Parametric Model Maker?" (2025–2026, OpenSCAD version reports): <https://forum.bambulab.com/t/any-documentation-on-parametric-model-maker/230605>
- OpenSCAD Customizer manual (what PMM follows): <https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Customizer>
- MakerWorld release notes (not readable by script, HTTP 402): <https://wiki.bambulab.com/en/makerworld/release-note/makerworld-release-notes>
