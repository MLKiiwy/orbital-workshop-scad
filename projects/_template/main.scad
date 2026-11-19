// Project template — rounded box example showing the parameter conventions
// SPDX-License-Identifier: CC-BY-NC-SA-4.0

include <../../libs/BOSL2/std.scad>

/* [Dimensions] */
// Outer width (X), mm
width = 40; // [10:1:200]
// Outer depth (Y), mm
depth = 30; // [10:1:200]
// Outer height (Z), mm
height = 20; // [5:1:150]
// Wall thickness, mm
wall = 2; // [0.8:0.2:6]
// Corner rounding radius, mm
rounding = 3; // [0:0.5:20]

/* [Printing] */
// Bottom edge chamfer (helps against elephant foot), mm
bottom_chamfer = 0.6; // [0:0.1:2]

/* [Quality] */
// Facet size used for the final export, mm
export_fs = 0.4; // [0.1:0.1:2]

/* [Hidden] */
$fa = 2;
$fs = $preview ? 1 : export_fs;
eps = 0.01;

assert(wall * 2 < min(width, depth), "wall too thick for width/depth");
assert(rounding * 2 <= min(width, depth), "rounding too large");

module open_box() {
    diff()
        cuboid([width, depth, height], rounding = rounding,
               edges = "Z", anchor = BOTTOM) {
            // bottom chamfer on the bed-facing edges
            edge_mask(BOTTOM) chamfer_edge_mask(chamfer = bottom_chamfer);
            corner_mask(BOTTOM) chamfer_corner_mask(chamfer = bottom_chamfer);
            // inner cavity
            tag("remove") position(TOP)
                cuboid([width - 2 * wall, depth - 2 * wall, height - wall + eps],
                       rounding = max(rounding - wall, 0), edges = "Z", anchor = TOP);
        }
}

open_box();
