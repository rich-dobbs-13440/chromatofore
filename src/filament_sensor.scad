include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/shapes.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>
use <ScadApotheka/ptfe_tubing_quick_connect.scad> 

NEW_DEVELOPMENT = 0 + 0;
DESIGNING = 1 + 0;
ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;

/* [Output Control] */

mode = 3; // [1:"Designing, no rotation or translation", 3: "Assemble", 4: "Printing"]
show_vitamins = true;
guide = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
base = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
qc_body = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
copies_to_print = 1; // [1:10]

/* [Design] */
use_ferrule_clamping = true;
dz_filament = -14;
dx_roller = -6;
dz_roller = 1; // [0:0.1:2]
filament_clearance = 0.5;
d_roller_clearance = 5.5;
l_roller_clearance = 5.; // [4:0.1:6]
dx_mount_holes = 5;
dy_outlet_screw_offset = 8;
dx_flange = 16;

/* [Build Plate Layout] */
x_guide_bp = 10; 
y_guide_bp = 0; 
dx_guide_bp = 30;

x_base_bp = 0;
y_base_bp = -20;
dx_base_bp = 30;

x_qc_body_bp = 0;
y_qc_body_bp = 30;
dx_qc_body_bp = 30;

module end_customization() {}


a_lot = 100;
d_filament = 1.75;
filament_length = 50;
outlet_flange = [2, 2*dy_outlet_screw_offset+6, 6];

    l_guide = back_plate().x + 2*dx_flange;
    guide_base = [l_guide, back_plate_translation().y, 10];

if (mode == PRINTING) {
    for (item = [0:copies_to_print-1]) {
        filament_sensor_base(item);
        filament_guide(item);  
        quick_connect_body_outlet(item);      
    }
} else {
    filament_sensor_base();
    filament_guide();
    quick_connect_body_outlet();
}

function layout_from_mode(mode) = 
    mode == NEW_DEVELOPMENT ? "hidden" :
    mode == DESIGNING ? "as_designed" :
    //mode == MESHING_GEARS ? "mesh_gears" :
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";

layout = layout_from_mode(mode);

show_parts = true;

visualization_guide = 
    visualize_info(
        "Filament Sensor Guide", PART_32, guide, layout, show_parts); 

visualization_base = 
    visualize_info(
        "Filament Sensor Base", PART_34, base, layout, show_parts); 

visualization_qc_body = 
    visualize_info(
        "Quick Connect Body", PART_29, qc_body, layout, show_parts); 
        
module filament(as_clearance=false) {
    translate([0, 0, dz_filament]) {
        if (as_clearance) {
             rod(d=d_filament + 2 * filament_clearance, l = a_lot);
        } else {
            color("red") rod(d=d_filament, l = filament_length);
        }
    }
}

module outlet_mounting_screws(as_clearance = false) {
    translate([0, 0, dz_filament]) {
        center_reflect([0, 1, 0]) {
            translate([0, dy_outlet_screw_offset, 0]) {
                rotate([0, 90, 0]) {    
                    if (as_clearance) {
                        translate([0, 0, 50])  hole_through("M2", $fn=12, cld=0.4, l=100);
                    } else {
                    }  
                }
            }
        }  
    }
}

module quick_connect_body_outlet(item) {
    module mounting_screws(as_clearance = false) {
        translate([0, 0, 0]) {
            center_reflect([0, 1, 0]) {
                translate([0, dy_outlet_screw_offset, 0]) {
                    rotate([0, 0, 90]) {    
                        if (as_clearance) {
                            translate([0, 0, 3])  hole_through("M2", l=15, cld=0.4,  $fn=12);                            
                        } else {
                            color(STAINLESS_STEEL) screw("M2x12", $fn=12);
                            color(BLACK_IRON)translate([0, 0, -10]) nut("M2", $fn=12);
                        }  
                    }
                }
            }  
        }   
    } 
    module blank() {
        quick_connect_body(orient_for_build=true);
        translate([0, 0, -outlet_flange.x/2]) rotate([0, 90, 0]) block(outlet_flange + [0, 0, 6]);
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            mounting_screws(as_clearance=true);
            can(d = d_filament + 2 * filament_clearance, h = filament_length);
        }
    }
    dz_printing = outlet_flange.x;  
    rotation = 
        mode == PRINTING ? [0, 0, 0] : [0, 90, 0];
    translation = 
        mode == PRINTING ? [x_qc_body_bp + item * dx_qc_body_bp, y_qc_body_bp, dz_printing] : 
        [guide_base.x/2 + outlet_flange.x, 0, dz_filament];
    translate(translation) {
        rotate(rotation) {
            if (show_vitamins && mode != PRINTING) {
                mounting_screws();
            }
            visualize(visualization_qc_body)  shape();
        }
    }
}

module filament_guide(item=0) {
    dx_flange_printing = -dy_outlet_screw_offset-4;
    d_guide_tube = 2*back_plate_translation().y; 
    module blank() {
        translate([0, 0, dz_filament]) {
            rod(d=d_guide_tube, l=l_guide);
            block(guide_base, center=BELOW+RIGHT);
            center_reflect([1, 0, 0]) translate([l_guide/2, 0, 0]) {
                hull() {
                    block(outlet_flange, center=BEHIND);
                    translate([dx_flange_printing, 0, 0]) rod(d=d_guide_tube, l=0.1);
                }
            }
        }
    }
    module roller_clearance() {
        translate([dx_roller, 0, dz_filament+dz_roller]) {
            hull() {
                rod(d=d_roller_clearance, l = l_roller_clearance, center=SIDEWISE);
                translate([0, 0, d_roller_clearance/2]) block([d_roller_clearance+3, l_roller_clearance + 4, 0.1], center=ABOVE);
            } 
        }
    }  
    module reentry_clearance() {
        translate([dx_roller, 0, dz_filament]) {
            hull() {
                rod(d=2*d_filament+2, l = l_roller_clearance+1);
                rod(d=d_filament, l = l_roller_clearance + 5);
            }
        }
    }  
    module shape() {
        render(convexity=10) difference() {
            blank();
            filament(as_clearance=true);
            reentry_clearance();
            roller_clearance();
            guide_mounting_screws(as_clearance=true, as_slot=true); 
            #outlet_mounting_screws(as_clearance=true);
        }
    }
    dz_printing = l_guide/2;  
    rotation = 
        mode == PRINTING ? [0, 90, 0] : [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_guide_bp + item * dx_guide_bp, y_guide_bp, dz_printing] : 
        [0, 0, 0];
    translate(translation) {
        rotate(rotation) {
            visualize(visualization_guide)  shape();
        }
    }
}

module guide_mounting_screws(as_clearance=false, as_slot=true) {
    dx=4;
    dz_mount_holes = dz_filament -6;
    center_reflect([1, 0, 0]) {
        translate([dx_mount_holes, 0, dz_mount_holes]) {
            rotate([90, 0, 0]) {
                if (as_clearance) {
                    if (as_slot) {
                        hull() {
                            translate([-3, 0, 25])  hole_through("M2", $fn=12, cld=0.4);
                            translate([dx, 0, 25]) hole_through("M2", $fn=12, cld=0.4);
                        }
                    } else { 
                        translate([dx/2, 0, 25]) hole_through("M2", $fn=12, cld=0.4);                    
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
    wall = 4;
    module base_extension() {
        render(convexity=10) difference() {
             translate(back_plate_translation()) {
                block([back_plate().x, wall, z_be], center=BELOW+RIGHT);
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
    dz_printing = back_plate_translation().y + wall ;
    translation = 
        mode == PRINTING ? [x_base_bp + item * dx_base_bp, y_base_bp, dz_printing] : 
        [0, 0, 0];    
    if (base > 0) {
        translate(translation) {
            rotate(rotation) {
                no_solder_roller_limit_switch_holder(use_ferrules=use_ferrule_clamping, show_vitamins=show_vitamins && mode != PRINTING);
                color(PART_34) base_extension();
            }
        }
    }
}