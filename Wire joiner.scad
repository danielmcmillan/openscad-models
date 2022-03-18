// $fa=1;
// $fs=0.4;

// Main customisation
wire_diameter=1.5;
bridge_distance=16;
bridge_height=18;

// Other params
wire_diameter_min=wire_diameter-0.3;
wire_diameter_max=wire_diameter+0.2;
wire_hole_depth=5;
support_top_thickness=10;
support_top_width=10;
support_bottom_thickness=3;
support_bottom_width=10;
support_base_height=2;

module support() {
    difference() {
        // Support
        translate([0, support_top_thickness/2])
            linear_extrude(height=bridge_height+support_base_height, scale=[support_top_width/support_bottom_width, support_top_thickness/support_bottom_thickness])
            square([support_bottom_width, support_bottom_thickness], center=true);
        // Wire hole
        translate([0, 0, bridge_height+support_base_height-wire_hole_depth])
            linear_extrude(height=wire_hole_depth, scale=[wire_diameter_max/wire_diameter_min, 1])
            translate([-wire_diameter_min/2, 0])
            square([wire_diameter_min, support_top_thickness]);
    }
}

support();
translate([0, support_top_thickness*2+bridge_distance, 0])
    rotate([0, 0, 180])
    support();
//Base
translate([-support_bottom_width/2,support_top_thickness/2,0])
    cube([support_bottom_width, bridge_distance+support_top_thickness, support_base_height]);
