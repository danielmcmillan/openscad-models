use <wheel.scad>
//$fa = 1;
$fs = 0.4;
overlap = 0.001;

length = 60;

track = 28;
turn_angle = 15;
body_roll = turn_angle / 4;

axle_z_offset = -4;
wheel_y_offset = track / 2;
axle_x_offset = length / 3;

module body(
    length = length,
    width = length / 3,
    base_height = 12,
    top_height = 8
) {
    // Base
    resize([length, width, base_height])
        sphere(length);
    // Top
    translate([5, 0, base_height / 2 - overlap / 2])
        resize([length / 2, width / 1.5, top_height + overlap])
        sphere(length / 2);
}

rotate([body_roll, 0, 0])
    body();

// Front wheels
translate([-axle_x_offset, -wheel_y_offset, axle_z_offset ])
    rotate([0, 0, -turn_angle])
    wheel();
translate([-axle_x_offset, wheel_y_offset, axle_z_offset ])
    rotate([0, 0, -turn_angle])
    wheel();
// Front axle
translate([-axle_x_offset, 0, axle_z_offset])
    rotate([90, 0, 0])
    cylinder(h=track, r=2, center=true);

// Rear wheels
translate([axle_x_offset, -wheel_y_offset, axle_z_offset ])
    rotate([0, 0, 0])
    wheel(width=5);
translate([axle_x_offset, wheel_y_offset, axle_z_offset ])
    rotate([0, 0, 0])
    wheel(width=5);
// Rear axle
translate([axle_x_offset, 0, axle_z_offset])
    rotate([90, 0, 0])
    cylinder(h=track, r=2, center=true);
