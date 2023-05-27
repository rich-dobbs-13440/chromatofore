include <lib/logging.scad>
include <lib/centerable.scad>
use <lib/shapes.scad>
use <lib/not_included_batteries.scad>
include <nutsnbolts-master/cyl_head_bolt.scad>
include <NopSCADlib/vitamins/extrusions.scad>
//use <tests/extrusion_brackets.scad>

 

show_mocks = true;
orient_for_build = true;
build_bracket = true;
build_shim = true;
shim_thickness = 0; // [0: "No shim",  0.5: PEI, 1.0:"Ender Flexible", 4.0:"Ender Glass"]


spring_z_uncompressed = 18.;
spring_z_compressed = 12.;
spring_z_target = 12.;
base_z = 8;
bracket_y = 30; // 30;
shim_guide_z = 8;
no_shim_height = base_z + shim_guide_z;


z_position = -6.85; // [-20 : 0.05 : 20]

module end_of_customization() {}

z_stop_rail_guide = [5, 20, 49.39];
z_stop_card_holder = [5, 21, 20.58];



module z_stop() {

    translate([0, 0, z_position]) {
        color("gray") {
            block(z_stop_rail_guide, center=ABOVE+FRONT);
            translate([0, z_stop_rail_guide.y/2, z_stop_rail_guide.z]) block(z_stop_card_holder, center=BELOW+FRONT+RIGHT);
        }
    }  
}

if (show_mocks && !orient_for_build) {
    z_stop();
    translate([-20, 0, 40]) rotate([0, 0, 90]) extrusion(E2040, 80, cornerHole = true);
    translate([-10, 0, -20]) rotate([90, 0, 0]) extrusion(E2040, 80, cornerHole = true);    
}

module bracket() {
    rail_guide = [5, bracket_y, 20];
    base = [rail_guide.x, bracket_y, base_z];
    shim_guide = [3, bracket_y, shim_guide_z];
    
    difference() {
        block(rail_guide, center=BELOW+FRONT+RIGHT);
        translate([-25, 5, -10]) rotate([0, -90, 0]) hole_through("M4", cld=0.4, $fn=12);
        translate([-25, bracket_y-5, -10]) rotate([0, -90, 0]) hole_through("M4", cld=0.4, $fn=12);
    }
    block(base, center=ABOVE+FRONT+RIGHT);
    translate([base.x, 0, base.z]) block(shim_guide, center=ABOVE+BEHIND+RIGHT);
}

if (orient_for_build) {
    if (build_bracket) {
        translate([0, 0, 5]) rotate([0, 90, 0]) bracket();
    }
    if (build_shim) {
        translate([0, -15, 0]) rotate([90, 0, 0]) shim(); 
    }
} else {
    translate([0, 10, 0]) {    
        bracket();
        translate([0, 0, no_shim_height]) shim(); 
    }
}

module shim() {
    shim_y = z_stop_card_holder.y;
    guide = [2, z_stop_card_holder.y, shim_guide_z];
    connector = [7, z_stop_card_holder.y, shim_guide_z];
    shim = [10, z_stop_card_holder.y, shim_thickness]; 
    
    color("blue") {
        block(guide, center=BELOW+FRONT+RIGHT);
        translate([5, 0, 0]) block(guide, center=BELOW+FRONT+RIGHT);
        block(connector, center=ABOVE+FRONT+RIGHT);
        translate([0, 0, connector.z])  block(shim, center=ABOVE+FRONT+RIGHT);
        translate([5, 0, connector.z + shim_thickness]) block(guide, center=ABOVE+FRONT+RIGHT);
    }
        
    
}


