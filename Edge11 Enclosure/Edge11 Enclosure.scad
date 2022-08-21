use <MCAD/boxes.scad>
use <standoff.scad>
// $fa=1;
// $fs=0.4;
$fa=1;
$fs=1;
overlap=0.005;
// Todo:
// Decide whether to allow for anything else (wifi antennas, internal usb, 2nd hdd)
// Test everything

left=true; right=true; top=false; bottom=true;

shell_thickness=1.2;
pcb_bottom_clearance=8.0;
pcb_y1_clearance=2.4;
pcb_y2_clearance=4.0;
lip_exposed=2.0;
lip_overlap=4.0;
lip_thickness=0.8;
lip_tolerance=0.04; // Shrink the lip slightly to fit top easily

foot_r=4.4;
foot_depth=0.6;
foot_spacing=16;

inner_width=273.6+1.7+2.6;
inner_depth=140.4+4.7+pcb_y1_clearance+pcb_y2_clearance;
inner_height=16.4;
outer_width=inner_width+2*shell_thickness;
outer_depth=inner_depth+2*shell_thickness;
outer_height=inner_height+2*shell_thickness;
outer_bottom_height=12.8;
pcb_x=shell_thickness+1.7; // Exhaust edge of pcb
pcb_y=shell_thickness+inner_depth-2.1-4.7-pcb_y1_clearance; // Battery edge of pcb
pcb_z=shell_thickness+pcb_bottom_clearance; // Bottom surface of pcb
pcb_thickness=1.3;
split_x=pcb_x+162.5-22.4+2.4;

pcb_hole_r=2.0/2;
hdd_hole_r=2.5/2;
// Holes relative to pcb_x and pcb_y [x, -y, bottom additional thickness]
standoffs=[
    [162.5-8.4-pcb_hole_r, 18.1+pcb_hole_r, 0.5], // H0
    [162.5-112.6-pcb_hole_r, 3.1+pcb_hole_r, 1.0], // H1
    [13.8+pcb_hole_r, 137.6-79.1-pcb_hole_r, 1.0], // H9
    [22.4-3.7+pcb_hole_r, 137.6-14.2-pcb_hole_r, 0.0], // H14
    [107.7-3.7+pcb_hole_r, 138.2-10.8-pcb_hole_r, 0.0], // H15
    [273.6+2.6-20.0-pcb_hole_r, 79.8+3.3+pcb_hole_r, 0.0], // H11
    [273.6+1.9-41.4-pcb_hole_r, 138.2-4.0+2.5-5.6+1.7-9.9-pcb_hole_r, 0.0], // H12
    [162.5-5.0, 79.8-3.9-3.7, 2.5], // HD1
    [162.5+96.0+hdd_hole_r, hdd_hole_r, 4.1] // HD2
];

// Screw posts
lid_post_tolerance=0.04; // Reduce the height slightly to ensure it's tight
lid_post_screw_head_r=3.0;
lid_post_screw_head_depth=3.8;
lid_post_female_r=3.8;
lid_post_nut_r=3.2;
lid_post_nut_depth=2.2;
lid_post_nut_height=2.6;
lid_post_margin=shell_thickness+lip_thickness+lip_tolerance+lid_post_female_r;
lid_post_bottom_height=9.4;
lid_post_pos=[
    [lid_post_margin, lid_post_margin],
    [pcb_x+22.0, outer_depth-lid_post_margin],
    [outer_width-lid_post_margin, lid_post_margin],
    [outer_width-25, outer_depth-lid_post_margin],
    [140, 86]
];

// Ports
front_left_pcb_y=pcb_y-137.6+4.3;
port_clearance=0.8;
audio_jack_radius=3.0;
audio_jack_width=9.5;
audio_jack_y=front_left_pcb_y+11.2-audio_jack_radius-audio_jack_width/2;
audio_jack_clearance=10;
ethernet_width=15.2;
ethernet_height=11.0;
ethernet_y=front_left_pcb_y+32.7-ethernet_width;
ethernet_z=pcb_z-3.4;
usb_width=14.1;
usb_height=7.5;
usb_z=pcb_z-4.1;
usb_bottom_height=outer_bottom_height-usb_z+overlap;
usb_top_height=usb_bottom_height-usb_height;
usb1_y=front_left_pcb_y+50.6-usb_width;
usb2_y=pcb_y-79.8-16.8;
hdmi_width=14.6;
hdmi_height=5.8;
hdmi_y=front_left_pcb_y+71.9-hdmi_width;
hdmi_z=pcb_z-3.6;
hdmi_bottom_height=outer_bottom_height-hdmi_z+overlap;
hdmi_top_height=hdmi_bottom_height-hdmi_height;
sd_width=28.8;
sd_height=4.0;
sd_y=pcb_y-79.8-49.6;
sd_z=pcb_z+pcb_thickness+0.3;

power_jack_width=12.5;
power_jack_height=10.2;
power_jack_depth=12.7;
power_jack_radius=5.0;
power_jack_raised=3.4;
power_jack_spacing=2.8;
power_jack_z=shell_thickness+power_jack_raised;

// Power button
power_button_cutout_r=1.8;
power_button_cutout_thickness=0.6;
power_button_height=4.8;
power_button_width=6.0;
power_button_x=outer_width-shell_thickness-lip_thickness-power_button_width/2-shell_thickness+overlap;
power_button_y=outer_depth-27.0;
power_button_lead_gap=2.5;
power_button_stand_height=outer_height-power_button_height;
power_button_stand_wall_height=2.2;

// Inner join between sides
inner_wall_thickness=4.8; // Both sides combined
inner_wall_height=3.8;
inner_join_size=6.0;
inner_join_screw_r=1.2;
inner_join_nut_depth=2.0;
inner_join_nut_r=2.3;
inner_join_gap=0.8;
inner_join_gap_r=2.0;
module inner_wall_joint(raise=0) {
    translate([-inner_join_size/2, 0, 0]) {
        cube([inner_join_size+inner_wall_thickness, inner_join_size, raise]);
        translate([0, 0, raise]) difference() {
            cube([inner_join_size+inner_wall_thickness, inner_join_size, inner_join_size]);
            translate([-overlap, inner_join_size/2, inner_join_size/2])
                rotate([0, 90, 0])
                cylinder(h=inner_join_size+inner_wall_thickness+2*overlap, r=inner_join_screw_r);
            for (x = [-overlap, inner_join_size+inner_wall_thickness-inner_join_nut_depth+overlap]) {
                translate([x, inner_join_size/2, inner_join_size/2])
                    rotate([0, 90, 0])
                    cylinder(h=inner_join_nut_depth, r=inner_join_nut_r, $fn=6);
            }
            translate([inner_join_size/2+inner_wall_thickness/2-inner_join_gap/2, inner_join_size/2, inner_join_size/2])
                rotate([0, 90, 0])
                cylinder(h=inner_join_gap, r=inner_join_gap_r);
        }
    }
}

module enclosure() {
    difference() {
        union() {
            // Outer case
            difference() {
                roundedCube([outer_width, outer_depth, outer_height], r=shell_thickness, center=false);
                translate([shell_thickness, shell_thickness, shell_thickness])
                    cube([inner_width, inner_depth, inner_height]);
                if (!top) {
                    translate([0, 0, outer_bottom_height])
                        cube([outer_width, outer_depth, outer_bottom_height]);
                }
                if (!bottom) {
                    cube([outer_width, outer_depth, outer_bottom_height]);
                }
            }
            if (bottom) {
                // Lip
                translate([shell_thickness, shell_thickness, outer_bottom_height-lip_overlap])
                    difference() {
                        union() {
                            cube([inner_width, inner_depth, lip_overlap]);
                            translate([lip_tolerance, lip_tolerance, lip_overlap])
                                cube([inner_width-2*lip_tolerance, inner_depth-2*lip_tolerance, lip_exposed]);
                        }
                        translate([lip_thickness, lip_thickness, -overlap])
                            cube([inner_width-2*lip_thickness, inner_depth-2*lip_thickness, lip_overlap+lip_exposed+2*overlap]);
                        translate([inner_width/2, inner_depth/2, -overlap])
                            linear_extrude(height=lip_overlap+2*overlap, scale=[(inner_width-2*lip_thickness)/inner_width, (inner_depth-2*lip_thickness)/inner_depth])
                            square([inner_width, inner_depth], center=true);
                    }
                // More support around ports
                translate([shell_thickness, audio_jack_y-port_clearance-shell_thickness, shell_thickness])
                    cube([lip_thickness, outer_depth-(audio_jack_y-port_clearance), outer_bottom_height-shell_thickness]);
                translate([outer_width-shell_thickness-lip_thickness, sd_y-port_clearance-shell_thickness, shell_thickness])
                    cube([lip_thickness, usb2_y-(sd_y-port_clearance-shell_thickness)+usb_width+port_clearance+shell_thickness, outer_bottom_height-shell_thickness]);
                // Power jack enclosure
                translate([outer_width-shell_thickness-power_jack_depth-0.8+overlap, inner_depth-power_jack_width-shell_thickness-power_jack_spacing, shell_thickness-overlap]) {
                    // Feet
                    union() {
                        cube([shell_thickness+0.8, power_jack_width+2*shell_thickness, power_jack_raised]);
                        translate([(power_jack_depth+0.8)/2, 0, 0]) cube([shell_thickness, power_jack_width+2*shell_thickness, power_jack_raised]);
                        translate([power_jack_depth, 0, 0]) cube([shell_thickness, power_jack_width+2*shell_thickness, power_jack_raised]);
                    }
                    // Right wall
                    cube([power_jack_depth+0.8, shell_thickness, power_jack_raised+power_jack_height]);
                    // Left wall
                    translate([0, shell_thickness+power_jack_width, 0])
                        cube([power_jack_depth+0.8, shell_thickness, power_jack_raised+power_jack_height]);
                    // Back half wall
                    translate([0, power_jack_width/2+shell_thickness, 0])
                        cube([0.8, power_jack_width/2+shell_thickness, power_jack_raised+power_jack_height]);
                }
            }
            // Lid screw posts
            // if (top) translate([70, shell_thickness+lid_post_female_r+lip_thickness+0.5, outer_height-shell_thickness])
            for (pos = lid_post_pos) {
                if (bottom) translate([pos[0], pos[1], 0]) {
                    cylinder(r=lid_post_screw_head_r+0.8, h=lid_post_screw_head_depth);
                    translate([0, 0, lid_post_screw_head_depth])
                        standoff(height=lid_post_bottom_height-lid_post_screw_head_depth, depth=0, inner_r=1.7, outer_r=2.5, fillet_x=lid_post_screw_head_r+0.8, fillet_y=2.8);
                }
                if (top) translate([pos[0], pos[1], lid_post_bottom_height+lid_post_tolerance+overlap]) {
                    lid_post_top_height=outer_height-lid_post_bottom_height-shell_thickness-lid_post_tolerance;
                    difference() {
                        // cylinder(h=lid_post_top_height, r=lid_post_female_r);
                        translate([-lid_post_female_r, -lid_post_female_r, 0]) cube([lid_post_female_r*2, lid_post_female_r*2, lid_post_top_height]);
                        translate([0, 0, -overlap]) cylinder(h=lid_post_top_height, r=1.7);
                        translate([0, 0, lid_post_nut_depth]) cylinder(h=lid_post_nut_height, r=lid_post_nut_r, $fn=6);
                    }
                    border_thickness=lid_post_margin-shell_thickness-lid_post_female_r;
                    for (d = [0, 90, 180, 270]) {
                        rotate([0, 0, d]) translate([lid_post_female_r-overlap, -lid_post_female_r-border_thickness, lid_post_top_height]) mirror([0, 0, 1])
                            cube([border_thickness+2*overlap, lid_post_female_r*2+2*border_thickness, outer_height-outer_bottom_height-shell_thickness-lip_exposed-lip_tolerance]);
                    }
                    // standoff(height=inner_height/2-lid_post_tolerance, inner_r=2.0, outer_r=3.2, fillet_x=3.2, depth=7.0);
                }
            }
        }
        // Lid screw shafts
        for (pos = lid_post_pos) {
            translate([pos[0], pos[1], -overlap])
                cylinder(r=lid_post_screw_head_r, h=lid_post_screw_head_depth+2*overlap);
        }
        // Left port holes
        translate([-overlap, audio_jack_y+audio_jack_width/2, pcb_z+pcb_thickness-0.7+audio_jack_radius])
            rotate([0, 90, 0])
            cylinder(r=audio_jack_radius+0.15, h=shell_thickness+2*overlap, center=false);
        translate([shell_thickness-overlap, audio_jack_y-port_clearance, shell_thickness])
            cube([lip_thickness+2*overlap, audio_jack_width+2*port_clearance, inner_height]);
        translate([-overlap, ethernet_y, ethernet_z])
            cube([shell_thickness+2*overlap, ethernet_width, ethernet_height]);
        translate([shell_thickness-overlap, ethernet_y-port_clearance, shell_thickness])
            cube([lip_thickness+2*overlap, ethernet_width+port_clearance*2, inner_height]);
        translate([-overlap, usb1_y, usb_z])
            cube([shell_thickness+2*overlap, usb_width, usb_bottom_height]);
        translate([shell_thickness-overlap, usb1_y-port_clearance, shell_thickness])
            cube([lip_thickness+2*overlap, usb_width+port_clearance*2, inner_height]);
        translate([-overlap, hdmi_y, hdmi_z])
            cube([shell_thickness+2*overlap, hdmi_width, hdmi_bottom_height]);
        translate([shell_thickness-overlap, hdmi_y-port_clearance, shell_thickness])
            cube([lip_thickness+2*overlap, hdmi_width+port_clearance*2, inner_height]);
        // Right port holes
        translate([outer_width-shell_thickness-overlap, usb2_y, usb_z])
            cube([shell_thickness+2*overlap, usb_width, usb_bottom_height]);
        translate([outer_width-shell_thickness-lip_thickness-overlap, usb2_y-port_clearance, shell_thickness])
            cube([lip_thickness+2*overlap, usb_width+port_clearance*2, inner_height]);
        translate([outer_width-shell_thickness-overlap, sd_y, sd_z])
            cube([shell_thickness+2*overlap, sd_width, sd_height]);
        translate([outer_width-shell_thickness-lip_thickness-overlap, sd_y-port_clearance, shell_thickness])
            cube([lip_thickness+2*overlap, sd_width+port_clearance*2, inner_height]);

        // Power jack hole
        translate([shell_thickness+inner_width-overlap, inner_depth-power_jack_spacing-power_jack_width/2, power_jack_z+power_jack_height/2])
            rotate([0, 90, 0])
            cylinder(r=power_jack_radius, h=shell_thickness+lip_thickness+overlap*2);
        translate([shell_thickness+inner_width-lip_thickness-overlap, inner_depth-power_jack_spacing-power_jack_width, power_jack_z])
            cube([lip_thickness+overlap, power_jack_width, inner_height-power_jack_z]);

        // Cutout for power button
        translate([power_button_x, power_button_y, outer_height-shell_thickness-overlap]) {
            cylinder(h=shell_thickness+2*overlap, r=power_button_cutout_r);
            translate([0, 0, power_button_cutout_thickness/2])
                cube([power_button_width+1, power_button_width+1, power_button_cutout_thickness+overlap], center=true);
        }

        // Fan exhaust
        exhaust_ventilation_y=hdmi_y+hdmi_width+5.0;
        exhaust_ventilation_z=pcb_z-5.0;
        translate([-overlap, exhaust_ventilation_y, exhaust_ventilation_z])
            let(angle=0, thickness=shell_thickness+lip_thickness+2*overlap, width=inner_depth-exhaust_ventilation_y, height=outer_bottom_height-exhaust_ventilation_z-shell_thickness, vent_width=4.0, gap_width=1.2)
            intersection() {
                cube([thickness, width, height]);
                rotate([-angle, 0, 0]) for (ty = [0 : vent_width+gap_width : width-vent_width-gap_width]) translate([0, ty, 0]) {
                    cube([thickness, vent_width, width+height]);
                }
            }
        // Top ventilation
        top_ventilation_margin=lid_post_female_r*2+lip_thickness*2+shell_thickness*2;
        top_ventilation_angle=10;
        top_ventilation_vent_width=2.8;
        top_ventilation_gap_width=3.6;
        intersection() {
            difference() {
                translate([top_ventilation_margin, top_ventilation_margin, outer_height-shell_thickness-overlap])
                    cube([outer_width-2*top_ventilation_margin, outer_depth-2*top_ventilation_margin, shell_thickness+2*overlap]);
                translate([split_x, outer_depth/2, outer_height-shell_thickness/2])
                    cube([2*top_ventilation_margin, outer_depth, shell_thickness+2*overlap], center=true);
                translate([outer_width/2, outer_depth/2, outer_height-shell_thickness/2])
                    cube([outer_width, shell_thickness*2, shell_thickness+2*overlap], center=true);
            }
            for (tx = [0 : top_ventilation_vent_width+top_ventilation_gap_width : outer_width])
                translate([top_ventilation_margin+tx, outer_depth-2*top_ventilation_margin, outer_height-shell_thickness/2])
                rotate([0, 0, -top_ventilation_angle])
                cube([top_ventilation_vent_width, outer_width+outer_height, shell_thickness+2*overlap], center=true);
        }

        // Holes for feet
        for (hole_x = [foot_spacing, outer_width-foot_spacing]) {
            for (hole_y = [foot_spacing, outer_depth-foot_spacing]) {
                translate([hole_x, hole_y, -overlap]) cylinder(r=foot_r, h=foot_depth);
            }
        }
    }
    if (bottom) {
        // Standoffs
        for (standoff = standoffs) {
            translate([pcb_x+standoff[0], pcb_y-standoff[1], shell_thickness-overlap])
                standoff_m2(height=pcb_bottom_clearance-standoff[2]);
        }
    }
    if (top) {
        // Port overhang from top
        translate([0, usb1_y, usb_z+usb_bottom_height-usb_top_height])
            cube([shell_thickness, usb_width, usb_top_height+overlap]);
        translate([outer_width-shell_thickness, usb2_y, usb_z+usb_bottom_height-usb_top_height])
            cube([shell_thickness, usb_width, usb_top_height+overlap]);
        translate([0, hdmi_y, hdmi_z+hdmi_bottom_height-hdmi_top_height])
            cube([shell_thickness, hdmi_width, hdmi_top_height+overlap]);
    }
    // Power button
    if (bottom) {
    translate([power_button_x-power_button_width/2, power_button_y-power_button_width/2, shell_thickness-overlap]) {
        cube([power_button_width, power_button_width, power_button_stand_height-shell_thickness]);
        for (ty = [-shell_thickness+overlap, power_button_width-overlap]) translate([0, ty, 0])
            cube([power_button_width, shell_thickness, power_button_stand_height-shell_thickness+power_button_stand_wall_height]);
        for (tx = [-shell_thickness+overlap, power_button_width-overlap]) translate([tx, power_button_width/2-power_button_lead_gap/2, 0])
            cube([shell_thickness, power_button_lead_gap, power_button_stand_height-shell_thickness+power_button_stand_wall_height]);
        }
    }

    translate([split_x-inner_wall_thickness/2, 0, 0]) {
        if (bottom) translate([0, shell_thickness, shell_thickness]) {
            // Inner wall
            translate([0, 0, pcb_bottom_clearance/2+inner_join_size/2-overlap]) cube([inner_wall_thickness, inner_wall_height, inner_height-inner_join_size-pcb_bottom_clearance/2-inner_join_size/2-lid_post_tolerance]);
            translate([0, inner_join_size-overlap, 0]) cube([inner_wall_thickness, inner_depth/2-inner_join_size*1.5+overlap, inner_wall_height]);
            translate([0, inner_depth/2+inner_join_size/2-overlap, 0]) cube([inner_wall_thickness, inner_depth/2-inner_join_size*1.5+overlap, inner_wall_height]);
            // Joints
            inner_wall_joint(raise=pcb_bottom_clearance/2-inner_join_size/2);
            translate([0, inner_depth/2-inner_join_size/2, 0]) inner_wall_joint();
            translate([0, inner_depth-inner_join_size, 0]) inner_wall_joint(raise=inner_height-2*inner_join_size-lid_post_tolerance);
        }
        if (top) {
            translate([0, outer_depth/2, outer_height-shell_thickness]) mirror([0, 0, 1]) {
                for (my = [1, 0]) mirror([0, my, 0]) {
                    translate([0, inner_depth/2+overlap, 0]) mirror([0, 1, 0]) cube([inner_wall_thickness, lip_thickness+lip_tolerance+2*overlap, outer_height-outer_bottom_height-shell_thickness-lip_exposed-lip_tolerance]);
                    translate([0, inner_join_size/2-overlap]) cube([inner_wall_thickness, inner_depth/2-inner_join_size*1.5-(lip_thickness+lip_tolerance)+2*overlap, inner_wall_height]);
                    translate([0, inner_depth/2-lip_thickness-lip_tolerance, 0]) mirror([0, 1, 0]) inner_wall_joint();
                }
                translate([0, -inner_join_size/2, 0]) inner_wall_joint();
            }
        }
    }
}

intersection() {
    enclosure();
    union() {
        if (left) cube([split_x, outer_depth, outer_height]);
        if (right) translate([split_x, 0, 0]) cube([outer_width-split_x, outer_depth, outer_height]);
    }
    *union() {
        cube([30, 26, outer_height/2]);
        translate([0, 79, 0]) cube([28, 13, outer_height/2]);
        cube([10, 92, 99]);
        cube([80, 21, outer_height/2]);
        cube([80, 5, 99]);
        translate([60, 0, 0]) cube([20, 12, 99]);
        translate([80, 13, 0]) cube([outer_width/2-80, 8, outer_height/2]);
        translate([19, 92, 0]) rotate([0, 0, -30]) cube([10, 62, outer_height/2]);
        translate([outer_width/2-8, 0, 0]) cube([8, 15, 5]);
    }
}

// Visualise PCB
pcb_depth=140.4-2.1;
*%union() {
    translate([pcb_x, pcb_y-pcb_depth, pcb_z]) {
        difference() {
            union() {
                cube([273.6, pcb_depth, 1.3]);
                translate([-1.0, pcb_depth+3.2, -5.0]) mirror([0, 1, 0]) {
                    cube([18.2, 57.6, 7.5]);
                }
                translate([162.5-22.5-29.3, pcb_depth-overlap, 1.3]) {
                    translate([0, 0, -5.9]) cube([4.1, 2.1, 5.9]);
                    translate([4.1, 0, -7.5]) cube([29.3-2*4.1, 2.1, 7.5]);
                    translate([6.8, 2.1, -3.1-3.1]) cube([14.5, 4.7, 3.1]);
                    translate([29.3-4.1, 0, -5.9]) cube([4.1, 2.1, 5.9]);
                }
            }
            translate([0, -overlap, -overlap]) {
                translate([-overlap, 0, 0])
                    cube([12.7, 4.3, 1.3+2*overlap]);
                translate([52.6, 0, 0])
                    cube([30.0, 5.3, 1.3+2*overlap]);
                translate([52.6+30+78.8, 0, 0])
                    cube([13.9, 4.0, 1.3+2*overlap]);
                translate([52.6+30+78.8+13.9-overlap, 0, 0])
                    cube([23.8+overlap, 4.0-2.5, 1.3+2*overlap]);
                translate([52.6+30+78.8+13.9+23.8-overlap, 0, 0])
                    cube([32.3+overlap, 4.0-2.5+5.6, 1.3+2*overlap]);
                translate([52.6+30+78.8+13.9+23.8+32.3-overlap, 0, 0])
                    cube([42.3, 4.0-2.5+5.6-1.7, 1.3+2*overlap]);
                translate([111.9, 64.1, 0])
                    cube([30, 33.5, 1.3+2*overlap]);
                translate([outer_width-pcb_x-shell_thickness, 54.3+4.0+overlap, 0])
                    mirror([1, 0, 0]) cube([2.6+11.0, pcb_depth-54.3-4.0+overlap, 1.3+2*overlap]);
            }

        }
    }
}
