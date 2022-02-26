overlap = 0.001;

depth = 7.5;
thickness = 0.9;
innerDepth = depth - thickness;

// Space allowed for the rf board
board_width = 18.8;
board_height = 1.3;
// Space allowed for plug on the rf board
plug_opening_width_top = 8;
plug_opening_width_bottom = 7;
plug_opening_height = 2;
// Part enclosing top of rf board
board_top_width = 2;
board_top_height = thickness;

// Total height of base from bottom of rf board to ground
base_height = 11.2;

// Top of the base below the rf board
base_top_height_outside = thickness;
base_top_height_inside = plug_opening_height + thickness;
base_top_width_top = board_width + 2 * thickness;
base_top_width_bottom = 8;

// Bottom of the base on the ground
base_bottom_height_outside = thickness;
base_bottom_height_inside = thickness * 2;
base_bottom_width_bottom = 8;
base_bottom_width_top = 2;

module trapezoid(a, b, h, d) {
    linear_extrude(d, convexity = 2)
        polygon([
            [-b / 2, 0],
            [b / 2, 0],
            [a / 2, h],
            [-a / 2, h]
        ]);
}


difference() {
    union() {
        // Base bottom
        translate([-base_bottom_width_bottom / 2, 0])
            cube([base_bottom_width_bottom, base_bottom_height_outside + overlap, depth]);
        translate([0, base_bottom_height_outside])
            trapezoid(
                base_bottom_width_top,
                base_bottom_width_bottom,
                base_bottom_height_inside - base_bottom_height_outside + overlap,
                depth
            );
        // Base middle
        translate([-base_bottom_width_top / 2, base_bottom_height_inside])
            cube([base_bottom_width_top, base_height - base_bottom_height_inside - base_top_height_inside + overlap, depth]);
        // Base top
        union() {
            translate([0, base_height - base_top_height_outside + overlap])
                mirror([0, 1, 0]) // top edge on origin
                trapezoid(
                    base_top_width_bottom,
                    base_top_width_top,
                    base_top_height_inside - base_top_height_outside + overlap,
                    depth
                );
            translate([-base_top_width_top / 2, base_height + overlap])
                mirror([0, 1, 0]) // top edge on origin
                cube([base_top_width_top, base_top_height_outside + overlap, depth]);
        }
        // Rf board sides
        translate([board_width / 2, base_height])
            cube([(base_top_width_top - board_width) / 2, board_height + board_top_height, innerDepth]);
        translate([-board_width / 2, base_height])
            mirror([1, 0, 0]) // right edge on origin
            cube([(base_top_width_top - board_width) / 2, board_height + board_top_height, innerDepth]);
        // Above rf board
        translate([board_width / 2 + overlap, base_height + board_height])
            mirror([1, 0, 0]) // right edge on origin
            cube([board_top_width + overlap, board_top_height, innerDepth]);
        translate([-board_width / 2 - overlap, base_height + board_height])
            cube([board_top_width + overlap, board_top_height, innerDepth]);
        // Cover
        translate([-base_top_width_top / 2, base_height, innerDepth - overlap])
            // mirror([0, 1, 0]) // top edge on origin
            cube([
                base_top_width_top,
                board_height + board_top_height,
                thickness + overlap
            ]);
    }
    // Space for plug
    translate([0, base_height + overlap])
        mirror([0, 1, 0]) // top edge on origin
        trapezoid(
            plug_opening_width_bottom,
            plug_opening_width_top,
            plug_opening_height + overlap,
            depth
        );
    translate([-plug_opening_width_top / 2, base_height + overlap])
        cube([plug_opening_width_top, board_height + thickness, depth]);
}
