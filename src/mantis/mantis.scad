/* 
The Mantis filament actuator is narrower and has less non-functional
material.  It is designed for easier assembly, with a integral pivots on the linkages 

Vitamins:

Qty     Item                                             Specification
  3           Servos with single arm horns          9g servos                               
  1           Optical reflective IR sensor              TCTR5000
  1           IR LED resistor                                 33Ω
  1           Sensor pulldown resistor                  8.2KΩ  
  4           Position sensor connection screws  M2x8  
  6           Servo mounting screws                    M2x10
  10         Nuts                                                  M2  
  3           Dupont jumpers                                 20 cm

Order of Assembly:
1.  Insert TCTR5000, resistors , and Dupont leads to holder body.
2.  Insert M2x8 screws and nuts into holder body and tighten. 
3.  Trim off any exposed leads.
4.  Snap mounted TCTR5000 sensor to slider plate. 
5.  Insert moving clamp servo and attach the filament guide using M2x10 screws and nuts.
6.  Insert pusher servo and the filament guide using M2x10 screws and nuts.
7.  Insert fixed clamp servo and the filament guide using M2x10 screws and nuts.
8.  Attach servo leads to the electronics junction box. 
9.  Attach position sensor lead to the electronics junction box.
10.  Position servos in installation positions using the Octoprint plugin. 
11.  Install the clamp cams in the installation positions.  
12.  Fine tune the starting and ending ranges for the servo using settings page of the Octoprint plugin.
13.  Test actuator using the plugin to load and unload filament. 



TODO:

1.  Implement alternative limit detection using photodetector. 
2.  Add Wire guides to keep servo and limit switch wires from being fouled with 
     the moving parts.  
3. Fixed clam servo and cam is not located properly. 
4.  Remove code for roller switch position sensing once photodetection is proven out. 
*/


include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>


use <ScadApotheka/9g_servo.scad>
use <ScadApotheka/roller_limit_switch.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>
use <ScadApotheka/ptfe_filament_tubing_connector.scad>
use <ScadApotheka/audrey_horizontal_pivot.scad>
include <ScadApotheka/audrey_horizontal_pivot_constants.scad>
use  <ScadApotheka/tcrt5000_mount.scad>



    
    * tcrt5000_reflective_optical_sensor_holder(
        show_body = show_vitamins,
        show_rails = true,
        orient_for_printing = false,
        orient_for_mounting = FRONT, 
        show_vitamins = true);


// Constants are calculations so they don't show up in the customization.    

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

// Development note:  Indent customization variables, so that sections can be spotted easily. 
// Development note:  Comments before values only show in the customization panel
//                                 if they start in the first column, so they can't be indented.

/* [Servo Characteristics] */
// Adjust so that servos fits into slide plate openings!
    9g_servo_body_length = 23; // [22.5, 23.0, 23.5, 24]
// Adjust so that servos fits into slide plate openings!
    9g_servo_body_width = 12.0; // [12.0, 12.2, 12.4]
// Adjust so that servo shows as middle of slot.
    9g_servo_offset_origin_to_edge = 6;
// Adjust so that servo shows as resting on pedistal
    9g_servo_vertical_offset_origin_to_flange = 14.5;
    9g_servo_mounting_flange_thickness = 2.4;


/* [One Arm Horn Characteristics] */
    dz_engagement_one_arm_horn = -1;// 1;
    h_barrel_one_arm_horn = 3.77;
    d_barrel_one_arm_horn = 7.5;
    h_arm_one_arm_horn = 1.3;    
    dx_one_arm_horn = 14;
// The height from the horn arm to the top of the cam
    z_servo_body_to_horn_barrel = 5.3; // [0: 0.1: 10]


/* [Show Parts and Features] */
    show_vitamins = true;
    show_filament = true;
    show_parts = true && true; // But nothing here has parts yet.
    use_limit_switch_position_sensor = false;
    use_optical_position_sensor = true;

// Order alphabetically!
    clamp_cam = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
    filament_guide = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
// Working on using IR position sensor, so by default limit_cam is invisible.     
    limit_cam =  0; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
    moving_clamp_bracket = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
    pusher_coupler_link = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
    pusher_driver_link = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
    servo_mounting_nut_wrench = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
    slide_plate = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
    slider  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

/* [Printing Control] */
    print_all_parts = false;
    print_one_part = false;

    // Update options for part_to_print with each defined variable in the following Show section!
    // Options can not be broken over multiple lines, they must only wrap!
    one_part_to_print = "slide_plate"; // [clip, collet, clamp_cam, filament_guide, pusher_coupler_link, pusher_driver_link, servo_mounting_nut_wrench, slide_plate, slider]

    mode = print_one_part ? PRINTING: 
        print_all_parts ? PRINTING:
        ASSEMBLE_SUBCOMPONENTS;

    print_slide = true;
    print_moving_clamp_cam = true;
    print_fixed_clamp_cam = true;
    print_pusher = true;
    print_pusher_filament_guide = true;
    print_servo_mounting_nut_wrench = true;

/* [Legend] */
    show_legend = true;
    x_legend = 36; // [-200 : 200]
    y_legend = 50; // [-200 : 200]
    z_legend = -30; // [-200 : 200]
    legend_position = [x_legend, y_legend, z_legend];

/* [Pusher Animation] */
    servo_angle_pusher  = 0; // [0:180]
    servo_offset_angle_pusher  = 250; // [0:360]

/* [Animation ] */
    servo_angle_moving_clamp = 0; // [0:180]
    servo_offset_angle_moving_clamp = 90; // [0:360]
    servo_angle_fixed_clamp = 0; // [0:180]
    servo_offset_angle_fixed_clamp = 0; // [0:360]

/* [Roller Position Sensor Animation ] */
    roller_switch_depressed = true;
    roller_arm_length = 20; // [18:Short, 20:Long]
    limit_switch_is_depressed = true;

/* [Clamp Cam Design] */
    d_bottom_for_clamp_cam = 16;
    d_top_for_clamp_cam = 16;
// Adjust so just a bit of flat exists based on z_clearance_clamp_cam.
    slice_angle_for_clamp_cam = 0; // [0: 0.1: 10]
// Sets how much vertial range that the cam surface varies by.  Adjust so there is roof above horn cavity
    dz_range = 2.0;
// Moves the entire cam surface up or down
    dz_slice_for_clamp_cam = 0.2;  // [-10: 0.1: 10]
// Adjust so horn is below thickest part of cam.
    az_slice_to_horn_for_clamp_cam = -80; // [-180:180]
// Adjust to clear housing
    z_clearance_clamp_cam = 0.7; 
// Set to control stiffness of cam to horn attachment
    z_screw_head_to_horn = 2; //[1:0.5:2.5]
// Adjust so that arm can slide into place
    dz_horn_arm_clearance_for_clamp_cam = 0.4;


/* [Servo Filament Guide Design] */
    d_filament_entrance = 4;
    l_filament_entrance = 8; // [0:12]
    dy_filament_entrance_offset = -9; //[-20:0]
    z_filament_guide_base =  4; 
    filament_guide_mounting_screw = "M2x12";



/* [Slide Plate Design] */
// Lateral offset between CL of filament to CL of clamp servos
    dx_slide_plate = 4.7; // [-10:0.1:10]
// Offset of the mid point of the slide plate from the mid point of the slide plate, in the direction that the slide moves.
    dy_slide_plate = 0; //[-20:0.1:20]
// Offset of the slide plate vertically from the CL of the filament.  
    dz_slide_plate = -7.; //[-20:0.1:20]
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
// Offset pusher servo to avoid filament
    dx_pusher_servo_offset = 4.7;
// Offset sensor so it doesn't interfer with pusher coupler link   
    dy_optical_sensor_holder = 19;

    dy_servo_offset_for_slide_plate = y_slide/2 + y_slide_plate_rim + 9g_servo_body_length/2;


/* [Slider Design] */
// Lateral clearance between slider and guide.  Needs to big enough that the parts print separately.  Small enough relative to thickness of plate so that slider doesn't fall out or move too much vertically.
    slider_clearance = 0.6;
// Lateral rim around servos inserted into slider
    x_slider_rim = 2;
// The offset between the linkage centerline and the centerline of servo
    dy_moving_clamp_offset = 18;



/* [Pusher Linkage Design] */
// Adjust so that linkage lines up with shaft pusher servo.  
    dz_linkage = -20; // [-22:0.1:-18]
    debug_kinematics = false; 
    r_drive_link = 18;
    coupler_link_length = 28;
  // TODO:  Calculate y_pusher_assembly from plate dimensions
    y_pusher_assembly = -42;
    dy_pusher_servo = 2;// 2;
    dx_slider_pivot_offset = 20; // [-6:0.1:20]


/* [Pusher Driver Link Design] */
// Adjust for engagement with servo horn and attachment with pivot.
    r_pusher_driver_link = 15; // [10: 0.1: 20]
// Adjust so the bearing attachment doesn't interfer with insertion of horn.  Also, not interferring with roller switch.
    az_drive_link_pivot = 40; // 40;
    attach_driver_link_pivot_to_horn = true;



/* [Pusher Coupler Link Design] */
    angle_moving_clamp_fixed = 105; // [0:180]
    dl_strut_moving_clamp = 0; // [0:0.1:5]
    angle_horn_cam_fixed = -120; // [-180:180]

    dl_strut_driver = 0; // [0:0.1:5]
    h_pivot = 11; //[10:0.25:15]
    d_pivot_axle = 6; // [1:0.25:8]
    moving_clamp_rim = 3; 
    dy_moving_clamp_bracket_offset = 5;
    az_attachment_to_moving_clamp = 75; // [70:110]
// Adjust these two variable so the attachment doesn't intefere with insertion of horn
    dz_bearing_attachment_for_driver_pivot = 1.6; // [0:0.1:3]
    da_driver_horn_to_linkage  = 135; // [0: 360]

/* [Moving Clamp Bracket Design] */
    z_moving_clamp_bracket = 6;  // [0:10]



/* [Limit Cam Design] */
// Sets where forward position of the moving clamp triggers limit switch
    az_limit_cam_front = 200; // [0:360]
// Sets where backward position of the moving clamp triggers limit switch
    az_limit_cam_back = 290; // [250: 300]
// Adjust so bumper flat is centered on roller
    d_limit_cam = 15;
// Adjusts so that bumper catches the roller and starts to depress
    h_limit_cam = 7;
// Adjust so bumper clears linkage near bracket
    h_limit_cam_bumper = 4;
// Sets the flat spot for the limit switch on top of the bumper
    d_limit_cam_bumper = 10;
// Adjust so bumper is on top of limit switch roller 
    dr_limit_cam_bumper = 15;


/* [Optical Position Sensor Design] */
// Must be large enough so that far wall doesn't interfere
    x_pattern = 10;
// Must match range of motion
    y_pattern = 26;
    z_pattern = 2;
// Adjust to align pattern over sensor, without interference
    dx_pattern = 3.5;
// Adjust to make it possible to check limits 
    dy_pattern = 17;
    dz_pattern = 9;

/* [Build Plate Layout] */

    x_slide_plate_bp = 40;
    y_slide_plate_bp = 0;

    x_slider_bp = x_slide_plate_bp;
    y_slider_bp = 0;

    x_servo_filament_guide_bp = 80;
    y_servo_filament_guide_bp = 40;
    dy_servo_filament_guide_bp = -40;

    x_clamp_cam_bp = 115;
    y_clamp_cam_bp = 65;
    dy_clamp_cam_bp = -50;

    x_pusher_bp = 110;
    y_pusher_bp = -20;

    x_limit_cam_bp = 150;
    y_limit_cam_bp = 0;

    x_servo_mounting_nut_wrench_bp = 150;
    y_servo_mounting_nut_wrench_bp = 40;


module end_of_customization() {}



/* Linkage Kinematicts  Calculations*/

    dx_origin = dx_slide_plate + dx_pusher_servo_offset;
    dy_origin = -40;  // TODO Calculate from frame size?
    dx_slider_pivot = dx_slide_plate + dx_slider_pivot_offset;

    dx_horn_pivot = function(a_horn_pivot) dx_origin + cos(a_horn_pivot) * r_drive_link;
    dy_horn_pivot = function(a_horn_pivot) dy_origin + sin(a_horn_pivot) * r_drive_link; 

    dx_coupler_link = function(a_horn_pivot) dx_slider_pivot - dx_horn_pivot(a_horn_pivot);
    coupler_link_angle = function(a_horn_pivot) acos(dx_coupler_link(a_horn_pivot) /coupler_link_length); 

    dx_pivot = function(a_horn_pivot) 
        dx_horn_pivot(a_horn_pivot) 
        + cos(coupler_link_angle(a_horn_pivot)) * coupler_link_length;
    dy_pivot = function(a_horn_pivot) 
        dy_horn_pivot(a_horn_pivot)  + sin(coupler_link_angle(a_horn_pivot)) * coupler_link_length; 

    dx_linkage_midpoint = function(a_horn_pivot) 
        (dx_pivot(a_horn_pivot) + dx_horn_pivot(a_horn_pivot))/2;
    dy_linkage_midpoint = function(a_horn_pivot) 
        (dy_pivot(a_horn_pivot) + dy_horn_pivot(a_horn_pivot))/2;

    // But translation is applied after rotation, so dy must be adjusted;
    dx_linkage = function(a_horn_pivot) 
        dx_linkage_midpoint(a_horn_pivot);
    dy_linkage = function(a_horn_pivot) 
        dy_horn_pivot(a_horn_pivot)  - dy_origin + sin(coupler_link_angle(a_horn_pivot)) * coupler_link_length/2;
     y_moving_clamp = function(a_horn_pivot) dy_pivot(a_horn_pivot) + y_pusher_assembly;


    a_horn_pivot = servo_angle_pusher + servo_offset_angle_pusher + az_drive_link_pivot;
    dy_moving_clamp =  dy_moving_clamp_offset  + dy_pivot(a_horn_pivot);

    if (debug_kinematics && mode != PRINTING) {
        translate([dx_origin, dy_origin, 0]) color("yellow") can(d=1, h=a_lot);
        a_horn_pivot = servo_angle_pusher + servo_offset_angle_pusher + az_drive_link_pivot;
        translate([dx_horn_pivot(a_horn_pivot), dy_horn_pivot(a_horn_pivot), 0]) color("blue") can(d=1, h=a_lot);
        echo("dx_coupler_link", dx_coupler_link(a_horn_pivot));
        echo("coupler_link_angle", coupler_link_angle(a_horn_pivot));
        translate([dx_pivot(a_horn_pivot), dy_pivot(a_horn_pivot), 0]) color("green") can(d=1, h=a_lot);
        translate([dx_linkage_midpoint(a_horn_pivot), dy_linkage_midpoint(a_horn_pivot), 0]) color("brown") can(d=1, h=a_lot);
    }


function layout_from_mode(mode) = 
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";

layout = layout_from_mode(mode);
echo("layout", layout);

echo("show(moving_clamp_bracket, \"moving_clamp_bracket\")",  show(moving_clamp_bracket, "moving_clamp_bracket"));

function show(variable, name) = 
    (print_one_part && (mode == PRINTING)) ? name == one_part_to_print :
    variable;

visualization_clamp_cam = 
    visualize_info(
        "Clamp Cam", PART_1, show(clamp_cam, "clamp_cam") , layout, show_parts); 

visualization_limit_cam  =
    visualize_info(
        "Limit Cam", PART_2, show(limit_cam, "limit_cam") , layout, show_parts);  
  
visualization_moving_clamp_bracket  =
    visualize_info(
        "Moving Clamp Bracket", PART_7, show(moving_clamp_bracket, "moving_clamp_bracket") , layout, show_parts);  
        
visualization_pusher_driver_link  =        
    visualize_info(
        "Pusher Driver Link", PART_8, show(pusher_driver_link, "pusher_driver_link") , layout, show_parts);   
     
visualization_pusher_coupler_link  =        
    visualize_info(
        "Pusher Coupler Link", PART_9, show(pusher_coupler_link, "pusher_coupler_link") , layout, show_parts);          
        
visualization_filament_guide = 
    visualize_info(
        "Filament Guide", PART_11, show(filament_guide, "filament_guide") , layout, show_parts);       
        
visualization_servo_mounting_nut_wrench = 
    visualize_info(
        "Servo Mounting Nut Wrench", PART_17, show(servo_mounting_nut_wrench, "servo_mounting_nut_wrench") , layout, show_parts);   
        
visualization_slide_plate = 
     visualize_info(
        "Slide Plate", PART_18, show(slide_plate, "slide_plate") , layout, show_parts);   
            
visualization_slider = 
     visualize_info(
        "Slider", PART_20, show(slider, "slider") , layout, show_parts);               
    
// Order alphabetically.  This is the order used in the legend.     
visualization_infos = [
    visualization_clamp_cam,
    visualization_filament_guide,
    visualization_limit_cam,
    visualization_moving_clamp_bracket,
    visualization_pusher_coupler_link,
    visualization_pusher_driver_link,    
    visualization_servo_mounting_nut_wrench,
    visualization_slider,
    visualization_slide_plate,
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

// TODO: Move to ScadApotheka
module servo_mounting_screws(as_clearance = false, dz_nut = -6, dz_screw_head= 6) {
    
    center_reflect([0, 1, 0]) translate([0, 9g_servo_body_length/2 + y_slide_plate_rim/2, 0]) { 
        if (as_clearance) {
            translate([0, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
            h_screw_head = 10;
            translate([0, 0, h_screw_head + dz_screw_head]) 
                hole_through("M2", cld=0.6, $fn=12, h=h_screw_head);  
            translate([0, 0, dz_nut])
                nutcatch_parallel(
                    name   = "M2",  // name of screw family (i.e. M3, M4, ...)
                    clk    =  0.3, // clearance aditional to nominal key width 
                    clh    =  10  // nut height clearance
                );                 
        } else {
            translate([0, 0, dz_screw_head])  
                color(STAINLESS_STEEL) 
                    screw(filament_guide_mounting_screw, $fn=12);
            translate([0, 0, dz_nut])   color(BLACK_IRON) nut("M2", $fn=12);
        }
    }
}


// Parts



module clamp_cam(item=0, servo_angle=0, servo_offset_angle=0, clearance=0.5) {
    h = z_servo_body_to_horn_barrel 
        + h_barrel_one_arm_horn 
        + z_screw_head_to_horn 
        - z_filament_guide_base
        - z_clearance_clamp_cam;
    dz_assembly = dz_slide_plate + z_slide_plate/2 + z_filament_guide_base + z_clearance_clamp_cam; 
    
    
    module cam_cutter() {
         // Provide the camming surface to force the filament down to lock it
        segment_count = 10;
        az_range =330;
        
        delta_az = az_range / segment_count;
        delta_z_slice_segment = dz_range / segment_count;
        rotate([0, 0, az_slice_to_horn_for_clamp_cam]) {
            for (i = [0:1:segment_count-1]) {
                rotate([0, 0, delta_az*i]) {
                    translate([0, 0, dz_slice_for_clamp_cam + i * delta_z_slice_segment]) {
                        hull() {
                            rotate([0, slice_angle_for_clamp_cam, 0]) 
                                block([0.1, 20, 20], center = BELOW + RIGHT + FRONT); 
                            rotate([0, slice_angle_for_clamp_cam, delta_az/2]) 
                                block([0.1, 20, 20], center = BELOW + RIGHT + FRONT); 
                            rotate([0, slice_angle_for_clamp_cam,  + delta_az]) 
                                block([0.1, 20, 20], center = BELOW + RIGHT + FRONT); 
                        }
                    }
                }
            } 
        }       
    }
    
    module horn_cavity() {
        az_horn_engagement = -35;
        ay_horn_insertion = -6;
        dz_horn = 
            - dz_engagement_one_arm_horn 
            + h_barrel_one_arm_horn 
            - h_arm_one_arm_horn
            - z_screw_head_to_horn;
        // Final position
        translate([0, 0, dz_horn])  one_arm_horn(as_clearance=true);
        translate([0, 0, dz_horn + dz_horn_arm_clearance_for_clamp_cam])  
            one_arm_horn(as_clearance=true, show_barrel = false);
        
        translate([0, 0, dz_horn]) {
            rotate([0, 0, az_horn_engagement])  { 
               //slot to insert arm, and then rotate it.
               hull() {
                    one_arm_horn(as_clearance=true, show_barrel = false);
                    translate([0, 0, 0.5]) rotate([0, ay_horn_insertion, 0]) 
                        one_arm_horn(as_clearance=true, show_barrel = false);
               }
               // This feature allows the barrel of the horn to be inserted:
               translate([1, 0, 0.5]) rotate([0, ay_horn_insertion, 0]) one_arm_horn(as_clearance=true);
               translate([-1, 0, 0.5]) rotate([0, ay_horn_insertion, 0]) one_arm_horn(as_clearance=true);
            }
        }
        // Slot to rotate and lock 
        hull() {
            rotate([0, 0, az_horn_engagement]) {
                translate([0, 0, dz_horn]) one_arm_horn(as_clearance=true, show_arm=false);              
                translate([0, 0, -dz_horn]) one_arm_horn(as_clearance=true, show_arm=false);
            } 
        }       
    }
 
    module shape() {
        d_lock = 0.1;
        ax_clamp_slice = 20;
        render(convexity=10) difference() {
            can(d=d_bottom_for_clamp_cam, taper=d_top_for_clamp_cam, h=h, center=ABOVE);
            // Screw used to attach horn
            can(d=2.5, h=a_lot); //Screw 
            horn_cavity();
            cam_cutter();
        }
    }
    
    z_printing = h;
    rotation = 
        mode == PRINTING ? [180, 0, 0] :
        [0, 0, 90 + servo_angle + servo_offset_angle];
    translation = 
        mode == PRINTING ? [x_clamp_cam_bp, y_clamp_cam_bp + item*dy_clamp_cam_bp, z_printing] :
        [0, 0, dz_assembly];
    translate(translation) rotate(rotation) visualize(visualization_clamp_cam) shape();   
}


module filament_guide(moving_clamp = false, fixed_clamp = false, pusher_guide=false, item = 0) {
    
    use_cam = moving_clamp || fixed_clamp;
    use_filament_entrance = use_cam;
    ay_mounting_screws = use_cam ? 0 : 180;
    
    x = 2 * x_slider_rim + 9g_servo_body_width;  
    y = 2 * y_slide_plate_rim + 9g_servo_body_length;
    // The core provides the body into which the servo will be inserted.
    core = [x, y, z_filament_guide_base];
    servo_slot = 1.02* [9g_servo_body_width, 9g_servo_body_length, a_lot];
    z_to_filament = -dz_slide_plate - z_slide_plate/2;
    z_above_filament_cl = use_filament_entrance ? 4 : 2;
    z_guide =  z_to_filament + z_above_filament_cl;
    x_guide = use_filament_entrance ? 6 : 5;
    guide = [x_guide, y, z_guide];
    cam_backer = [d_bottom_for_clamp_cam/2 + 2, d_bottom_for_clamp_cam, z_guide];

    dy_cam_offset = 5.5;
    dx_core_offset = pusher_guide ? dx_pusher_servo_offset : 0;
    
    dz_screw_head = 
        moving_clamp ?  2 :
        fixed_clamp ? 2 :
        pusher_guide? 9g_servo_mounting_flange_thickness + z_slide_plate:
        0;
    dz_nut = 
        moving_clamp ? -(9g_servo_mounting_flange_thickness + z_slide_plate):
        fixed_clamp ?  -(9g_servo_mounting_flange_thickness + z_slide_plate) :
        pusher_guide ? -2 :
        0;
    
    module collet_blank(is_exit=true) {
        connector =  flute_clamp_connector();
        connector_extent = gtcc_extent(connector);
        dz_collet = z_to_filament; 
        dy_collet = 32;
        dy_mid_support =23;
        az = is_exit ? 0 : 180;
        translate ([-dx_slide_plate,0, 0]) {
            rotate([0, 0, az]) {
                translate ([0, dy_collet, dz_collet]) {// z_guide]) {
                    rotate([90, 0, 0]) flute_collet(is_filament_entrance=false);
                }
                // Printing support:
                translate ([0, dy_collet, 0]) {
                    block([connector_extent.x, 2, 2], center=ABOVE);
                    block([4, 2 * connector_extent.z, 0.4], center=ABOVE + LEFT);
                }
                translate ([0, dy_collet - connector_extent.z, 0]) {
                    block([connector_extent.x, connector_extent.z + 3, 2], center=ABOVE+LEFT);
                }
            }
        }
    }
    
    module ir_pattern() {   
    // Add the pattern for the position sensor
    translate([dx_core_offset + core.x/2, 0, 0])  {
        // Attach pattern to guide, without interfering with guide movement
        hull() {
            block([2,  core.y/2, 2], center = BEHIND+RIGHT+ABOVE);
            translate([dx_pattern, 5, dz_pattern]) 
                block([2,  core.y/2, z_pattern], center = FRONT+RIGHT+ABOVE);
        }
        translate([dx_pattern, dy_pattern, dz_pattern]) 
            block([x_pattern, y_pattern, z_pattern], center = FRONT+ABOVE);
        // Close wall - breakaway, to not interfer with slide
        translate([dx_pattern, core.y/2 + 6, 0]) 
            block([0.6, y_pattern - core.y/2,  abs(dz_pattern) + z_pattern], center = FRONT + RIGHT + ABOVE);
        // Far wall - other side of sensor - support for bridging, breakaway
        translate([dx_pattern + x_pattern, dy_pattern, 0]) 
            block([0.6, y_pattern,  abs(dz_pattern) + z_pattern], center = BEHIND + ABOVE); 
        // Add mouse ears, to try to hold down thin walls
        translate([dx_pattern + x_pattern/2, dy_pattern, 0]) 
            center_reflect([1, 0, 0]) center_reflect([0, 1, 0]) 
                translate([x_pattern/2 + 1, y_pattern/2+1, 0]) can(d=5, h= 0.2, center=ABOVE); 
        }        
    }
   
    module blank() {    
        translate([dx_core_offset, 0, 0]) block(core, center = ABOVE);
        translate([-dx_slide_plate, 0, 0]) block(guide, center = ABOVE);
        if (use_cam)  {
            // Chamfer, to not interfer with sliding
            hull() {
                translate([0, dy_cam_offset, cam_backer.z]) 
                    block([cam_backer.x, cam_backer.y, 4], center = BEHIND + BELOW);  
                translate([0, dy_cam_offset, 0]) 
                    block([cam_backer.x-3, cam_backer.y, 0.1] , center = ABOVE + BEHIND);
            } 
        }
        if (fixed_clamp) {
            collet_blank(is_exit=true);
       } if (pusher_guide) {
           collet_blank(is_exit=false);
       }
       if (moving_clamp && use_optical_position_sensor) {
            ir_pattern();
       }
   } 

  
    module cam_cavity() {
        d_cam_clearance = d_bottom_for_clamp_cam;
        dz_horn_clearance = z_guide - 2; 
        // When using the optical position sensor, you must trim servo horn!
        d_horn_clearance = use_optical_position_sensor ? 20 : 34;
        translate([0, dy_cam_offset, z_filament_guide_base]) can(d=d_cam_clearance, h=10, center=ABOVE);
        translate([0, dy_cam_offset, dz_horn_clearance]) can(d=d_horn_clearance, h=10, center=ABOVE);  
    }  
    
    module filament_entrance_cavity() {
        translate([0, dy_filament_entrance_offset, 0]) 
            rod(d=d_filament_entrance, taper=d_filament, l=l_filament_entrance, center=SIDEWISE+LEFT);  
    }
    
    module gear_housing_cavity() {
        d_large_gear_clearance = 13;
        d_small_gear_clearance = 8;

        translate([0, dy_cam_offset, 0]) can(d=d_large_gear_clearance, h=a_lot);
        translate([0, -2, 0]) can(d=d_small_gear_clearance, h=a_lot);
    }
    
    
    module shape() {
        difference() {
            blank();
            if (use_cam) {
                gear_housing_cavity();
                cam_cavity();
                translate([dx_core_offset, 0, 0]) 
                    servo_mounting_screws(as_clearance = true, dz_nut = dz_nut, dz_screw_head= dz_screw_head);
            } 
            if (pusher_guide) {
                translate([dx_core_offset, 0, 0]) {
                    pusher_servo_cavity();
                    // Servo screws are inserted from bottom
                    rotate([0, ay_mounting_screws, 0]) 
                        servo_mounting_screws(as_clearance=true, dz_nut = dz_nut, dz_screw_head= dz_screw_head); 
                }
            }        
            translate([-dx_slide_plate, 0, -dz_slide_plate-z_slide_plate/2]) {
                filament(as_clearance = true, clearance_is_tight = false);
                if (use_filament_entrance) {
                    filament_entrance_cavity();
                }
            }   
        }
    }
    
    z_printing = 0;
    rotation = mode == PRINTING ? [0,  0, 0] : [0, 0, 0];
    translation = mode == PRINTING ? 
        [x_servo_filament_guide_bp, y_servo_filament_guide_bp  + item*dy_servo_filament_guide_bp, z_printing]:
        [0, 0,  z_slide_plate/2 + dz_slide_plate];
    
    translate(translation) rotate(rotation) {
        if (mode != PRINTING) {
            visualize_vitamins(visualization_filament_guide) {
                translate([dx_core_offset, 0, 0]) 
                    rotate([0, ay_mounting_screws, 0]) 
                        servo_mounting_screws(dz_nut = dz_nut, dz_screw_head= dz_screw_head);             
            }
        }
        visualize(visualization_filament_guide) shape();
    }  
    
}


module moving_clamp_bracket(a_horn_pivot) {
           
    base = [
        2 * moving_clamp_rim + 9g_servo_body_width,
        2 * moving_clamp_rim + 9g_servo_body_length,
        z_moving_clamp_bracket
    ]; 
    servo_wire_clearance = [ 6, 20, 12]; 
    slot = 1.02* [9g_servo_body_width, 9g_servo_body_length, a_lot];
    d_mouse_ear = 2* moving_clamp_rim * sqrt(2);
    h_mouse_ear = 0.2;
    module blank() {
        block(base, center=ABOVE);
        center_reflect([1, 0, 0]) center_reflect([0, 1, 0]) translate([base.x/2, base.y/2, 0]) can(d=d_mouse_ear, h=h_mouse_ear, center=ABOVE);
    }
    module shape() {    
        render(convexity=10) difference() {
            blank();
            block(slot);
            translate([0, 0, 2]) block(servo_wire_clearance, center=RIGHT+ABOVE);
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0, 0, 0] :
        [0, 0, 0];
    dy = 9g_servo_body_length/2 + moving_clamp_rim/2 + dy_pivot(a_horn_pivot) + dy_moving_clamp_bracket_offset;
    translation = 
        mode == PRINTING ? 
        [x_pusher_bp + dx_slide_plate, y_pusher_bp + dy, z_printing] :
        [dx_slide_plate,  dy, dz_slide_plate + dz_linkage];
    translate(translation) rotate(rotation) visualize(visualization_moving_clamp_bracket) shape();       
}

module pusher_driver_link(a_horn_pivot, as_blank = false) {
    h = 4;
    z_base = 2;
    dz_horn = dz_engagement_one_arm_horn + h_barrel_one_arm_horn + z_base;

    d_center = d_barrel_one_arm_horn + 4;
    radius_of_bearing = ahpb_r_bearing(h_pivot, d_pivot_axle);
    d_horn_pivot_end = 5;
    // Clear the bearing, then the space for building up to attachment, then pad used to shape the link
    dr_horn_clearance = radius_of_bearing + 0.2*h_pivot + d_horn_pivot_end/2;
    

    module blank() {
        // Create a blank for inserting the servo horn
        hull() {
            can(d=d_center, h=h, center=ABOVE);
            translate([r_pusher_driver_link, 0, 0]) can(d=7, h=h, center=ABOVE); 
        }
        // Create a blank to which the pivot can be attached
        if (!attach_driver_link_pivot_to_horn) {
            hull() {
                can(d=d_center, h=2, center=ABOVE);
                rotate([0, 0, az_drive_link_pivot])  
                    translate([r_drive_link - dr_horn_clearance, 0, 0]) 
                        can(d=d_horn_pivot_end, h=2, center=ABOVE);
            }   
        }
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
            mode == PRINTING ? [0,  0, a_horn_pivot - az_drive_link_pivot] :
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
    horn_linkage_cutout_sf = 1.05; // Adjust to get fit without slop!
    horn_linkage_cutout_scaling = [horn_linkage_cutout_sf, horn_linkage_cutout_sf, 1];
    dz_engagement = 2;

    module bumper() {
        hull() {
            can(d=d_limit_cam_bumper, taper = 5, h = h_limit_cam_bumper, center = ABOVE);
             translate([dr_limit_cam_bumper, 0, 0]) 
                can(d=d_limit_cam_bumper, taper = 5, h = h_limit_cam_bumper, center = ABOVE);
        }        
    }
    module blank() {
        can(d=d_limit_cam, h = h_limit_cam, center=ABOVE);
        rotate([0, 0, az_limit_cam_front]) bumper();
        rotate([0, 0, az_limit_cam_back]) bumper();
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

    angle_moving_clamp_to_linkage =  + 90 - coupler_link_angle(a_horn_pivot);
    angle_horn_cam_to_linkage =   da_driver_horn_to_linkage - coupler_link_angle(a_horn_pivot) + a_horn_pivot;
    air_gap = 0.60;
    radius_of_bearing = ahpb_r_bearing(h_pivot, d_pivot_axle);
    l_strut_moving_clamp = radius_of_bearing + d_pivot_axle + dl_strut_moving_clamp;
    l_strut_driver = radius_of_bearing + d_pivot_axle + dl_strut_driver;

    // Use the children to generate an attachment
    clipping_diameter = 10;  // Only helps in plane of rotation, so no help here. 
    child_idx_handle_for_bearing = 0;
    child_idx_handle_for_tcap = 1;
    child_idx_handle_for_lcap = 2; 
    r_attachment = d_pivot_axle/2;
    dx_attachment = radius_of_bearing + r_attachment + 0.2*h_pivot;
    
    
    module moving_clamp_bracket_pivot() {
        

        attachment_instructions = [
            [ADD_HULL_ATTACHMENT, AP_BEARING, 0, clipping_diameter],
            [ADD_HULL_ATTACHMENT, AP_TCAP, child_idx_handle_for_tcap, clipping_diameter],
            [ADD_HULL_ATTACHMENT, AP_LCAP, child_idx_handle_for_lcap, clipping_diameter],
            [ADD_SPRUES, AP_LCAP, [0, 130, 216, 290]],  
        ];         
        
        translate([coupler_link_length/2, 0, 0]) {
            audrey_horizontal_pivot(
                height = h_pivot, 
                d_axle = d_pivot_axle,
                air_gap = air_gap, 
                angle_bearing = angle_moving_clamp_to_linkage, 
                angle_pin = angle_moving_clamp_fixed , 
                attachment_instructions = attachment_instructions) {
                    rotate([0, 0, az_attachment_to_moving_clamp]) 
                        translate([dx_attachment, 0, 0]) 
                            can(d=2*r_attachment, h=z_moving_clamp_bracket , center=ABOVE);                       
                    rotate([0, 0, 90]) 
                        translate([dx_attachment, 0, (0.5)*h_pivot]) 
                            can(d=2*r_attachment, h=0.3*h_pivot , center=ABOVE);
                    rotate([0, 0, 90]) 
                        translate([dx_attachment, 0, 0]) 
                            can(d=2*r_attachment, h=0.3*h_pivot , center=ABOVE);                    
                 
                };
            rotate([0, 0, 90 + angle_moving_clamp_fixed]) {
                hull() {
                    translate([dx_attachment, 0, 0]) 
                        can(d=d_pivot_axle, h=0.8*h_pivot, center=ABOVE);
                    translate([l_strut_moving_clamp, 0, 0]) 
                        can(d=d_pivot_axle, h=0.8 * h_pivot , center=ABOVE);
                }
            }
        }
    }
    
    module driver_pivot() {
        attachment_instructions_driver = [
            [ADD_HULL_ATTACHMENT, AP_BEARING, child_idx_handle_for_bearing, clipping_diameter],
            [ADD_HULL_ATTACHMENT, AP_TCAP, child_idx_handle_for_tcap, clipping_diameter],
            [ADD_HULL_ATTACHMENT, AP_LCAP, child_idx_handle_for_lcap, clipping_diameter],
            [ADD_SPRUES, AP_LCAP, [0, 72, 144, 216 ]],  
        ]; 
        
        translate([-coupler_link_length/2, 0, 0]) {
            
            audrey_horizontal_pivot(
                height = h_pivot,  
                d_axle = d_pivot_axle,
                air_gap = air_gap, 
                angle_bearing = angle_horn_cam_to_linkage, 
                angle_pin = angle_horn_cam_fixed, 
                attachment_instructions = attachment_instructions_driver) {
                    rotate([0, 0,  90]) 
                        translate([dx_attachment-dz_bearing_attachment_for_driver_pivot, 0, dz_bearing_attachment_for_driver_pivot])
                            if (attach_driver_link_pivot_to_horn) {
                                block([1, 2*r_attachment, 0.4 * h_pivot], center=ABOVE);
                            } else {
                                can(d=2*r_attachment, h=0.8 * h_pivot, center=ABOVE);
                            }
                    rotate([0, 0, 90]) 
                        translate([dx_attachment, 0, 0.5*h_pivot]) 
                            can(d=2*r_attachment, h=0.3*h_pivot , center=ABOVE);     
                    rotate([0, 0, 90]) 
                        translate([dx_attachment, 0, 0]) 
                            can(d=2*r_attachment, h=0.3*h_pivot , center=ABOVE);                      
             }
            rotate([0, 0, 90 + angle_horn_cam_fixed]) {
                
                hull() {
                    translate([dx_attachment, 0, 0]) 
                        can(d=2*r_attachment, h=0.8 * h_pivot, center=ABOVE);
                    translate([l_strut_driver, 0, 0]) 
                        can(d=2*r_attachment, h=0.8 * h_pivot, center=ABOVE);
                }
            }
        }        
    }
    
    module connecting_bar() { 
        hull() {
            translate([coupler_link_length/2, 0, 0]) 
                rotate([0, 0, 90 + angle_moving_clamp_fixed])
                    translate([l_strut_moving_clamp, 0, 0]) can(d=d_pivot_axle, h=0.7 * h_pivot, center=ABOVE);
                    
            translate([-coupler_link_length/2, 0, 0]) 
                rotate([0, 0, 90 + angle_horn_cam_fixed]) 
                    translate([l_strut_driver, 0, 0]) can(d=d_pivot_axle, h=0.7 * h_pivot, center=ABOVE);    
        }        
    }
    
    
    
    // The linkage connects the pivot of the horn linkage to the pusher pivot on the moving clamp. 
    module shape() {
        if (debug_kinematics) {
            render(convexity=10) difference() {
                hull() center_reflect([1, 0, 0]) translate([coupler_link_length/2, 0, 0]) can(d=5, h = 2, center=ABOVE);
                center_reflect([1, 0, 0]) translate([coupler_link_length/2, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
            }
        }
        moving_clamp_bracket_pivot();
        driver_pivot();
        connecting_bar();
    }
    
    z_printing = 0;
        rotation = 
        mode == PRINTING ? 
            [0,  0, coupler_link_angle(a_horn_pivot)] :
            [0, 0, coupler_link_angle(a_horn_pivot)];    
    translation = 
        mode == PRINTING ? 
            [x_pusher_bp + dx_linkage(a_horn_pivot), y_pusher_bp + dy_linkage(a_horn_pivot), z_printing] :
            [dx_linkage(a_horn_pivot), dy_linkage(a_horn_pivot), dz_slide_plate + dz_linkage];  
    translate(translation) rotate(rotation) visualize(visualization_pusher_coupler_link)  shape();  
}


module servo_mounting_nut_wrench(z_servo_flange = 2.5) {
    // A wrench that holds the nuts for assembling
    
    dx_arm_cutoff = 4;
    wrench_head = [
        8 + 9g_servo_body_width, 
        2 * y_slide_plate_rim + 9g_servo_body_length + 2, 
        3];
    servo_slot = [9g_servo_body_width, 9g_servo_body_length, a_lot];
    wrench_opening = servo_slot;
    handle = [40, 9g_servo_body_length, 2];
    z_under_nut = 1;
    module blank() {
        block(wrench_head, center = ABOVE);
        block(handle, center = ABOVE+BEHIND);
    }
    module shape() {
        difference() {
            blank();
            block(servo_slot);
            servo_mounting_screws(as_clearance=true);
            block(wrench_opening, center=FRONT);
            translate([dx_arm_cutoff, 0, 0]) plane_clearance(FRONT);
        }
    }
    
    rotation = mode == PRINTING ? [0,  0, 0] : [0, 180, 0];
    translation = mode == PRINTING ? 
        [x_servo_mounting_nut_wrench_bp,  y_servo_mounting_nut_wrench_bp, 0] : 
        [0, 0,  -z_slide_plate/2 - z_servo_flange + dz_slide_plate];
    
    translate(translation) rotate(rotation) {
        visualize(visualization_servo_mounting_nut_wrench) shape();
    }   
}




module pusher_servo_cavity() {   
    // The servo wired must past throught slot, so it must be longer
    dy_serrvo_wire_clearance = 3.5;
    block([9g_servo_body_width, 9g_servo_body_length + dy_serrvo_wire_clearance, a_lot]);
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
        
    module shape() {
        render(convexity=10) {
                difference() {
                    blank();
                    servo_slot();
                    servo_mounting_screws(as_clearance=true);                    
                }    
            }        
    }
    
    module vitamins() {
        translate([0, 5.5, 9.3]) {
            rotate([0, 0, 90]) {
                color(MIUZEIU_SERVO_BLUE) 
                    9g_motor_sprocket_at_origin();
                translate([0, 0, -1]) one_arm_horn(servo_angle=servo_angle_moving_clamp, servo_offset_angle=servo_offset_angle_moving_clamp);
                
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
    
    dy_pusher_servo = -dy_servo_offset_for_slide_plate + 9g_servo_offset_origin_to_edge;
    
    dz_pusher_servo = -(z_pusher_servo_pedistal + 9g_servo_vertical_offset_origin_to_flange);
    
    x_sliding_blank = 2 * x_slide_plate_rim + 9g_servo_body_width;
    y_sliding_blank = y_slide + 2 * y_slide_plate_rim;    
    optical_sensor_translation = [x_sliding_blank/2, dy_optical_sensor_holder, z_slide_plate/2];

    module fixed_clamp_cavity() {
        dy = (y_slide/2 + y_slide_plate_rim + 9g_servo_body_length/2);
        translate([0, dy, 0]) {
            block([9g_servo_body_width, 9g_servo_body_length, a_lot]);
            servo_mounting_screws(as_clearance=true); 
        }
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
        // The sliding area blank:

        block([x_sliding_blank, y_sliding_blank, z_slide_plate]); 
        
        x_servo_blank = 9g_servo_body_width + 2 * x_slider_rim;
        y_servo_blank = 9g_servo_body_length + 2 * y_slide_plate_rim;
        
        dy_pusher_servo = -dy_servo_offset_for_slide_plate;
        
        translate ([dx_pusher_servo_offset, dy_pusher_servo, 0]) {
            block([x_servo_blank, y_servo_blank, z_slide_plate]); 
            // TODO: Allow pedistals?
        }
        
        dy_fixed_clamp_servo = dy_servo_offset_for_slide_plate;
        translate ([0, dy_fixed_clamp_servo, 0]) {
            block([x_servo_blank, y_servo_blank, z_slide_plate]); 
        }
        translate(optical_sensor_translation) {
            tcrt5000_reflective_optical_sensor_holder(
                show_body = false,
                show_rails = true,
                orient_for_mounting = FRONT, 
                orient_for_printing = false,
                mouse_ears = true,
                show_vitamins = false);
        }
    }
    
    module shape() {
        render(convexity=10) difference() {
                blank();
                translate([dx_pusher_servo_offset, -dy_servo_offset_for_slide_plate, 0]) {
                    pusher_servo_cavity();
                    servo_mounting_screws(as_clearance=true); 
                }
                fixed_clamp_cavity();
                rail_cavity();      
          }
     }
     
    z_printing = z_slide_plate/2;
    rotation = 
        mode == PRINTING ? [0, 180, 0] : 
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_slide_plate_bp, y_slide_plate_bp, z_printing] :
        [dx_slide_plate, dy_slide_plate, dz_slide_plate];
    translate(translation) rotate(rotation) {
         if (show_vitamins && mode != PRINTING) {
             translate([dx_pusher_servo_offset, dy_pusher_servo, dz_pusher_servo]) {
                rotate([0, 180, -90]) 
                    color(MIUZEIU_SERVO_BLUE) 9g_motor_sprocket_at_origin();
             }
             
            translate(optical_sensor_translation) {
                tcrt5000_reflective_optical_sensor_holder(
                    show_body = true,
                    orient_for_mounting = FRONT, 
                    show_vitamins = show_vitamins);
            }
         }
        visualize(visualization_slide_plate) shape();  
    }
    
}

module limit_switch_position_sensor(show_vitamins=false) {
    /*
    The position sensor is a limit switch upon which the limit_cam rotates. 
    
    By using this indirect method, we will be able to detect jams, while using only a single component.
    */
    module shape_and_vitamins() {
        
        
        dy_position_sensor = 20;
        dz_position_sensor = -12.75;
        translation = 
                [
                    -dx_pusher_servo_offset - 4.5,
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
    
    //dx_slide_plate + dx_pusher_servo_offset,
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  180, 0] : 
        [0, 0, 0];    
    translation = 
        mode == PRINTING ? [x_slide_plate_bp, y_slide_plate_bp, z_printing] :  
        [ dx_slide_plate, dy_slide_plate, dz_slide_plate + z_slide_plate/2];
    translate(translation)  rotate(rotation) shape_and_vitamins();
}


// Assemblies

module fixed_clamp_assembly() {
    dy_fixed_clamp = dy_servo_offset_for_slide_plate; 
    translate([dx_slide_plate, dy_fixed_clamp, 0]) {
        filament_guide(fixed_clamp = true);
        if (show_vitamins) {
            one_arm_horn(servo_angle=servo_angle_fixed_clamp, servo_offset_angle=servo_offset_angle_fixed_clamp);
        }
        clamp_cam(servo_angle=servo_angle_fixed_clamp);
    }
}

module moving_clamp_assembly() {
    translate([dx_slide_plate, dy_moving_clamp, 0]) {
        translate([0, 5.5, 0]) 
            clamp_cam(servo_angle=servo_angle_moving_clamp, servo_offset_angle = servo_offset_angle_moving_clamp);
        filament_guide(moving_clamp=true);
    }
}

module pusher_assembly() {
    echo("a_horn_pivot", a_horn_pivot);
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



module slide_assembly() {
    // The slide is a new assembly that integrates the rails, pusher body, fixed clamp
    // body and the moving clamp body.  By integrating these parts,
    // less material will be used and assembly will be simplified. 
    
    // It will have two or three separate parts, but it is expected that they will be printed in-place 
    // so there will be no separate assembly - just inserting the servos
   
    slide_plate();
    slider(dy_moving_clamp);
    if (use_limit_switch_position_sensor) {
        limit_switch_position_sensor(show_vitamins=show_vitamins);
    }
    
    translate([dx_slide_plate, -dy_servo_offset_for_slide_plate, 0]) filament_guide(pusher_guide=true);
}

module visualize_assemblies() {
    if (show_filament) {
        filament();
    }
    slide_assembly();
    pusher_assembly();
    fixed_clamp_assembly();
    moving_clamp_assembly();
     if (show_legend) {
        generate_legend_for_visualization(
            visualization_infos, legend_position, font6_legend_text_characteristics());
     }
 }
  
module print_parts() {
    if (print_slide) {
        slide_plate();
        slider();
        if (use_limit_switch_position_sensor) {
            limit_switch_position_sensor();
        }
    }
    if (print_fixed_clamp_cam) {
        clamp_cam(item=0);   
        filament_guide(fixed_clamp=true, item=0);
    }    
    if (print_moving_clamp_cam) {
        clamp_cam(item=1); 
        filament_guide(moving_clamp=true, item=1);
    }
    if (print_pusher_filament_guide) {
        filament_guide(pusher_guide=true, item=2);
    }
    
    if (print_pusher) {
        a_horn_pivot = 360;
        translate([0, y_pusher_assembly, 0]) {
            translate([0, dy_pusher_servo, 0]) 
                pusher_driver_link(a_horn_pivot=a_horn_pivot); 
            translate([0, dy_pusher_servo, 0]) 
                pusher_coupler_link(a_horn_pivot=a_horn_pivot); 
        }
        moving_clamp_bracket(a_horn_pivot=a_horn_pivot);        
        limit_cam(a_horn_pivot=a_horn_pivot);   
    }
    if (print_servo_mounting_nut_wrench) {
        servo_mounting_nut_wrench();
    }
 }
 


if (mode ==  ASSEMBLE_SUBCOMPONENTS) { 
    visualize_assemblies();
} else if (mode ==  PRINTING) {
    print_parts();
}
