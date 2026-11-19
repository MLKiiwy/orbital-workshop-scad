---
createdAt: 2026-11-19
printer: Bambu Lab
material: PETG
status: designing
---

## Description

Wall-mounted cradle for an e-bike battery (400 × 93 × 95 mm, 4 kg). The battery
drops in from the top and rests on a floor shelf; two side walls and two front
lips hold it on the sides and the front. A circular opening in the left side
wall keeps the battery's own charging port reachable while the battery is
docked.

Everything is parametric — see [`design/bike-battery-wall-holder.scad`](design/bike-battery-wall-holder.scad).

```
        front view                       side view (left)
   ┌──┬───────────────┬──┐          ┌──────────────┐
   │  │               │  │          │              │  ← back plate
   │▓▓│               │▓▓│          │              │     (against wall)
   │▓▓│   ▭ strap     │▓▓│          │     ╱────┐   │
   │▓▓│     slots     │▓▓│          │    │ ⌀35 │   │  ← charging port
   │  │               │  │          │     ╲────┘   │
   │  │   ◦       ◦   │  │ ← screws │              │
   │  └───────────────┘  │          └──────────────┘
   └─────────────────────┘             floor shelf
     ▓ = front retaining lip
```

### Key dimensions (with the defaults as shipped)

| | Value |
|---|---|
| Battery | 95 (W) × 93 (D) × 400 (H) mm, 4 kg |
| Pocket | 97.4 × 94.5 mm (1.2 mm side slack per side, 1.5 mm front) |
| Outside envelope | 107.4 (W) × 107.5 (D) × 228 (H) mm |
| Battery captured | 220 mm — 55 % of its height |
| Back plate / side walls / floor | 8 / 5 / 8 mm |
| Front lips | 20 mm reach, 5 mm thick, 57.4 mm open window between them |
| Screws | 4 × countersunk, 4.0 × 40 mm TX-20 |
| Screw pattern | 44 mm apart in X, 160 mm apart in Z |
| Charging port | ⌀35 mm, centre 30 mm from the battery's back face and 30 mm from its bottom face |
| Solid volume | ≈ 531 cm³ (≈ 540 g PETG as sliced below) |

The port centre is specified relative to the **battery**, as requested; the model
adds `wall_back` and `wall_floor` internally, so in part coordinates the hole
centre lands at y = 38 mm from the wall face and z = 38 mm from the bottom of
the piece.

## Printing

```sh
openscad -o stl/bike-battery-wall-holder.stl design/bike-battery-wall-holder.scad
```

**Orientation: upright, floor shelf flat on the bed, back plate vertical.**
This is the only orientation that needs no supports and it also puts the load in
the right direction: the battery's weight becomes in-plane tension in the floor
shelf and broad-area interlayer shear at the shelf-to-wall joints, instead of
peeling layers apart. Printing it on its back would leave both front lips as
unsupported islands.

| Setting | Value |
|---|---|
| Nozzle / layer height | 0.4 mm / 0.20 mm |
| Wall loops | 5 (≈ 2.0 mm) |
| Top / bottom layers | 6 |
| Infill | 40 % gyroid |
| Supports | None |
| Brim | 5 mm (228 mm tall part) |
| Nozzle / bed | 245 °C / 80 °C |
| Part cooling | 30–50 % — favour layer adhesion over crispness |
| Outer wall speed | 30–40 mm/s |

Expect roughly 540 g of PETG and a long print (15–20 h). The ⌀35 mm port
opening sits in a vertical wall, so its apex bridges a short span — enable
bridge/overhang handling and accept a couple of slightly rough layers there, or
drill/ream the rim clean afterwards.

## Mounting

The countersinks open **into the pocket**, so the heads finish flush with the
inner face of the back plate and never push the battery forward. Drive the four
screws from inside the cradle, through the 57.4 mm window between the lips,
before putting the battery in. With an 8 mm back plate a 40 mm screw gives
32 mm of embedment.

Load check: the battery's centre of mass sits ~55 mm off the wall, so 4 kg
produces about 2.2 N·m of tipping moment. Across the 160 mm vertical screw
spacing that is ~14 N of pull-out shared by the top pair, plus ~40 N of vertical
shear shared by all four — a fraction of what 4.0 × 40 screws carry.

**The fasteners, not the plastic, are the weak link here.** Into masonry use
6 mm nylon plugs. Into plasterboard, 4.0 × 40 screws alone will *not* hold 4 kg
on a 55 mm lever arm — hit a stud, or use proper hollow-wall anchors rated well
above 10 kg each.

The strap slots through the front lips take a 25 mm hook-and-loop strap across
the battery face. Not load-bearing, but cheap insurance against the pack being
knocked forward.

## Parameters

Open the file in the OpenSCAD Customizer; every group below is a `/* [Section] */`.

| Group | Parameters |
|---|---|
| Quality | `fn_preview`, `fn_render` |
| Preview helpers | `show_battery`, `show_wall`, `show_screws` |
| Battery | `battery_w`, `battery_d`, `battery_h`, `battery_kg` |
| Fit clearances | `clear_side`, `clear_front` |
| Shell thickness | `wall_back`, `wall_side`, `wall_floor` |
| Capture height | `capture_frac`, `capture_h_override` |
| Front lips | `lip_w`, `lip_t` |
| Lead-in chamfer | `lead_in_h`, `lead_in_x`, `lead_in_y` |
| Screws | `screw_shank_d`, `screw_head_d`, `screw_head_angle`, `screw_head_sink`, `screw_len`, `screw_x_offsets`, `screw_z_rows`, `screw_z_margin` |
| Charging port | `port_enable`, `port_side`, `port_d`, `port_from_back`, `port_from_bottom`, `port_edge_cham`, `port_boss`, `port_boss_t`, `port_boss_w` |
| Strap slots | `strap_enable`, `strap_h`, `strap_t`, `strap_z_rows`, `strap_z_margin` |

`screw_z_rows` and `strap_z_rows` are lists; leave them `[]` to auto-place from
the matching `*_margin`, or set e.g. `screw_z_rows = [40, 120, 200]` for three
rows. `screw_x_offsets` is measured from the pocket centre line.

The model `assert`s its own consistency — it refuses to render if the
countersink no longer fits the back plate, if the port opening would break into
the floor or run past the lips, if the lips overlap, if the front window gets
too narrow to drive a screw through, or if a strap slot lands in the lead-in
taper. `echo` prints a dimension summary to the console on every render.

### Set `port_side = "right"` if the charging port is on the other side

"Left" is as seen standing in front of the mounted holder, facing the battery.
The model mirrors the opening and its collar to the other wall.

### Slimmer variant

`wall_back = 6`, `wall_floor = 6`, `capture_frac = 0.50` drops roughly 15 % of
the filament and still clears every assertion — the countersink needs only
2.4 mm of the 6 mm plate, and 200 mm still meets the half-height requirement.

## Notes

- Nothing printed yet — geometry has been verified analytically (pocket clear of
  interference, port and screw placement, lip taper) but not on a real battery.
- Measure the battery before printing: the pocket assumes a true rectangular
  cuboid. If it has a tapered foot, a protruding latch, or rails on its back,
  add a relief cut-out or increase `clear_*` first.
- Check the port opening against the actual charger plug — ⌀35 mm fits the
  socket as specified, but a bulky plug body may want a few more millimetres or
  `port_edge_cham` opened up.
