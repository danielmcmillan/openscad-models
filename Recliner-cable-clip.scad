use <MCAD/boxes.scad>
// $fa=1;
$fs=0.4;

width=16;
height=11.5;
length=23.5;

top_radius=8;
side_straight_height=6.5;
thickness=1.5;

rounded_section_length=11;
rounded_section_radius=5;
rounded_section_hole_radius=2;

clip_hole_offset=5.2;
clip_hole_radius=2;
clip_bump_radius=2;
clip_bump_size=0.8;

module volume() {
    cube([width, side_straight_height, length]);
    difference() {
        translate([top_radius, side_straight_height])
            cylinder(r=top_radius, h=length, center=false);
        translate([0, height])
            cube([width, height, length]);
    }

}

module outline() {
    translate([0, 0, height])
        rotate([-90, 0, 0])
        difference() {
            volume();
            translate([thickness, -thickness, 0])
                scale([1 - 2*thickness/width, 1, 1])
                volume();
        }
}

difference() {
    outline();
    // Straight edge of rounded section
    translate([0, length - rounded_section_length])
        cube([width, rounded_section_length, height - 2*rounded_section_radius]);
    translate([0, length - rounded_section_length, 0])
        rotate([0, 90, 0])
        cylinder(r=height - 2*rounded_section_radius, h=width, center=false);
    // Round the end of rounded section
    difference() {
        translate([0, length - rounded_section_radius, 0])
            cube([width, rounded_section_radius, height]);
        translate([0, length - rounded_section_radius, height - rounded_section_radius])
            rotate([0, 90, 0])
            cylinder(r=rounded_section_radius, h=width, center=false);
    }
    // Hole in rounded section
    translate([0, length - rounded_section_radius, height - rounded_section_radius])
        rotate([0, 90, 0])
        cylinder(r=rounded_section_hole_radius, h=width, center=false);
    // Hole for clip
    difference() {
        union() {
            translate([0, clip_hole_offset, height - clip_hole_offset])
                rotate([0, 90, 0])
                cylinder(r=clip_hole_radius, h=width, center=false);
            translate([0, clip_hole_offset - clip_hole_radius, height - clip_hole_offset])
                cube([width, clip_hole_radius*2, clip_hole_offset]);
        }
        translate([0, clip_hole_offset - clip_hole_radius - clip_bump_radius + clip_bump_size, height - clip_bump_radius])
            rotate([0, 90, 0])
            cylinder(r=clip_bump_radius, h=width, center=false);
    }
}
