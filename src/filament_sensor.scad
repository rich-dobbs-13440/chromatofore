include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/shapes.scad>
use <ScadStoicheia/visualization.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>
include <ScadApotheka/material_colors.scad>

NEW_DEVELOPMENT = 0 + 0;
DESIGNING = 1 + 0;
ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;

/* [Output Control] */

mode = 3; // [1:"Designing, no rotation or translation", 3: "Assemble", 4: "Printing"]
show_vitamins = true;
guide = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
base = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
copies_to_print = 3;

/* [Design] */
dz_filament = -12;
filament_clearance = 0.5;
d_roller_clearance = 5;
l_roller_clearance = 10;
dx_mount_holes = 5;
dz_mount_holes = -18;

/* [Build Plate Layout] */
x_guide_bp = 30; 
y_guide_bp = 0; 
dx_guide_bp = 15;

x_base_bp = 0;
y_base_bp = 0;
dx_base_bp = -50;

module end_customization() {}



d_filament = 1.75;
filament_length = 50;

if (mode == PRINTING) {
    for (item = [0:copies_to_print-1]) {
        filament_sensor_base(item);
        filament_guide(item);        
    }
} else {
    filament_sensor_base();
    filament_guide();
}

module filament(as_clearance=false) {
    translate([0, 0, dz_filament]) {
        if (as_clearance) {
             rod(d=d_filament + 2 * filament_clearance, l = filament_length);
        } else {
            color("red") rod(d=d_filament, l = filament_length);
        }
    }
}



module filament_guide(item=0) {
    module roller_clearance() {
        translate([-6, -2.5, dz_filament+2]) {
            rod(d=d_roller_clearance, l = l_roller_clearance, center=SIDEWISE);
            block([d_roller_clearance, l_roller_clearance, 4], center=ABOVE); 
        }
    } 
    module blank() {
        translate([0, 0, dz_filament]) {
            rod(d=2*back_plate_translation().y, l=back_plate().x);
            block([back_plate().x, back_plate_translation().y, 10], center=BELOW+RIGHT);
        }
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            filament(as_clearance=true);
            roller_clearance();
            guide_mounting_screws(as_clearance=true, for_guide=true); 
        }
    }
    color(PART_32) shape();
}

module guide_mounting_screws(as_clearance=false, for_guide=false) {
    dx=4;

    center_reflect([1, 0, 0]) {
        translate([dx_mount_holes, 0, dz_mount_holes]) {
            rotate([90, 0, 0]) {
                if (as_clearance) {
                    if (for_guide) {
                        translate([dx/2, 0, 25]) hole_through("M2", $fn=12, cld=0.4);
                    } else {
                        hull() {
                            hole_through("M2", $fn=12, cld=0.4);
                            translate([dx, 0, 0]) hole_through("M2", $fn=12, cld=0.4);
                        }
                    }
                } else {
                    color(STAINLESS_STEEL) {
                        translate([dx/2, 0, 0]) screw("M2x10", $fn=12);
                        translate([dx/2, 0, -7.5]) nut("M2", $fn=12);
                    }
                }
            }
        }
    }    
}

module filament_sensor_base(item=0) {
    z_be = -dz_filament + 6;
    module base_extension() {
        render(convexity=10) difference() {
             translate(back_plate_translation()) {
                block([back_plate().x, 4, z_be], center=BELOW+RIGHT);
             }
             guide_mounting_screws(as_clearance=true); 
        }   
    }
    if (show_vitamins && mode != PRINTING) {
        filament(as_clearance=false);
        guide_mounting_screws(as_clearance=false); 
    }
    rotation = 
        mode == PRINTING ? [-90, 0, 0] :
         [0, 0, 0];
    rotate(rotation) {
        no_solder_roller_limit_switch_holder(show_vitamins=show_vitamins && mode != PRINTING);
        color(PART_34) base_extension();
    }
}