// Bike battery wall holder — wall-mounted drop-in cradle for an e-bike battery
// SPDX-License-Identifier: CC-BY-NC-SA-4.0
// =====================================================================
//  A thick-walled U-channel cradle: wall-facing back plate, two side
//  walls, a load-bearing floor shelf, and two front retaining lips.
//  The battery drops in from the top and rests on the floor.
//
//  Coordinate system (origin = back / left / bottom outer corner):
//    +X : left  -> right  (as seen standing in front of the holder)
//    +Y : wall  -> front
//    +Z : floor -> top
//
//  Units: millimetres. Mass: kg. Angles: degrees.
//
//  Export:  ./scripts/export.sh projects/bike-battery-wall-holder/bike-battery-wall-holder.scad
//  Check:   set show_battery = true in the GUI to eyeball the fit.
// =====================================================================

include <../../libs/BOSL2/std.scad>

/* [Quality] */
// Facets for curved surfaces in preview (higher = smoother, slower)
fn_preview = 64;   // [24:8:128]
// Facets for curved surfaces in the final render/export
fn_render  = 128;  // [64:8:256]

/* [Preview helpers] */
// Ghost battery, for visual fit checking (keep off when exporting)
show_battery = false;
// Ghost wall slab behind the back plate
show_wall    = false;
// Ghost screws, to check head seating
show_screws  = false;

/* [Preview colors] */
// Preview-only: color() is never written to the STL
use_colors = true;
// Back plate
col_back   = "SteelBlue";
// Side walls
col_sides  = "SeaGreen";
// Floor shelf
col_floor  = "DarkOrange";
// Front retaining lips
col_lips   = "Gold";
// Charging-port collar
col_collar = "MediumPurple";
// Faces exposed by holes, slots, lead-in and bed chamfer
col_cuts   = "Crimson";
// Ghost battery / wall / screws (RGBA)
col_ghost  = [0.6, 0.8, 1.0, 0.35];

/* [Battery] */
// X — battery width (left <-> right), mm
battery_w = 92;    // [40:0.5:200]
// Y — battery depth (wall <-> front), mm
battery_d = 91;    // [40:0.5:200]
// Z — battery height, mm
battery_h = 380;   // [100:1:600]
// Battery mass, kg (informational, used in the echo summary)
battery_kg = 4;    // [0.5:0.1:10]

/* [Fit clearances] */
// X — slack per side between battery and side wall (total is 2x), mm
clear_side  = 1.2; // [0:0.1:5]
// Y — slack between battery front face and the lips, mm
clear_front = 1.5; // [0:0.1:5]

/* [Shell thickness] */
// Back plate thickness (must fit the screw countersink), mm
wall_back  = 5.0;  // [3:0.5:20]
// Left and right side wall thickness, mm
wall_side  = 4.0;  // [2:0.5:15]
// Floor shelf thickness — carries the full battery weight, mm
wall_floor = 6.0;  // [3:0.5:20]

/* [Capture height] */
// Fraction of the battery height the holder wraps (at least 0.35)
capture_frac       = 0.40; // [0.35:0.01:1.00]
// Explicit capture height, mm (0 = derive from capture_frac)
capture_h_override = 0;    // [0:1:600]

/* [Front retaining lips] */
// X — how far each lip reaches inward from its side wall, mm
lip_w = 20.0;      // [5:0.5:60]
// Y — lip thickness, mm
lip_t = 5.0;       // [2:0.5:15]
// Z — lip height as a fraction of the pocket height (floor to top), from the floor up
lip_h_frac = 0.70; // [0.50:0.01:1.00]

/* [Top lead-in chamfer] */
// Flares the pocket mouth so the battery slides in without fighting it.
// The same Z/Y taper is repeated on the inner face of the front lips.
// Z — chamfer height from the top edge (and from the lip top) down, mm
lead_in_h = 15.0;  // [0.5:0.5:50]
// X — extra opening per side at the very top, mm
lead_in_x = 2.0;   // [0:0.5:10]
// Y — extra opening at the top of the pocket and of the lips (>= lip_t gives a knife edge), mm
lead_in_y = 7.0;   // [0:0.5:20]

/* [Mounting screws] */
// Defaults: 4.0 x 40 mm wood/masonry screw, TX-20, countersunk flat head.
// Nominal screw diameter, mm
screw_d          = 4.0;   // [3:0.5:8]
// Nominal countersunk head diameter, mm
screw_head_nom_d = 8.0;   // [5:0.5:16]
// Diametral clearance added to the shank hole and the countersink, mm
screw_clearance  = 0.4;   // [0:0.1:1.5]
// Included angle of the conical head, degrees
screw_head_angle = 90;    // [60:1:120]
// Extra recess so the head sits below the pocket face, mm
screw_head_sink  = 0.4;   // [0:0.1:3]
// Screw length, mm (informational — echoes the embedment depth)
screw_len        = 40;    // [20:1:120]
// Screw grid X offsets, measured from the pocket centre line, mm
screw_x_offsets = [-22, 22];
// Screw grid Z heights from the bottom of the part, mm ([] = auto: one low, one high row)
screw_z_rows    = [];
// Auto rows: distance from the floor top / from the part top, mm
screw_z_margin  = 30;     // [10:1:100]
// Extra window width, beyond the head, needed to reach the screws with a driver, mm
driver_access   = 8;      // [0:1:30]

/* [Charging port opening] */
// Cut an opening for the battery's charging port
port_enable      = true;
// Side wall with the opening, as seen facing the holder
port_side        = "right"; // [left, right]
// Opening diameter, mm
port_d           = 35.0;   // [10:0.5:60]
// Y — from the battery BACK face to the hole centre, mm
port_from_back   = 30.0;   // [5:0.5:150]
// Z — from the battery BOTTOM face to the hole centre, mm
port_from_bottom = 30.0;   // [5:0.5:300]
// Chamfer on both rims, for cable comfort, mm
port_edge_cham   = 1.2;    // [0:0.1:5]
// Reinforcing collar around the opening (outside)
port_boss        = true;
// How far the collar stands off the side wall, mm
port_boss_t      = 2.5;    // [0.5:0.5:10]
// Radial width of the collar, mm
port_boss_w      = 5.0;    // [1:0.5:15]

/* [Strap slots] */
// Optional pair of slots through the front lips for a hook-and-loop
// strap across the battery face — cheap insurance on a 4 kg pack.
// Cut the strap slots
strap_enable   = true;
// Z — slot height (strap width), mm
strap_h        = 25.0;  // [10:0.5:50]
// X — slot width (strap thickness + slack), mm
strap_t        = 4.0;   // [1:0.5:10]
// Slot centre heights from the bottom of the part, mm ([] = auto: one row near the top)
strap_z_rows   = [];
// Auto row: distance of the slot centre below the top of the lips, mm
strap_z_margin = 45;    // [20:1:200]
// Minimum lip material left on each side of a slot, mm
strap_rim_min  = 3;     // [1:0.5:10]
// Minimum gap between a slot and the top lead-in taper, mm
strap_lead_in_gap = 5;  // [0:1:30]

/* [Edge rounding] */
// Fillet radius on every exposed edge (0 = sharp). Bed-facing edges keep bed_chamfer, mm
fillet_r       = 1.0;   // [0:0.1:1.9]
// Facets of the rounding sphere (higher = smoother, much slower render)
fillet_fn      = 16;    // [8:4:48]
// Also round in preview (slow); off = fast, sharp, per-part colors
fillet_preview = false;

/* [Printing] */
// Chamfer on the bed-facing outer edges (elephant-foot relief), mm
bed_chamfer    = 0.6;   // [0:0.1:3]
// Max unsupported overhang your printer handles — shapes the teardrop port, degrees
overhang_angle = 45;    // [30:5:60]
// Minimum solid material left around holes and cut-outs, mm
min_web        = 2.0;   // [0.8:0.1:5]

/* [Hidden] */
// =====================================================================
//  Derived geometry and internals — nothing below needs editing
// =====================================================================

$fn = $preview ? fn_preview : fn_render;

eps          = 0.01; // avoids coincident faces in boolean ops
overshoot    = 1;    // how far cutters poke past the faces they cut
capture_step = 0.1;  // rounding step for the derived capture height
capture_frac_min = 0.35; // smallest share of the battery height the holder may wrap
lip_h_frac_min   = 0.50; // lip height limits, as a share of the pocket height
lip_h_frac_max   = 1.00;
// Effective fillet radius: the slow Minkowski rounding is skipped in preview
// unless asked for.
fr = ($preview && !fillet_preview) ? 0 : fillet_r;
ghost_wall_t = 15;   // thickness of the preview wall slab
ghost_margin = 20;   // how far the preview wall extends past the part

// Pocket (battery cavity) cross-section
cav_w = battery_w + 2 * clear_side;
cav_d = battery_d + clear_front;

capture_h = capture_h_override > 0
  ? capture_h_override
  : round(battery_h * capture_frac / capture_step) * capture_step;

// Overall envelope
total_w = cav_w + 2 * wall_side;
total_d = wall_back + cav_d + lip_t;
total_h = wall_floor + capture_h;

// Front lips rise from the floor shelf to lip_top
lip_h   = round(capture_h * lip_h_frac / capture_step) * capture_step;
lip_top = wall_floor + lip_h;

// Key planes
pocket_x0 = wall_side;              // inner face of the left wall
pocket_x1 = wall_side + cav_w;      // inner face of the right wall
pocket_y0 = wall_back;              // inner face of the back plate
pocket_y1 = wall_back + cav_d;      // inner face of the lips
pocket_z0 = wall_floor;             // top face of the floor shelf
centre_x  = total_w / 2;

// Clear opening between the two lips (where a driver / your hand reaches)
window_x0 = pocket_x0 + lip_w;
window_x1 = pocket_x1 - lip_w;
window_w  = window_x1 - window_x0;

// Screw holes (nominal + clearance) and countersink depth
screw_shank_d = screw_d + screw_clearance;
screw_head_d  = screw_head_nom_d + screw_clearance;
cs_depth = ((screw_head_d - screw_shank_d) / 2) / tan(screw_head_angle / 2);

// Screw rows
screw_z = len(screw_z_rows) > 0
  ? screw_z_rows
  : [ pocket_z0 + screw_z_margin, total_h - screw_z_margin ];

// Strap slot rows
strap_z = len(strap_z_rows) > 0
  ? strap_z_rows
  : [ lip_top - strap_z_margin ];

// Port centre, converted from battery-referenced to part coordinates
port_cy = wall_back  + port_from_back;
port_cz = wall_floor + port_from_bottom;

// Outer face of the side wall / collar on the port side
port_x_out = -(port_boss ? port_boss_t : 0);
collar_d   = port_d + 2 * port_boss_w;
// Downward teardrop tip of the collar, capped so it never dips below the bed
collar_tip = min((collar_d / 2) / sin(overhang_angle), port_cz);

// =====================================================================
//  Sanity checks
// =====================================================================

assert(capture_h >= battery_h * capture_frac_min - eps,
  str("capture_h must hold at least ", 100 * capture_frac_min,
      " % of the battery height"));
assert(cs_depth + screw_head_sink < wall_back - min_web,
  "wall_back too thin for the screw countersink — increase wall_back");
assert(screw_head_d > screw_shank_d,
  "screw head must be wider than the shank");
assert(2 * lip_w < cav_w,
  "front lips overlap — reduce lip_w");
assert(window_w > screw_head_d + driver_access,
  "front window too narrow to drive the screws — reduce lip_w");
assert(len(screw_z) >= 2, "need at least two screw rows");
assert(bed_chamfer < min(wall_side, wall_back, wall_floor, lip_t),
  "bed_chamfer larger than the thinnest wall");
assert(fillet_r >= 0, "fillet_r must not be negative");
assert(2 * fillet_r < min(wall_side, wall_back, wall_floor, lip_t,
                          strap_enable ? (lip_w - strap_t) / 2 : lip_w,
                          port_boss ? port_boss_w : wall_side),
  "fillet_r too large: it must be under half the thinnest wall, lip, strap rim and collar");
assert(lead_in_h < capture_h, "lead_in_h taller than the holder");
assert(lead_in_h < lip_h, "lead_in_h taller than the front lips");
assert(lip_h_frac >= lip_h_frac_min && lip_h_frac <= lip_h_frac_max,
  str("lip_h_frac must be between ", lip_h_frac_min, " and ", lip_h_frac_max));

if (port_enable) {
  assert(port_cz - port_d / 2 > wall_floor + min_web,
    "port opening cuts into the floor shelf — raise port_from_bottom");
  assert(port_cy - port_d / 2 > wall_back + min_web,
    "port opening cuts into the back plate — raise port_from_back");
  assert(port_cy + port_d / 2 < pocket_y1 - min_web,
    "port opening runs past the front lips — lower port_from_back");
  assert(port_cz + port_d / 2 < total_h - min_web,
    "port opening runs past the top of the side wall");
  assert(port_side == "left" || port_side == "right",
    "port_side must be \"left\" or \"right\"");
  assert(!port_boss || port_cz >= collar_d / 2,
    "port collar would dip below the bed — raise port_from_bottom or reduce port_boss_w");
}

if (strap_enable) {
  assert(strap_t + 2 * strap_rim_min < lip_w,
    "strap slot too wide for the lip — reduce strap_t");
  for (sz = strap_z) {
    assert(sz - strap_h / 2 > pocket_z0, "strap slot below the pocket floor");
    assert(sz + strap_h / 2 < lip_top - strap_rim_min,
      "strap slot runs past the top of the lips — increase strap_z_margin or lip_h_frac");
    assert(sz + strap_h / 2 < lip_top - lead_in_h - strap_lead_in_gap,
      "strap slot runs into the lead-in taper of the lips — increase strap_z_margin");
  }
}

// =====================================================================
//  Summary
// =====================================================================

echo(str("--- bike battery wall holder -------------------------------"));
echo(str("battery           : ", battery_w, " x ", battery_d, " x ",
         battery_h, " mm, ", battery_kg, " kg"));
echo(str("pocket            : ", cav_w, " x ", cav_d, " mm"));
echo(str("outside envelope  : ", total_w, " x ", total_d, " x ", total_h, " mm"));
echo(str("battery captured  : ", capture_h, " mm (",
         round(100 * capture_h / battery_h), "% of height)"));
echo(str("front lips        : ", lip_h, " mm tall (",
         round(100 * lip_h_frac), "% of pocket), top at z=", lip_top, " mm"));
echo(str("front window      : ", window_w, " mm wide"));
echo(str("screw X positions : ", [ for (dx = screw_x_offsets) centre_x + dx ], " mm"));
echo(str("screw Z positions : ", screw_z, " mm"));
echo(str("screw X spacing   : ",
         max(screw_x_offsets) - min(screw_x_offsets), " mm"));
echo(str("screw Z spacing   : ", max(screw_z) - min(screw_z), " mm"));
echo(str("countersink depth : ", cs_depth + screw_head_sink,
         " mm of ", wall_back, " mm plate"));
echo(str("screw embedment   : ", screw_len - wall_back, " mm into the wall"));
if (port_enable)
  echo(str("port centre       : ", port_side, " wall, y=", port_cy,
           " mm z=", port_cz, " mm (d=", port_d, " mm)"));
echo(str("-----------------------------------------------------------"));

// =====================================================================
//  Helpers
// =====================================================================

// Applies a preview color when use_colors is on.
module paint(c) {
  if (use_colors) color(c) children();
  else children();
}

// Box placed by its minimum corner, like cube(), but built with BOSL2.
module box(size, chamfer = 0, edges = []) {
  cuboid(size, chamfer = chamfer, edges = edges, anchor = LEFT + FRONT + BOTTOM);
}

// Teardrop along +X starting at x0, centred on (cy, cz). The profile points
// up (or down when `down`) with the printer's overhang angle, so a horizontal
// hole or boss prints without supports. cap1/cap2 truncate the tip.
module x_teardrop(x0, len, cy, cz, d1, d2, cap1, cap2, down = false) {
  translate([x0, cy, cz])
    mirror([0, 0, down ? 1 : 0])
      teardrop(l = len, d1 = d1, d2 = d2, cap_h1 = cap1, cap_h2 = cap2,
               ang = overhang_angle, spin = -90, anchor = FWD);
}

// Rounds every convex edge of the children by `r` (Minkowski with a sphere).
// The children must already be eroded by `r` so the result keeps its size.
module rounded(r) {
  if (r > 0)
    minkowski() { children(); sphere(r = r, $fn = fillet_fn); }
  else
    children();
}

// Grows a convex cutter by `r` on every side, the counterpart of the erosion
// above: cut, then round, and the opening ends up exactly at its nominal size.
module grown(r) {
  if (r > 0)
    minkowski() { children(); sphere(r = r, $fn = fillet_fn); }
  else
    children();
}

// Mirrors children to the right-hand wall when port_side == "right".
module on_port_side() {
  if (port_side == "right")
    translate([total_w, 0, 0]) mirror([1, 0, 0]) children();
  else
    children();
}

// =====================================================================
//  Parts
// =====================================================================

// The four parts only touch face to face (no overlap), so their preview
// colors never z-fight on shared outer faces.
// Every exposed face is pulled in by `fr` (the bed face excepted); the
// final Minkowski rounding pushes it back out, so the nominal dimensions hold.
module back_plate() {
  translate([fr, fr, 0])
    box([total_w - 2 * fr, wall_back - 2 * fr, total_h - fr]);
}

module floor_shelf() {
  translate([fr, wall_back - fr, 0])
    box([total_w - 2 * fr, total_d - wall_back, wall_floor - fr]);
}

module side_walls() {
  for (x = [fr, total_w - wall_side + fr])
    translate([x, wall_back - fr, wall_floor - fr])
      box([wall_side - 2 * fr, total_d - wall_back, total_h - wall_floor]);
}

module front_lips() {
  for (x = [pocket_x0 - fr, pocket_x1 - lip_w + fr])
    translate([x, pocket_y1 + fr, wall_floor - fr])
      box([lip_w, lip_t - 2 * fr, lip_h]);
}

// Removes what the rounding pushes below the bed, leaving a flat bottom.
module below_bed_cut() {
  o = overshoot;
  if (fr > 0)
    translate([-(fr + o), -(fr + o), -(fr + o)])
      box([total_w + 2 * (fr + o), total_d + 2 * (fr + o), fr + o]);
}

// Ring cutter that chamfers the bed-facing outer edges: a slab just under the
// part minus a 45° frustum. The frustum's slope runs past the part outline on
// both ends, so no cutter face is coplanar with a wall (clean preview).
module bed_chamfer_cut() {
  c = bed_chamfer;
  o = overshoot;
  if (c > 0)
    difference() {
      translate([-2 * o, -2 * o, -o])
        box([total_w + 4 * o, total_d + 4 * o, c + o]);
      translate([total_w / 2, total_d / 2, -o])
        prismoid(size1 = [total_w - 2 * (c + o), total_d - 2 * (c + o)],
                 size2 = [total_w + 2 * o, total_d + 2 * o],
                 h = c + 2 * o, anchor = BOTTOM);
    }
}

// Collar around the port opening. Teardrop pointing down so its underside
// stays within the overhang limit instead of a flat cantilevered ledge.
module port_collar() {
  // eroded by fr like the other parts; a tip resting on the bed stays there
  tip = collar_tip >= port_cz ? port_cz : collar_tip - fr;
  if (port_enable && port_boss)
    on_port_side()
      x_teardrop(port_x_out + fr, wall_side - port_x_out - 2 * fr, port_cy, port_cz,
                 collar_d - 2 * fr, collar_d - 2 * fr, tip, tip, down = true);
}

module holder_solid() {
  union() {
    paint(col_back)   back_plate();
    paint(col_sides)  side_walls();
    paint(col_floor)  floor_shelf();
    paint(col_lips)   front_lips();
    paint(col_collar) port_collar();
  }
}

// ---------------------------------------------------------------------
//  Cut-outs
// ---------------------------------------------------------------------

// Flared mouth at the top of the pocket. The taper continues `overshoot`
// above the part so the cut never shares a face with the top surface.
module lead_in_cut() {
  k  = (lead_in_h + overshoot) / lead_in_h;
  dx = lead_in_x * k;
  dy = lead_in_y * k;
  translate([centre_x, pocket_y0 + cav_d / 2, total_h - lead_in_h])
    prismoid(size1 = [cav_w, cav_d], size2 = [cav_w + 2 * dx, cav_d + dy],
             shift = [0, dy / 2], h = lead_in_h + overshoot, anchor = BOTTOM);
}

// Same lead-in taper on the inner (battery-side) face of the front lips, so
// a battery dropped in at a slight forward tilt is guided behind them. No X
// flare here: that would notch the side walls partway up.
module lip_lead_in_cut() {
  k  = (lead_in_h + overshoot) / lead_in_h;
  dy = lead_in_y * k;
  w  = cav_w + 2 * eps;
  translate([centre_x, pocket_y0 + cav_d / 2, lip_top - lead_in_h])
    prismoid(size1 = [w, cav_d], size2 = [w, cav_d + dy],
             shift = [0, dy / 2], h = lead_in_h + overshoot, anchor = BOTTOM);
}

// One countersunk screw hole, drilled from the pocket side into the wall.
// The conical seat opens toward the pocket so the head finishes flush with
// the inner face and never pushes the battery forward.
module mount_hole(cx, cz) {
  // through shank
  translate([cx, -eps, cz])
    ycyl(h = wall_back + 2 * eps, d = screw_shank_d, anchor = FRONT);
  // conical seat
  translate([cx, wall_back - cs_depth - screw_head_sink, cz])
    ycyl(h = cs_depth, d1 = screw_shank_d, d2 = screw_head_d, anchor = FRONT);
  // straight recess so the head finishes flush / just below the face
  translate([cx, wall_back - screw_head_sink, cz])
    ycyl(h = screw_head_sink + eps, d = screw_head_d, anchor = FRONT);
}

module mount_holes() {
  for (dx = screw_x_offsets)
    for (cz = screw_z)
      mount_hole(centre_x + dx, cz);
}

// Charging-port opening through the side wall (and its collar). Teardrop
// profile capped flat at the circle top: a short bridge instead of an
// unsupported arch.
module port_cut() {
  cham_d = port_d + 2 * (port_edge_cham + overshoot);
  if (port_enable)
    on_port_side() {
      // main bore
      x_teardrop(port_x_out - overshoot, wall_side - port_x_out + 2 * overshoot,
                 port_cy, port_cz, port_d, port_d, port_d / 2, port_d / 2);
      if (port_edge_cham > 0) {
        // outer rim chamfer
        x_teardrop(port_x_out - overshoot, port_edge_cham + overshoot,
                   port_cy, port_cz, cham_d, port_d, cham_d / 2, port_d / 2);
        // inner rim chamfer (pocket side)
        x_teardrop(wall_side - port_edge_cham, port_edge_cham + overshoot,
                   port_cy, port_cz, port_d, cham_d, port_d / 2, cham_d / 2);
      }
    }
}

// Strap slots through both front lips (each one grown by fr before rounding).
module strap_cuts() {
  if (strap_enable)
    for (sz = strap_z, xc = [pocket_x0 + lip_w / 2, pocket_x1 - lip_w / 2])
      grown(fr)
        translate([xc - strap_t / 2, pocket_y1 - overshoot, sz - strap_h / 2])
          box([strap_t, lip_t + 2 * overshoot, strap_h]);
}

// ---------------------------------------------------------------------
//  Assembly
// ---------------------------------------------------------------------

// The Minkowski rounding drops colors, so the rounded body is split back
// along the original part boundaries and each piece repainted (colors only;
// skipped when use_colors is off, so plain exports are untouched).
module repaint_parts() {
  big = total_w + total_d + total_h;           // reaches past the whole part
  module region(x0, x1, y0, y1, z0, z1) {
    translate([x0, y0, z0]) box([x1 - x0, y1 - y0, z1 - z0]);
  }
  if (use_colors && fr > 0) {
    // back plate: everything behind the pocket
    paint(col_back) intersection() {
      children(); region(0, total_w, -big, wall_back, -big, big); }
    // floor shelf: below the pocket floor, in front of the back plate
    paint(col_floor) intersection() {
      children(); region(0, total_w, wall_back, big, -big, wall_floor); }
    // side walls
    for (xr = [[0, pocket_x0], [pocket_x1, total_w]])
      paint(col_sides) intersection() {
        children(); region(xr[0], xr[1], wall_back, big, wall_floor, big); }
    // front lips
    paint(col_lips) intersection() {
      children(); region(pocket_x0, pocket_x1, pocket_y1, big, wall_floor, big); }
    // port collar, outside the side walls
    for (xr = [[-big, 0], [total_w, big]])
      paint(col_collar) intersection() {
        children(); region(xr[0], xr[1], -big, big, -big, big); }
  } else
    children();
}

// Lead-in and strap cuts happen before the rounding so their edges get
// filleted too; screw holes, the port (already rim-chamfered) and the bed
// chamfer are cut afterwards to keep their exact shape.
module holder() {
  difference() {
    repaint_parts() rounded(fr)
      difference() {
        holder_solid();
        paint(col_cuts) {
          grown(fr) lead_in_cut();
          grown(fr) lip_lead_in_cut();
          strap_cuts();
        }
      }
    paint(col_cuts) {
      mount_holes();
      port_cut();
      bed_chamfer_cut();
      below_bed_cut();
    }
  }
}

// ---------------------------------------------------------------------
//  Ghost geometry for visual checks — keep these off when exporting
// ---------------------------------------------------------------------

module ghost_battery() {
  paint(col_ghost) translate([centre_x - battery_w / 2, wall_back, wall_floor])
    box([battery_w, battery_d, battery_h]);
}

module ghost_wall() {
  paint(col_ghost) translate([-ghost_margin, -ghost_wall_t, -ghost_margin])
    box([total_w + 2 * ghost_margin, ghost_wall_t, total_h + 2 * ghost_margin]);
}

module ghost_screws() {
  for (dx = screw_x_offsets)
    for (cz = screw_z)
      paint(col_ghost) translate([centre_x + dx, wall_back - screw_head_sink, cz]) {
        // conical head: wide at the seated face, tapering into the wall
        ycyl(h = cs_depth, d1 = screw_d, d2 = screw_head_nom_d, anchor = BACK);
        // shank, continuing into the wall
        ycyl(h = screw_len, d = screw_d, anchor = BACK);
      }
}

holder();
if (show_battery) ghost_battery();
if (show_wall)    ghost_wall();
if (show_screws)  ghost_screws();
