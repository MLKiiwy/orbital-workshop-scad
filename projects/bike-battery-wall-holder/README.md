# Bike battery wall holder

> Wall-mounted drop-in cradle for a 92 × 91 × 380 mm, 4 kg e-bike battery (Bafang BT F08.600.C, 600 Wh), with an opening that keeps its charging port reachable.

## What

Designed primarily for the **Bafang BT F08.600.C (600 Wh)** e-bike battery.
Other packs of similar size fit by changing the `battery_*` parameters.

A thick-walled U-channel cradle screwed to the wall. The battery drops in from
the top and rests on a floor shelf; two side walls and two front lips hold it on
the sides and the front. A teardrop-shaped opening in one side wall keeps the
battery's own charging port reachable while it is docked, so it charges in
place. Both side walls, the back plate and the two lips are cut with a
honeycomb of hexagonal cells to save filament; a solid frame stays at every
joint and around the port and the screws.

```
        front view                       side view (port side)
   ┌──┬───────────────┬──┐          ┌──────────────┐
   │  │               │  │          │              │  ← back plate
   │  │       ◦       │  │ ← screw  │              │     (against wall)
   │  │               │  │          │              │
   │▓▓│               │▓▓│          │              │
   │▓▓│               │▓▓│          │     ┌────┐   │
   │▓▓│               │▓▓│          │    │ ⌀35 │   │  ← charging port
   │▓▓│               │▓▓│          │     ╲  ╱     │     (teardrop collar)
   │▓▓│       ◦       │▓▓│ ← screw  │       ╲╱     │
   │▓▓└───────────────┘▓▓│          └──────────────┘
   └─────────────────────┘             floor shelf
     ▓ = front retaining lip, from the floor up to 70 % of the pocket height
```

### Key dimensions (defaults)

| | Value |
|---|---|
| Battery | Bafang BT F08.600.C, 600 Wh — 92 (W) × 91 (D) × 380 (H) mm, 4 kg |
| Pocket | 94.4 × 92.5 mm (1.2 mm side slack per side, 1.5 mm front) |
| Outside envelope | 102.4 (W) × 102.5 (D) × 158 (H) mm |
| Battery captured | 152 mm — 40 % of its height |
| Back plate / side walls / floor | 5 / 4 / 6 mm |
| Front lips | 20 mm reach, 5 mm thick, 106.4 mm tall (70 % of the pocket), 54.4 mm open window between them |
| Screw pattern | 2 screws on the centre line of the back plate, 92 mm apart in Z |
| Charging port | ⌀35 mm, centre 30 mm from the battery's back face and 30 mm from its bottom face |
| Honeycomb | 14 mm cells, 3 mm struts, 3 mm solid frame, partial cells along the frame — 88 cells on the plain side wall, 81 on the port wall, 88 on the back plate, 16 on each lip |
| Solid volume | ≈ 166 cm³ (206 cm³ with whole cells only, 275 cm³ without the honeycomb; ≈ 170 g PETG with the settings below, scaled from an earlier slice) |

The port centre is specified relative to the **battery**; the model adds
`wall_back` and `wall_floor`, so in part coordinates the hole centre lands at
y = 35 mm from the wall face and z = 36 mm from the bottom of the piece.

## Why

The battery has to come off the bike to charge, and a 4 kg pack lying on the
floor or a shelf gets knocked over. The goals that drove the design:

- **Drop in / lift out with one hand** — no latch. The top of the pocket and of
  the lips can be flared with a lead-in chamfer; it is almost off by default
  (`lead_in_h = 0.5`) so the honeycomb fills more of the walls; set
  `lead_in_h = 15` for a flared mouth.
- **Charge in place** — the side opening lines up with the battery's charging port.
- **Hold at least 35 % of the battery height** (40 % by default) so it cannot tip out of the cradle.
- **Save filament where it is not needed** — the side walls only tie the floor,
  back plate and lips together, the back plate only needs solid material
  around the screws, and the lips only have to stop the battery tipping
  forward, so a honeycomb with a solid frame replaces the rest (≈ 39 % less
  material).
- **Nothing sharp to the touch** — every exposed edge gets a small fillet
  (`fillet_r`), and the dimensions stay nominal.
- **Carry 4 kg on a wall safely** — the weight sits on a thick floor shelf and
  the back plate is screwed to the wall with two countersunk screws on its
  centre line.
- **Print without supports** in PETG on a Bambu Lab printer.

## Parameters

All lengths in mm, mass in kg, angles in degrees. Every group is a Customizer
section (`/* [Section] */`) in [`bike-battery-wall-holder.scad`](bike-battery-wall-holder.scad).

| Parameter | Default | Description |
|-----------|---------|-------------|
| **Quality** | | |
| `fn_preview` | 64 | Facets for curved surfaces in preview |
| `fn_render` | 128 | Facets for curved surfaces in the final render/export |
| **Preview helpers** | | |
| `show_battery` | false | Ghost battery for fit checking (keep off when exporting) |
| `show_wall` | false | Ghost wall slab behind the back plate |
| `show_screws` | false | Ghost screws, to check head seating |
| **Preview colors** | | |
| `use_colors` | true | Color the parts in preview and 3MF (never written to the STL) |
| `col_back` | `"SteelBlue"` | Back plate |
| `col_sides` | `"SeaGreen"` | Side walls |
| `col_floor` | `"DarkOrange"` | Floor shelf |
| `col_lips` | `"Gold"` | Front retaining lips |
| `col_collar` | `"MediumPurple"` | Charging-port collar |
| `col_cuts` | `"Crimson"` | Faces exposed by screw holes, port and bed chamfer (also honeycomb and lead-in when not rounded) |
| `col_ghost` | `[0.6, 0.8, 1.0, 0.35]` | Ghost battery / wall / screws (RGBA) |
| **Battery** | | |
| `battery_w` | 92 | Battery width, X (left ↔ right) |
| `battery_d` | 91 | Battery depth, Y (wall ↔ front) |
| `battery_h` | 380 | Battery height, Z |
| `battery_kg` | 4 | Battery mass, kg (informational, echo summary) |
| **Fit clearances** | | |
| `clear_side` | 1.2 | Slack per side between battery and side wall |
| `clear_front` | 1.5 | Slack between battery front face and the lips |
| **Shell thickness** | | |
| `wall_back` | 5.0 | Back plate (must fit the screw countersink) |
| `wall_side` | 4.0 | Side walls |
| `wall_floor` | 6.0 | Floor shelf — carries the full battery weight |
| **Capture height** | | |
| `capture_frac` | 0.40 | Fraction of the battery height the holder wraps (≥ 0.35) |
| `capture_h_override` | 0 | Explicit capture height (0 = derive from `capture_frac`) |
| **Front retaining lips** | | |
| `lip_w` | 20.0 | How far each lip reaches inward from its side wall |
| `lip_t` | 5.0 | Lip thickness |
| `lip_h_frac` | 0.70 | Lip height as a fraction of the pocket height, from the floor up (0.50 – 1.00) |
| **Top lead-in chamfer** | | |
| `lead_in_h` | 0.5 | Chamfer height from the top edge down (also applied from the top of the lips) |
| `lead_in_x` | 2.0 | Extra opening per side at the very top |
| `lead_in_y` | 7.0 | Extra opening at the front at the top of the pocket and of the lips (≥ `lip_t` gives a knife edge) |
| **Mounting screws** | | |
| `screw_d` | 4.0 | Nominal screw diameter |
| `screw_head_nom_d` | 8.0 | Nominal countersunk head diameter |
| `screw_clearance` | 0.4 | Diametral clearance added to shank hole and countersink |
| `screw_head_angle` | 90 | Included angle of the conical head, degrees |
| `screw_head_sink` | 0.4 | Extra recess so the head sits below the pocket face |
| `screw_len` | 40 | Screw length (informational — echoes the embedment depth) |
| `screw_x_offsets` | `[0]` | Screw columns, measured from the pocket centre line (`[0]` = one column on the centre line) |
| `screw_z_rows` | `[]` | Screw row heights from the part bottom (`[]` = auto, one low and one high row) |
| `screw_z_margin` | 30 | Auto rows: distance from the floor top / from the part top |
| `driver_access` | 8 | Extra window width beyond the head needed to reach the screws with a driver |
| **Charging port opening** | | |
| `port_enable` | true | Cut the charging-port opening |
| `port_side` | `"right"` | Side wall with the opening, as seen facing the holder (`left` / `right`) |
| `port_d` | 35.0 | Opening diameter |
| `port_from_back` | 30.0 | From the battery back face to the hole centre |
| `port_from_bottom` | 30.0 | From the battery bottom face to the hole centre |
| `port_edge_cham` | 1.2 | Chamfer on both rims, for cable comfort |
| `port_boss` | true | Reinforcing collar around the opening (outside) |
| `port_boss_t` | 2.5 | How far the collar stands off the side wall |
| `port_boss_w` | 5.0 | Radial width of the collar |
| **Honeycomb** | | |
| `hex_sides` | true | Cut a honeycomb through both side walls to save filament |
| `hex_back` | true | Cut a honeycomb through the back plate (clear of the screws) |
| `hex_lips` | true | Cut a honeycomb through both front retaining lips |
| `hex_spacing` | 14 | Centre-to-centre spacing of the hexagonal cells |
| `hex_strut` | 3.0 | Material left between neighbouring cells |
| `hex_frame` | 3 | Solid border kept around each pattern (wall joints, lead-in, port collar, screw heads) |
| `hex_partial` | true | Also cut the partial cells along the border, so the pattern fills each wall fully |
| **Edge rounding** | | |
| `fillet_r` | 1.0 | Fillet radius on every exposed edge, 0 = sharp (bed-facing edges keep `bed_chamfer`) |
| `fillet_fn` | 16 | Facets of the rounding sphere (higher = smoother, slower render) |
| `fillet_preview` | false | Also round in preview (slow); off = fast, sharp preview with per-part colors |
| **Printing** | | |
| `bed_chamfer` | 0.6 | Chamfer on the bed-facing outer edges (elephant-foot relief) |
| `overhang_angle` | 45 | Max unsupported overhang of your printer — shapes the teardrop port and collar, degrees |
| `min_web` | 2.0 | Minimum solid material left around holes and cut-outs |

The model `assert`s its own consistency: it refuses to render if the
countersink no longer fits the back plate, the port opening would break into
the floor/back plate or run past the lips, the lips overlap, the front window
gets too narrow to drive a screw through, `lead_in_h` is taller than the lips, `lip_h_frac` is outside 0.50 – 1.00, the
bed chamfer is larger than the thinnest wall, or `fillet_r` is not under half
of the thinnest wall, lip or collar. With the honeycomb on, it also
refuses struts not wider than `2 × fillet_r` or two extrusion lines (0.9 mm),
`hex_spacing` not larger than `hex_strut`, and `hex_frame` under `min_web`.
`echo` prints a dimension summary on every render, including the number of
honeycomb cells per wall.

**How the honeycomb works:** the cells are flat-top hexagons in the wall plane,
so each cell roof is a short bridge (≈ 6.4 mm) and the slanted edges sit 30° off
vertical — no supports. Each wall has an area the pattern may use: the wall
minus `hex_frame` — on the side walls from the floor, back plate, lips (measured
from their inner face, so the lip joint stays solid) and lead-in taper, and
clear of the port collar; on the back plate from the side walls, the floor and
the top, and clear of every screw head; on each lip from the side-wall joint,
the free edge, the floor and the lip lead-in taper (a 20 mm lip leaves a
14 mm strip, so its cells are partial columns — with `hex_partial = false`
the lips get no cells). The keep-outs around the collar and
the screws are teardrops pointing down, so cells under them get 45° roofs.
With `hex_partial = true` the lattice is clipped to that area, so cut-off cells
fill it right up to the frame; cells that would leave a hole shallower than
2 mm are dropped to avoid slivers. With `hex_partial = false` only whole cells
are cut. Each lattice is centred on its area, and of the two possible lattice
phases the one that gives more cells is used. The cells are cut before the
edge rounding, so their rims are filleted too. The export takes about 25 s;
smaller cells (`hex_spacing` ≈ 10) multiply the cell count and make it much
slower.

**How the fillet works:** every part is modelled `fillet_r` smaller on each
exposed face, the lead-in and honeycomb cuts `fillet_r` larger, then a Minkowski sum
with a sphere grows everything back. All exposed edges come out rounded and
inside corners stay sharp. The outside dimensions stay nominal to within the
sphere's facet error (≈ 0.02 mm). Screw holes, the port and the bed chamfer
are cut afterwards, so they keep their exact geometry. The rounding is skipped
in preview unless `fillet_preview = true`; the export takes about 5 s. The
Minkowski step drops colors, so with `use_colors` on, the rounded body is
split back along the part boundaries and repainted. The VS Code OpenSCAD
Preview extension renders through a full 3MF export, so it always shows the
rounded version.

- **Port on the other side?** `port_side` is as seen standing in front of the
  mounted holder, facing the battery. The model mirrors the opening and its
  collar to the other wall.
- **Slimmer variant:** `capture_frac = 0.35` (133 mm) is the lowest the model
  accepts — anything below fails the capture-height check.

## Printing

Printer: Bambu Lab H2D, 0.4 mm nozzle (see [docs/print-setup.md](../../docs/print-setup.md)).
**Orientation: upright, floor shelf flat on the bed, back plate vertical** (the
model is already in this orientation). This is the only orientation that needs
no supports, and it puts the load in the right direction: the battery's weight
becomes in-plane tension in the floor shelf and broad-area interlayer shear at
the shelf-to-wall joints, instead of peeling layers apart.

- Process profile: **0.20mm Balanced Strength @BBL H2D**, with these overrides
  for the 4 kg load:
  - Walls: 5 wall loops (≈ 2.2 mm) instead of 2
  - Infill: 40 % gyroid instead of 15 % grid
  - Top / bottom layers: 6 / 4 (profile default)
- Filament profile: **SUNLU PETG High Speed @Bambu Lab H2D 0.4 nozzle**
  (SUNLU PETG High Speed Matte)
  - Nozzle 255 °C; bed 75 °C on the textured PEI plate (70 °C on smooth PEI)
  - Part cooling 40–90 % (profile), flow ratio 0.95, max volumetric speed 12 mm³/s
- Supports: **off** — the profile enables auto tree supports, disable them. The
  port is a flat-topped teardrop (short bridge) and its collar points down at
  `overhang_angle`.
- Brim: 5 mm (158 mm tall part)
- Speeds: profile defaults (outer wall 60 mm/s)

Expect roughly 170 g of PETG and a 5–7 h print (scaled from a slice of an
earlier, larger version — re-slice to confirm).

## Hardware (BOM)

| Qty | Item | Notes |
|-----|------|-------|
| 2 | Countersunk wood/masonry screw, 4.0 × 40 mm, TX-20 | 35 mm embedment through the 5 mm back plate |
| 2 | 6 mm nylon wall plug | Masonry only; on plasterboard hit a stud or use hollow-wall anchors rated > 10 kg each |

### Mounting

The countersinks open **into the pocket**, so the heads finish flush with the
inner face of the back plate and never push the battery forward. Drive the two
screws from inside the cradle, through the 54.4 mm window between the lips,
before putting the battery in.

Load check: the battery's centre of mass sits ~50.5 mm off the wall
(`wall_back` + half the battery depth), so 4 kg (≈ 39 N) produces about
2.0 N·m of tipping moment. Across the 92 mm vertical screw spacing that is
~22 N of pull-out on the top screw, plus ~39 N of vertical shear shared by
both — a fraction of what a 4.0 × 40 screw carries. With a single column the
holder can pivot slightly around the screw line if the wall is uneven; snug
the screws firmly.

**The fasteners, not the plastic, are the weak link.** Into plasterboard,
4.0 × 40 screws alone will *not* hold 4 kg on a 50 mm lever arm.

## Export

```sh
./scripts/export.sh projects/bike-battery-wall-holder/bike-battery-wall-holder.scad
```

## Status

Created 2026-11-19.

- [x] Design
- [ ] Test print
- [ ] Final

Notes before the first print:

- Geometry has been checked in renders (pocket clear of interference, port and
  screw placement, lip taper, edge fillets) but not on a real battery.
- The back plate is now a honeycomb with solid rings around the screws. Check
  it on the test print (press on the front of the floor shelf with ~10 kg)
  before trusting it with the battery; set `hex_back = false` if it flexes.
- The volume, weight and print time above are estimates; re-slice the current
  model in Bambu Studio for real figures.
- Measure the battery first: the pocket assumes a true rectangular cuboid. If it
  has a tapered foot, a protruding latch, or rails on its back, add a relief
  cut-out or increase `clear_*`.
- Check the port opening against the actual charger plug — a bulky plug body may
  want a larger `port_d` or `port_edge_cham`.
