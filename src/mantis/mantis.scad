include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>


use <PolyGear/PolyGear.scad>
use <ScadApotheka/9g_servo.scad>
use <ScadApotheka/hs_311_standard_servo.scad>
use <ScadApotheka/roller_limit_switch.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>
use <ScadApotheka/ptfe_filament_tubing_connector.scad>
use <ScadApotheka/audrey_horizontal_pivot.scad>
include <ScadApotheka/audrey_horizontal_pivot_constants.scad>


    

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

//NEW_DEVELOPMENT = 0 + 0;
//DESIGNING = 1 + 0;
ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;

/* [Output Control] */

mode = 3; // [3: "Assembly", 4: "Printing"]
show_vitamins = true;
show_filament = true;
show_parts = true; // But nothing here has parts yet.
show_legend = true;
print_slide = true;
print_moving_clamp_cam = true;
print_fixed_clamp_cam = true;
print_pusher = true;

print_one_part = false;
part_to_print = "pusher_driver_link"; // [clip, collet, clamp_cam, limit_cam, pusher_coupler_link, pusher_driver_link, servo_retainer slide_plate, slider]



/* [Show] */ 
// Order to match the legend:

clamp_cam = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
fixed_clamp_body = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
limit_cam =  1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
pusher_coupler_link = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
moving_clamp_bracket = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
pusher_driver_link = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
servo_retainer = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
slide_plate = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
slider  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]


/* [Legend] */
x_legend = 36; // [-200 : 200]
y_legend = 50; // [-200 : 200]
z_legend = -30; // [-200 : 200]
legend_position = [x_legend, y_legend, z_legend];



/* [Animation ] */
servo_angle_moving_clamp = 0; // [0:180]
servo_offset_angle_moving_clamp = 90; // [0:360]
servo_angle_fixed_clamp = 0; // [0:180]
servo_offset_angle_fixed_clamp = 0; // [0:360]
servo_angle_pusher  = 25; // [0:180]
servo_offset_angle_pusher  = 245; // [0:360]
    
roller_switch_depressed = true;
roller_arm_length = 20; // [18:Short, 20:Long]
limit_switch_is_depressed = true;

/* [Servo Characteristics] */
// Adjust so that servos fits into slide plate openings!
9g_servo_body_length = 23; // [22.5, 23.0, 23.5, 24]
// Adjust so that servos fits into slide plate openings!
9g_servo_body_width = 12.0; // [12.0, 12.2, 12.4]
// Adjust so that servo shows as middle of slot.
9g_servo_offset_origin_to_edge = 6;
// Adjust so that servo shows as resting on pedistal
9g_servo_vertical_offset_origin_to_flange = 14.5;

/* [One Arm Horn Characteristics] */
dz_engagement_one_arm_horn = -1;// 1;
h_barrel_one_arm_horn = 3.77;
d_barrel_one_arm_horn = 7.5;
h_arm_one_arm_horn = 1.3;    
dx_one_arm_horn = 14;
// The height from the horn arm to the top of the cam
z_servo_body_to_horn_barrel = 5.3; // [0: 0.1: 10]


/* [Clamp Cam Design] */
d_bottom_for_clamp_cam = 26;
d_top_for_clamp_cam = 20;
// Needs to clear the gear housing, and probably wire end servo screw
id_for_clamp_cam = 22;

// Adjust so just a bit of flat exists based on z_clearance_clamp_cam.
slice_angle_for_clamp_cam = 2.5; // [0: 0.1: 10]
dz_slice_for_clamp_cam = 2;  // [-10: 0.1: 10]
az_slice_to_horn_for_clamp_cam =145; // [-180:180]
delta_z_slice_segment = 0.5; // [0: 0.1: 3]
z_clearance_clamp_cam = 2.0; 
// Set to control stiffness of cam to horn attachment
z_screw_head_to_horn = 2; //[1:0.5:2.5]



/* [Slide Plate Design] */

// Lateral offset between CL of filament to CL of servos
dx_slide_plate = 9; 
// Offset of the mid point of the slide plate from the mid point of the slide plate, in the direction that the slide moves.
dy_slide_plate = 0; //[-20:0.1:20]
// Offset of the slide plate vertically from the CL of the filament.  
dz_slide_plate = -6; //[-20:0.1:20]
// Lateral rim around servos inserted into slide plate
x_slide_plate_rim = 6;
// Rim in the direction of sliding 
y_slide_plate_rim = 5;
// Thickness of slide plate as well as the slides themselves
z_slide_plate = 4;
// The distance between the the rims of fixed clamp and the pusher.  Limits the maximum range of motion
y_slide =60;
// Vertical offset from the CL of the base plate to the bottom of the pusher servo flange.
z_pusher_servo_pedistal = 1.5; //6; 
// Lateral offset of the clearance, to allow room for the pusher servo wires
x_offset_pusher_wire_clearance = 1;
// Offset of the clearance, in the direction of sliding to allow room for pusher servo wires
y_offset_pusher_wire_clearance = y_slide_plate_rim - 3;
// Amount of vertical clearance for these wires
z_pusher_servo_wires_clearance = 9;


/* [Slider Design] */
// Lateral clearance between slider and guide.  Needs to big enough that the parts print separately.  Small enough relative to thickness of plate so that slider doesn't fall out or move too much vertically.
slider_clearance = 0.4;
// Lateral rim around servos inserted into slider
x_slider_rim = 2;

// The offset between the linkage centerline and the centerline of servo
dy_moving_clamp_offset = 18;

/* [Base Design] */
dz_servo = 3.5;
x_base_pillar = 34;
y_base_pillar = 12;
z_base_pillar = 8.8;
z_base_joiner = 3.8;
dx_base_offset = -5;
dy_base_offset = 5;


/* [Outlet Design] */
y_outlet = 20;

/* [Guide Design] */
x_guide = 46;
y_guide = 16;
z_guide =2;
d_guide = 3.2;
s_guide_dovetail = 2;
y_guide_moving_clamp = 26;



/* [Dove Tail Design] */
x_dovetail = 4;
y_dovetail = 6;
z_dovetail = 5;
dovetail_clearance = 0.25;
tie_length = 30;



/* [Pusher Linkage Design] */
// Adjust so that linkage lines up with shaft pusher servo.  
dz_linkage = -20; // [-22:0.1:-18]
debug_kinematics = false; 
az_drive_link_pivot = 25;
r_horn_linkage = 16;
linkage_length = 24;
linkage_shorten_range = 4;
// *******************************************************

// TODO:  Calculate y_pusher_assembly from plate dimensions
y_pusher_assembly = -42;
dy_pusher_servo = 2;



/* [Build Plate Layout] */

x_slide_plate_bp = -40;
y_slide_plate_bp = 0;

x_slider_bp = x_slide_plate_bp;
y_slider_bp = 0;

x_servo_base_bp = 0;
y_servo_base_bp = 0;
dx_servo_base_bp = -50;

x_fixed_clamp_body_bp = 0;
y_fixed_clamp_body_bp = 0;

x_clamp_cam_bp = 40;
y_clamp_cam_bp = -20;
dx_clamp_cam_bp = -30;

x_pusher_bp = 0;
y_pusher_bp = 0;

x_limit_cam_bp = 50;
y_limit_cam_bp = 0;

x_filament_loader_clip_bp = -40;
y_filament_loader_clip_bp = 10;

x_filament_loader_bp = -40;
y_filament_loader_bp = -30;

x_foundation_bp = 60;
y_foundation_bp = -40;

module end_of_customization() {}




/* Linkage Kinematicts  Calculations*/

dx_origin = dx_slide_plate;
dy_origin = -40;  // TODO Calculate from frame size?
dx_slider_pivot = dx_slide_plate; // Slider pivot and pusher server are aligned

dx_horn_pivot = function(a_horn_pivot) dx_origin + cos(a_horn_pivot) * r_horn_linkage;
dy_horn_pivot = function(a_horn_pivot) dy_origin + sin(a_horn_pivot) * r_horn_linkage; 

dx_linkage_offset = function(a_horn_pivot) dx_slider_pivot - dx_horn_pivot(a_horn_pivot);
linkage_angle = function(a_horn_pivot) acos(dx_linkage_offset(a_horn_pivot) /linkage_length); 

dx_pivot = function(a_horn_pivot) dx_horn_pivot(a_horn_pivot) + cos(linkage_angle(a_horn_pivot)) * linkage_length;
dy_pivot = function(a_horn_pivot) dy_horn_pivot(a_horn_pivot)  + sin(linkage_angle(a_horn_pivot)) * linkage_length; 

dx_linkage_midpoint = function(a_horn_pivot) dx_horn_pivot(a_horn_pivot)/2;
dy_linkage_midpoint = function(a_horn_pivot) (dy_pivot(a_horn_pivot) +dy_horn_pivot(a_horn_pivot) )/2;

// But translation is applied after rotation, so dy must be adjusted;
dx_linkage = function(a_horn_pivot) dx_slide_plate/2 + dx_linkage_midpoint(a_horn_pivot);
dy_linkage = function(a_horn_pivot) dy_horn_pivot(a_horn_pivot)  - dy_origin + sin(linkage_angle(a_horn_pivot)) * linkage_length/2;
 y_moving_clamp = function(a_horn_pivot) dy_pivot(a_horn_pivot) + y_pusher_assembly;


a_horn_pivot = servo_angle_pusher + servo_offset_angle_pusher + az_drive_link_pivot;
dy_moving_clamp =  dy_moving_clamp_offset  + dy_pivot(a_horn_pivot);

if (debug_kinematics && mode != PRINTING) {
    translate([dx_origin, dy_origin, 0]) color("yellow") can(d=1, h=a_lot);
    a_horn_pivot = servo_angle_pusher + servo_offset_angle_pusher + az_drive_link_pivot;
    translate([dx_horn_pivot(a_horn_pivot), dy_horn_pivot(a_horn_pivot), 0]) color("blue") can(d=1, h=a_lot);
    translate([dx_pivot(a_horn_pivot), dy_pivot(a_horn_pivot), 0]) color("green") can(d=1, h=a_lot);
    translate([dx_linkage_midpoint(a_horn_pivot), dy_linkage_midpoint(a_horn_pivot), 0]) color("brown") can(d=1, h=a_lot);
}


function layout_from_mode(mode) = 
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";

layout = layout_from_mode(mode);

function show(variable, name) = 
    (print_one_part && (mode == PRINTING)) ? name == part_to_print :
    variable;
    
visualization_pusher_driver_link  =        
    visualize_info(
        "Pusher Driver Link", PART_1, show(pusher_driver_link, "pusher_driver_link") , layout, show_parts);   
     
visualization_pusher_coupler_link  =        
    visualize_info(
        "Pusher Coupler Link", PART_2, show(pusher_coupler_link, "pusher_coupler_link") , layout, show_parts);        
        
visualization_fixed_clamp_body = 
    visualize_info(
        "Fixed Clamp Body", PART_5, show(fixed_clamp_body, "fixed_clamp_body") , layout, show_parts); 
 
        
visualization_clamp_cam = 
    visualize_info(
        "Horn Cam", PART_7, show(clamp_cam, "clamp_cam") , layout, show_parts); 

  
visualization_moving_clamp_bracket  =
    visualize_info(
        "Moving Clamp Bracket", PART_9, show(moving_clamp_bracket, "moving_clamp_bracket") , layout, show_parts);  
        
visualization_limit_cam  =
    visualize_info(
        "Limit Cam", PART_11, show(limit_cam, "limit_cam") , layout, show_parts);  
        
visualization_servo_retainer = 
    visualize_info(
        "Servo Retainer", PART_17, show(servo_retainer, "servo_retainer") , layout, show_parts);   
        
visualization_slide_plate = 
     visualize_info(
        "Slide Plate", PART_18, show(slide_plate, "slide_plate") , layout, show_parts);   
            
visualization_slider = 
     visualize_info(
        "Slider", PART_20, show(slider, "slider") , layout, show_parts);               
        
visualization_infos = [
    visualization_fixed_clamp_body,
    visualization_clamp_cam,
    visualization_pusher_coupler_link,
    visualization_pusher_driver_link,
    visualization_limit_cam,
    
    visualization_moving_clamp_bracket,
    visualization_servo_retainer,
    visualization_slide_plate,
    visualization_slider,
];


 
 // Vitamins:
 module filament(as_clearance = false, clearance_is_tight = true) {
    
    if (as_clearance) {
         
        if (clearance_is_tight) {
            rod(d=d_filament_with_tight_clearance, l=a_lot, center=SIDEWISE); 
        } else {
            rod(d=d_filament_with_clearance, l=a_lot, center=SIDEWISE);      
        }  
    } else if (mode != PRINTING) {
        filament_length = y_slide + 2 * 9g_servo_body_length + 80;
        
        color("red") 
            rod(d=d_filament, l=filament_length, center=SIDEWISE);
    }
}

module one_arm_horn(as_clearance=false, servo_angle=0, servo_offset_angle=0, show_barrel = true, show_arm=true) {    
    dz_arm = h_barrel_one_arm_horn + dz_engagement_one_arm_horn;
    module blank() {
        
        if (show_barrel) {
            translate([0, 0, dz_engagement_one_arm_horn]) can(d=d_barrel_one_arm_horn, h=h_barrel_one_arm_horn, center=ABOVE); 
        }
        if (show_arm) {
            translate([0, 0, dz_engagement_one_arm_horn+h_barrel_one_arm_horn]) {
                hull() {           
                    can(d=6, h=h_arm_one_arm_horn, center=BELOW);
                    translate([dx_one_arm_horn, 0, 0]) can(d=4, h=h_arm_one_arm_horn, center=BELOW); 
                }
            }    
        }    
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            can(d=2.5, h=a_lot);
            translate([0, 0, 4.77]) can(d=5, h=1, center=BELOW); // The splined hole
        }
    } 
    if (as_clearance) {
        blank();
    } else if (mode != PRINTING) {
        rotate([0, 0, servo_angle + servo_offset_angle]) {
            color("white") {
                shape();
            }
        }
    }
}


// Parts



module clamp_cam(item=0, servo_angle=0, servo_offset_angle=0, clearance=0.5) {
    h = z_servo_body_to_horn_barrel + h_barrel_one_arm_horn + z_screw_head_to_horn - z_clearance_clamp_cam;
    dz_horn = z_servo_body_to_horn_barrel - dz_engagement_one_arm_horn -z_clearance_clamp_cam;
    dz_assembly = dz_slide_plate + z_slide_plate/2 + z_clearance_clamp_cam + 1; // -h - dz_engagement_one_arm_horn + h_barrel_one_arm_horn +  ;    
    z_housing_clearance = z_servo_body_to_horn_barrel - z_clearance_clamp_cam;
 
    module gear_housing_clearance() {
        can(d=id_for_clamp_cam, h=z_housing_clearance, center=ABOVE);
//        intersection() {
//            translate([-4, 0, -1]) block([20, 20, z_housing_clearance], center=ABOVE+FRONT);
//            can(d=id_for_clamp_cam, h=z_housing_clearance, center=ABOVE);
//        }
    }   
    module shape() {
        d_lock = 0.1;
        ax_clamp_slice = 20;
        //render(convexity=10) 
        difference() {
            can(d=d_bottom_for_clamp_cam, taper=d_top_for_clamp_cam, h=h, center=ABOVE);
             // Provide the camming surface to force the filament down to lock it
            rotate([0, 0, az_slice_to_horn_for_clamp_cam]) 
                for (i = [0:1:2]) {
                    rotate([0, 0, 90*i])
                    translate([0, 0, dz_slice_for_clamp_cam + i * delta_z_slice_segment])
                        rotate([0, slice_angle_for_clamp_cam, 0]) 
                            //#plane_clearance(BELOW + RIGHT + FRONT); 
                            block([20, 20, 20], center = BELOW + RIGHT + FRONT); 
                }
            
            // Screw used to attach horn
            can(d=2.5, h=a_lot); //Screw 
            // Slot for horn
            translate([0, 0, dz_horn])  one_arm_horn(as_clearance=true);
            hull() {
                translate([0, 0, dz_horn])  one_arm_horn(as_clearance=true, show_barrel = false);
                translate([0, 0, dz_horn-h])  one_arm_horn(as_clearance=true, show_barrel = false);
            }
            hull() {
                translate([0, 0, dz_horn])  one_arm_horn(as_clearance=true, show_arm = false);
                translate([0, 0, dz_horn-h])  one_arm_horn(as_clearance=true, show_arm = false);
            }
            
            
            gear_housing_clearance();
        }
    }
    z_printing = h;
    rotation = 
        mode == PRINTING ? [180, 0, 0] :
        [0, 0, 90 + servo_angle + servo_offset_angle];
    translation = 
        mode == PRINTING ? [x_clamp_cam_bp + item*dx_clamp_cam_bp, y_clamp_cam_bp, z_printing] :
        [0, 0, dz_assembly];
    translate(translation) rotate(rotation) visualize(visualization_clamp_cam) shape();   
}



module moving_clamp_bracket(a_horn_pivot) {
    z_moving_clamp_bracket = 10;
    moving_clamp_rim = 3;        
    base = [
        2 * moving_clamp_rim + 9g_servo_body_width,
        2 * moving_clamp_rim + 9g_servo_body_length,
        z_moving_clamp_bracket
    ]; 
    servo_wire_clearance = [ 6, 20, 6]; 
    slot = [9g_servo_body_width, 9g_servo_body_length, a_lot];
    module shape() {    
        render(convexity=10) difference() {
            block(base, center=ABOVE);
            block(slot);
            translate([0, 0, 8]) block(servo_wire_clearance, center=RIGHT);
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0, 0, 0] :
        [0, 0, 0];
    // base.y + dy_pivot,
    translation = 
        mode == PRINTING ? [x_pusher_bp , y_pusher_bp, z_printing] :
        [dx_slide_plate,  base.y/2 + 4 + dy_pivot(a_horn_pivot), dz_slide_plate + dz_linkage];
    translate(translation) rotate(rotation) visualize(visualization_moving_clamp_bracket) shape();       
}

module pusher_driver_link(a_horn_pivot, as_blank = false) {
    h = 4;
    z_base = 2;
    dz_horn = dz_engagement_one_arm_horn + h_barrel_one_arm_horn + z_base;
    pin_attachment = [2, 3, 8];
    barrel_attachment = [10, 3, 8];
    r_pin_attachment = r_horn_linkage - 4.5;
    r_barrel_attachment = r_horn_linkage + 4.;
    linkage = [15, 3, 8];
    d_center = d_barrel_one_arm_horn + 4;

    module blank() {
        hull() {
            can(d=d_center, h=h, center=ABOVE);
            translate([12, 0, 0]) can(d=7, h=h, center=ABOVE); 
        }

        hull() {
            can(d=d_center, h=2, center=ABOVE);
            rotate([0, 0, az_drive_link_pivot])  translate([r_horn_linkage, 0, 0]) can(d=5, h=2, center=ABOVE);
        }
        rotate([0, 0, az_drive_link_pivot])  translate([r_pin_attachment, 0, 0])  block(pin_attachment, center=ABOVE);     

    }   
            
    module shape() {
        render(convexity=10) difference() {
            blank();
            translate([0, 0, dz_horn])  rotate([180, 0, 0]) hull() one_arm_horn(as_clearance=true);
            can(d=2.2, h=a_lot);  // Central hole for screw!
        }
    }
    
    if (as_blank) {
        blank();
    } else {
    
        z_printing = 0;
        rotation = 
            mode == PRINTING ? [0,  0, a_horn_pivot] :
            [0, 0, a_horn_pivot - az_drive_link_pivot];
        translation = 
            mode == PRINTING ? [x_pusher_bp + dx_origin, y_pusher_bp, z_printing] :
            [dx_origin, 0, dz_slide_plate + dz_linkage]; 
        translate(translation) rotate(rotation) {
            if (show_vitamins && mode != PRINTING) {
                visualize_vitamins(visualization_pusher_driver_link) 
                    translate([0, 0, dz_horn])  rotate([180, 0, 0]) one_arm_horn();
            }
            visualize(visualization_pusher_driver_link) shape();  
        }
    }
} 

module limit_cam(a_horn_pivot) {
    horn_linkage_cutout_sf = 1.03; // Adjust to get fit without slop!
    horn_linkage_cutout_scaling = [horn_linkage_cutout_sf, horn_linkage_cutout_sf, 1];
    d_limit_cam = 18   ;
    h_limit_cam = 7;
    h_bumper = 4;
    dz_engagement = 2;
    az_limit_cam_back = 280;
    az_limit_cam_front = 100;
    
    module blank() {
        can(d=d_limit_cam, h = h_limit_cam, center=ABOVE);
        hull() {
            rotate([0, 0, az_limit_cam_back]) translate([15, 0, 0]) can(d=10, taper = 5, h = h_bumper, center = ABOVE);
            rotate([0, 0, az_limit_cam_front]) translate([15, 0, 0]) can(d=10, taper = 5, h = h_bumper, center = ABOVE);
        }
    }
        
    module shape() {
        render(convexity=10) difference() {
            blank();
            translate([0, 0, h_limit_cam - dz_engagement]) scale(horn_linkage_cutout_scaling)  pusher_driver_link(as_blank=true);
            can(d=2.2, h=a_lot);  // Central hole for screw!
            can(d=8, taper=5, h=h_limit_cam-dz_engagement-1, center=ABOVE);
            translate([0, 0, h_limit_cam-dz_engagement-1]) can(d=5, taper=2.2, h=1, center=ABOVE);
        }        
    }    
    
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, a_horn_pivot - az_drive_link_pivot];
    translation = 
        mode == PRINTING ? [x_limit_cam_bp, y_limit_cam_bp, z_printing] :
        [dx_origin, 0, dz_slide_plate  + dz_linkage - h_limit_cam + dz_engagement]; 
    translate(translation) rotate(rotation) {
        visualize(visualization_limit_cam) shape();  
    }
}


module pusher_coupler_link(a_horn_pivot) {
    angle_bearing_moving_clamp = -220; 
    l_strut_moving_clamp = 14;
    angle_bearing_horn_cam = -180;
    l_strut_horn_cam = 10;
    
    
    pivot_size = 1; 
    angle_pin_moving_clamp = -linkage_angle(a_horn_pivot);
    angle_pin_horn_cam = 90 + az_drive_link_pivot 
                                        - linkage_angle(a_horn_pivot)
                                        + servo_angle_pusher
                                        + servo_offset_angle_pusher;
    air_gap = 0.45;
    attachment_instructions = [
        [ADD_SPRUES, AP_LCAP, [45, 135, 225, 315]],
    ]; 
    
    
    // The linkage connects the pivot of the horn linkage to the pusher pivot on the moving clamp. 
    module shape() {
        * visualize(visualization_linkage)  render(convexity=10) difference() {
            hull() center_reflect([1, 0, 0]) translate([linkage_length/2, 0, 0]) can(d=5, h = 2, center=ABOVE);
            center_reflect([1, 0, 0]) translate([linkage_length/2, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
        }
        translate([linkage_length/2, 0, 0]) {
            audrey_horizontal_pivot(
                pivot_size, 
                air_gap, 
                angle_bearing_moving_clamp, 
                angle_pin_moving_clamp, 
                attachment_instructions=attachment_instructions);
            rotate([0, 0, 90 + angle_bearing_moving_clamp]) {
                hull() {
                    translate([5, 0, 0]) can(d=3, h=8, center=ABOVE);
                    translate([l_strut_moving_clamp, 0, 0]) can(d=3, h=8, center=ABOVE);
                }
            }
            
        }

        translate([-linkage_length/2, 0, 0]) {
            audrey_horizontal_pivot(
                pivot_size, 
                air_gap, 
                angle_bearing_horn_cam, 
                angle_pin_horn_cam, 
                attachment_instructions=attachment_instructions);
            rotate([0, 0, 90 + angle_bearing_horn_cam]) {
                hull() {
                    translate([5, 0, 0]) can(d=3, h=8, center=ABOVE);
                    translate([l_strut_horn_cam, 0, 0]) can(d=3, h=8, center=ABOVE);
                }
            }     
        }
        
        hull() {
            translate([linkage_length/2, 0, 0]) 
                rotate([0, 0, 90 + angle_bearing_moving_clamp])
                    translate([l_strut_moving_clamp, 0, 0]) can(d=3, h=8, center=ABOVE);
                    
            translate([-linkage_length/2, 0, 0]) 
                rotate([0, 0, 90 + angle_bearing_horn_cam]) 
                    translate([l_strut_horn_cam, 0, 0]) can(d=3, h=8, center=ABOVE);
                    
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, linkage_angle(a_horn_pivot)];    
    translation = 
        mode == PRINTING ? 
            [x_pusher_bp + dx_linkage(a_horn_pivot), y_pusher_bp + dy_linkage(a_horn_pivot), z_printing] :
        [dx_linkage(a_horn_pivot), dy_linkage(a_horn_pivot), dz_slide_plate + dz_linkage];  
    translate(translation) rotate(rotation) visualize(visualization_pusher_coupler_link)  shape();  
}


//module filament_loader_clip(as_clearance=false) {
//    blank = [7, 12, 20];
//    base = [7, 14, 4];
//    connector =  flute_clamp_connector();
//    connector_extent = gtcc_extent(connector); 
//    y_loose =  connector_extent.y + 0.5;
//    y_tight = connector_extent.y - 1;
//    y_spring = connector_extent.y - 3;
//    x_loose = 3.5; 
//    z_slit = 4;
//    
//    z_printing = blank.z;
//    
//    module shape() {
//        render(convexity=10) difference() {
//            union() {
//                block(blank, center = ABOVE);
//                hull() {
//                    translate([base.x/2, 0, 0]) block([0.1, base.y, base.z], center = ABOVE);
//                    translate([base.x/2, 0, 0]) block([0.1, blank.y, base.z+4], center = ABOVE);
//                    translate([-base.x/2, 0, 0])  block([0.1, blank.y, base.z], center = ABOVE);
//                }
//            }
//            // Spreader - slot is narrow then connector
//            translate([0, 0, 5.0]) block([x_loose, y_tight, 8], center=ABOVE);
//            // Wedging cut above clip
//            hull() {
//                translate([0, 0, 3]) rod(d=0.5, l=x_loose);
//                translate([0, 0, 10]) block([x_loose, y_loose , 0.1], center=ABOVE);
//            }                  
//            // Clearance for arm
//            translate([0, 0, 10])  {
//                hull() {
//                    block([x_loose, y_loose, 11.5], center=ABOVE);
//                    translate([0, 1.5, 0]) block([0.1, y_loose, 11.5], center=ABOVE);
//                }
//                translate([0, 0, 0]) block([10, y_loose-1, 11.5], center=ABOVE+FRONT);
//            }
//            // Clearance for arm insertion    
//            translate([-x_loose/2, 0, 10]) block([10, y_loose, 8.5], center=ABOVE+FRONT);
//            // vertical slit through clamp
//            block([10, 0.5, blank.z-z_slit], center=ABOVE);
//            // Clamp for filament
//            translate([0, 0, 4]) {
//                rod(d=1.25, l=20);
//                block([20, 1.25, 1.25/2], center=ABOVE);
//            }
//            // Cut below clip
//            hull() {
//                translate([0, 0, 0.75]) rod(d=0.5, l=a_lot);
//                block([a_lot, 1.75, 0.1], center=BELOW);
//            }
//            // Cut near top to make back side flexible
//            //translate([0, 0, blank.z - 2]) block([10, y_spring, 1]);
//        }          
//    }
//    if (as_clearance) {  
//        translate([filament_translation.x, dy_filament_loader_clip, filament_translation.z]) rotate([0, 0, -90])  {
//            hull() {
//                translate([0, -2, -4]) shape();
//                translate([-0, +2, -4]) shape();
//            }
//            // Slit for filament to come in, plus remove unprintable overhand
//            x = 10;
//            hull() {
//                rod(d=7, l=x, center= FRONT);
//                translate([0, 0, 10]) block([x, 22, 0.1], center=ABOVE+FRONT);
//            }
//        }
//    } else {
//        rotation = 
//            mode == PRINTING ? [180, 0, 0] :
//            [0, 0, -90];
//        translation = 
//            mode == PRINTING ? [x_filament_loader_clip_bp, y_filament_loader_clip_bp, z_printing] :
//            [filament_translation.x, 105, filament_translation.z-4];
//        translate(translation) {
//            rotate(rotation) {
//                visualize(visualization_filament_loader_clip) {
//                    shape() ;
//                }
//            }    
//        }
//    }
//}

//module filament_loader(as_holder = true, as_inlet_clip_clearance = false, show_bow = false, show_tip = true) {
//    connector =  flute_clamp_connector();
//    connector_extent = gtcc_extent(connector);
//    dz_clip = -6;
//    dx_clip = 4;
//    clip = [4, a_lot, 4];
//    module tip_blank() {
//        block([10, connector_extent.y, 3], center=BELOW + BEHIND);
//        translate([-4, 0, 0]) hull() {
//            block([6, connector_extent.y, 3], center=BELOW + BEHIND);
//            translate([0, -1.5, -1.5])  block([6, connector_extent.y, 0.1], center=BELOW + BEHIND);
//        }
//        translate([-6, 0, 0]) block([4, connector_extent.y, 20], center=BELOW+BEHIND);
//    }
//
//    module blank() {
//        rotate([0, 90, 0]) {
//            rotate([-90, 0, 0]) {
//                if (show_bow) {
//                    translate([0, 0, -2 * connector_extent.z-4]) flute_collet(is_filament_entrance=false);
//                    translate([0, 0, -6]) block([4, connector_extent.y, 40], center=ABOVE);
//                    translate([0, 0, 30]) block([8, connector_extent.y, 4], center=ABOVE+BEHIND);
//                    translate([-8, 0, 30]) block([4, connector_extent.y, 76], center=ABOVE+BEHIND);
//                }
//                if (show_tip) {
//                    translate([-2, 0, 106.5]) tip_blank();
//                }
//            }
//        }        
//    }
//    
//    module shape() {
//        render(convexity=10) difference() {
//            blank();
//            rod(d=d_filament_with_clearance, l=a_lot, center=SIDEWISE + RIGHT);        
//        }
//    }
//    
//    if (as_inlet_clip_clearance) {
//        translate([filament_translation.x, 0, filament_translation.z]) {
//            scale([1.1, 1.1, 1.1]) block([connector_extent.y, 100, 4]);
//        }
//    } else if (as_holder) {
//        z_printing = connector_extent.y/2;
//        rotation = 
//            mode == PRINTING ? [0,  -90, 0] :
//            [0, 0, 0];
//        translation = 
//            mode == PRINTING ? [x_filament_loader_bp, y_filament_loader_bp, z_printing] :
//            [filament_translation.x, 0, filament_translation.z];
//        translate(translation) rotate(rotation) {
//            visualize(visualization_filament_loader) shape();
//        } 
//    } else {
//    }    
//}






module servo_retainer(z_servo_flange = 2.5) {
    // A backup that holds the nuts on the back side of the servo mounting bracket
    x = 2 * x_slider_rim + 9g_servo_body_width;  
    y = 2 * y_slide_plate_rim + 9g_servo_body_length;
    z =  3;    // Just needs to be a bit more than the thickness of a nut. 
    z_under_nut = 1; 
    // The core provides the body into which the servo will be inserted.
    core = [x, y, z];
    servo_slot = 1.05* [9g_servo_body_width, 9g_servo_body_length, a_lot];
    
    module servo_screws(as_clearance) {
        center_reflect([0, 1, 0]) translate([0, 9g_servo_body_length/2 + y_slide_plate_rim/2, 0]) { 
            if (as_clearance) {
                translate([0, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
                translate([0, 0, z_under_nut]) rotate([180, 0, 0]) nutcatch_parallel(
                    name   = "M2",  // name of screw family (i.e. M3, M4, ...)
                    clh    =  10,  // nut height clearance
                    clk    =  0.4);  // clearance aditional to nominal key width                
            } else {
                assert(false, "Not implemented yet");
            }
        }
    }
    module shape() {
        difference() {
            block(core, center = ABOVE);
            block(servo_slot);
            servo_screws(as_clearance=true);       
        }
    }
    
    rotation = mode == PRINTING ? [0,  0, 0] : [0, 180, 0];
    translation = mode == PRINTING ? [0,  0, 0] : [0, 0,  -z_slide_plate/2 - z_servo_flange + dz_slide_plate];
    
    translate(translation) rotate(rotation) {
        visualize(visualization_servo_retainer) shape();
    }   
}



module slider(dy_slider) {
    
    module blank() {
        x = 2 * x_slider_rim + 9g_servo_body_width - 2 * slider_clearance;  
        y = 2 * y_slide_plate_rim + 9g_servo_body_length;
        z = z_slide_plate;
        // The core provides the body into which the servo will be inserted.
        core = [x, y, z_slide_plate];
        // The waist engages with the slider plate rails with a 45 degree angle.
        waist = [x + z_slide_plate, y, 0.01];
        hull() {
            block(core);
            block(waist);
        }
    }
    
    module servo_slot() {
        // Currently this is a tight press fit! 
        block([9g_servo_body_width, 9g_servo_body_length, a_lot]);
        // Note: Once screws are used, add clearance for easier assembly
    }
    
    module servo_screw(as_clearance) {
        rotate([0, 0, 180]) translate([0, 9g_servo_body_length/2 + y_slide_plate_rim/2, 0]) { 
            if (as_clearance) {
                translate([0, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
            } else {
                assert(false, "Not implemented yet");
            }
        }
    }
    
    module servo_screw_by_wires(as_clearance) {
        if (as_clearance) {
            hull () {
                rotate([0, 0, 180])  {
                    servo_screw(as_clearance=true);
                    //translate([0, -y_slide_plate_rim, 0]) servo_screw(as_clearance=true);
                }
            }
        }
    }    
     
    module shape() {
        render(convexity=10) {
                difference() {
                    blank();
                    servo_slot();
                    servo_screw(as_clearance=true);
                    servo_screw_by_wires(as_clearance=true);
                    
                }    
            }        
    }
    
    module vitamins() {
        translate([0, 5.5, 9.3]) {
            rotate([0, 0, 90]) {
                color(MIUZEIU_SERVO_BLUE) 
                    9g_motor_sprocket_at_origin();
                one_arm_horn(servo_angle=servo_angle_moving_clamp, servo_offset_angle=servo_offset_angle_moving_clamp);
                
            }     
        }

    }
         
    z_printing = z_slide_plate/2;
    rotation = 
        mode == PRINTING ? [180,  0, 0] : 
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_slider_bp, y_slider_bp, z_printing] :
        [dx_slide_plate, dy_slider, dz_slide_plate];
    translate(translation) rotate(rotation) {
        if (show_vitamins && mode != PRINTING) {
            visualize_vitamins(visualization_slider) vitamins();
        }
        visualize(visualization_slider) shape();  
    }
}

module slide_plate() {
    dy_pusher_servo_inner_pedistal = -y_slide/2;
    dy_pusher_servo_slot = -(y_slide/2 + y_slide_plate_rim + 9g_servo_body_length/2);
    dy_pusher_servo = dy_pusher_servo_slot + 9g_servo_offset_origin_to_edge;
    
    dz_pusher_servo = -(z_pusher_servo_pedistal + 9g_servo_vertical_offset_origin_to_flange);
    
    module pusher_slot() {
        translate([0, dy_pusher_servo_slot, 0]) block([9g_servo_body_width, 9g_servo_body_length, a_lot]);
    }
    module pusher_wire_clearance() {
        // Cut into inner pedistal to allow room for wire and assembly
        dy_pusher_wire_clearance = dy_pusher_servo_inner_pedistal - y_offset_pusher_wire_clearance;
        pusher_wire_clearance_offset = 3;
        z_pusher_servo_wires_clearance_extra = 2;
        dz = 4;
        x = 10;
        hull() {
            translate([x_offset_pusher_wire_clearance, dy_pusher_wire_clearance, dz]) 
                block([x, 0.01, z_pusher_servo_wires_clearance], center=BELOW+LEFT);
            translate([x_offset_pusher_wire_clearance, dy_pusher_wire_clearance - pusher_wire_clearance_offset, dz]) 
                block([x, 0.01, z_pusher_servo_wires_clearance + z_pusher_servo_wires_clearance_extra], center=BELOW+LEFT);
        }
           
    }
    
    module fixed_clamp_slot() {
        dy = (y_slide/2 + y_slide_plate_rim + 9g_servo_body_length/2);
        translate([0, dy, 0]) block([9g_servo_body_width, 9g_servo_body_length, a_lot]);
    }
    
    module rail_cavity() {
        x = 9g_servo_body_width + 2 * x_slider_rim;  

        block([x, y_slide, a_lot]);
        dx_rail = z_slide_plate;  // Make slide rails at a 45 degree angle.
        hull() {  
            block([x, y_slide, z_slide_plate]);      
            block([x + dx_rail, y_slide, 0.001]);
        }
    }
    
    module blank() {
        // The main plate:
        x = 2 * x_slide_plate_rim + 9g_servo_body_width;  
        y = 2 * (2 * y_slide_plate_rim + 9g_servo_body_length)  
              + y_slide;
        z = z_slide_plate;
        block([x, y, z]); 
        // Pedistal for outer part of pusher servo:
        dy_pusher_servo_outer_pedistal = -y/2;
        x_outer_pedistal = 9g_servo_body_width;
        translate([0, dy_pusher_servo_outer_pedistal, 0]) 
            block([x_outer_pedistal, y_slide_plate_rim, z_pusher_servo_pedistal], center=BELOW + RIGHT);
        // Inner pedistal - must avoid interfering with wire and still allow assembly
     
        translate([0, dy_pusher_servo_inner_pedistal, 0]) 
            block([9g_servo_body_width, y_slide_plate_rim, z_pusher_servo_pedistal], center=BELOW+LEFT);
    }
    
    module shape() {
        render(convexity=10) 
                difference() {
                blank();
                pusher_slot();
                pusher_wire_clearance();
                fixed_clamp_slot();
                rail_cavity();      
            }
     }
     
    z_printing = z_slide_plate/2;
    rotation = 
        mode == PRINTING ? [0,  0, 180] : 
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_slide_plate_bp, y_slide_plate_bp, z_printing] :
        [dx_slide_plate, dy_slide_plate, dz_slide_plate];
    translate(translation) rotate(rotation) {
         if (show_vitamins && mode != PRINTING) {
             translate([0, dy_pusher_servo, dz_pusher_servo]) 
                rotate([0, 180, -90]) 
                    color(MIUZEIU_SERVO_BLUE) 9g_motor_sprocket_at_origin();
         }
        visualize(visualization_slide_plate) shape();  
    }
    
}

module position_sensor(show_vitamins=false) {
    /*
    The position sensor is a limit switch upon which the limit_cam rotates. 
    
    By using this indirect method, we will be able to detect jams, while using only a single component.
    */
    module shape_and_vitamins() {
        dx_position_sensor = -14;
        
        dy_position_sensor = 20;
        dz_position_sensor = -12.75;
        translation = 
                [
                   dx_position_sensor, 
                    -y_slide/2 - dy_position_sensor, 
                    dz_position_sensor];
        visualize_vitamins(visualization_slide_plate) {
            translate(translation) {
                rotate([0, 0, 90]) 
                    nsrsh_terminal_side_clamp(
                        roller_is_at_end = false, 
                        switch_depressed=limit_switch_is_depressed, 
                        show_vitamins=show_vitamins);
            }
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [180,  0, 0] : 
        [0, 0, 0];    
    translation = 
        mode == PRINTING ? [x_slide_plate_bp, y_slide_plate_bp, z_printing] :  [dx_slide_plate, dy_slide_plate, dz_slide_plate];
    translate(translation)  rotate(rotation) shape_and_vitamins();
}


// Assemblies




module fixed_clamp() {
    dy_fixed_clamp = y_slide - y_base_pillar/2; 
    translate([0, dy_fixed_clamp, 0]) {
        //fixed_clamp_body();
        if (show_vitamins) {
            one_arm_horn(servo_angle=servo_angle_fixed_clamp, servo_offset_angle=servo_offset_angle_fixed_clamp);
        }
        * clamp_cam(servo_angle=servo_angle_fixed_clamp);
    }
}

module moving_clamp() {
    translate([dx_slide_plate, dy_moving_clamp, 0]) {
        servo_retainer();
        translate([0, 6, 0]) clamp_cam(servo_angle=servo_angle_moving_clamp, servo_offset_angle = servo_offset_angle_moving_clamp);
    }
}

module pusher() {
    //dz_slide_plate
    translate([0, y_pusher_assembly, 0]) {
        translate([0, dy_pusher_servo, 0]) 
            pusher_driver_link(a_horn_pivot=a_horn_pivot); 
        translate([0, dy_pusher_servo, 0]) 
            pusher_coupler_link(a_horn_pivot=a_horn_pivot); 
        translate([0, dy_pusher_servo, 0]) 
            limit_cam(a_horn_pivot=a_horn_pivot);        
    }
    translate([0, 0, 0]) moving_clamp_bracket(a_horn_pivot=a_horn_pivot);
     
}




module slide() {
    // The slide is a new assembly that integrates the rails, pusher body, fixed clamp
    // body and the moving clamp body.  By integrating these parts,
    // less material will be used and assembly will be simplified. 
    
    // It will have two or three separate parts, but it is expected that they will be printed in-place 
    // so there will be no separate assembly - just inserting the servos
   
    slide_plate();
    slider(dy_moving_clamp);
    position_sensor(show_vitamins=show_vitamins);
}

module visualize_assemblies() {
    if (show_filament) {
        filament();
    }
    slide();
    pusher();
    fixed_clamp();
    moving_clamp();
    // filament_loader(as_holder = true, show_bow = true, show_tip = true);
     //filament_loader_clip();
     if (show_legend) {
        generate_legend_for_visualization(
            visualization_infos, legend_position, font6_legend_text_characteristics());
     }
 }
  
module print_assemblies() {
    if (print_slide) {
        slide_plate();
        slider();
        position_sensor();
    }
    if (print_moving_clamp_cam) {
        clamp_cam(item=0); 
    }
    if (print_fixed_clamp_cam) {
        clamp_cam(item=1);   
    }
    if (print_pusher) {
        a_horn_pivot = 50;
        pusher_driver_link(a_horn_pivot);
        pusher_coupler_link(a_horn_pivot=a_horn_pivot);
        moving_clamp_bracket(a_horn_pivot=a_horn_pivot); 
        limit_cam(a_horn_pivot=a_horn_pivot);
    }
 }
 


if (mode ==  ASSEMBLE_SUBCOMPONENTS) { 
    visualize_assemblies();
} else if (mode ==  PRINTING) {
    print_assemblies();
}
