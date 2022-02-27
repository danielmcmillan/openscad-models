module wheel(
    radius = 6,
    width = 2,
    side_radius = 30
) {
    difference() {
        sphere(radius);
        translate([0, width / 2 + side_radius, 0])
            sphere(side_radius);
        translate([0, -width / 2 - side_radius, 0])
            sphere(side_radius);

        translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 30, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 60, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 90, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 120, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 150, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 180, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 210, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 240, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 270, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 300, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
        rotate([0, 330, 0])
            translate([radius / 2, 0, 0])
            rotate([90, 0, 0])
            cylinder(h=radius * 2, r=0.5, center=true);
    }
}
