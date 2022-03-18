$fa=1;
$fs=0.4;
overlap=0.005;

// todo: round base corners.

// Main customisation
wire_diameter=1.5;
reel_outer_diameter=55;
reel_inner_diameter=25;
rod_diameter=16.5;
rod_length=90.7;
wire_holder_length=15;
wire_holder_count=4;
base_length=66;

// Other parameters
base_thickness=1.5;
reel_bottom_spacing=5;
rod_depth=2.5;
rod_margin=2;
rod_holder_thickness=rod_depth+1;
rod_holder_bump_radius=3;
rod_holder_bump_size=1;
wire_holder_reel_distance=5; // Horizontal distance from reel to wire holder
wire_holder_margin=5; // Distance between the end and the outer slots
wire_holder_height=10;
joiner_height=18;

// Calculation
rod_centre_height=reel_outer_diameter/2+reel_inner_diameter/2-rod_diameter/2+reel_bottom_spacing;
// wire_holder_y=rod_diameter/2+rod_margin+reel_outer_diameter/2+wire_holder_reel_distance;
base_width=2*rod_holder_thickness-2*rod_depth+rod_length;
// base_length=wire_holder_y+wire_holder_length;
wire_holder_y=base_length-wire_holder_length;
joiner_corner_radius=joiner_height-wire_holder_height+overlap;

module rod_holder(open=false) {
    width=rod_diameter+rod_margin*2;
    height=rod_centre_height+rod_diameter/2+rod_margin;
    holder_inset_thickness=rod_holder_thickness-rod_depth;

    difference() {
        cube([rod_holder_thickness, width, height]);
        translate([holder_inset_thickness, width/2, rod_centre_height])
            rotate([0, 90, 0])
            cylinder(r=rod_diameter/2, h=rod_depth+overlap);
        difference() {
            translate([-overlap, -overlap, height-width/2-overlap])
                cube([rod_holder_thickness+overlap*2, width+overlap*2, width/2+overlap*2]);
            translate([-overlap, width/2, rod_centre_height])
                rotate([0, 90, 0])
                cylinder(r=width/2, h=rod_holder_thickness+overlap*2);
        }
        if (open) {
            // Cut top of circle out
            translate([holder_inset_thickness, rod_margin, rod_centre_height])
                cube([rod_depth+overlap, rod_diameter, rod_diameter/2+rod_margin+overlap]);
        }
    }
    if (open) {
        intersection() {
            for (bump_side=[-1:2:1]) {
                translate([
                    holder_inset_thickness-overlap,
                    rod_margin+(bump_side<0 ? rod_diameter:0)+bump_side*(rod_holder_bump_size-rod_holder_bump_radius),
                    rod_centre_height+sqrt((rod_diameter/2+rod_margin)^2-(rod_diameter/2)^2)-sqrt(rod_holder_bump_radius^2-(rod_holder_bump_radius-rod_holder_bump_size)^2)
                ])
                    rotate([0, 90, 0])
                    cylinder(r=rod_holder_bump_radius, h=rod_depth+overlap);
            }
            translate([holder_inset_thickness-overlap, rod_margin-overlap, rod_centre_height])
                cube([rod_depth+overlap, rod_diameter+overlap*2, rod_diameter/2+rod_margin+overlap]);
        }
    }
}

module wire_holder(
    length=wire_holder_length,
    wire_hole_depth=5,
    wire_diameter_min=wire_diameter-0.3,
    wire_diameter_max=wire_diameter+0.2
) {
    slots_length=base_width-wire_diameter_max-wire_holder_margin*2-rod_holder_thickness*2;
    translate([base_width/2, length/2, 0])
        difference() {
            linear_extrude(height=wire_holder_height)
                square([base_width, length], center=true);
            for (slot=[0:1:wire_holder_count-1]) {
                translate([slots_length/2 - slot*slots_length/(wire_holder_count-1), 0, wire_holder_height+overlap-wire_hole_depth])
                    linear_extrude(height=wire_hole_depth, scale=[wire_diameter_max/wire_diameter_min, 1])
                    square([wire_diameter_min, length+overlap], center=true);
            }
        }
}

module joiner(
    length,
    height,
    thickness
) {
    inner_wedge_outer_bottom_z=4.8;
    inner_wedge_outer_height=10.195;
    inner_wedge_inner_height=6.4;
    inner_wedge_depth=1.9;
    inner_wedge_inner_length=53.0;
    inner_wedge_outer_length=inner_wedge_inner_length-inner_wedge_depth*2;

    translate([0, length/2, inner_wedge_outer_height/2+inner_wedge_outer_bottom_z])
        rotate([0, 90, 0])
        linear_extrude(height=inner_wedge_depth, scale=[inner_wedge_outer_height/inner_wedge_inner_height, inner_wedge_outer_length/inner_wedge_inner_length])
        square([inner_wedge_inner_height, inner_wedge_inner_length], center=true);
    translate([-thickness, 0, 0])
        cube([thickness, length, height]);
}

translate([0, 0, base_thickness])
    rod_holder(open=true);
translate([base_width, 0, base_thickness])
    mirror([1, 0, 0])
    rod_holder(open=false);

translate([0, wire_holder_y, base_thickness])
    wire_holder();

// Base
cube([base_width, base_length, base_thickness+overlap]);

// Joiner
difference() {
    mirror([1, 0, 0])
        joiner(length=base_length, height=joiner_height, thickness=base_thickness);
    translate([-overlap, base_length-joiner_corner_radius+overlap, wire_holder_height])
        difference() {
            cube([base_thickness+overlap*2, joiner_corner_radius, joiner_corner_radius]);
            rotate([0, 90, 0])
                cylinder(h=base_thickness+overlap*2, r=joiner_corner_radius);
        }
}

translate([base_width-base_thickness, 0, 0])
    cube([base_thickness, base_length, base_thickness+wire_holder_height]);


// Rod
// translate([rod_holder_thickness-rod_depth, base_width+rod_diameter, 0])
//     rotate([0, 90, 0])
//     cylinder(h=rod_length, r=rod_diameter/2);
