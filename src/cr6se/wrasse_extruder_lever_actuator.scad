/* 


Purpose:

  The Wrasse Extruder Lever Actuator allows automated control of the extruder 
  release lever for the Creality CR 6 SE with the stock extruder.  It is necessary to 
  disengage the extruder as part of filament loading and unloading.  It is desirable
  to automate this lever because it is ackward to get to when the printer is in a 
  cabinet, and as part of an automated filament exchanger. 

Orientation:  

    Origin is placed at a corner of the extruder closest to both engagement lever and filament entrance, 
    at the top away from support place.
    
    Filament entrance is positive y.  
    
    Lever is negative x.  
    
    
Assembly Note: 

With standard servos you can safely rotate them by hand if you 
move them gently.  Too strong movements may permanently
damage them by stripping the gears.  
    
Assembly:
    
    1. Install M3 nuts into the nut catches, and test install the M3x8 screws. 
        You may need pliers to get the bottom 
        Leave the screws in place, but do not yet install the servo motor.
    3. Inserted the puller pin should beinto the horn extension.  
    4. Install the servo horn into the horn extension.  
    5. With the servo in the zero position, attach the horn and horn extension
        onto servo shaft aligning the registration marks on horn extension with
        the servo body, using the screw provided with the servo.
    6. Attach the standard servo motor to the servo mount using M3x8 screws. 
    7. Partially disengage the extruder, so that the release lever is in a mid postion. 
    8. Rotate the servo motor so the pusher pin is beyond the lever.  
    9. Ensure that the puller is raised completely, and then attach the servo mount 
        to the extruder using two 12" zip ties, pulling the zip ties tight with a pliers.  
    10. Install the lever glove on the release lever handle. 
    11. Release the lever, so that it is resting against the pusher pin.  Then lower
          the puller pin, so that the glove handle is between the two pins. 
    
    TODO:  
    1. Registration marks to align horn extension with servo during assembly.
    2. No rounding for servo attachment block.
*/


include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
include <MCAD/servos.scad>


a_lot = 100 + 0;
ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;

/* [Extruder Characteristics] */
extruder = [42.8, 43.3, 24.7];
extruder_fixed = [42.8, 43.3, 6.4];
mounting_plate = [42.8, 48.8, 3];
entrance_translation = [0, 15, 11];
translation_attachment_screw = [-5, extruder.y-5, 0];
translation_pivot_screw = [-23, 5, 0];
lever = [extruder.x/2 -2, 5, 6];
lever_handle = [15.4, 4, 12.86];
dz_lever = -extruder.z + extruder_fixed.z +lever_handle.z/2  + 2;// + lever_handle.z/2 + 2;
lever_slot = [extruder.x/2+10, 8, 12];

/* [Stepper Characteristics] */
stepper_motor = [42, 42, 40];

/* [Servo Characteristics ] */
servo_horn_offset = [-20, 9, -7.5];
dx_servo_screws = 48.5;
dy_servo_screw_offset = 5;

/* [Zip Tie Characteristics] */
x_zip_tie_slot = 1.5;
z_zip_tie_slot = 5.4;


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
    // Order alphabetically:

    glove = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
    horn_extension = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
    horn_extension_lock  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
    puller = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
    servo_mount = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 


/* [Animation] */
// At zero, the lever is fully released - adjust range after offset is configured
    az_servo = 0; // [0:140]
// Adjust so when az_servo == 0, that the puller pin is at beyond the lever fully release
    az_servo_horn_offset = -140; // [-360:360]
// Add the start of the range so the lever matches fully open
    lever_angle = 0; // [-135:0]
    enage_puller = true;
    az_puller_handle_to_horn_extension = -140; // [-180:180]


/* [Printing Control] */

    print_all_parts = false;
    print_one_part = false;
    // Update options for part_to_print with each defined variable in the Show section!
    one_part_to_print = "horn_extension_lock"; // [glove, horn_extension, horn_extension_lock, puller, servo_mount]

    mode = print_one_part ? PRINTING: 
        print_all_parts ? PRINTING:
        ASSEMBLE_SUBCOMPONENTS;


/* [Servo Mount Design] */

    dx_servo_ztsm = 0;
    dy_servo_ztsm = -6;
    dz_servo_ztsm = 18;
// Adjust for servo location
    y_attachment_plate_ztsm = 12;
// Must be enough for zip tie slot
    x_attachment_plate_padding_ztsm = 6;
    z_ziptie_allowance_ztsm = 12;
// Adjust to engage with mounting plate, and sides of extruder to register in all three axes. 
    dy_attachment_plate_ztsm = 7;


/* [Horn Extension Design] */

    h_horn_extension = 9;  
    dz_horn_clearance = 10;  
    d_pusher_pin = 6;
    h_pusher_pin = 18;
// Distance from servo shaft to center of pin. 
    r_pusher_pin = 27.5; // [24: 0.1, 28.0]
    az_pusher_pin = 0; // [-5:0.5:5]
    d_padding_puller_pin = 6;
    az_puller_insertion_slot = -25;
    az_puller_handle_depression = -50;
    h_retention_nib_cavity = 2;   
// Controls the orientation of the slots in the servo horn relative to the blank - adjust for printability
    horn_extension_offset_angle  = -5; // [0:360]
    dz_top_of_extruder_to_horn_extension = 0.0;
    d_horn_screw_access = 6;
// Adjust for location of print surface pivot which controls how much of pusher pin is sliced off.
    az_print_surface_pivot = 65;
// Align with intersection of horn with horn extension 
    az_horn_extension_print_surface = -25; // [-40: 0]
// Adjust to control steepness of print support for the horn can 
    ratio_support_base = 0.30;    


/* [Horn Extension Lock Design] */
    cl_od_horn_barrel = 0.6;
    cl_d_hxtl = 1.2;

/* [Puller Design] */
    r_puller_pin = 26; // [24: 0.1, 28.0]
    az_puller_pin = -40; // [-55:0.5:0]
// Offset from the top of the cap
    dz_puller_pin = 7; // [-5:0.1:10]
    d_puller_pin = 6;
    h_puller_pin = 22; 
    z_puller_pin_handle = 2;
    retention_nib = [d_puller_pin/2, 2, 2];
    az_retention_nib_to_flat = 135;
    dx_trim_puller_handle_tip = 18;


/* [Lever Glove Design] */
// Adjust for a tight, non slip grip
   cl_glove = 0.0;
// Adjust so that glove clears extruder corner, so can be fully inserted on to handle
    dx_front_cutoff_lg = 3;
    dx_backside_cutoff_lg = 3;   
    
/* [Build Plate Layout] */

    
// Adjust build plate layout for building all parts withouth interference
    x_servo_mount_bp = 20;
    y_servo_mount_bp = 20;

    x_horn_extension_bp = 00;
    y_horn_extension_bp = 20;
    
    x_horn_extension_lock_bp = -20;
    y_horn_extension_lock_bp = -10;

    x_puller_bp = -5;
    y_puller_bp = 10;

    x_lever_glove_bp = 20;
    y_lever_glove_bp = -10;


module end_of_customization() {}

/* [Visualization] */

    function layout_from_mode(mode) = 
        mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
        mode == PRINTING ? "printing" :
        "unknown";

    layout = layout_from_mode(mode);
    show_parts = false;

    function show(variable, name) = 
        (print_one_part && (mode == PRINTING)) ? name == one_part_to_print :
        variable;

    visualization_servo_mount = 
        visualize_info("Servo Mount", PART_1, show(servo_mount, "servo_mount") , layout, show_parts); 

    visualization_horn_extension = 
        visualize_info("Horn Extension", PART_2, show(horn_extension, "horn_extension") , layout, show_parts); 

    visualization_horn_extension_lock = 
        visualize_info("Horn Extension Lock", PART_3, show(horn_extension_lock, "horn_extension_lock") , layout, show_parts); 

    visualization_puller = 
        visualize_info("Puller", PART_4, show(puller, "puller") , layout, show_parts); 
        
    visualization_lever_glove = 
        visualize_info("Glove", PART_5, show(glove, "glove") , layout, show_parts); 
    
    
/* [Kinematics] */
    servo_translation_ztsm = [dx_servo_ztsm, dy_servo_ztsm, dz_servo_ztsm];
    // The horn translation gets us to underneath servo axis of rotation;
    horn_translation = [
        dx_servo_ztsm + servo_horn_offset.x, 
        dy_servo_ztsm + servo_horn_offset.y, 
        dz_top_of_extruder_to_horn_extension];

    dx_puller_pin = r_puller_pin * cos(az_puller_pin);
    dy_puller_pin = r_puller_pin * sin(az_puller_pin); 
    dx_pusher_pin = r_pusher_pin * cos(az_pusher_pin);
    dy_pusher_pin = r_pusher_pin * sin(az_pusher_pin);
    
    dz_puller_pin_lift = enage_puller ? 0 : 
        (h_puller_pin - dz_puller_pin) + (h_retention_nib_cavity-retention_nib.z); 


/* [Utilities] */


// TODO: Move rounded_block into shape




/* [Mocks] */

module Extruder(as_clearance = false, lever_angle = 0) {
    module blank() {
        translate([-extruder.x/2, extruder.y/2, 0]) 
        render() intersection() {
            block(extruder + [0, 0, mounting_plate.z + stepper_motor.z], center=BELOW);
            // Cut off corners:4
            rotate([0, 0, 45]) block([54.5, 54.5, a_lot]);
        }
    }
    
    module mounting_plate() {
        // Show mounting plate
        dy_front_mounting_plate = 12;
        cl_z_mouting_plate = 1;
        z_extra = as_clearance ? cl_z_mouting_plate : 0;
        dz = -extruder.z + (as_clearance ? + cl_z_mouting_plate/2 : 0);
        translate([0, 0, dz]) {
            color(BLACK_IRON) {
                block(mounting_plate + [0, 0, z_extra], center=BEHIND+RIGHT+BELOW);
                translate([0, dy_front_mounting_plate, 0]) 
                    block(mounting_plate + [0, -dy_front_mounting_plate, 0], center=FRONT+RIGHT+BELOW);
            }
        }        
    }
    
    module release_lever() {
            translate(translation_pivot_screw + [0, 0, dz_lever]) rotate ([0, 0, lever_angle]) {
                color(BLACK_PLASTIC_2) {
                    block(lever, center = FRONT + RIGHT);
                    translate([extruder.x/2-2, 0, 0]) rotate([0, 0, -45]) block(lever_handle, center=FRONT);
                }
            }        
    }
    
    module stepper() {
        color(STAINLESS_STEEL) 
            difference() {
                blank() ; 
               translate([0, 0, -extruder.z  - mounting_plate.z]) plane_clearance(ABOVE); 
            }      
    }
    
    module housing(lower=true, color_code) {
        dz_split = -extruder.z + extruder_fixed.z;
        dz_above = lower ? dz_split : 10;
        dz_below = lower ? -extruder.z : dz_split;
        color(color_code) {
            render(convexity=10) difference() {
                blank() ;
                translate(entrance_translation + [0, 0, -extruder.z]) rod(d=5, l=a_lot);
                translate(translation_attachment_screw + [0, 0, 10]) hole_through("M3", $fn=12);
                translate(translation_pivot_screw + [0, 0, 10]) hole_through("M3", $fn=12);
                translate([0, -1, -extruder.z + extruder_fixed.z]) 
                    block(lever_slot, center = BEHIND+RIGHT+ABOVE);
                if (lower) {
                    translate([0, 0, dz_above]) plane_clearance(ABOVE);
                    translate([0, 0, dz_below]) plane_clearance(BELOW);
                } else {
                    translate([0, 0, dz_split]) plane_clearance(BELOW);
                }
            }
        }    
    }
    
    module shape() {
        stepper();
        mounting_plate();
        release_lever();
        housing(lower = false, color_code=BLACK_PLASTIC_1);
        housing(lower = true, color_code=BLACK_PLASTIC_2);
    }
    
    module cavity() {
        blank();
        mounting_plate() ;
        dx = 6;
        translate([dx, -1, -extruder.z + extruder_fixed.z]) block(lever_slot + [dx, 0, 6], center = BEHIND+RIGHT+ABOVE);        
    }
    
    if (as_clearance) {
        cl_dx_extruder = 1;
        translate([cl_dx_extruder, 0, 0]) cavity();
        translate([-cl_dx_extruder, 0, 0]) cavity();
    } else {
        shape();
    }
}

module MountingPlate(as_clearance = false) {
}
module StepperMotor(as_clearance = false) {
}

if (show_mocks && mode != PRINTING) {
    Extruder(lever_angle=lever_angle);
    MountingPlate();
    StepperMotor();
}

/* [ Vitamins ] */

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
            
            // Add a flag at zero to clearly differentiate one horn
            color("yellow") block([40, 0.01, h_horn_arm + 5], center=FRONT+BELOW);           
        }        
    }
    shape();
}


module servo_mounting_screws(as_clearance = false, dz= 0) {
    dx = dx_servo_screws/2;
    registration = [55, 1.6, 3];
    
    if (as_clearance) {
        translate([-10, 10, dz]) {
            center_reflect([0, 1, 0]) center_reflect([1, 0, 0]) {
                translate([dx, dy_servo_screw_offset, 40]) hole_through("M3", $fn=12);
                translate([dx, dy_servo_screw_offset, -2]) rotate([0, 0, 90]) nutcatch_sidecut(
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


/* [Parts] */   

// Order parts alphabetically:


module Glove(test_fit = false) {
    // The lever glove provides a smooth surface for the pins to push against.  
    // The basic handle is textured for easy grip, but this causes additional friction
    // when attempting to rotate the servo to release or engage the lever. 
    
    clearances = [cl_glove, cl_glove, cl_glove];
    walls = [2, 1.4, 3];
    dx_extra_for_sliding = 8;
    dx_handle_cavity = 0;
    blank = lever_handle + clearances + walls;
    cavity = lever_handle + clearances;
    back_side_cutout = [20, 20, lever_handle.z + clearances.z];
    module blank() {
        block(blank);
        translate([-dx_extra_for_sliding, 0, 0]) block(blank);
    } 
    
    module shape() {
        render(convexity=10) difference() {
            blank();
            block(cavity);
            // Cut it off so it doesn't impact corner of extruder
            translate([dx_front_cutoff_lg, 0, 0]) rotate([0, 0, 0]) plane_clearance(FRONT);
            translate([dx_backside_cutoff_lg, 0, 0]) rotate([0, 0, -45]) block(back_side_cutout, center = BEHIND+RIGHT);
            
            if (test_fit) {
                plane_clearance(BELOW);
            }
        }
    }
    // Align glove with handle
    dx = 2;
    dy = -0.8;
    z_printing = blank.y/2;
    rotation = 
        mode == PRINTING ? [90, 0, 0] : 
        [0, 0, 135];
    translation = 
        mode == PRINTING ? [x_lever_glove_bp, y_lever_glove_bp, z_printing] :
        [dx, dy, dz_lever];
    translate(translation) rotate(rotation) {
        visualize(visualization_lever_glove) {
            shape();
        }
    }
}


module HornExtensionLock(as_clearance = false) {
    module blank() {
        can(d = 20 - cl_d_hxtl, taper = 18-cl_d_hxtl, h = 2, center = ABOVE);
        hull() {
            translate([0, -4, 0]) block([6, 6 - cl_d_hxtl/2, 0.1], center = ABOVE + LEFT);
            translate([0, -7, 3.5]) block([6, 6 - cl_d_hxtl/2, 0.1], center = BELOW + LEFT);
        }        
    }
    
    module shape() {
        difference() {
            intersection() {
                blank();
                translate([0, 0, 0]) {
                    standard_servo_four_armed_horn(as_clearance = true, angle=0);
                } 
            }  
            can(d=od_horn_barrel + cl_od_horn_barrel, h = a_lot);
        }   
    }
    
    if (as_clearance) {
       can(d = 18, h = a_lot, center = ABOVE);
        can(d = 20, taper = 18, h = 2, center = ABOVE);
        hull() {
            block([10, 10, 0.1], center = BELOW + LEFT);
            translate([0, -7, 3.]) block([18, 6, 0.1], center = BELOW + LEFT);
        }
    } else {
        z_printing = 0;
        rotation = 
            mode == PRINTING ? [0, 0, 0] : 
            [0, 0, 135];
        translation = 
            mode == PRINTING ? [x_horn_extension_lock_bp, y_horn_extension_lock_bp, z_printing] :
            horn_translation + [0, 0, dz_horn_clearance + dz_horn_arm +h_horn_arm];   
        translate(translation) rotate(rotation) {
            visualize(visualization_horn_extension_lock) {
                shape();
            }
        }
    }
}


module HornExtension() {
    
    print_base_translation = [
        dx_pusher_pin + cos(az_print_surface_pivot)*d_pusher_pin/2,  
        dy_pusher_pin + sin(az_print_surface_pivot)*d_pusher_pin/2, 
        0];
    echo("print_base_translation", print_base_translation);
    
    module blank() {
        // Coordinates are relative to center
        s = 0.7*d_puller_pin;
        hull() {
            can(d = od_horn, h=h_horn_extension, center=ABOVE);
            translate([dx_pusher_pin, dy_pusher_pin, 0]) 
                can(d = d_pusher_pin, h=h_horn_extension, center=ABOVE);
            translate([dx_puller_pin, dy_puller_pin, 0]) 
                can(d = d_puller_pin+d_padding_puller_pin, h=h_horn_extension, center=ABOVE);
            translate(print_base_translation) {
                rotate([0, 0, az_horn_extension_print_surface]) {
                    block([s, s, h_horn_extension], center = ABOVE); 
                        translate([-r_pusher_pin - ratio_support_base*od_horn, 0, 0]) 
                            block([s, s, h_horn_extension], center = ABOVE);
                }
            }    
        }
        // The pusher pin
        hull() {
            translate([dx_pusher_pin, dy_pusher_pin, 0]) {
                    can(d = d_pusher_pin, h=h_pusher_pin, center=BELOW);
            }
            translate(print_base_translation) {
                rotate([0, 0, az_horn_extension_print_surface]) {
                    block([s, s, h_pusher_pin], center = BELOW);
                }
            }
        }
    }
   r_ps = sqrt((-5)^2  + 3^2);
   echo("r_ps", r_ps);
    
    module shape() {
        rotation = 
            mode == PRINTING  ? [0, 0, -az_horn_extension_print_surface]:
            [0, 0, 0];
        rotate(rotation)  {
            render() difference() {
                blank();
                translate([0, 0, dz_horn_clearance]) {
                    standard_servo_four_armed_horn(as_clearance = true, angle=horn_extension_offset_angle);
                }
                translate([0, 0, dz_horn_clearance]) {
                    can(d=d_horn_screw_access, h= a_lot);
                }
                rotate([0, 0, horn_extension_offset_angle - 45]) 
                    translate([0, 0, dz_horn_clearance + dz_horn_arm +h_horn_arm]) 
                        HornExtensionLock(as_clearance = true);
                translate([dx_puller_pin, dy_puller_pin, dz_puller_pin-dz_top_of_extruder_to_horn_extension]) {
                    // Rotate for orientation of insertion slot
                    rotate([0, 0, az_puller_insertion_slot]) Puller(as_clearance=true);                
                    // Rotate for orientation of handle depression
                    
                    rotate([0, 0, az_puller_handle_depression]) 
                        translate([-5, 3, 0]) block([8, 20, 10], center=FRONT + LEFT + ABOVE );
                }
                // Create a cutout for the flag, so that the puller pin can be retracted enough so 
                // glove fits under bottom of in pin. 
                translate([dx_puller_pin, dy_puller_pin, 0]) can(d = 12, h=h_retention_nib_cavity, center=ABOVE);
                translate(print_base_translation) 
                    rotate([0, 0, az_horn_extension_print_surface]) 
                        plane_clearance(RIGHT);   
            }
        }
    }
    echo("az_horn_extension_print_surface", az_horn_extension_print_surface);
    z_printing = 
        r_pusher_pin * sin(-az_horn_extension_print_surface)  
        //+ r_ps * sin(az_horn_extension_print_surface) +
        + 3; //+ sin(az_print_surface_pivot)*d_pusher_pin/2;
    // TODO: Calculate from geometry
    rotation = 
        mode == PRINTING ? [-90, 0, 0]: //az_horn_extension_print_surface]: 
        [0, 0, az_servo + az_servo_horn_offset];
    translation = 
        mode == PRINTING ? [x_horn_extension_bp, y_horn_extension_bp, z_printing] :
        horn_translation;
    
    translate(translation) rotate(rotation) {        
        visualize(visualization_horn_extension) {
            shape();
        }        
    }  
    
}


module Puller(as_clearance = false, d_handle_recess =  0, h_handle_recess = z_puller_pin_handle ) {  
    
    dz_cut = 0.5;
    x_handle = 20;
    dy_trim = d_puller_pin/2 - dz_cut;
    
    module blank() {
        can(d = d_puller_pin, h=h_puller_pin, center=BELOW); 
        // rounded tip in help insertion in front of release lever handle
        translate([0, 0, -h_puller_pin]) sphere(d = d_puller_pin, $fn=24);
         // Retention flag, so the puller stops when lifting up. Can only be remove if the handle is rotated to special position.
         rotate([0, 0, az_retention_nib_to_flat]) 
            translate([0, d_puller_pin/2, -h_puller_pin]) block(retention_nib, center = BEHIND + LEFT);
        // Handle - provides something to pull up on to manually operate release lever,
        
        block([x_handle, d_puller_pin/2, z_puller_pin_handle], center = FRONT + RIGHT + ABOVE);
        block([x_handle, 5, z_puller_pin_handle], center = FRONT + LEFT + ABOVE);
        can(d = d_puller_pin, h=z_puller_pin_handle, center=ABOVE);

    }
    module shape() {   
        render() difference() {
            blank();
            // Trim tip of handle, so it clears the servo mount during rotation. 
            translate([dx_trim_puller_handle_tip, 0, 0]) rotate([0, 0, 45]) plane_clearance(FRONT);
            // Trim some off pin, so that it prints better()
            //translate([0, 0, dz_trim]) 
            translate([0, dy_trim, 0])  plane_clearance(RIGHT);
        }
    } 
    if (as_clearance) {     
        rotate([0, 0, -90]) {
            can(d = d_puller_pin, h=a_lot);
            translate([0, d_puller_pin/2, 0]) block([retention_nib.x, retention_nib.y, a_lot], center = BEHIND + LEFT);
            can(d = d_handle_recess, h =h_handle_recess, center = ABOVE); 
        }
    } else {
        z_printing = dy_trim;
        rotation = 
            mode == PRINTING ? [-90,  0, 0] : 
            [0, 0, az_servo + az_servo_horn_offset];
        translation = 
            mode == PRINTING ? [x_puller_bp, y_puller_bp, z_printing] :
            horn_translation;
            //[servo_horn_offset.x, servo_horn_offset.y, dz_top_of_extruder_to_horn_extension + dz_lift];    
        translate(translation) rotate(rotation) {
            visualize(visualization_puller) {
                if (mode == PRINTING) {
                    shape();
                } else {
                    // These deltas are relative to servo axis, at top of extruder 
                    translate([dx_puller_pin, dy_puller_pin, dz_puller_pin + dz_puller_pin_lift])
                        rotate([0, 0, az_puller_handle_to_horn_extension]) 
                            shape();
                } 
            }
        }      
    }  
}


module ZiptieServoMount() {
    side_padding = x_attachment_plate_padding_ztsm;
    
    dx_servo = dx_servo_ztsm;
    dy_servo = dy_servo_ztsm;
    dz_servo = dz_servo_ztsm;

    module servo(servo_angle=0, horn_offset_angle = 0) {
        translate([dx_servo, dy_servo, dz_servo]) {
            color(MIUZEIU_SERVO_BLUE) {
                futabas3003(position=[10,20,29],  rotation=[0, 180, 90]);
            }
            translate(servo_horn_offset) 
                standard_servo_four_armed_horn(angle = servo_angle + horn_offset_angle);
        }   
    }
    plate = [ 
        extruder.x + 2*side_padding,
        y_attachment_plate_ztsm, 
        extruder_fixed.z + mounting_plate.z + z_ziptie_allowance_ztsm
    ];
    attachment_plate_translation = [
        side_padding,
        dy_attachment_plate_ztsm, 
        -extruder.z + extruder_fixed.z // Move down to align with bottom of slot for release lever
    ];
    module attachment_plate() {
        // Attaches to the side of the servo motor and bottom of extruder, on the 
        // side where the release lever is locate.
        translate(attachment_plate_translation) 
            block(plate, center = BEHIND + BELOW + LEFT);
    }
    
    module zip_tie_slots() {
        translate([-extruder.x/2, 0, -extruder.z - mounting_plate.z/2])
            center_reflect([1, 0, 0]) 
                center_reflect([0, 0, 1]) 
                    translate([extruder_fixed.x/2 + 2, 2, mounting_plate.z/2]) 
                        rotate([0, 0, -20]) block([x_zip_tie_slot, a_lot, z_zip_tie_slot], center = FRONT + ABOVE);
    }
    pad = [12, 18, 7.5];
    s = 8;
    z_nut_block = 7.5;
    intermediate = [s, 14, z_nut_block];
    connector = [s, s, s];
    landing = [8, 8, plate.z + 1];        
    dz_end =  -dz_servo - extruder.z + extruder_fixed.z;     
    
    module pad(translation) {
         translate(translation) block(pad, center = BELOW + RIGHT);
    }
    module intermediate(translation) {
        translate(translation) rounded_block(intermediate, center = BELOW + RIGHT, radius = 2);
    }
    module connector(translation) {
         translate(translation) rounded_block(connector, center = BELOW + RIGHT, radius = 2);
    }  
    module landing(translation) {
         translate(translation) rounded_block(landing, center = BELOW + RIGHT, radius =2);
    }    
    module pedistal(x_offset, y_offset) {
        translate([dx_servo_screws/2, 0, 0]) {
            pairwise_hull() {     
                pad([1, y_offset, 0]);
                intermediate([x_offset, y_offset, 0]);
                connector([x_offset, y_offset,  -6]);
                connector([x_offset, y_offset, dz_end]);
                landing([x_offset-10, y_offset, dz_end]);
                landing([x_offset-40, y_offset, dz_end]);            
            }
        }
    }

    module connected_servo_pedistals() {
        translate([dx_servo, dy_servo, dz_servo] + [-10, 10, 0]) {
            pedistal(5, y_offset = -pad.y/2);
            mirror([1, 0, 0]) pedistal(24, y_offset = -pad.y/2); 
        }
    }

    module blank() {
        //translate([0, dy_cap, 0]) {
        attachment_plate();
        connected_servo_pedistals();   
    }
    
    module shape() {
        render(convexity=10) difference() {
            blank();
            zip_tie_slots();
            Extruder(as_clearance = true);
            MountingPlate(as_clearance = true);
            StepperMotor(as_clearance = true);
            translate([dx_servo, dy_servo, dz_servo]) servo_mounting_screws(as_clearance = true);
        }
    }
    z_printing = 5;
    rotation = 
        mode == PRINTING ? [90,  0, 0] : 
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_servo_mount_bp, y_servo_mount_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        if (show_vitamins && mode != PRINTING) {
            visualize_vitamins(visualization_servo_mount) {
                servo(
                    servo_angle=az_servo, 
                    horn_offset_angle = az_servo_horn_offset + horn_extension_offset_angle);
            }
        }
        visualize(visualization_servo_mount) {
            shape();
        }
    }
}



// These should be ordered from inner to outer, for best results for visualization 
// with varying levels of opacity (parts visualized as ghostly).

Puller();

ZiptieServoMount();

HornExtension();

HornExtensionLock();

Glove();




