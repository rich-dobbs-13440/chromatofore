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
print_moving_clamp_horn_cam = true;
print_fixed_clamp_horn_cam = true;
print_pusher = true;
print_filament_loader = true;

print_one_part = false;
part_to_print = "limit_cam"; // [clip, collet, filament_loader, filament_loader_clip, fixed_clamp_body, foundation, horn_cam, horn_linkage, linkage, limit_cam, moving_clamp_body, rails, servo_base, slide_plate, tie, tie_bracket]

filament_length = 200; // [50:200]

/* [Show] */ 
// Order to match the legend:
filament_loader  = 0; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
filament_loader_clip  = 0; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
fixed_clamp_body = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_cam = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_linkage = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
limit_cam =  1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
linkage = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
moving_clamp_bracket = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
slide_plate = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
slider  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
foundation  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 


/* [Legend] */
x_legend = 36; // [-200 : 200]
y_legend = 120; // [-200 : 200]
z_legend = -40; // [-200 : 200]
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

/* [One Arm Horn Characteristics] */
dz_engagement_one_arm_horn = -1;// 1;
h_barrel_one_arm_horn = 3.77;
h_arm_one_arm_horn = 1.3;    
dx_one_arm_horn = 14;


/* [Clamp Cam Design] */
od_cam = 22;
od_cam_top = 22;

dx_cam_slice_bottom = 5;  // [-10: 0.1: 10]
ay_cam_slice_bottom = -85; // [-90: 0]
az_clamp_cam_to_horn = 180; // [-180:180]

// The height from the horn arm to the top of the cam
z_servo_body_to_horn_barrel = 5.3; // [0: 0.1: 10]
z_clearance_horn_cam = 1; 
// Set to control stiffness of cam to horn attachment
z_screw_head_to_horn = 2; //[1:0.5:2.5]

/* [Slide Plate Design] */
// Adjust so that servos fits into slide plate openings!
9g_servo_body_length = 22.5; // [22.5, 23.0, 23.5, 24]
// Adjust so that servos fits into slide plate openings!
9g_servo_body_width = 12.0; // [12.0, 12.2, 12.4]
// Adjust so that servo shows as middle of slot.
9g_servo_offset_origin_to_edge = 6;
// Adjust so that servo shows as resting on pedistal
9g_servo_vertical_offset_origin_to_flange = 14.5;
// Lateral offset between CL of filament to CL of servos
dx_slide_plate = 2.5;
// Offset of the mid point of the slide plate from the mid point of the slide plate, in the direction that the slide moves.
dy_slide_plate = 0;
// Offset of the slide plate vertically from the CL of the filament.  
dz_slide_plate = -2;
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


/* [Slider] */
// TODO:  Calculate value based on animation and kinematics!
dy_slider = 0; // Good enough to start printing!
// Lateral clearance between slider and guide.  Needs to big enough that the parts print separately.  Small enough relative to thickness of plate so that slider doesn't fall out or move too much vertically.
slider_clearance = 0.4;
// Lateral rim around servos inserted into slider
x_slider_rim = 2;

/* [Base Design] */
dz_servo = 3.5;
x_base_pillar = 34;
y_base_pillar = 12;
z_base_pillar = 8.8;
z_base_joiner = 3.8;
dx_base_offset = -5;
dy_base_offset = 5;
dy_base_offset_moving_clamp = 12;

/* [Foundation Design] */

x_foundation = 45;
y_foundation = 117.5;
z_foundation = 4;


x_foundation_ls_terminal =  9.5;
y_foundation_ls_terminal = 11.8;
z_foundation_ls_terminal = 4; // [4,8]

dx_foundation = -33;
dy_foundation = 5;
dz_foundation = -44; // [-50:30]

dx_pusher_servo_clip  = 25;
dy_pusher_servo_clip = 30;

/* [Outlet Design] */
y_outlet = 20;





/* [Guide Design] */
filament_translation = [-4.5, 0, 1.7];
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

/* [Linkage Design] */
debug_kinematics = false; 
az_horn_linkage_pivot = 25;
r_horn_linkage = 16;
linkage_length = 24;
linkage_shorten_range = 4;
// *******************************************************
dz_linkage = -24 + z_pusher_servo_pedistal; // [-40: 0]
// TODO:  Calculate y_pusher_assembly from plate dimensions
y_pusher_assembly = -42;
dy_pusher_servo = 2;

a_horn_pivot = servo_angle_pusher + servo_offset_angle_pusher + az_horn_linkage_pivot;

/* [Filament Holder Design] */
dy_filament_loader_clip = 12;


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

x_horn_cam_bp = 40;
y_horn_cam_bp = -20;
dx_horn_cam_bp = -30;

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

/* Linkage kinematicts */

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

if (debug_kinematics && mode != PRINTING) {
    translate([dx_origin, dy_origin, 0]) color("yellow") can(d=1, h=a_lot);
    a_horn_pivot = servo_angle_pusher + servo_offset_angle_pusher + az_horn_linkage_pivot;
    translate([dx_horn_pivot(a_horn_pivot), dy_horn_pivot(a_horn_pivot), 0]) color("blue") can(d=1, h=a_lot);
    translate([dx_pivot(a_horn_pivot), dy_pivot(a_horn_pivot), 0]) color("green") can(d=1, h=a_lot);
    translate([dx_linkage_midpoint(a_horn_pivot), dy_linkage_midpoint(a_horn_pivot), 0]) color("brown") can(d=1, h=a_lot);
}

///* Rail calculations */
//x_rail = 1 + s_guide_dovetail + 1 + rail_wall;
//z_rail = z_guide + s_guide_dovetail + 2 * rail_wall;



function layout_from_mode(mode) = 
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";

layout = layout_from_mode(mode);

function show(variable, name) = 
    (print_one_part && (mode == PRINTING)) ? name == part_to_print :
    variable;
    
visualization_horn_linkage  =        
    visualize_info(
        "Horn Linkage", PART_1, show(horn_linkage, "horn_linkage") , layout, show_parts);   
     
visualization_linkage  =        
    visualize_info(
        "Linkage", PART_2, show(linkage, "linkage") , layout, show_parts);        
        
visualization_fixed_clamp_body = 
    visualize_info(
        "Fixed Clamp Body", PART_5, show(fixed_clamp_body, "fixed_clamp_body") , layout, show_parts); 
 
        
visualization_horn_cam = 
    visualize_info(
        "Horn Cam", PART_7, show(horn_cam, "horn_cam") , layout, show_parts); 
        
//visualization_limit_switch_holder =   
//    visualize_info(
//        "Limit Switch Holder", PART_8, show(limit_switch_holder, "limit_switch_holder") , layout, show_parts);  
  
visualization_moving_clamp_bracket  =
    visualize_info(
        "Moving Clamp Bracket", PART_9, show(moving_clamp_bracket, "moving_clamp_bracket") , layout, show_parts);  
        
visualization_limit_cam  =
    visualize_info(
        "Limit Cam", PART_11, show(limit_cam, "limit_cam") , layout, show_parts);  
        
visualization_filament_loader =       
    visualize_info(
        "Filament Loader", PART_13, show(filament_loader, "filament_loader") , layout, show_parts);   
        
visualization_filament_loader_clip =       
    visualize_info(
        "Filament Loader Clip", PART_14, show(filament_loader_clip, "filament_loader_clip") , layout, show_parts);         

visualization_foundation = 
    visualize_info(
        "Foundation", PART_17, show(foundation, "foundation") , layout, show_parts);   


visualization_slide_plate = 
     visualize_info(
            "Slide Plate", PART_18, show(slide_plate, "slide_plate") , layout, show_parts);   
            
visualization_slider = 
     visualize_info(
            "Slider", PART_20, show(slider, "slider") , layout, show_parts);               
        
visualization_infos = [
    visualization_filament_loader, 
    visualization_filament_loader_clip, 
    visualization_fixed_clamp_body,
    visualization_horn_cam,
    visualization_horn_linkage,
    visualization_limit_cam,
    //visualization_limit_switch_holder,
    visualization_linkage,
    visualization_moving_clamp_bracket,
    visualization_slide_plate,
    visualization_slider,
    visualization_foundation,
];


 
 // Vitamins:
 module filament(as_clearance = false, clearance_is_tight = true) {
    
    if (as_clearance) {
        translate(filament_translation) 
            if (clearance_is_tight) {
                rod(d=d_filament_with_tight_clearance, l=a_lot, center=SIDEWISE); 
            } else {
                rod(d=d_filament_with_clearance, l=a_lot, center=SIDEWISE);      
            }  
    } else if (mode != PRINTING) {
        filament_length = y_slide + 90;
        translate(filament_translation + [0, -40, 0]) 
            color("red") 
                rod(d=d_filament, l=filament_length, center=SIDEWISE+RIGHT);
    }
}

module one_arm_horn(as_clearance=false, servo_angle=0, servo_offset_angle=0, show_barrel = true, show_arm=true) {    
    dz_arm = h_barrel_one_arm_horn + dz_engagement_one_arm_horn;
    module blank() {
        if (show_barrel) {
            translate([0, 0, dz_engagement_one_arm_horn]) can(d=7.5, h=h_barrel_one_arm_horn, center=ABOVE); 
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



module horn_cam(item=0, servo_angle=0, servo_offset_angle=0, clearance=0.5) {
    h = z_servo_body_to_horn_barrel + h_barrel_one_arm_horn + z_screw_head_to_horn - z_clearance_horn_cam;
    dz_horn = z_servo_body_to_horn_barrel - dz_engagement_one_arm_horn -z_clearance_horn_cam;
    dz_assembly = -h - dz_engagement_one_arm_horn + h_barrel_one_arm_horn;    
    z_housing_clearance = z_servo_body_to_horn_barrel - z_clearance_horn_cam;
 
    module gear_housing_clearance() {
        can(d=12, h=z_housing_clearance, center=ABOVE);
        intersection() {
            translate([-4, 0, 0]) block([20, 20, z_housing_clearance], center=ABOVE+FRONT);
            can(d=20, h=z_housing_clearance, center=ABOVE);
        }
    }   
    module shape() {
        d_lock = 0.1;
        render(convexity=10) difference() {
            can(d=od_cam, taper=od_cam_top, h=h, center=ABOVE);
             // Provide the camming surface to force the filament down to lock it
            rotate([0, 0, az_clamp_cam_to_horn]) 
                translate([dx_cam_slice_bottom, 0, 0]) 
                    rotate([0, ay_cam_slice_bottom, 0]) 
                        plane_clearance(BEHIND); 
            
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
        [0, 0, servo_angle + servo_offset_angle];
    translation = 
        mode == PRINTING ? [x_horn_cam_bp + item*dx_horn_cam_bp, y_horn_cam_bp, z_printing] :
        [0, 0, dz_assembly];
    translate(translation) rotate(rotation) visualize(visualization_horn_cam) shape();   
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
        [dx_slide_plate,  base.y/2 + 4 + dy_pivot(a_horn_pivot), dz_linkage];
    translate(translation) rotate(rotation) visualize(visualization_moving_clamp_bracket) shape();       
}

module horn_linkage(a_horn_pivot, as_blank = false) {
    h = 4;
    pin_attachment = [2, 3, 8];
    barrel_attachment = [10, 3, 8];
    r_pin_attachment = r_horn_linkage - 4.5;
    r_barrel_attachment = r_horn_linkage + 4.;
    linkage = [15, 3, 8];

    module blank() {
        hull() {
            can(d=od_cam, h=h, center=ABOVE);
            translate([12, 0, 0]) can(d=7, h=h, center=ABOVE); 
        }

        hull() {
            can(d=od_cam, h=2, center=ABOVE);
            rotate([0, 0, az_horn_linkage_pivot])  translate([r_horn_linkage, 0, 0]) can(d=5, h=2, center=ABOVE);
        }
        rotate([0, 0, az_horn_linkage_pivot])  translate([r_pin_attachment, 0, 0])  block(pin_attachment, center=ABOVE);     

    }   
            
    module shape() {
        render(convexity=10) difference() {
            blank();
            translate([0, 0, 7])  rotate([180, 0, 0]) hull() one_arm_horn(as_clearance=true);
            can(d=2.2, h=a_lot);  // Central hole for screw!
        }
    }
    
    if (as_blank) {
        blank();
    } else {
    
        z_printing = 0;
        rotation = 
            mode == PRINTING ? [0,  0, a_horn_pivot] :
            [0, 0, a_horn_pivot - az_horn_linkage_pivot];
        translation = 
            mode == PRINTING ? [x_pusher_bp + dx_origin, y_pusher_bp, z_printing] :
            [dx_origin, 0, dz_linkage]; 
        translate(translation) rotate(rotation) {
            if (show_vitamins && mode != PRINTING) {
                visualize_vitamins(visualization_horn_linkage) 
                    translate([0, 0, -7.5])  one_arm_horn();
            }
            visualize(visualization_horn_linkage) shape();  
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
            translate([0, 0, h_limit_cam - dz_engagement]) scale(horn_linkage_cutout_scaling)  horn_linkage(as_blank=true);
            can(d=2.2, h=a_lot);  // Central hole for screw!
            can(d=8, taper=5, h=h_limit_cam-dz_engagement-1, center=ABOVE);
            translate([0, 0, h_limit_cam-dz_engagement-1]) can(d=5, taper=2.2, h=1, center=ABOVE);
        }        
    }    
    
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, a_horn_pivot];
    translation = 
        mode == PRINTING ? [x_limit_cam_bp, y_limit_cam_bp, z_printing] :
        [dx_origin, 0, dz_linkage - h_limit_cam + dz_engagement]; 
    translate(translation) rotate(rotation) {
        visualize(visualization_limit_cam) shape();  
    }
}


module linkage(a_horn_pivot) {
    angle_bearing_moving_clamp = -220; 
    l_strut_moving_clamp = 14;
    angle_bearing_horn_cam = -180;
    l_strut_horn_cam = 10;
    
    
    pivot_size = 1; 
    angle_pin_moving_clamp = -linkage_angle(a_horn_pivot);
    angle_pin_horn_cam = 90 + az_horn_linkage_pivot 
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
        [dx_linkage(a_horn_pivot), dy_linkage(a_horn_pivot), dz_linkage];  
    translate(translation) rotate(rotation) visualize(visualization_linkage)  shape();  
}


module filament_loader_clip(as_clearance=false) {
    blank = [7, 12, 20];
    base = [7, 14, 4];
    connector =  flute_clamp_connector();
    connector_extent = gtcc_extent(connector); 
    y_loose =  connector_extent.y + 0.5;
    y_tight = connector_extent.y - 1;
    y_spring = connector_extent.y - 3;
    x_loose = 3.5; 
    z_slit = 4;
    
    z_printing = blank.z;
    
    module shape() {
        render(convexity=10) difference() {
            union() {
                block(blank, center = ABOVE);
                hull() {
                    translate([base.x/2, 0, 0]) block([0.1, base.y, base.z], center = ABOVE);
                    translate([base.x/2, 0, 0]) block([0.1, blank.y, base.z+4], center = ABOVE);
                    translate([-base.x/2, 0, 0])  block([0.1, blank.y, base.z], center = ABOVE);
                }
            }
            // Spreader - slot is narrow then connector
            translate([0, 0, 5.0]) block([x_loose, y_tight, 8], center=ABOVE);
            // Wedging cut above clip
            hull() {
                translate([0, 0, 3]) rod(d=0.5, l=x_loose);
                translate([0, 0, 10]) block([x_loose, y_loose , 0.1], center=ABOVE);
            }                  
            // Clearance for arm
            translate([0, 0, 10])  {
                hull() {
                    block([x_loose, y_loose, 11.5], center=ABOVE);
                    translate([0, 1.5, 0]) block([0.1, y_loose, 11.5], center=ABOVE);
                }
                translate([0, 0, 0]) block([10, y_loose-1, 11.5], center=ABOVE+FRONT);
            }
            // Clearance for arm insertion    
            translate([-x_loose/2, 0, 10]) block([10, y_loose, 8.5], center=ABOVE+FRONT);
            // vertical slit through clamp
            block([10, 0.5, blank.z-z_slit], center=ABOVE);
            // Clamp for filament
            translate([0, 0, 4]) {
                rod(d=1.25, l=20);
                block([20, 1.25, 1.25/2], center=ABOVE);
            }
            // Cut below clip
            hull() {
                translate([0, 0, 0.75]) rod(d=0.5, l=a_lot);
                block([a_lot, 1.75, 0.1], center=BELOW);
            }
            // Cut near top to make back side flexible
            //translate([0, 0, blank.z - 2]) block([10, y_spring, 1]);
        }          
    }
    if (as_clearance) {  
        translate([filament_translation.x, dy_filament_loader_clip, filament_translation.z]) rotate([0, 0, -90])  {
            hull() {
                translate([0, -2, -4]) shape();
                translate([-0, +2, -4]) shape();
            }
            // Slit for filament to come in, plus remove unprintable overhand
            x = 10;
            hull() {
                rod(d=7, l=x, center= FRONT);
                translate([0, 0, 10]) block([x, 22, 0.1], center=ABOVE+FRONT);
            }
        }
    } else {
        rotation = 
            mode == PRINTING ? [180, 0, 0] :
            [0, 0, -90];
        translation = 
            mode == PRINTING ? [x_filament_loader_clip_bp, y_filament_loader_clip_bp, z_printing] :
            [filament_translation.x, 105, filament_translation.z-4];
        translate(translation) {
            rotate(rotation) {
                visualize(visualization_filament_loader_clip) {
                    shape() ;
                }
            }    
        }
    }
}

module filament_loader(as_holder = true, as_inlet_clip_clearance = false, show_bow = false, show_tip = true) {
    connector =  flute_clamp_connector();
    connector_extent = gtcc_extent(connector);
    dz_clip = -6;
    dx_clip = 4;
    clip = [4, a_lot, 4];
    module tip_blank() {
        block([10, connector_extent.y, 3], center=BELOW + BEHIND);
        translate([-4, 0, 0]) hull() {
            block([6, connector_extent.y, 3], center=BELOW + BEHIND);
            translate([0, -1.5, -1.5])  block([6, connector_extent.y, 0.1], center=BELOW + BEHIND);
        }
        translate([-6, 0, 0]) block([4, connector_extent.y, 20], center=BELOW+BEHIND);
    }

    module blank() {
        rotate([0, 90, 0]) {
            rotate([-90, 0, 0]) {
                if (show_bow) {
                    translate([0, 0, -2 * connector_extent.z-4]) flute_collet(is_filament_entrance=false);
                    translate([0, 0, -6]) block([4, connector_extent.y, 40], center=ABOVE);
                    translate([0, 0, 30]) block([8, connector_extent.y, 4], center=ABOVE+BEHIND);
                    translate([-8, 0, 30]) block([4, connector_extent.y, 76], center=ABOVE+BEHIND);
                }
                if (show_tip) {
                    translate([-2, 0, 106.5]) tip_blank();
                }
            }
        }        
    }
    
    module shape() {
        render(convexity=10) difference() {
            blank();
            rod(d=d_filament_with_clearance, l=a_lot, center=SIDEWISE + RIGHT);        
        }
    }
    
    if (as_inlet_clip_clearance) {
        translate([filament_translation.x, 0, filament_translation.z]) {
            scale([1.1, 1.1, 1.1]) block([connector_extent.y, 100, 4]);
        }
    } else if (as_holder) {
        z_printing = connector_extent.y/2;
        rotation = 
            mode == PRINTING ? [0,  -90, 0] :
            [0, 0, 0];
        translation = 
            mode == PRINTING ? [x_filament_loader_bp, y_filament_loader_bp, z_printing] :
            [filament_translation.x, 0, filament_translation.z];
        translate(translation) rotate(rotation) {
            visualize(visualization_filament_loader) shape();
        } 
    } else {
    }    
}





module rail_riders(left_right_centering = 0, y_guide = y_guide) {
    center_reflect([1, 0, 0]) translate([x_guide/2, 0, 0]) {
        hull() {
            block([1, y_guide, z_guide + s_guide_dovetail], center=ABOVE+BEHIND + left_right_centering);
            block([1+s_guide_dovetail, y_guide, z_guide], center=ABOVE+BEHIND + left_right_centering);   
        }
    }
}


module servo_screws(as_clearance = true, recess=false, upper_nutcatch_sidecut = false) {
    h_recess = recess ? 3.8 : 0;
    h = recess ? 10 : 0;
    
    screw_length = recess ? 12 : 20;
    screw_name = str("M2x", screw_length);
    if (as_clearance) {
        dz = recess ? h-h_recess : 25;
        translate([8.5, 0, dz]) hole_through("M2", cld=0.4, h = h, $fn=12);
        translate([-19.5, 0, dz]) hole_through("M2", cld=0.4, h = h, $fn=12);
        if (upper_nutcatch_sidecut) {
            translate([-19.5, 0, -16]) {
                rotate([0, 0, 180]) 
                    nutcatch_sidecut(
                        name   = "M2",  // name of screw family (i.e. M3, M4, ...) 
                        l      = 50.0,  // length of slot
                        clk    =  0.0,  // key width clearance
                        clh    =  0.0,  // height clearance
                        clsl   =  0.1);  // slot width clearance
            }
        }
    } else {
        dz = recess ? - h_recess : 2;
        color(BLACK_IRON) {
            translate([8.5, 0, dz]) screw(screw_name, $fn=12);
             translate([-19.5, 0, dz]) screw(screw_name, $fn=12);
        }
    }    
}


module 9g_servo(as_clearance=false) {
    module cavity() {
        translate([0, 0, dz_servo]) 9g_motor_sprocket_at_origin();
        servo_screws(as_clearance = true, recess=true);      
    }

    if (as_clearance) {
        cavity();
    } else {
         translate([0, 0, dz_servo]) color(MIUZEIU_SERVO_BLUE) 9g_motor_sprocket_at_origin();
    }
}



module slider(a_horn_pivot) {
    
    module blank() {
        x = 2 * x_slider_rim + 9g_servo_body_width - 2 * slider_clearance;  
        y = 2 * y_slide_plate_rim + 9g_servo_body_length;
        z = z_slide_plate;    
        hull() {
            block([x, y, z_slide_plate]);
            block([x + z_slide_plate, y, 0.01]);
        }
    }
    
    module moving_clamp_slot() {
        block([9g_servo_body_width, 9g_servo_body_length, a_lot]);
    }
     
    module shape() {
        render(convexity=10) 
                difference() {
                blank();
                moving_clamp_slot();     
            }        
    }
    
    module vitamins() {
        translate([0, 5.5, 9.3]) {
            rotate([0, 0, 90]) {
                color(MIUZEIU_SERVO_BLUE) 
                    9g_motor_sprocket_at_origin();
                one_arm_horn(servo_angle=servo_angle_moving_clamp, servo_offset_angle=servo_offset_angle_moving_clamp);
                horn_cam(servo_angle=servo_angle_moving_clamp, servo_offset_angle = servo_offset_angle_moving_clamp);
            }     
        }
    }
    

        
        
    z_printing = z_slide_plate/2;
    rotation = 
        mode == PRINTING ? [180,  0, 0] : 
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_slider_bp, y_slider_bp, z_printing] :
        [dx_slide_plate, 18  + dy_pivot(a_horn_pivot), dz_slide_plate];
    translate(translation) rotate(rotation) {
        visualize_vitamins(visualization_slider) vitamins();
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
        mode == PRINTING ? [x_slide_plate_bp, y_slide_plate_bp, z_printing] :  [dx_slide_plate, dy_slide_plate, 0];
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
        horn_cam(servo_angle=servo_angle_fixed_clamp);
    }
}

module pusher() {
    
    translate([0, y_pusher_assembly, 0]) {
        translate([0, dy_pusher_servo, 0]) 
            horn_linkage(a_horn_pivot=a_horn_pivot); 
        translate([0, dy_pusher_servo, 0]) 
            linkage(a_horn_pivot=a_horn_pivot); 
        translate([0, dy_pusher_servo, 0]) 
            limit_cam(a_horn_pivot=a_horn_pivot);        
    }
    moving_clamp_bracket(a_horn_pivot=a_horn_pivot);
     
}


module slide() {
    // The slide is a new assembly that integrates the rails, pusher body, fixed clamp
    // body and the moving clamp body.  By integrating these parts,
    // less material will be used and assembly will be simplified. 
    
    // It will have two or three separate parts, but it is expected that they will be printed in-place 
    // so there will be no separate assembly - just inserting the servos
   
    slide_plate();

    slider(a_horn_pivot);
    position_sensor(show_vitamins=show_vitamins);
}

module visualize_assemblies() {
    if (show_filament) {
        filament();
    }
    slide();
    pusher();
    moving_clamp();
    fixed_clamp();
     filament_loader(as_holder = true, show_bow = true, show_tip = true);
     filament_loader_clip();
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
    if (print_moving_clamp_horn_cam) {
        horn_cam(item=0); 
    }
    if (print_fixed_clamp_horn_cam) {
        horn_cam(item=1);   
    }
    if (print_pusher) {
        a_horn_pivot = 50;
        horn_linkage(a_horn_pivot);
        linkage(a_horn_pivot=a_horn_pivot);
        moving_clamp_bracket(a_horn_pivot=a_horn_pivot); 
        limit_cam(a_horn_pivot=a_horn_pivot);
    }
    if (print_filament_loader) {
        filament_loader(as_holder = true, show_bow = true, show_tip = true);
        filament_loader_clip();
    }
 }
 


if (mode ==  ASSEMBLE_SUBCOMPONENTS) { 
    visualize_assemblies();
} else if (mode ==  PRINTING) {
    print_assemblies();
}
