$fa=1;
$fs=0.4;
overlap=0.005;

module standoff(height, inner_r, outer_r, fillet_x, fillet_y, depth=-0.8) {
    d=depth <= 0 ? height+depth : depth;
    difference() {
        union() {
            cylinder(h=height, r=outer_r, center=false);
            cylinder(h=fillet_y, r1=fillet_x, r2=outer_r-overlap, center=false);
        }
        translate([0, 0, height-d]) cylinder(h=d+overlap, r=inner_r, center=false);
    }
}

module standoff_m2(height, inner_r_offset=0, outer_r=1.7, fillet_x=2.2, fillet_y=2.5, depth=0) {
    standoff(height, inner_r=0.9+inner_r_offset, outer_r=outer_r, fillet_x=fillet_x, fillet_y=fillet_y, depth=depth);
}

module standoff_m3(height, inner_r_offset=0, outer_r=2.2, fillet_x=3.7, fillet_y=2.5, depth=0) {
    standoff(height, inner_r=1.4+inner_r_offset, outer_r=outer_r, fillet_x=fillet_x, fillet_y=fillet_y, depth=depth);
}

module standoff_m4(height, inner_r_offset=0, outer_r=2.6, fillet_x=4.1, fillet_y=2.5, depth=0) {
    standoff(height, inner_r=1.8+inner_r_offset, outer_r=outer_r, fillet_x=fillet_x, fillet_y=fillet_y, depth=depth);
}

union() {
    cube([30, 12, 0.6]);
    translate([5, 6, 0.3-overlap])
        standoff_m2(6.0);
    translate([15, 6, 0.3-overlap])
        standoff_m3(6.0);
    translate([25, 6, 0.3-overlap])
        standoff_m4(6.0);
}
