# MakerWorld listing — Bike battery wall holder

Copy the sections below into the MakerWorld upload form.

## Files to upload

| File | Where in the form | Why |
|------|-------------------|-----|
| `exports/bike-battery-wall-holder.3mf` (from `./scripts/export.sh projects/bike-battery-wall-holder/bike-battery-wall-holder.scad`, then sliced and saved in Bambu Studio with the settings below) | Print profile | Ready to print, with the 1 mm rounded edges |
| [`makerworld/bike-battery-wall-holder.scad`](makerworld/bike-battery-wall-holder.scad) | Raw Model Files | Turns on the **Customize** button (Parametric Model Maker) |
| `pictures/holder_printed_and_installed.jpg` | Pictures | |

The `.scad` for MakerWorld is generated from the main model by
`scripts/makerworld.py`. Regenerate it after any change to the model. See
[docs/makerworld-parametric.md](../../docs/makerworld-parametric.md) for the
rules it follows. Unlike the 3MF, it has **sharp edges**: MakerWorld's renderer
times out on the Minkowski edge rounding.

---

## Title

E-bike battery wall holder — charge in place (Bafang BT F08.600.C, parametric)

## Tags

e-bike, ebike, battery, bafang, wall mount, holder, cradle, charging, garage, storage, honeycomb, parametric, openscad, petg

## Category

Household › Organization (or Tools › Garage & Workshop)

## Summary (short description)

A wall cradle for an e-bike battery. Drop the battery in from the top and lift it out with one hand. A side opening keeps the charging port reachable, so it charges while docked. Prints without supports. Two screws hold it on the wall.

## Description

I got tired of my 4 kg e-bike battery lying on the floor while it charged, so I designed a holder that keeps it upright on the wall with the charger plugged in.

**Made for the Bafang BT F08.600.C (600 Wh)** frame battery (92 × 91 × 380 mm, 4 kg). It is fully parametric, so you can adapt it to other batteries of similar shape (see *Customizing* below).

### Features

- **Drop in, lift out**: no latch, no strap. The battery rests on a 6 mm floor shelf and is held by the side walls and two front lips that reach 70 % of the way up.
- **Charge in place**: a 35 mm opening in the side wall lines up with the battery's charging port. A collar reinforces the edge, and the rims are chamfered so they don't rub the cable.
- **Holds 40 % of the battery height** (152 mm), so the battery cannot tip out.
- **Honeycomb walls**: the side walls, back plate and lips have hexagonal cut-outs with a solid frame at every joint. This uses about 39 % less filament than solid walls.
- **No sharp edges**: in the ready-to-print file, every exposed edge is rounded (1 mm fillet).
- **No supports needed**: the hexagon tops and the teardrop-shaped port opening are designed to print without supports.

### Size

- Outside: 102.4 (W) × 102.5 (D) × 158 (H) mm
- Pocket: 94.4 × 92.5 mm (1.2 mm clearance on each side, 1.5 mm at the front)
- Weight: about 170 g of PETG

### Print settings

Tested on a Bambu Lab H2D with a 0.4 mm nozzle, in SUNLU PETG High Speed Matte. Any printer with a build height of at least 160 mm should work.

- **Orientation:** as supplied, standing upright with the floor shelf on the bed and the back plate vertical. Don't rotate it. This orientation needs no supports, and the battery's weight pulls along the layers instead of peeling them apart.
- **Profile:** 0.20 mm layer height (Bambu Studio: *0.20mm Balanced Strength*)
- **Walls:** 5 loops
- **Infill:** 40 % gyroid
- **Top / bottom layers:** 6 / 4
- **Supports:** off (if your profile turns tree supports on automatically, turn them off)
- **Brim:** 5 mm, because the part is tall
- **Material:** PETG recommended. PLA works, but it creeps under constant load and softens in a warm garage. Keep the holder away from heat sources, since PETG softens at about 70 °C.

Print time is roughly 5–7 h, depending on your printer.

### Hardware

| Qty | Item |
|-----|------|
| 2 | Countersunk wood or masonry screw, 4 × 40 mm (TX-20) |
| 2 | 6 mm wall plug (masonry walls) |

### Mounting

1. Hold the holder against the wall at the height you want and mark the two screw holes. They are on the centre line, 92 mm apart.
2. Drill the holes and insert the wall plugs.
3. Drive the screws **from inside the cradle**, through the gap between the two front lips. The countersinks are on the inside, so the screw heads sit flush and don't press on the battery.
4. Drop the battery in and plug in the charger through the side opening.

⚠️ **The screws and wall plugs carry the load, not the plastic.** The battery hangs about 50 mm out from the wall. On masonry or wood, 4 × 40 mm screws are plenty. On **plasterboard / drywall**, screw into a stud or use hollow-wall anchors rated for more than 10 kg each. Plain screws in plasterboard will not hold.

### Customizing

Click **Customize** to change the model in your browser. Every dimension is a parameter. The customized version has sharp edges instead of the 1 mm rounding, because the rounding is too slow for MakerWorld's online renderer. The main options:

- **Other battery:** set `battery_w`, `battery_d`, `battery_h` to your battery's measurements. Measure it first: the pocket assumes a plain rectangular box. If your battery has a tapered foot, a latch or rails, increase `clear_side` / `clear_front`.
- **Charging port position:** `port_from_back` and `port_from_bottom` set the hole centre, measured from the battery's back and bottom faces. `port_d` sets the hole size, so make it bigger if your charger plug is bulky. `port_side` (`left` / `right`, as seen standing in front of the holder) chooses which wall gets the opening. Set `port_enable = false` for no opening.
- **Taller or shorter cradle:** `capture_frac` sets how much of the battery height is held (0.35 minimum).
- **Solid walls:** set `hex_sides`, `hex_back` or `hex_lips` to `false` if you'd rather have solid panels.
- **Flared opening:** set `lead_in_h = 15` to make the top wider, so the battery is easier to drop in.

The model checks its own settings: if a combination would make broken geometry (a screw head too deep for the back plate, a port hole cutting into the floor, and so on), it stops with a message telling you which parameter to change.

### License

CC BY-NC-SA 4.0. You can share and remix it for non-commercial use, with attribution and under the same license.
