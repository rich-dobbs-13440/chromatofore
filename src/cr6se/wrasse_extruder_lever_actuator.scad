/* Orientation:  

    Origin is placed at a corner of the extruder closest to both engagement lever and filament entrance, 
    at the top away from support place.
    
    Filament entrance is positive y.  
    
    Lever is negative x.  

*/


include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
include <MCAD/servos.scad>
use <MCAD/boxes.scad>

a_lot = 100 + 0;
ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;

/* [Extruder Characteristics] */
extruder = [42.8, 43.3, 24.7];
mounting_plate = [42.8, 48.8, 3];
stepper_motor = [42, 42, 40];
entrance_translation = [0, 15, 11];
translation_attachment_screw = [-5, extruder.y-5, 0];
translation_pivot_screw = [-23, 5, 0];
lever = [extruder.x/2 -2, 5, 6];
lever_handle = [15.2, 3.9, 13.1];
dz_lever = -4.7 - lever_handle.z/2;
lever_slot = [extruder.x/2+10, 8, lever.z + 2];

/* [Servo Characteristics ] */
servo_horn_offset = [-20, 9, -7.5];

/* [Servo Horn Characteristics ] */
// Measure across horn at greatest point  - might vary for different brands of servo.
od_horn = 36;
// Adjust if necessary to get a good fit for actual horn  - might vary for different brands of servo.
cl_d_horn_arm_tip = 1;
// The following characteristic might vary for different brands of servo. 
od_horn_barrel = 7.6;
id_horn_barrel = 5.3;
h_horn_barrel = 6.1;
d_horn_arm_hub = 11.5;
d_horn_arm_hub_fillet = 15;
d_horn_arm_tip = 5.1;
h_horn_arm = 2;  
dz_horn_arm = -5.5;

r_horn_arm = (od_horn - d_horn_arm_tip)/2;

// Provide a large clearance so that servo and horn can be inserted into extension.  Should not need to be tuned
cl_h_horn_arm = 10;


/* [Show] */

show_mocks = true;
show_vitamins = true;
cap = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_extension = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
puller = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
test_of_pivot_with_detent = 0; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 

/* [Animation] */
az_servo =115; // [0:120]
az_servo_horn_offset = -90; // [-360:360]
lever_angle = 0; // [-130:0]
ay_puller = 215; // [0:engaged, 30: mid, 60:disengaged, 215: assembly]


/* [Printing Control] */

print_all_parts = false;
print_one_part = false;

// Update options for part_to_print with each defined variable in the Show section!
one_part_to_print = "test_of_pivot_with_detent"; // [cap, horn_extension, puller, test_of_pivot_with_detent]

mode = print_one_part ? PRINTING: 
    print_all_parts ? PRINTING:
    ASSEMBLE_SUBCOMPONENTS;



/* [Cap Design] */
z_base_cap = 7.5;
dz_cap_base = 2;
dx_servo = -10.4; // [-12:0.1:-10] 
pedistal = [8, 18, 6];
dx_back_pedistal = -30;
dx_front_pedistal = 10;   
dx_servo_screw_offset = 4.5;
dy_screw_offset = 4.6;
dz_servo_mount = 18;



/* [Horn Extension Design] */
h_horn_extension = 8;  
dz_horn_clearance = 8;  
dx_horn_extension_tip = 30; // [18 : 35]
dy_horn_extension_tip = -11.5; // [-20:0]
d_horn_extension_tip = 4;
d_horn_extension_outer_tip = 6;
horn_extension_offset_angle  = 25; // [20:45]
h_horn_extension_pusher = 12;
ay_horn_extension_print_surface = 0; // [0:45]
dz_horn_extension_print_surface = -16; // [-20:0.1:-10]
ax_horn_extension_print_surface = -90; // [-90:90]



/* [Puller Design] */
dx_puller_pivot = -2;
dy_puller_pivot = -16; // [-20: 0.1: -7]
dz_puller_pivot = 0.0; // [-5:0.1:10]
h_puller_pivot = 4;
h_puller_detent = 1;

cl_d_axle = 0.5;
cl_h_cone = 0.5;
cl_d_cone = 2; //0.5;
cl_y_key_hole = 0.5;
cl_r_detent = 0.25;
cl_dz_detent = 0.5;
cl_r_detent_sphere = 0.25;

az_cross_section = 0; // [0:360]
az_pivot_insertion = 0; // [0:360]


/* [Build Plate Layout] */

x_cap_bp = 20;
y_cap_bp = 20;

x_horn_extension_bp = 20;
y_horn_extension_bp = 0;

x_puller_bp = 40;
y_puller_bp = 40;



module end_of_customization() {}

function layout_from_mode(mode) = 
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";

layout = layout_from_mode(mode);
show_parts = false;

function show(variable, name) = 
    (print_one_part && (mode == PRINTING)) ? name == one_part_to_print :
    variable;

visualization_cap = 
    visualize_info("Cap", PART_1, show(cap, "cap") , layout, show_parts); 

visualization_horn_extension = 
    visualize_info("Horn Extension", PART_2, show(horn_extension, "horn_extension") , layout, show_parts); 

visualization_puller = 
    visualize_info("Puller", PART_3, show(puller, "puller") , layout, show_parts); 

visualization_pivot_with_detent = 
    visualize_info(
        "Horn Extension", 
        PART_10, 
        show(test_of_pivot_with_detent, "test_of_pivot_with_detent") , 
        layout, 
        show_parts); 

module rounded_block(extent, radius = 2, sidesonly = false, center = CENTER) {
    extent_for_rounding =  sidesonly == "XZ" ? [extent.x, extent.z, extent.y] : extent;
    translation = 
        center == BEHIND + RIGHT + BELOW ? [-extent.x/2, extent.y/2, -extent.z/2] :
        center == BEHIND + RIGHT + ABOVE ? [-extent.x/2, extent.y/2, extent.z/2] :
        center == BEHIND + LEFT ?  [-extent.x/2, -extent.y/2, 0] :
        center == BEHIND+LEFT+ABOVE ?  [-extent.x/2, -extent.y/2, extent.z/2] :
        center == BEHIND + LEFT + BELOW ? [-extent.x/2, -extent.y/2, -extent.z/2] :
        center == FRONT + RIGHT+ BELOW ? [extent.x/2, extent.y/2, -extent.z/2] :
        center == FRONT +RIGHT ?  [extent.x/2, extent.y/2, 0] :
        center == FRONT +RIGHT + ABOVE ? [extent.x/2, extent.y/2, extent.z/2] :
        center == FRONT + RIGHT + BELOW ? [extent.x/2, extent.y/2, -extent.z/2] :
        center == FRONT + LEFT + ABOVE ? [extent.x/2, -extent.y/2, extent.z/2] :
        center == LEFT ? [0, -extent.y/2, 0] :
                assert(false);
    rotation = sidesonly == "XZ" ? [90, 0, 0] : [0, 0, 0];
    translate(translation) rotate(rotation) {
        roundedCube(extent_for_rounding,  r=radius, sidesonly=sidesonly != false, center=true, $fn=12);
    }
}

module Extruder(as_clearance = false, lever_angle = 0) {
    module blank() {
        translate([-extruder.x/2, extruder.y/2, 0]) 
        render() intersection() {
            block(extruder + [0, 0, mounting_plate.z + stepper_motor.z], center=BELOW);
            // Cut off corners:
            rotate([0, 0, 45]) block([54.5, 54.5, a_lot]);
        }
    }
    
    module mounting_plate() {
        // Show mounting plate
        dy_front_mounting_plate = 12;
        cl_z_mouting_plate = 1;
        dz = -extruder.z + (as_clearance ? + cl_z_mouting_plate/2 : 0);
        translate([0, 0, dz]) {
            color(BLACK_IRON) {
                block(mounting_plate + [0, 0, cl_z_mouting_plate], center=BEHIND+RIGHT+BELOW);
                translate([0, dy_front_mounting_plate, 0]) 
                    block(mounting_plate + [0, -dy_front_mounting_plate, 0], center=FRONT+RIGHT+BELOW);
            }
        }        
    }
    
    module shape() {
        translate([0, 0, 0]) {
            color(BLACK_PLASTIC_1) { 
                difference() {
                    blank() ;
                    translate(entrance_translation + [0, 0, 0]) rod(d=5, l=a_lot);
                    translate(translation_attachment_screw + [0, 0, 10]) hole_through("M3", $fn=12);
                    translate(translation_pivot_screw + [0, 0, 10]) hole_through("M3", $fn=12);
                    translate([0, -1, dz_lever]) block(lever_slot, center = BEHIND+RIGHT);
                }
            }
            translate(translation_pivot_screw + [0, 0, dz_lever]) rotate ([0, 0, lever_angle]) {
                color(BLACK_PLASTIC_2) {
                    block(lever, center = FRONT);
                    translate([extruder.x/2-2, 0, 0]) rotate([0, 0, -45]) block(lever_handle, center=FRONT);
                }
            }
            mounting_plate();
        }
    }
    
    if (as_clearance) {
        blank();
        mounting_plate() ;
        dx = 6;
        translate([dx, -1, dz_lever]) block(lever_slot + [dx, 0, 6], center = BEHIND+RIGHT);
    } else {
        shape();
    }
}

module standard_servo_four_armed_horn(angle=0, as_clearance = false) {

    module horn_arm() {
        dh_horn_arm = as_clearance ? cl_h_horn_arm : 0;
        dd_horn_arm_tip = as_clearance ? cl_d_horn_arm_tip : 0;
        translate([0, 0, dz_horn_arm]) {
            hull() {
                can(d=d_horn_arm_hub, h=h_horn_arm + dh_horn_arm, center=ABOVE);
                translate([r_horn_arm, 0, 0]) 
                    can(d=d_horn_arm_tip + dd_horn_arm_tip, h=h_horn_arm + dh_horn_arm, center=ABOVE);
            }
            if (as_clearance) {
                // fake fillet 
                can(d=d_horn_arm_hub_fillet,  h=h_horn_arm + cl_h_horn_arm, center=ABOVE);
            }
        }
    } 
    module shape() {
        hollow = as_clearance ? 0.01 : id_horn_barrel;
        rotate([0, 0, angle]) {
            color(POLYETHELYNE) {
                can(d=od_horn_barrel, hollow=hollow , h = h_horn_barrel, center = BELOW);
                horn_arm();
                rotate([0, 0, 90]) horn_arm();
                rotate([0, 0, 180]) horn_arm();
                rotate([0, 0, 270]) horn_arm();
            }
            if (as_clearance) {
            } else {
                // Add a flag at zero to clearly differentiate one horn
                color("black") block([40, 0.1, h_horn_arm + 5], center=FRONT+BELOW);
            }
        }        
    }
    shape();
}

module servo(servo_angle=0, horn_offset_angle = 0) {
    translate([0, 0, dz_servo_mount]) {
        color(MIUZEIU_SERVO_BLUE) {
            futabas3003(position=[10,20,29],  rotation=[0, 180, 90]);
        }


        translate(servo_horn_offset) 
            standard_servo_four_armed_horn(angle = servo_angle + horn_offset_angle);
    }   
}

module servo_mounting_screws(as_clearance = false) {
    dx = (dx_front_pedistal - dx_back_pedistal + 2 * dx_servo_screw_offset) / 2;
    registration = [55, 1.6, 3];
    
    if (as_clearance) {
        translate([-10, 9.5, dz_servo_mount]) {
            center_reflect([0, 1, 0]) center_reflect([1, 0, 0]) {
                translate([dx, dy_screw_offset, 40]) hole_through("M3", $fn=12);
                translate([dx, dy_screw_offset, -2]) rotate([0, 0, 90]) nutcatch_sidecut(
                    name   = "M3",  // name of screw family (i.e. M3, M4, ...) 
                    l      = 50.0,  // length of slot
                    clk    =  0.0,  // key width clearance
                    clh    =  0.2,  // height clearance
                    clsl   =  0.1);  // slot width clearance
            }
            // Divot for servo registration, at least on RadioShack servos. 
            hull() {
                translate([0, 0, -1.6])  block(registration, center=ABOVE);
                scale([1, 3, 0.01]) block(registration, center=ABOVE);
            }
        }
    }
}



module Cap() {
    
    module front_pedistal() {
        translate([dx_front_pedistal, 0, dz_servo_mount]) 
            rounded_block(pedistal + [4, 0, 0], sidesonly = "XZ", center=FRONT+RIGHT+BELOW);
        rounded_block(
            [dx_front_pedistal + pedistal.x + 4, pedistal.y, 4], sidesonly = "XZ", center=RIGHT+FRONT);     
        translate([dx_front_pedistal + pedistal.x, 0, -2])  
            rounded_block(
                [4, pedistal.y, dz_servo_mount + 2], sidesonly = "XZ", center = FRONT+RIGHT+ABOVE);
    }
    
    
    module back_pedistal() {
        translate([dx_back_pedistal, 0, dz_servo_mount]) 
            rounded_block(pedistal + [10, 0, 0], sidesonly = "XZ", center = BEHIND + RIGHT + BELOW);
        translate([dx_back_pedistal - 14, 0, -2])  
            rounded_block(
                [4, pedistal.y, dz_servo_mount + 2], sidesonly = "XZ", center = BEHIND + RIGHT + ABOVE);          

    }   
    
    module cap_base() {
        translate([4, 0, dz_cap_base]) 
            rounded_block(
                [extruder.x + 7.3, extruder.y + 2, z_base_cap], sidesonly = "XZ", center = BEHIND + BELOW + RIGHT);
    }
    
    module cap_clip() {
        // front of extruder
        translate([12, 0, 0]) 
            rounded_block(
                [extruder.x + 16, 4, extruder.z + 8], sidesonly = "XZ", center = BEHIND + BELOW + RIGHT);
        
        translate([0, 0, -extruder.z - 3]) {
            translate([0, 0, -4]) 
                rounded_block([4, 11, 14], sidesonly = "XZ", center = FRONT + RIGHT  + ABOVE);
            translate([0, 7, 4]) 
                rounded_block([4, 4, extruder.z], sidesonly = "XZ", center = FRONT + RIGHT  + ABOVE);
            hull() {
                rounded_block([8, 18, 8], sidesonly = "XZ", center = FRONT + RIGHT + BELOW);
                translate([0, 0, -4]) 
                    rounded_block([8, 28, 4], sidesonly = "XZ", center = FRONT + RIGHT + BELOW);
            }
        }
    }
   
    module horn_clearance() {
       translate([-20, 6, 2]) can(d = 40, h=8, center=ABOVE);
    } 
    module blank() {
        cap_base();
        cap_clip();          
        back_pedistal();
        front_pedistal();
    }
    
    module shape() {
        render(convexity=10) difference() {
            blank();
            translate([0.7, -0.1, 0]) scale([1.03, 1, 1.01]) 
                Extruder(as_clearance = true);
            horn_clearance();
            servo_mounting_screws(as_clearance=true);
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [90,  0, 0] : 
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_cap_bp, y_cap_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        if (show_mocks && mode != PRINTING) {
            Extruder(lever_angle=lever_angle);
        }
        if (show_vitamins && mode != PRINTING) {
            servo(servo_angle=az_servo, horn_offset_angle = az_servo_horn_offset);
        }
        visualize(visualization_cap) {
            shape();
        }
    }
}




module HornExtension() {
    module blank() {
        hull() {
            can(d = 2*r_horn_arm, h=h_horn_extension, center=ABOVE);
            translate([dx_horn_extension_tip, dy_horn_extension_tip, 0]) 
                can(d = d_horn_extension_tip, h=h_horn_extension, center=ABOVE);
            
        }
        // Support under horn disk
        translate([-10, -2, 0]) 
            rounded_block(
                [34, abs(dz_horn_extension_print_surface), h_horn_extension], 
                sidesonly = "XZ", 
                center=FRONT + LEFT + ABOVE);
        // Reinforce the corner
        corner = [14, h_puller_pivot + 2, 14];
        translate([dx_horn_extension_tip + 5, dz_horn_extension_print_surface, -5.5])  
            rounded_block(corner, sidesonly = "XZ", center=BEHIND+RIGHT+ABOVE);           
        translate([dx_horn_extension_tip, dy_horn_extension_tip, 0]) {
            hull() {
                can(d = d_horn_extension_tip, h=h_horn_extension_pusher, center=BELOW);
                translate([d_horn_extension_outer_tip, -d_horn_extension_outer_tip/2, 0]) 
                    can(d = d_horn_extension_outer_tip, h=h_horn_extension_pusher, center=BELOW);
                
            }
         
        } 
    }
    module unprintable_overhang_top() {
        translate([5, d_horn_arm_hub_fillet/2-1, dz_cap_base + 1])  
            rotate([-45, 0, 0]) block([15, 5, 10], center = ABOVE+LEFT);
    }
    
    module unprintable_overhang_back() {
        translate([-14, -d_horn_arm_hub_fillet/2+4., dz_cap_base + 1])  
            rotate([-45, 0, 0]) block([15,5, 10], center = ABOVE+LEFT);
    }
    
    module shape() {
        render() difference() {
            blank();
            translate([0, 0, dz_horn_clearance]) {
                standard_servo_four_armed_horn(as_clearance = true, angle=horn_extension_offset_angle);
            }
            translate([dx_horn_extension_tip + dx_puller_pivot, dy_puller_pivot, dz_puller_pivot]) 
                rotate([-90, 0, 0]) 
                    InsertablePivotWithDetent(h=h_puller_pivot, h_detent = h_puller_detent, as_clearance = true);
            unprintable_overhang_top();
            unprintable_overhang_back();
            rotate([ax_horn_extension_print_surface, ay_horn_extension_print_surface, 0]) 
                translate([0, 0, dz_horn_extension_print_surface]) plane_clearance(BELOW);
        }
    }
    z_printing = -dz_horn_extension_print_surface;
    rotation = 
        mode == PRINTING ? [-ax_horn_extension_print_surface,  -ay_horn_extension_print_surface, 0] : 
        [0, 0, az_servo + az_servo_horn_offset - horn_extension_offset_angle];
    translation = 
        mode == PRINTING ? [x_horn_extension_bp, y_horn_extension_bp, z_printing] :
        [servo_horn_offset.x, servo_horn_offset.y, dz_cap_base];
    
    translate(translation) rotate(rotation) {
        visualize(visualization_horn_extension) {
            shape();
        } 
    }  
    
}


module Puller() {  
    d_puller = 5;
    y_base = 3;

    module blank() {
        rotate([-90, 0, 0]) rotate([0, 0, 135]) InsertablePivotWithDetent(h=h_puller_pivot, h_detent = h_puller_detent); 
        // Base 
        translate([-1, 0, 0]) 
            rounded_block([10, y_base, 8], sidesonly = "XZ", center = LEFT);
        // Latch bar   
        translate([h_puller_pivot,  0, 0]) 
            rounded_block([28, y_base, 8], sidesonly = "XZ", center = BEHIND + LEFT + ABOVE);
        // The pusher itself
        translate([-4, -y_base, -15]) can(d=d_puller, h=5, center = BEHIND + RIGHT + ABOVE);
        // Connect pusher to latch bar
        translate([-4, 0, 4]) rounded_block([5, y_base, 20], sidesonly = "XZ", center = BEHIND + LEFT + BELOW); 
        // Add handle
        rotate([0, 30, 0]) {
            // Lever
            rounded_block([8, y_base, 34], sidesonly = "XZ", center = BEHIND + LEFT + ABOVE);
            // Thumb pad
            translate([0, 0, 22]) rounded_block([4, 10, 12], sidesonly = "XZ", center = BEHIND + RIGHT + ABOVE);
        }

    }
    module latch() {
        translate([-20, 0, 4]) block([8, 3, 3]);
    }
    module shape() {
        ay = mode == PRINTING ? 0 : ay_puller;          
        translate([dx_horn_extension_tip + dx_puller_pivot, dy_puller_pivot, dz_puller_pivot]) {
            rotate([0, ay, 0]) {  
                render() difference() {
                    blank();
                    latch();
                }
            }
        }
    } 
    dy_explode = -0;
    z_printing = y_base;
    rotation = 
        mode == PRINTING ? [90,  0, 0] : 
        [0, 0, az_servo + az_servo_horn_offset - horn_extension_offset_angle];
    translation = 
        mode == PRINTING ? [x_puller_bp, y_puller_bp, z_printing] :
        [servo_horn_offset.x, servo_horn_offset.y + dy_explode, dz_cap_base];    
    
    translate(translation) rotate(rotation) {
        visualize(visualization_puller) {
            shape();
        } 
    }      
    
}


Puller();

HornExtension();

Cap();




module InsertablePivotWithDetent(h=6, h_detent=0.2, as_clearance = false) {
    h_axle = 1;
    h_cone = h;
    d_axle = h;
    d_cone = 2 * h;
     
    y_key_hole = 0.6*h_cone;
    d_base = d_cone;
    h_base = 2;
    r_detent = y_key_hole/2;
    dx_detent = 0.35 * d_cone;
    dz_detent = -0.6 * r_detent;
    
    d_axle_actual = d_axle + (as_clearance ? cl_d_axle : 0);
    d_cone_actual = d_cone + (as_clearance ? cl_d_cone : 0);
    h_cone_actual = h_cone + (as_clearance ? cl_h_cone : 0);
    y_key_hole_actual = y_key_hole + (as_clearance ? cl_y_key_hole : 0);
    r_detent_sphere = 0.5 * (r_detent^2 + h_detent^2)/h_detent;
    r_detent_sphere_actual = r_detent_sphere + (as_clearance ? cl_r_detent_sphere : 0);
    
    module blank() {
        can(d = d_axle_actual, h = h_axle, center = ABOVE);
        translate([0, 0, h_axle]) 
            can(d = d_axle_actual, taper = d_cone_actual, h = h_cone_actual, center = ABOVE);
    }
    module key_slot() {
        block([d_cone_actual/2, y_key_hole_actual, h_axle + h_cone_actual], center = ABOVE + FRONT);
    }
    
    module detent_ball() {
        difference() {
            translate([dx_detent, 0, h_detent - r_detent_sphere]) sphere(r=r_detent_sphere_actual, $fn=24);
            plane_clearance(BELOW);
        }
    }
    
    module detent_balls() {
        rotate([0, 0, 0]) detent_ball();
        rotate([0, 0, 90]) detent_ball();
        rotate([0, 0, 180]) detent_ball();
        rotate([0, 0, 270]) detent_ball();         
    }
    module key_hole() {
        can(d = d_axle_actual, h = h_axle+h_cone, center = ABOVE);
        rotate([0, 0, 45]) key_slot();
        rotate([0, 0, -45]) key_slot();
        rotate([0, 0, -135]) key_slot();
        rotate([0, 0, 135]) detent_ball();
    }
    module shape() {
        render() {
            intersection() {
                blank();
                key_hole();
            }
            can(d = d_base, h = h_base, center = BELOW);
            difference() {
                detent_balls();
                plane_clearance(BELOW);
            }
        }
     
    }
    if (as_clearance) {
        blank();
        key_hole();
        can(d = d_base, h = h_base, center = BELOW);
    } else {
        shape();
        
    }
}


visualize_vitamins(visualization_pivot_with_detent) {
    h_base = 2;
    h_pivot = 4;
    h_detent = 0.25;
    visualize(visualization_pivot_with_detent) {
        translate([0, 0, h_base]) {
            InsertablePivotWithDetent(h=h_pivot, h_detent=h_detent);
            block([10, 4, h_base], center=BELOW + FRONT);
        }
    }

    translate([20, 0, 0]) {
        test_piece = [3*h_pivot, h_pivot + 2, 3*h_pivot];
        render() difference() {
            block(test_piece, center = ABOVE + LEFT);
            translate([0, 0, test_piece.z/2]) rotate([90, 0, 0]) InsertablePivotWithDetent(h=h_pivot, h_detent=h_detent, as_clearance = true);
        }
    }
    
    if (mode != PRINTING) {
        translate([-20, 0, 0]) {

            color("blue") render() difference() {
                block([3*h_pivot, 3*h_pivot, h_pivot+2], center=ABOVE);
                InsertablePivotWithDetent(h=h_pivot, h_detent=h_detent, as_clearance = true);
                rotate([0, 0, az_cross_section]) plane_clearance(FRONT);
            }
            visualize(visualization_pivot_with_detent)  {
                rotate([0, 0, az_pivot_insertion]) InsertablePivotWithDetent(h=h_pivot, h_detent=h_detent, as_clearance = false);
            }
        }
    }
}


