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
extruder_fixed = [42.8, 43.3, 6.4];
mounting_plate = [42.8, 48.8, 3];
entrance_translation = [0, 15, 11];
translation_attachment_screw = [-5, extruder.y-5, 0];
translation_pivot_screw = [-23, 5, 0];
lever = [extruder.x/2 -2, 5, 6];
lever_handle = [15.2, 3.9, 13.1];
dz_lever = -extruder.z + extruder_fixed.z + lever_handle.z/2;
lever_slot = [extruder.x/2+10, 8, lever.z + 2];

/* [Stepper Characteristics] */
stepper_motor = [42, 42, 40];

/* [Servo Characteristics ] */
servo_horn_offset = [-20, 9, -7.5];
dx_servo_screws = 48.5;
dy_servo_screw_offset = 5;


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
horn_extension = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
puller = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
servo_mount = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 


/* [Animation] */
// At zero, the lever is fully released - adjust range after offset is configured
az_servo = 0; // [0:140]
// Adjust so when az_servo == 0, that the puller pin is at beyond the lever fully release
az_servo_horn_offset = -133; // [-360:360]
// Add the start of the range so the lever matches fully open
lever_angle = 0; // [-135:0]
enage_puller = true;
az_puller_handle_to_horn_extension = 0; // [-180:180]


/* [Printing Control] */

print_all_parts = false;
print_one_part = false;

// Update options for part_to_print with each defined variable in the Show section!
one_part_to_print = "servo_mount"; // [servo_mount, horn_extension, puller]

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

h_horn_extension = 7;  
dz_horn_clearance = 10;  
d_pusher_pin = 6;
h_pusher_pin = 12;
dx_pusher_pin = 24; // [18 : 35]
dy_pusher_pin = -0.5; // [-20:0]
dz_puller_pin = 4;
// Offset of the puller from location of servo - adjust to clear releast lever handle
dx_puller_pin = 16; // 
// Offset of the puller from location of servo - adjust clear extruder
dy_puller_pin = -11.5; //  [-20: 0.1: -7]
// Offset from the top of the cap
dz_puller = 9; // [-5:0.1:10]
d_padding_puller_pin = 6;
az_puller_insertion_slot = -25;
az_puller_handle_depression = -50;
// Controls the orientation of the slots in the servo horn relative to the blank - adjust for printability
horn_extension_offset_angle  = -5; // [0:360]
ay_horn_extension_print_surface = 0; // [0:45]
dz_horn_extension_print_surface = -16; // [-20:0.1:-10]
ax_horn_extension_print_surface = -90; // [-90:90]
dz_top_of_extruder_to_horn_extension = 0.25;
// Adjust for location of print surface pivot which controls how much of pusher pin is sliced off.
az_print_surface_pivot = 65;
// Align with intersection of horn with horn extension 
az_horn_extension_print_surface = -35; // [-40: 0]



/* [Puller Design] */


d_puller_pin = 6;
h_puller_pin = 18; 
z_puller_pin_handle = 2;
az_flag_to_flat = 135;

/* [Build Plate Layout] */

x_servo_mount_bp = 20;
y_servo_mount_bp = 20;

x_horn_extension_bp = -20;
y_horn_extension_bp = 0;

x_puller_bp = 30;
y_puller_bp = 10;


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

visualization_servo_mount = 
    visualize_info("Servo Mount", PART_1, show(servo_mount, "servo_mount") , layout, show_parts); 

visualization_horn_extension = 
    visualize_info("Horn Extension", PART_2, show(horn_extension, "horn_extension") , layout, show_parts); 

visualization_puller = 
    visualize_info("Puller", PART_3, show(puller, "puller") , layout, show_parts); 
    
    
/* [Kinematics] */
servo_translation_ztsm = [dx_servo_ztsm, dy_servo_ztsm, dz_servo_ztsm];

// The horn translation gets us to underneath servo axis of rotation;
horn_translation = [
    dx_servo_ztsm + servo_horn_offset.x, 
    dy_servo_ztsm + servo_horn_offset.y, 
    dz_top_of_extruder_to_horn_extension];






// TODO: Move rounded_block into shape
module rounded_block(extent, radius = 2, sidesonly = false, center = CENTER) {
    extent_for_rounding =  sidesonly == "XZ" ? [extent.x, extent.z, extent.y] : extent;
    translation = 
        center == CENTER ? [0, 0, 0] :
        center == BELOW ? [0, 0,  -extent.z/2] :
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
        center == FRONT + LEFT + BELOW ? [extent.x/2, -extent.y/2, -extent.z/2] :
        center == LEFT ? [0, -extent.y/2, 0] :
                assert(false);
    rotation = sidesonly == "XZ" ? [90, 0, 0] : 
        sidesonly == false ? [0, 0, 0] :
        assert(false);
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
    
    module cavity() {
        blank();
        mounting_plate() ;
        dx = 6;
        translate([dx, -1, dz_lever]) block(lever_slot + [dx, 0, 6], center = BEHIND+RIGHT);        
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


module HornExtension() {
    
    print_base_translation = [
        dx_pusher_pin + cos(az_print_surface_pivot)*d_pusher_pin/2,  
        dy_pusher_pin + sin(az_print_surface_pivot)*d_pusher_pin/2, 
        0];
    
    module blank() {
        // Coordinates are relative to center
        hull() {
            can(d = od_horn, h=h_horn_extension, center=ABOVE);
            translate([dx_pusher_pin, dy_pusher_pin, 0]) 
                can(d = d_pusher_pin, h=h_horn_extension, center=ABOVE);
            translate([dx_puller_pin, dy_puller_pin, 0]) 
                can(d = d_puller_pin+d_padding_puller_pin, h=h_horn_extension, center=ABOVE);
        }
        // The pusher pin
        translate([dx_pusher_pin, dy_pusher_pin, 0]) {
                can(d = d_pusher_pin, h=h_pusher_pin, center=BELOW);
        }
        translate(print_base_translation) 
            rotate([0, 0, az_horn_extension_print_surface]) {
                s = 0.7*d_puller_pin;
                block([s, s, h_horn_extension], center = ABOVE); 
                block([s, s, h_pusher_pin], center = BELOW);
            }
 
    }
    

    module shape() {
        rotation = 
            mode == PRINTING  ? [0, 0, -az_horn_extension_print_surface]: //az_horn_extension_print_surface]: 
            [0, 0, 0];
        rotate(rotation)  {
            render() difference() {
                blank();
                translate([0, 0, dz_horn_clearance]) {
                    standard_servo_four_armed_horn(as_clearance = true, angle=horn_extension_offset_angle);
                }
                translate([dx_puller_pin, dy_puller_pin, dz_puller_pin-dz_top_of_extruder_to_horn_extension]) {
                    // Rotate for orientation of insertion slot
                    rotate([0, 0, az_puller_insertion_slot]) Puller(as_clearance=true);                
                    // Rotate for orientation of handle depression
                    rotate([0, 0, az_puller_handle_depression]) translate([-5, 4, 0]) block([8, 20, 10], center=FRONT + LEFT + ABOVE );
                }
                translate(print_base_translation) rotate([0, 0, az_horn_extension_print_surface]) plane_clearance(RIGHT);   
            }
        }
    }
    z_printing = 12; //print_base_translation.z;
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

    flag = [5, 2, 4];
    dz_cut = 0.5;
    x_handle = 20;
    dy_trim = d_puller_pin/2 - dz_cut;
    module blank() {
        can(d = d_puller_pin, h=h_puller_pin, center=BELOW); 
        // rounded tip in help insertion in front of release lever handle
        translate([0, 0, -h_puller_pin]) sphere(d = d_puller_pin, $fn=24);
         // Retention flag, so the puller stops when lifting up. Can only be remove if the handle is rotated to special position.
         rotate([0, 0, az_flag_to_flat]) 
            translate([0, d_puller_pin/2, -h_puller_pin]) block(flag, center = BEHIND + LEFT);
        // Handle - provides something to pull up on to manually operate release lever,
        
        block([x_handle, d_puller_pin/2, z_puller_pin_handle], center = FRONT + RIGHT + ABOVE);
        block([x_handle, 5, z_puller_pin_handle], center = FRONT + LEFT + ABOVE);
        can(d = d_puller_pin, h=z_puller_pin_handle, center=ABOVE);

    }
    module shape() {   
        render() difference() {
            blank();
            // Trim some off pin, so that it prints better()
            //translate([0, 0, dz_trim]) 
            translate([0, dy_trim, 0])  plane_clearance(RIGHT);
        }

    } 
    if (as_clearance) {     
        rotate([0, 0, -90]) {
            can(d = d_puller_pin, h=a_lot);
            translate([0, d_puller_pin/2, 0]) block([flag.x, flag.y, a_lot], center = BEHIND + LEFT);
            can(d = d_handle_recess, h =h_handle_recess, center = ABOVE);
            
        }
    } else {
        dz_lift = enage_puller ? -2 : h_puller_pin - flag.z - 9;
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
                    translate([dx_puller_pin, dy_puller_pin, dz_puller_pin])
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
            rounded_block(plate, sidesonly = false, radius=2.5, center = BEHIND + BELOW + LEFT);
    }
    
    module zip_tie_slots() {
        translate([-extruder.x/2, 0, -extruder.z - mounting_plate.z/2])
            center_reflect([1, 0, 0]) 
                center_reflect([0, 0, 1]) 
                    translate([extruder_fixed.x/2 + 2, 2, mounting_plate.z/2]) 
                        rotate([0, 0, -45]) block([2, a_lot, 4.5], center = FRONT + ABOVE);
    }

    pad = [12, 18, 7.5];
    module segment(dx1, dz1, e1, dx2, dz2, e2) {
        dy1 = (e1.y - pad.y)/2;
        dy2 = (e2.y - pad.y)/2;
        min1 = min(e1.x, e1.y, e1.z);
        min2 = min(e2.x, e2.y, e2.z);
        r1 = min1 < 6 ? 2 : 2.5;
        r2 = min1 < 6 ? 2 : 2.5;
        hull() {
            translate([dx1, dy1, dz1]) rounded_block(e1, center = BELOW, radius = r1);
            translate([dx2, dy2, dz2]) rounded_block(e2, center = BELOW, radius = r2);
        }            
    }
    
    module pedistal(x_offset) {
        z_nut_block = 7.5;
        s = 8;
        intermediate = [s, 14, z_nut_block];
        connector = [s, s, s];
        landing = [8, 8, plate.z];        
        dz_end =  -dz_servo - extruder.z + extruder_fixed.z; 
        translate([dx_servo_screws/2, 0, 0]) {
            segment(1, 0, pad, 1, 0, intermediate);
            segment(3, 0, intermediate, x_offset, 0, intermediate);
            segment(x_offset, 0, intermediate, x_offset, -6, connector);
            
            segment(x_offset, -6, connector, x_offset, dz_end, connector);
            segment(x_offset, dz_end, connector, x_offset-10, dz_end, landing);
            segment(x_offset-10, dz_end, landing, x_offset-40, dz_end, landing);
        }
    }
    module connected_servo_pedistals() {
        translate([dx_servo, dy_servo, dz_servo] + [-10, 10, 0]) {
            pedistal(0);
            mirror([1, 0, 0]) pedistal(16); 
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
    
    z_printing = 0;
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


Puller();

ZiptieServoMount();

HornExtension();




