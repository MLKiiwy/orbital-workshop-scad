# Bike battery wall holder

> Wall-mounted drop-in cradle for a 92 × 91 × 380 mm, 4 kg e-bike battery (Bafang BT F08.600.C, 600 Wh), with an opening that keeps its charging port reachable.

## What

Designed primarily for the **Bafang BT F08.600.C (600 Wh)** e-bike battery.
Other packs of similar size fit by changing the `battery_*` parameters.

A thick-walled U-channel cradle screwed to the wall. The battery drops in from
the top and rests on a floor shelf; two side walls and two front lips hold it on
the sides and the front. A teardrop-shaped opening in one side wall keeps the
battery's own charging port reachable while it is docked, so it charges in
place. Optional slots in the lips take a hook-and-loop strap across the battery
face.

```
        front view                       side view (port side)
   ┌──┬───────────────┬──┐          ┌──────────────┐
   │  │               │  │          │              │  ← back plate
   │  │   ◦       ◦   │  │ ← screws │              │     (against wall)
   │  │               │  │          │              │
   │▓▓│               │▓▓│          │              │
   │▓▓│   ▭ strap     │▓▓│          │     ┌────┐   │
   │▓▓│     slots     │▓▓│          │    │ ⌀35 │   │  ← charging port
   │▓▓│               │▓▓│          │     ╲  ╱     │     (teardrop collar)
   │▓▓│   ◦       ◦   │▓▓│ ← screws │       ╲╱     │
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
| Screw pattern | 44 mm apart in X, 92 mm apart in Z |
| Charging port | ⌀35 mm, centre 30 mm from the battery's back face and 30 mm from its bottom face |
| Solid volume | ≈ 269 cm³ (≈ 275 g PETG with the settings below, scaled from an earlier slice) |

The port centre is specified relative to the **battery**; the model adds
`wall_back` and `wall_floor`, so in part coordinates the hole centre lands at
y = 35 mm from the wall face and z = 36 mm from the bottom of the piece.

## Why

The battery has to come off the bike to charge, and a 4 kg pack lying on the
floor or a shelf gets knocked over. The goals that drove the design:

- **Drop in / lift out with one hand** — no latch; a lead-in chamfer at the top
  of the pocket and of the lips guides the battery in.
- **Charge in place** — the side opening lines up with the battery's charging port.
- **Hold at least 35 % of the battery height** (40 % by default) so it cannot tip out of the cradle.
- **Nothing sharp to the touch** — every exposed edge gets a small fillet
  (`fillet_r`), and the dimensions stay nominal.
- **Carry 4 kg on a wall safely** — the weight sits on a thick floor shelf and
  the back plate is screwed to the wall with four countersunk screws.
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
| `col_cuts` | `"Crimson"` | Faces exposed by screw holes, port and bed chamfer (also slots and lead-in when not rounded) |
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
| `lead_in_h` | 15.0 | Chamfer height from the top edge down (also applied from the top of the lips) |
| `lead_in_x` | 2.0 | Extra opening per side at the very top |
| `lead_in_y` | 7.0 | Extra opening at the front at the top of the pocket and of the lips (≥ `lip_t` gives a knife edge) |
| **Mounting screws** | | |
| `screw_d` | 4.0 | Nominal screw diameter |
| `screw_head_nom_d` | 8.0 | Nominal countersunk head diameter |
| `screw_clearance` | 0.4 | Diametral clearance added to shank hole and countersink |
| `screw_head_angle` | 90 | Included angle of the conical head, degrees |
| `screw_head_sink` | 0.4 | Extra recess so the head sits below the pocket face |
| `screw_len` | 40 | Screw length (informational — echoes the embedment depth) |
| `screw_x_offsets` | `[-22, 22]` | Screw columns, measured from the pocket centre line |
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
| **Strap slots** | | |
| `strap_enable` | true | Cut the strap slots through both lips |
| `strap_h` | 25.0 | Slot height (strap width) |
| `strap_t` | 4.0 | Slot width (strap thickness + slack) |
| `strap_z_rows` | `[]` | Slot centre heights from the part bottom (`[]` = auto, one row near the top of the lips) |
| `strap_z_margin` | 45 | Auto row: distance of the slot centre below the top of the lips |
| `strap_rim_min` | 3 | Minimum lip material left on each side of a slot |
| `strap_lead_in_gap` | 5 | Minimum gap between a slot and the lead-in taper of the lips |
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
gets too narrow to drive a screw through, a strap slot runs into the lead-in
taper of the lips, `lead_in_h` is taller than the lips, `lip_h_frac` is outside 0.50 – 1.00, the
bed chamfer is larger than the thinnest wall, or `fillet_r` is not under half
of the thinnest wall, lip, strap rim or collar. `echo` prints a
dimension summary on every render.

**How the fillet works:** every part is modelled `fillet_r` smaller on each
exposed face, the lead-in and strap cuts `fillet_r` larger, then a Minkowski sum
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

Printer: Bambu Lab. **Orientation: upright, floor shelf flat on the bed, back
plate vertical** (the model is already in this orientation). This is the only
orientation that needs no supports, and it puts the load in the right
direction: the battery's weight becomes in-plane tension in the floor shelf and
broad-area interlayer shear at the shelf-to-wall joints, instead of peeling
layers apart.

- Material: PETG
- Layer height / nozzle: 0.20 mm / 0.4 mm
- Infill / walls: 40 % gyroid / 5 wall loops (≈ 2.0 mm), 6 top / bottom layers
- Supports: none — the port is a flat-topped teardrop (short bridge) and its
  collar points down at `overhang_angle`
- Brim: 5 mm (158 mm tall part)
- Temperatures: nozzle 245 °C / bed 80 °C
- Part cooling: 30–50 % — favour layer adhesion over crispness
- Outer wall speed: 30–40 mm/s

Expect roughly 275 g of PETG and an 8–11 h print (scaled from a slice of the
earlier, larger version — re-slice to confirm).

## Hardware (BOM)

| Qty | Item | Notes |
|-----|------|-------|
| 4 | Countersunk wood/masonry screw, 4.0 × 40 mm, TX-20 | 35 mm embedment through the 5 mm back plate |
| 4 | 6 mm nylon wall plug | Masonry only; on plasterboard hit a stud or use hollow-wall anchors rated > 10 kg each |
| 1 | Hook-and-loop strap, 25 mm wide | Optional, through the strap slots |

### Mounting

The countersinks open **into the pocket**, so the heads finish flush with the
inner face of the back plate and never push the battery forward. Drive the four
screws from inside the cradle, through the 54.4 mm window between the lips,
before putting the battery in.

Load check: the battery's centre of mass sits ~50.5 mm off the wall
(`wall_back` + half the battery depth), so 4 kg (≈ 39 N) produces about
2.0 N·m of tipping moment. Across the 92 mm vertical screw spacing that is
~22 N of pull-out shared by the top pair, plus ~39 N of vertical shear shared
by all four — a fraction of what 4.0 × 40 screws carry.

**The fasteners, not the plastic, are the weak link.** Into plasterboard,
4.0 × 40 screws alone will *not* hold 4 kg on a 50 mm lever arm.

The strap is not load-bearing, but it is cheap insurance against the pack
being knocked forward.

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
- The volume, weight and print time above are estimates; re-slice the current
  model in Bambu Studio for real figures.
- Measure the battery first: the pocket assumes a true rectangular cuboid. If it
  has a tapered foot, a protruding latch, or rails on its back, add a relief
  cut-out or increase `clear_*`.
- Check the port opening against the actual charger plug — a bulky plug body may
  want a larger `port_d` or `port_edge_cham`.
