// =====================================================================
//  Bike battery wall holder — fully parametric
// ---------------------------------------------------------------------
//  A thick-walled U-channel cradle: wall-facing back plate, two side
//  walls, a load-bearing floor shelf, and two front retaining lips.
//  The battery drops in from the top and rests on the floor.
//
//  Coordinate system (origin = back / left / bottom outer corner):
//    +X : left  -> right  (as seen standing in front of the holder)
//    +Y : wall  -> front
//    +Z : floor -> top
//
//  Units: millimetres. Angles: degrees.
//
//  Render:  openscad -o holder.stl bike-battery-wall-holder.scad
//  Check:   set show_battery = true in the GUI to eyeball the fit.
// =====================================================================

/* [Quality] */
// Facets for curved surfaces (higher = smoother, slower)
fn_preview = 64;   // [24:128]
fn_render  = 128;  // [64:256]
$fn = $preview ? fn_preview : fn_render;

/* [Preview helpers] */
show_battery = false; // ghost battery, for visual fit checking
show_wall    = false; // ghost wall slab behind the back plate
show_screws  = false; // ghost screws, to check head seating

/* [Preview colors] */
// Preview-only: color() is never written to the STL.
use_colors = true;
col_back   = "SteelBlue";      // back plate
col_sides  = "SeaGreen";       // side walls
col_floor  = "DarkOrange";     // floor shelf
col_lips   = "Gold";           // front retaining lips
col_collar = "MediumPurple";   // charging-port collar
col_cuts   = "Crimson";        // faces exposed by holes, slots, lead-in
col_ghost  = [0.6, 0.8, 1.0, 0.35]; // ghost battery / wall / screws

/* [Battery] */
battery_w = 95;    // X — width  (left<->right)
battery_d = 93;    // Y — depth  (wall<->front)
battery_h = 400;   // Z — height
battery_kg = 4;    // informational only, used in the echo summary

/* [Fit clearances] */
clear_side  = 1.2; // per side, X — total slack is 2x this
clear_front = 1.5; // Y — between battery front face and the lips

/* [Shell thickness] */
wall_back  = 8.0;  // back plate (must fit the screw countersink)
wall_side  = 5.0;  // left + right side walls
wall_floor = 8.0;  // bottom shelf — carries the full battery weight

/* [Capture height] */
// Fraction of the battery height the holder wraps. The brief asks for
// at least half; 0.55 gives margin. Overridden by capture_h_override.
capture_frac       = 0.55; // [0.30:0.01:1.00]
capture_h_override = 0;    // mm, 0 = derive from capture_frac

/* [Front retaining lips] */
lip_w = 20.0;      // X — how far each lip reaches inward from its side wall
lip_t = 5.0;       // Y — lip thickness

/* [Top lead-in chamfer] */
// Flares the pocket mouth so the battery slides in without fighting it.
lead_in_h = 15.0;  // Z — chamfer height from the top edge down
lead_in_x = 2.0;   // X — extra opening per side at the very top
lead_in_y = 7.0;   // Y — extra opening at the top (>= lip_t fully tapers the lips)

/* [Mounting screws] */
// Defaults: 4.0 x 40 mm wood/masonry screw, TX-20, countersunk flat head.
screw_shank_d    = 4.4;   // through-hole diameter (4.0 screw + clearance)
screw_head_d     = 8.4;   // countersunk head diameter + clearance
screw_head_angle = 90;    // included angle of the conical head
screw_head_sink  = 0.4;   // extra recess so the head sits below the face
screw_len        = 40;    // informational — used to echo embedment depth
// Screw grid. X offsets are measured from the pocket centre line,
// Z values are absolute heights from the bottom of the part.
screw_x_offsets = [-22, 22];
screw_z_rows    = [];     // [] = auto (one low row, one high row)
screw_z_margin  = 30;     // mm from floor top / from part top when auto

/* [Charging port opening] */
port_enable      = true;
port_side        = "right"; // ["left", "right"] — as seen facing the holder
port_d           = 35.0;   // opening diameter
port_from_back   = 30.0;   // Y — from the battery BACK face to hole centre
port_from_bottom = 30.0;   // Z — from the battery BOTTOM face to hole centre
port_edge_cham   = 1.2;    // chamfer on both rims, for cable comfort
port_boss        = true;   // reinforcing collar around the opening (outside)
port_boss_t      = 2.5;    // how far the collar stands off the side wall
port_boss_w      = 5.0;    // radial width of the collar

/* [Strap slots] */
// Optional pair of slots through the front lips for a hook-and-loop
// strap across the battery face — cheap insurance on a 4 kg pack.
strap_enable = true;
strap_h      = 25.0;  // Z — slot height (strap width)
strap_t      = 4.0;   // X — slot width (strap thickness + slack)
strap_z_rows = [];    // [] = auto (one row in the upper half of the lip)
strap_z_margin = 45;  // mm below the part top when auto

// =====================================================================
//  Derived geometry — nothing below here needs editing
// =====================================================================

eps = 0.01;

// Pocket (battery cavity) cross-section
cav_w = battery_w + 2 * clear_side;
cav_d = battery_d + clear_front;

// rounded to 0.1 mm so derived dimensions stay tidy
capture_h = capture_h_override > 0
  ? capture_h_override
  : round(battery_h * capture_frac * 10) / 10;

// Overall envelope
total_w = cav_w + 2 * wall_side;
total_d = wall_back + cav_d + lip_t;
total_h = wall_floor + capture_h;

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

// Countersink depth for the conical head
cs_depth = ((screw_head_d - screw_shank_d) / 2) / tan(screw_head_angle / 2);

// Screw rows
screw_z = len(screw_z_rows) > 0
  ? screw_z_rows
  : [ pocket_z0 + screw_z_margin, total_h - screw_z_margin ];

// Strap slot rows
strap_z = len(strap_z_rows) > 0
  ? strap_z_rows
  : [ total_h - strap_z_margin ];

// Port centre, converted from battery-referenced to part coordinates
port_cy = wall_back  + port_from_back;
port_cz = wall_floor + port_from_bottom;

// Outer face of the side wall / collar on the port side
port_x_out = -(port_boss ? port_boss_t : 0);

// =====================================================================
//  Sanity checks
// =====================================================================

assert(capture_h >= battery_h / 2,
  "capture_h must hold at least half the battery height");
assert(cs_depth + screw_head_sink < wall_back - 1.5,
  "wall_back too thin for the screw countersink — increase wall_back");
assert(2 * lip_w < cav_w,
  "front lips overlap — reduce lip_w");
assert(window_w > screw_head_d + 8,
  "front window too narrow to drive the screws — reduce lip_w");
assert(len(screw_z) >= 2, "need at least two screw rows");

if (port_enable) {
  assert(port_cz - port_d / 2 > wall_floor + 2,
    "port opening cuts into the floor shelf — raise port_from_bottom");
  assert(port_cy - port_d / 2 > wall_back + 2,
    "port opening cuts into the back plate — raise port_from_back");
  assert(port_cy + port_d / 2 < pocket_y1 - 2,
    "port opening runs past the front lips — lower port_from_back");
  assert(port_cz + port_d / 2 < total_h - 2,
    "port opening runs past the top of the side wall");
  assert(port_side == "left" || port_side == "right",
    "port_side must be \"left\" or \"right\"");
}

if (strap_enable) {
  assert(strap_t + 6 < lip_w, "strap slot too wide for the lip — reduce strap_t");
  for (sz = strap_z) {
    assert(sz - strap_h / 2 > pocket_z0, "strap slot below the pocket floor");
    assert(sz + strap_h / 2 < total_h - lead_in_h - 5,
      "strap slot runs into the top lead-in taper — increase strap_z_margin");
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
echo(str("front window      : ", window_w, " mm wide"));
echo(str("screw X positions : ", [ for (dx = screw_x_offsets) centre_x + dx ]));
echo(str("screw Z positions : ", screw_z));
echo(str("screw X spacing   : ",
         max(screw_x_offsets) - min(screw_x_offsets), " mm"));
echo(str("screw Z spacing   : ", max(screw_z) - min(screw_z), " mm"));
echo(str("countersink depth : ", cs_depth + screw_head_sink,
         " mm of ", wall_back, " mm plate"));
echo(str("screw embedment   : ", screw_len - wall_back, " mm into the wall"));
if (port_enable)
  echo(str("port centre       : ", port_side, " wall, y=", port_cy,
           " z=", port_cz, " (d=", port_d, ")"));
echo(str("-----------------------------------------------------------"));

// =====================================================================
//  Parts
// =====================================================================

// Applies a preview color when use_colors is on.
module paint(c) {
  if (use_colors) color(c) children();
  else children();
}

// Mirrors children to the right-hand wall when port_side == "right".
module on_port_side() {
  if (port_side == "right")
    translate([total_w, 0, 0]) mirror([1, 0, 0]) children();
  else
    children();
}

module back_plate() {
  cube([total_w, wall_back, total_h]);
}

module side_walls() {
  cube([wall_side, total_d, total_h]);
  translate([total_w - wall_side, 0, 0])
    cube([wall_side, total_d, total_h]);
}

module floor_shelf() {
  cube([total_w, total_d, wall_floor]);
}

module front_lips() {
  translate([pocket_x0, pocket_y1, 0])
    cube([lip_w, lip_t, total_h]);
  translate([pocket_x1 - lip_w, pocket_y1, 0])
    cube([lip_w, lip_t, total_h]);
}

module port_collar() {
  if (port_enable && port_boss)
    on_port_side()
      translate([port_x_out, port_cy, port_cz])
        rotate([0, 90, 0])
          cylinder(h = wall_side - port_x_out, d = port_d + 2 * port_boss_w);
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

// Flared mouth at the top of the pocket. The upper box is pushed 1 mm above
// the part so the cut never shares a face with the top surface.
module lead_in_cut() {
  hull() {
    translate([pocket_x0, pocket_y0, total_h - lead_in_h])
      cube([cav_w, cav_d, eps]);
    translate([pocket_x0 - lead_in_x, pocket_y0, total_h])
      cube([cav_w + 2 * lead_in_x, cav_d + lead_in_y, 1]);
  }
}

// One countersunk screw hole, drilled from the pocket side into the wall.
// The conical seat opens toward the pocket so the head finishes flush with
// the inner face and never pushes the battery forward.
module screw_hole(cx, cz) {
  // through shank
  translate([cx, -eps, cz])
    rotate([-90, 0, 0])
      cylinder(h = wall_back + 2 * eps, d = screw_shank_d);
  // conical seat
  translate([cx, wall_back - cs_depth - screw_head_sink, cz])
    rotate([-90, 0, 0])
      cylinder(h = cs_depth, d1 = screw_shank_d, d2 = screw_head_d);
  // straight recess so the head finishes flush / just below the face
  translate([cx, wall_back - screw_head_sink, cz])
    rotate([-90, 0, 0])
      cylinder(h = screw_head_sink + eps, d = screw_head_d);
}

module screw_holes() {
  for (dx = screw_x_offsets)
    for (cz = screw_z)
      screw_hole(centre_x + dx, cz);
}

// Charging-port opening through the side wall (and its collar).
module port_cut() {
  if (port_enable)
    on_port_side() {
      // main bore, from 1 mm outside the collar through the side wall
      translate([port_x_out - 1, port_cy, port_cz])
        rotate([0, 90, 0])
          cylinder(h = wall_side - port_x_out + 2, d = port_d);
      // outer rim chamfer
      translate([port_x_out - 1, port_cy, port_cz])
        rotate([0, 90, 0])
          cylinder(h = port_edge_cham + 1,
                   d1 = port_d + 2 * (port_edge_cham + 1),
                   d2 = port_d);
      // inner rim chamfer (pocket side)
      translate([wall_side - port_edge_cham, port_cy, port_cz])
        rotate([0, 90, 0])
          cylinder(h = port_edge_cham + 1,
                   d1 = port_d,
                   d2 = port_d + 2 * (port_edge_cham + 1));
    }
}

// Strap slots through both front lips.
module strap_cuts() {
  if (strap_enable)
    for (sz = strap_z) {
      translate([pocket_x0 + lip_w / 2 - strap_t / 2, pocket_y1 - eps,
                 sz - strap_h / 2])
        cube([strap_t, lip_t + 2 * eps, strap_h]);
      translate([pocket_x1 - lip_w / 2 - strap_t / 2, pocket_y1 - eps,
                 sz - strap_h / 2])
        cube([strap_t, lip_t + 2 * eps, strap_h]);
    }
}

// ---------------------------------------------------------------------
//  Assembly
// ---------------------------------------------------------------------

module holder() {
  difference() {
    holder_solid();
    paint(col_cuts) {
      lead_in_cut();
      screw_holes();
      port_cut();
      strap_cuts();
    }
  }
}

// ---------------------------------------------------------------------
//  Ghost geometry for visual checks (never exported as part of the STL
//  unless you enable it — keep these false when slicing)
// ---------------------------------------------------------------------

module ghost_battery() {
  paint(col_ghost) translate([centre_x - battery_w / 2, wall_back, wall_floor])
    cube([battery_w, battery_d, battery_h]);
}

module ghost_wall() {
  paint(col_ghost) translate([-20, -15, -20]) cube([total_w + 40, 15, total_h + 60]);
}

module ghost_screws() {
  for (dx = screw_x_offsets)
    for (cz = screw_z)
      paint(col_ghost) translate([centre_x + dx, wall_back - screw_head_sink, cz])
        rotate([90, 0, 0]) {
          // conical head: wide at the seated face, tapering into the wall
          cylinder(h = cs_depth, d1 = screw_head_d - 0.4, d2 = screw_shank_d - 0.4);
          // shank, continuing into the wall
          cylinder(h = screw_len, d = 4.0);
        }
}

holder();
if (show_battery) ghost_battery();
if (show_wall)    ghost_wall();
if (show_screws)  ghost_screws();
