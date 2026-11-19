# Print setup

The printer, filament and slicer profiles the models in this repo are designed
for. **Design limits** sums up what that means for a model; the sections after
it hold the source data.

Last checked: 2026-11-19 (Bambu Studio 02.09.01.70).

## Design limits

Use these as defaults when modelling. A model that breaks one should say why in
its README.

| Topic | Limit / default | Why |
|---|---|---|
| Part size, one filament | ≤ **325 × 320 × 320 mm** (X × Y × Z) | Left-nozzle printable area; see [Build volume](#build-volume) |
| Part size, any nozzle / two colors | ≤ **300 × 320 × 320 mm** | Area both nozzles can reach |
| Margin | Keep ~5 mm free on each side for a brim | Tall PETG parts usually need a 5 mm brim |
| Nozzle | **0.4 mm** (line width 0.42 mm outer, 0.45 mm inner) | Installed nozzle; all usual profiles assume it |
| Minimum wall | ≥ **0.9 mm** (2 lines); structural walls ≥ **1.6 mm** | 2 × nozzle rule from `CLAUDE.md`; thin walls print as gap fill |
| Wall thickness steps | Prefer multiples of ~0.45 mm (0.9, 1.35, 1.8, 2.25 …) | Avoids gap-fill slivers between perimeters |
| Layer height | **0.20 mm** mechanical, **0.16 mm** detailed; first layer 0.20 mm | Usual profiles, see [Bambu Studio profiles](#bambu-studio-profiles) |
| Z features | Heights in multiples of 0.2 mm (0.8 mm works for both 0.16 and 0.20) | Features snap to layers |
| Overhangs | ≤ 45° from vertical without support | Repo rule; slicer auto-supports below a 30° (0.20) / 25° (0.16) threshold |
| Bed-facing edges | Chamfer, not fillet (≈ 0.4–0.6 mm) | Profiles compensate only 0.15 mm of elephant foot |
| Holes & fits | Profiles apply **no** XY hole/contour compensation: model clearances explicitly (start at 0.2 mm per side for sliding fits, then test-print) | `xy_hole_compensation = 0`, `xy_contour_compensation = 0` |
| Heat | PETG parts must stay **below ~70 °C** (no car dashboards, no hot-pipe contact) | SUNLU HDT 70 ± 2 °C |
| Material default | SUNLU PETG High Speed Matte | See [Filament](#filament) |

## Printer — Bambu Lab H2D

Dual-nozzle enclosed CoreXY printer. The machine has a 0.4 mm hardened-steel
nozzle on each side, so abrasive (CF/GF) filaments are possible.

| Spec | Value | Source |
|---|---|---|
| Build volume, total (both nozzles combined) | 350 × 320 × 325 mm | Bambu Studio machine profile, 3DPI |
| Build volume, single nozzle | 325 × 320 × 325 mm | 3DPI (see table below for the per-nozzle split) |
| Build volume, dual-nozzle print | 300 × 320 × 325 mm | 3DPI |
| Nozzles | 0.4 mm installed; 0.2 / 0.6 / 0.8 mm available. Hardened steel, all-metal hot end | 3DPI, Bambu Studio |
| Max nozzle temperature | 350 °C | 3DPI (one comparison table said 300 °C; unconfirmed) |
| Max bed temperature | 120 °C | 3DPI, Bambu tech-spec page |
| Active chamber heating | up to 65 °C | 3DPI |
| Max toolhead speed | 1000 mm/s | 3DPI, Bambu Studio |
| Max acceleration | 20 000 mm/s² | 3DPI, Bambu Studio |
| Max hot-end flow | 40 mm³/s standard, 65 mm³/s high-flow hot end | 3DPI (measured with Bambu ABS at 280 °C) |
| Build plates | Textured PEI, Smooth PEI | 3DPI |
| Layer height range (0.4 nozzle) | 0.08 – 0.28 mm | Bambu Studio machine profile |
| Filament diameter | 1.75 mm | 3DPI |
| Machine size / weight | 492 × 514 × 626 mm, 31 kg | 3DPI |

### Build volume

From the Bambu Studio machine profile `Bambu Lab H2D 0.4 nozzle`:

| Nozzle | X range | Y range | Max Z |
|---|---|---|---|
| Nozzle 1 (left) | 0 – 325 mm | 0 – 320 mm | 320 mm |
| Nozzle 2 (right) | 25 – 350 mm | 0 – 320 mm | 325 mm |
| Both (two-color print) | 25 – 325 mm | 0 – 320 mm | 320 mm |

Other clearances from the same profile: tool-head clearance radius 49 mm,
clearance height to the gantry rod 47.4 mm, to the lid 201 mm (these matter
only for print-by-object sequencing).

## Filament

Main filament: **SUNLU PETG High Speed Matte**, 1.75 mm, 1 kg spools, in
several colors.

| Property | Value | Source |
|---|---|---|
| Nozzle temperature | 240 – 260 °C | SUNLU product page |
| Bed temperature | 70 – 80 °C | SUNLU product page |
| Print speed | ≤ 400 mm/s (marketing says up to 600 mm/s) | SUNLU product page |
| Retraction (SUNLU) | 0.8 – 1.2 mm at 30 – 40 mm/s | SUNLU product page (the H2D direct-drive profile uses 0.4 mm) |
| Density | 1.28 g/cm³ (the Bambu Studio profile uses 1.27) | SUNLU product page |
| Diameter | 1.75 ± 0.02 mm | SUNLU product page |
| Tensile strength | 46 ± 5 MPa | SUNLU product page |
| Elongation at break | 14 ± 5 % | SUNLU product page |
| Flexural strength | 75 ± 6 MPa | SUNLU product page |
| Notched Izod impact | 3 ± 1.5 kJ/m² | SUNLU product page |
| Heat deflection temperature | 70 ± 2 °C | SUNLU product page |
| Drying | 65 °C, 12 h | Bambu Studio `Generic PETG` AMS drying preset (SUNLU publishes none) |
| Abrasive | No — any nozzle | SimplyPrint |

Mass estimate for a model: solid volume (cm³) × 1.28 g/cm³ gives the upper
bound; the real figure depends on walls and infill, so slice to confirm.

### Colors in stock

<!-- Fill in the colors you have; models can reference them in their README. -->

| Color | Notes |
|---|---|
| | |

## Bambu Studio profiles

### Usual choices

| Use | Process profile | Filament profile |
|---|---|---|
| Mechanical parts | **0.20mm Balanced Strength @BBL H2D** | SUNLU PETG High Speed @Bambu Lab H2D 0.4 nozzle |
| Detailed models (figurines…) | **0.16mm Balanced Quality @BBL H2D** | SUNLU PETG High Speed @Bambu Lab H2D 0.4 nozzle |

Key settings of those two system profiles (0.4 mm nozzle):

| Setting | 0.20mm Balanced Strength | 0.16mm Balanced Quality |
|---|---|---|
| Layer height / first layer | 0.20 / 0.20 mm | 0.16 / 0.20 mm |
| Walls | 2 | 2 |
| Top / bottom shell layers | 6 / 4 | 6 / 4 |
| Sparse infill | 15 % grid | 15 % gyroid |
| Outer / inner wall speed | 60 / 150 mm/s | 60 / 150 mm/s |
| Sparse infill speed | 200 mm/s | 180 mm/s |
| Acceleration (default / outer wall) | 4000 / 2000 mm/s² | 4000 / 2000 mm/s² |
| Support | tree (auto), threshold 30° | tree (auto), threshold 25° |
| Elephant-foot compensation | 0.15 mm | 0.15 mm |
| XY hole / contour compensation | 0 / 0 | 0 / 0 |
| Seam | aligned | aligned |

For load-bearing parts, a project README may ask for more walls or infill than
the profile gives (e.g. the bike battery holder uses 5 walls and 40 % gyroid).

### My filament profiles (user presets)

| Profile | Based on | Notes |
|---|---|---|
| **SUNLU PETG High Speed @Bambu Lab H2D 0.4 nozzle** | — (standalone) | 255 °C nozzle; plate 70 °C smooth / engineering, 75 °C textured; max volumetric speed 12 mm³/s; fan 40–90 %; flow ratio 0.95; retraction 0.4 mm; vitrification 70 °C; density 1.27 |
| SUNLU PETG @BBL H2D | Generic PETG @BBL H2D | Textured plate 75 °C, retraction 0.4 mm |
| Sunlu PETG | Generic PETG @BBL H2D | Same settings as above (duplicate) |
| eSUN PETG Basic @Bambu Lab H2D 0.4 nozzle | — | Other brand |
| FLASHFORGE PETG Titanium @Bambu Lab H2D 0.4 nozzle | — | Other brand |
| Tinmorry PETG Metallic @Bambu Lab H2D 0.4 nozzle | — | Other brand |
| Bambu PLA Basic @BBL H2D - Copie | Bambu PLA Basic @BBL H2D | |

### My process profiles (user presets)

| Profile | Based on | Changes |
|---|---|---|
| 0.20mm Standard PETG @BBL H2D | 0.20mm Standard @BBL H2D | 4 top / 4 bottom layers, gyroid infill, monotonic top and internal solid |
| 0.12mm Fine Strong - ML | 0.12mm Fine @BBL H2D | 4 walls, 30 % infill, slim tree supports, top-surface ironing |

### All system process profiles for the H2D

0.4 mm nozzle (installed):

- 0.08mm Extra Fine @BBL H2D
- 0.12mm Fine @BBL H2D
- 0.16mm Balanced Quality @BBL H2D
- 0.16mm Standard @BBL H2D
- 0.20mm Balanced Strength @BBL H2D
- 0.20mm Standard @BBL H2D (Bambu's default)
- 0.24mm Standard @BBL H2D

0.2 mm nozzle:

- 0.08mm Extra Fine @BBL H2D 0.2 nozzle
- 0.10mm Standard @BBL H2D 0.2 nozzle
- 0.12mm Balanced Quality @BBL H2D 0.2 nozzle

0.6 mm nozzle:

- 0.18mm Balanced Quality @BBL H2D 0.6 nozzle
- 0.24mm Balanced Strength @BBL H2D 0.6 nozzle
- 0.30mm Standard @BBL H2D 0.6 nozzle

0.8 mm nozzle:

- 0.24mm Balanced Quality @BBL H2D 0.8 nozzle
- 0.32mm Balanced Strength @BBL H2D 0.8 nozzle
- 0.40mm Standard @BBL H2D 0.8 nozzle

The "Balanced Strength" profiles favor strength (slower walls, more top
layers); "Balanced Quality" favor surface finish; "Standard" are the fast
defaults (500 mm/s outer walls, 8000 mm/s² acceleration).

Profiles are read from
`/Applications/BambuStudio.app/Contents/Resources/profiles/BBL/` (system) and
`~/Library/Application Support/BambuStudio/user/<id>/` (user presets).

## Sources

- [3D Printing Industry — Bambu Lab H2D technical specifications](https://3dprintingindustry.com/news/bambu-labs-new-h2d-3d-printer-technical-specifications-and-pricing-237763/) (2025-03-25)
- [Bambu Lab H2D tech specs](https://bambulab.com/en/h2d/tech-specs) (not machine-readable; values cross-checked against the Bambu Studio machine profile)
- [SUNLU — High Speed Matte PETG](https://www.sunlu.com/products/high-speed-matte-petg-filament)
- [SimplyPrint — SUNLU High Speed Matte PETG](https://simplyprint.io/filaments/sunlu/high-speed-matte-petg)
- Bambu Studio 02.09.01.70 system and user profiles on this machine
