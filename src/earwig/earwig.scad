include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>


use <PolyGear/PolyGear.scad>
use <ScadApotheka/9g_servo.scad>
use <ScadApotheka/hs_311_standard_servo.scad>
use <ScadApotheka/roller_limit_switch.scad>

a_lot = 200 + 0;
d_filament = 1.75 + 0.;
d_filament_with_clearance = d_filament + 0.75;  // Filament can be inserted even with elephant footing.
d_filament_with_tight_clearance = d_filament + 0.25;  // Filament slides, but no provision for vertical insertion
od_ptfe_tube = 4 + 0;
id_ptfe_tube = 2 + 0;
d_ptfe_insertion = od_ptfe_tube + 0.5;
d_m2_nut_driver = 6.0 + 0;
d_number_ten_screw = 4.7 + 0;
od_three_eighths_inch_tubing = 9.3 + 0;
od_one_quarter_inch_tubing = 6.5 + 0;

NEW_DEVELOPMENT = 0 + 0;
DESIGNING = 1 + 0;
ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;

/* [Output Control] */

mode = 3; // [1:"Designing, no rotation or translation", 3: "Assemble", 4: "Printing"]
show_vitamins = true;
show_parts = true; // But nothing here has parts yet.

print_one = false;
one_to_print = "frame"; // [clamp_servo_base, horn_cam, filament_guide, frame]

/* [Show] */
clamp_servo_base = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_cam = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
filament_guide = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
frame = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]



/* [BaseDesign] */

dz_servo = 3.5;
x_base_pillar = 34;
z_base_pillar = 8.8;
z_base_joiner = 3.8;
x_base_offset = -5;

/* [Cam Design] */

od_cam = 12;
dz_cam = -1.2;
ay_cam = 4;
az_cam = 30;
servo_angle = 0; // [0:180]

/* [Guide Design] */
filament_translation = [-4.5, 0, 1.7];
x_guide = 38;
z_guide =2;
d_guide = 3.2;

/* [Frame Design] */
frame_clearance = 0.75;
y_frame = 40;

/* [Build Plate Layout] */
x_clamp_servo_base_bp = 0;
y_clamp_servo_base_bp = 0;

x_horn_cam_bp = 0;
y_horn_cam_bp = 32;

x_filament_guide_bp = 0; 
y_filament_guide_bp = 16;

x_frame_bp = 0;
y_frame_bp = -15;

module end_of_customization() {}



function layout_from_mode(mode) = 
    mode == NEW_DEVELOPMENT ? "hidden" :
    mode == DESIGNING ? "as_designed" :
    //mode == MESHING_GEARS ? "mesh_gears" :
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";

layout = layout_from_mode(mode);

function show(variable, name) = 
    (print_one && (mode == PRINTING)) ? name == one_to_print :
    variable;

visualization_clamp_servo_base = 
    visualize_info(
        "Clamp Servo Base", PART_1, show(clamp_servo_base, "clamp_servo_base") , layout, show_parts); 

visualization_horn_cam = 
    visualize_info(
        "Horn Cam", PART_2, show(horn_cam, "horn_cam") , layout, show_parts); 
        
// Skip PART_3 because of color confict with 9g servo!
        
visualization_filament_guide =         
    visualize_info(
        "Filament Guide", PART_4, show(filament_guide, "filament_guide") , layout, show_parts); 
     
  
  visualization_frame =         
    visualize_info(
        "Frame", PART_5, show(frame, "frame") , layout, show_parts);   
        
        
filament();
clamp_servo_base();
one_arm_horn();
horn_cam();
filament_guide();
frame();


module filament(as_clearance = false, clearance_is_tight = true) {
    
    if (as_clearance) {
        translate(filament_translation) 
            if (clearance_is_tight) {
                rod(d=d_filament_with_tight_clearance, l=a_lot, center=SIDEWISE); 
            } else {
                rod(d=d_filament_with_clearance, l=a_lot, center=SIDEWISE);      
            }  
    } else if (mode != PRINTING) {
        translate(filament_translation) 
            color("red") 
                rod(d=d_filament, l=20, center=SIDEWISE);
    }
}

module one_arm_horn(as_clearance=false) {
    module blank() {
        translate([0, 0, 1]) can(d=7.5, h=3.77, center=ABOVE); 
        translate([0, 0, 4.77]) {
            hull() {
                can(d=6, h=1.3, center=BELOW);
                translate([14, 0, 0]) can(d=4, h=1.3, center=BELOW); 
            }
        }        
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            can(d=2.5, h=a_lot);
            translate([0, 0, 4.77]) can(d=5, h=1, center=BELOW);
        }
    } 
    if (as_clearance) {
        shape();
    } else if (mode != PRINTING) {
        rotate([0, 0, servo_angle + az_cam]) {
            color("white") {
                shape();
            }
        }
    }
}

module frame() {
    x_frame = x_guide + 8;
    z_frame = z_guide + 3;
    guides = [x_guide + 2*frame_clearance, y_frame - 4, z_guide + 0.25];
    servo_clearance = [x_base_pillar + 1, y_frame-4, a_lot]; 
    module blank() {
        translate([x_base_offset, 0, -2]) block([x_frame, y_frame, z_frame], center = ABOVE+RIGHT); 
    }
    module attachment_blank() {
        translate([x_base_offset, 0, 0]) {
            center_reflect([1, 0, 0]) {
                translate([20, 0, z_frame-2]) {
                    hull() {
                        block([8, 9, 1], center =BELOW+RIGHT+BEHIND);
                        block([0.1, 14, 1], center =BELOW+RIGHT+BEHIND);
                    }
                }
            }
        }        
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            translate([x_base_offset, 0, +2]) {
                hull() {
                    block(guides, center=BELOW+RIGHT);
                    block(guides + [-4, 0, +2], center=BELOW+RIGHT);
                }
            }
            translate([x_base_offset, 0, -2]) block(servo_clearance, center=RIGHT);
            filament(as_clearance=true);
        }
        render(convexity=10) difference() {        
            attachment_blank();
            translate([0, 7, 0]) servo_screws(as_clearance = true);
        }

    }
    
    z_printing = 3;
    rotation = 
        mode == PRINTING ? [180, 0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_frame_bp, y_frame_bp, z_printing] :
        [0, -7, 0];
    translate(translation) rotate(rotation) visualize(visualization_frame) shape();    
}

module filament_guide() {
    cam_clearance = 0.5;
    module blank() {
        translate([x_base_offset, 0, 0]) block([x_guide, 16, z_guide], center=ABOVE);
        // translate(filament_translation) rod(d=d_guide, l=14, center=SIDEWISE); 
        translate(filament_translation) block([6, 16, d_guide]); 
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            hull() {
                filament(as_clearance=true);
                translate(filament_translation + [0, 0, 1]) rod(d=0.5, l=20, center=SIDEWISE); 
            }
            can(d=od_cam + 2*cam_clearance, h=a_lot);
            servo_screws(as_clearance = true);
            translate([0, 0, z_guide]) block([a_lot, 8, a_lot], center=ABOVE); 
        }        
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0, -0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_filament_guide_bp, y_filament_guide_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) visualize(visualization_filament_guide) shape();       
}

module horn_cam() {
    
    module shape() {
        render(convexity=10) difference() {
            can(d=od_cam, h=2, center=ABOVE);
            rotate([0, 0, az_cam]) hull() {
                translate([0, 0, -1])  one_arm_horn(as_clearance=true);
                translate([0, 0, -5])  one_arm_horn(as_clearance=true);
            }
        }
        render(convexity=10) difference() {
            can(d=od_cam, hollow=7.5, h=3, center=BELOW);
            translate([0, 0, dz_cam]) rotate([0, ay_cam, 0]) plane_clearance(BELOW);
        }
    }
    z_printing = -dz_cam;
    rotation = 
        mode == PRINTING ? [0, -ay_cam, 0] :
        [0, 0, servo_angle];
    translation = 
        mode == PRINTING ? [x_horn_cam_bp, y_horn_cam_bp, z_printing] :
        [0, 0, 3.5];
    translate(translation) rotate(rotation) visualize(visualization_horn_cam) shape();   
}

module servo_screws(as_clearance = true) {
    if (as_clearance) {
        translate([8.5, 0, 25]) hole_through("M2", cld=0.4, $fn=12);
        translate([-19.5, 0, 25]) hole_through("M2", cld=0.4, $fn=12);
    } else {
    }    
}

module clamp_servo_base() {
    module shape() {
        render(convexity=10) difference() {
            union() {
                translate([x_base_offset, 0, 0]) block([x_base_pillar, 10, z_base_pillar], center=BELOW);
                block([14, 14, z_base_joiner], center=BELOW);
            } 
            translate([0, 0, dz_servo]) 9g_motor_sprocket_at_origin();
            servo_screws(as_clearance = true);

        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [180, 0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_clamp_servo_base_bp, y_clamp_servo_base_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        if (show_vitamins && mode != PRINTING) {
            translate([0, 0, dz_servo]) 9g_motor_sprocket_at_origin();
        }
        visualize(visualization_clamp_servo_base) shape();
    }
}