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
print_both_rails = true;
print_moving_clamp = true;
print_fixed_clamp = true;
print_pusher = true;

print_one_part = false;
part_to_print = "frame"; // [servo_base, horn_cam, filament_guide, rails, horn_linkage, linkage]


/* [Show] */
servo_base = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_cam = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
filament_guide = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
rails = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_linkage = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
linkage = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

/* [Animation ] */
servo_angle_moving_clamp = 0; // [0:180]
servo_angle_fixed_clamp = 0; // [0:180]
servo_angle_pusher  = 0; // [0:180]
servo_offset_angle_pusher  = 110; // [0:360]
y_moving_clamp =35; // [0:100]

/* [Base Design] */
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


/* [Guide Design] */
filament_translation = [-4.5, 0, 1.7];
x_guide = 46;
y_guide = 16;
z_guide =2;
d_guide = 3.2;
s_guide_dovetail = 2;

/* [Frame Design] */
frame_clearance = 0.5;
y_frame = 85;
x_rail_attachment = 8;
y_rail_attachment = 16; 
z_rail_attachment = 8;
y_rail_screw_offset = 3;

/* [Linkage Design] */
linkage_length = 26;


/* [Build Plate Layout] */
x_servo_base_bp = 0;
y_servo_base_bp = 0;
dx_servo_base_bp = -50;

x_horn_cam_bp = 0;
y_horn_cam_bp = 32;
dx_horn_cam_bp = -15;

x_filament_guide_bp = 0; 
y_filament_guide_bp = 16;
dx_filament_guide_bp = -50; 

x_frame_bp = 0;
y_frame_bp = -15;

x_rail_bp = 30; 
y_rail_bp = 0; 
dx_rail_bp = 15;

x_horn_linkage_bp = 0;
y_horn_linkage_bp = 0;

x_linkage_bp = 0;
y_linkage_bp = 0;

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
    (print_one_part && (mode == PRINTING)) ? name == part_to_print :
    variable;

visualization_servo_base = 
    visualize_info(
        "Servo Base", PART_1, show(servo_base, "servo_base") , layout, show_parts); 

visualization_horn_cam = 
    visualize_info(
        "Horn Cam", PART_2, show(horn_cam, "horn_cam") , layout, show_parts); 
        
// Skip PART_3 because of color confict with 9g servo!
        
visualization_filament_guide =         
    visualize_info(
        "Filament Guide", PART_4, show(filament_guide, "filament_guide") , layout, show_parts); 
     
visualization_rails =         
    visualize_info(
        "Rails", PART_5, show(rails, "rails") , layout, show_parts);   
        
visualization_horn_linkage  =        
    visualize_info(
        "Horn Linkage", PART_6, show(horn_linkage, "horn_linkage") , layout, show_parts);   
        
visualization_linkage  =        
    visualize_info(
        "Linkage", PART_7, show(linkage, "linkage") , layout, show_parts);          
        
 if (mode ==  ASSEMBLE_SUBCOMPONENTS) {     
    filament();
    pusher_assembly();
    moving_clamp();
    fixed_clamp();
    rails();
 } else if (mode ==  PRINTING) {
     rail(item=0);
     if (print_both_rails) {
         rail(item=1);
     }
     if (print_moving_clamp) {
         filament_guide(item=0, include_pusher_pivot=true);
         servo_base(item=0);
         horn_cam(item=0);
     }
     if (print_fixed_clamp) {
         filament_guide(item=1);
         servo_base(item=1);
        horn_cam(item=1);          
     }
     if (print_pusher) {
         filament_guide(item=2);
         servo_base(item=2);
         horn_linkage();
         linkage();
     }
 }

module moving_clamp() {
    translate([0, y_moving_clamp, 0]) {
        servo_base();
        filament_guide(include_pusher_pivot=true);
        one_arm_horn(servo_angle=servo_angle_moving_clamp, servo_offset_angle=az_cam);
        horn_cam(servo_angle=servo_angle_moving_clamp); 
    }
}

module fixed_clamp() {
    y_fixed_clamp = y_frame - y_guide/2;
    translate([0, y_fixed_clamp, 0]) {
        servo_base();
        filament_guide();
        one_arm_horn(servo_angle=servo_angle_fixed_clamp, servo_offset_angle=az_cam);
        horn_cam(servo_angle=servo_angle_fixed_clamp);
    }
}

module pusher_assembly() {
    y_pusher_assmebly = y_guide/2;
    translate([0, y_pusher_assmebly, 0]) {
        servo_base();
        filament_guide();
        one_arm_horn(servo_angle=servo_angle_pusher, servo_offset_angle=servo_offset_angle_pusher);
        horn_linkage(servo_angle=servo_angle_pusher, servo_offset_angle=servo_offset_angle_pusher); 
    }
}

module rails() {  
    translate([x_base_offset+x_guide/2, 0, 0]) rail(); 
    translate([x_base_offset-x_guide/2, y_frame, 0])  rotate([0, 0, 180]) rail(); 
}

module filament(as_clearance = false, clearance_is_tight = true) {
    
    if (as_clearance) {
        translate(filament_translation) 
            if (clearance_is_tight) {
                rod(d=d_filament_with_tight_clearance, l=a_lot, center=SIDEWISE); 
            } else {
                rod(d=d_filament_with_clearance, l=a_lot, center=SIDEWISE);      
            }  
    } else if (mode != PRINTING) {
        filament_length = y_frame + 40;
        translate(filament_translation + [0, -20, 0]) 
            color("red") 
                rod(d=d_filament, l=filament_length, center=SIDEWISE+RIGHT);
    }
}

module one_arm_horn(as_clearance=false, servo_angle=0, servo_offset_angle=0) {
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
        rotate([0, 0, servo_angle + servo_offset_angle]) {
            color("white") {
                shape();
            }
        }
    }
}


module horn_linkage(servo_angle=0, servo_offset_angle=0) {
    //  The horn linkage sits on top of the horn, to avoid interference with the filament.
    az_pivot = 20;
    dx_pivot = 16;
    module pivot(as_clearance) {
        rotate([0, 0, az_pivot]) translate([dx_pivot, 0, 1.9]) rotate([180, 0, 0]) {
            if (as_clearance) {
                translate([0, 0, 5]) hole_through("M2", h=5, cld=0.0, $fn=12);  // Tap this to avoid a nut!
            } else {
                color(BLACK_IRON) screw("M2x8", $fn=12);
                translate([0, 0, -2]) color(BLACK_IRON) nut("M2", $fn=12);
                translate([0, 0, -5]) color(BLACK_IRON) nut("M2", $fn=12);
                rotate([0, 0, 15]) translate([0, 0, -6.6]) color(BLACK_IRON) nut("M2", $fn=12);
            }
        }
    }
    module shape() {
        h = 4;
        render(convexity=10) difference() {
            union() {
                hull() {
                    can(d=od_cam, h=h, center=ABOVE);
                    translate([5, 0, 0]) can(d=7, h=h, center=ABOVE);
                    
                }
                translate([0, 0, h-2]) {
                    hull() {
                        can(d=od_cam, h=2, center=ABOVE);
                        rotate([0, 0, az_pivot])  translate([dx_pivot, 0, 0]) can(d=5, h=2, center=ABOVE);
                    }
                }
            }
            translate([0, 0, -3.5])  hull() one_arm_horn(as_clearance=true);
            can(d=2.2, h=a_lot);  // Central hole for screw!
            pivot(as_clearance=true); 
        }
    }
    z_printing = 4;
    rotation = 
        mode == PRINTING ? [180,  0, 0] :
        [0, 0, servo_angle + servo_offset_angle];
    translation = 
        mode == PRINTING ? [x_horn_linkage_bp, y_horn_linkage_bp, z_printing] :
        [0, 0, 3.5];
    translate(translation) rotate(rotation) {
        if (show_vitamins && mode != PRINTING) {
            visualize_vitamins(visualization_horn_linkage) pivot(as_clearance = false) ; 
        }
        visualize(visualization_horn_linkage) shape();  
    }
} 


module linkage() {
    // The linkage connects the pivot of the horn linkage to the pusher pivot on the moving clamp. 
    module shape() {
        render(convexity=10) difference() {
            hull() center_reflect([1, 0, 0]) translate([linkage_length/2, 0, 0]) can(d=5, h = 2, center=ABOVE);
            center_reflect([1, 0, 0]) translate([linkage_length/2, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
        }
    }
    //linkage_angle = 12; // TODO:  Calculate it based on kinematics.
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, 0];    // TODO:  Calculate it based on kinematics.
    translation = 
        mode == PRINTING ? [x_linkage_bp, y_linkage_bp, z_printing] :
        [0, 0, 0];   // TODO:  Calculate it based on kinematics.  
    translate(translation) rotate(rotation) visualize(visualization_linkage) shape();  
}

module rail_screws(as_clearance=false, cld=0.2) {
    if (as_clearance) {
        center_reflect([0, 1, 0]) 
            translate([5, y_rail_screw_offset, -4]) 
                rotate([0, 90, 0]) 
                    hole_through("M2", l=20, cld=cld, $fn=12);
    } else {
        assert(false);
    }
} 

module rail(item=0) {
    s_dovetail = s_guide_dovetail + 2*frame_clearance; 
    rail_wall = 2;
    x_rail = 1 + s_guide_dovetail + 1 + rail_wall;
    z_rail = z_guide + s_guide_dovetail + 2 * rail_wall;
    module attachment_block() {
        render(convexity=10) difference() {
            translate([0, 0, rail_wall-frame_clearance]) 
                block([x_rail_attachment, y_rail_attachment, z_rail_attachment], center = BELOW+RIGHT+BEHIND);
            translate([0, y_rail_attachment/2, rail_wall]) 
                rail_screws(as_clearance=true, cld=0.4);
        } 
    }
    module blank() {
        translate([rail_wall, 0, -rail_wall]) {
            block([x_rail, y_frame, z_rail], center = ABOVE+RIGHT+BEHIND);
            attachment_block();
            translate([0, y_frame - y_rail_attachment, 0]) attachment_block();
            
        } 
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
                translate([frame_clearance, 0, -frame_clearance]) {
                block([s_dovetail+2, a_lot, z_guide+2 * frame_clearance ], center=ABOVE+BEHIND);
                hull() {
                    block([1 +frame_clearance , a_lot, z_guide + s_dovetail], center=ABOVE+BEHIND);
                    block([1+s_dovetail, a_lot, z_guide+frame_clearance], center=ABOVE+BEHIND);
                }
            }
        }
    }
    z_printing = rail_wall;
    rotation = 
        mode == PRINTING ? [0, 90, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_rail_bp + dx_rail_bp*item, y_rail_bp, z_printing]:
        [0, 0, 0];
    translate(translation) rotate(rotation)  visualize(visualization_rails) shape();  
}


module filament_guide(item=0, include_pusher_pivot=false) {
    cam_clearance = 0.5;
    module pusher_pivot(as_pad = false, as_vitamin = false) {
        translation = [0, -y_guide/2-1.7, 0];
        if (as_pad) {
            translate(translation) {
                render(convexity=10) difference() {
                    block([7, 5, z_guide], center=ABOVE);
                    translate([0, 0, 25]) hole_through("M2", cld=0.4, $fn=12); 
                }
            }
        } else if (as_vitamin) {
            translate(translation) {
                rotate([180, 0, 0]) color(BLACK_IRON) screw("M2x16", $fn=12);
                translate([0, 0, z_guide]) rotate([180, 0, 0]) color(BLACK_IRON) nut("M2", $fn=12);
            }
        } else {
            assert(false);
        }
    } 
    module blank() {
        translate([x_base_offset, 0, 0]) {
            block([x_guide, y_guide, z_guide], center=ABOVE);
            center_reflect([1, 0, 0]) translate([x_guide/2, 0, 0]) hull() {
                block([1, y_guide, z_guide + s_guide_dovetail], center=ABOVE+BEHIND);
                block([1+s_guide_dovetail, y_guide, z_guide], center=ABOVE+BEHIND);
            }
        }
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
            translate([0, 0, z_guide]) block([16, 8, 8], center=ABOVE+BEHIND); 
        }
        if (include_pusher_pivot) {
            pusher_pivot (as_pad = true);
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0, -0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_filament_guide_bp + dx_filament_guide_bp*item, y_filament_guide_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        if (include_pusher_pivot && show_vitamins && mode != PRINTING) {
            visualize_vitamins(visualization_filament_guide) {
                pusher_pivot (as_vitamin = true);
            }
        }
        visualize(visualization_filament_guide) shape();
    }       
}

module horn_cam(item=0, servo_angle=0, servo_offset_angle=0) {
    
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
        [0, 0, servo_angle + servo_offset_angle];
    translation = 
        mode == PRINTING ? [x_horn_cam_bp + item*dx_horn_cam_bp, y_horn_cam_bp, z_printing] :
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

module servo_base(item=0, visualization = visualization_servo_base) {
    module shape() {
        render(convexity=10) difference() {
            union() {
                translate([x_base_offset, 0, 0]) block([x_base_pillar, 10, z_base_pillar], center=BELOW);
                block([14, 14, z_base_joiner], center=BELOW);
            } 
            translate([0, 0, dz_servo]) 9g_motor_sprocket_at_origin();
            servo_screws(as_clearance = true);
            translate([x_base_offset, 0, 0]) 
                center_reflect([1, 0, 0]) 
                    translate([25, 0, 0]) 
                        rail_screws(as_clearance=true, cld=0.2); // Tight fit, will hold screws
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [180, 0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_servo_base_bp + item*dx_servo_base_bp, y_servo_base_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {    
        if (show_vitamins && mode != PRINTING) {
            translate([0, 0, dz_servo]) 9g_motor_sprocket_at_origin();
        }  
        visualize(visualization) shape();
    }  
}

