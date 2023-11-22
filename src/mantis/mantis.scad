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
show_parts = true; // But nothing here has parts yet.


// Order to match the legend:
clamp_cam = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
limit_cam =  1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
pusher_coupler_link = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
moving_clamp_bracket = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
pusher_driver_link = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
servo_filament_guide = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
servo_mounting_nut_wrench = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
slide_plate = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
slider  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

/* [Printing Control] */

print_all_parts = false;
print_one_part = false;

// Update options for part_to_print with each defined variable in the following Show section!
one_part_to_print = "servo_filament_guide"; // [clip, collet, clamp_cam, limit_cam, pusher_coupler_link, pusher_driver_link, servo_filament_guide, servo_mounting_nut_wrench, slide_plate, slider]

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
servo_angle_pusher  = 25; // [0:180]
servo_offset_angle_pusher  = 245; // [0:360]

/* [Animation ] */
servo_angle_moving_clamp = 0; // [0:180]
servo_offset_angle_moving_clamp = 90; // [0:360]
servo_angle_fixed_clamp = 0; // [0:180]
servo_offset_angle_fixed_clamp = 0; // [0:360]

    
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

dy_servo_offset_for_slide_plate = y_slide/2 + y_slide_plate_rim + 9g_servo_body_length/2;


/* [Slider Design] */
// Lateral clearance between slider and guide.  Needs to big enough that the parts print separately.  Small enough relative to thickness of plate so that slider doesn't fall out or move too much vertically.
slider_clearance = 0.4;
// Lateral rim around servos inserted into slider
x_slider_rim = 2;
// The offset between the linkage centerline and the centerline of servo
dy_moving_clamp_offset = 18;



/* [Pusher Linkage Design] */
// Adjust so that linkage lines up with shaft pusher servo.  
dz_linkage = -20; // [-22:0.1:-18]
debug_kinematics = false; 
// Adjust so the bearing attachment doesn't interfer with insertion of horn.
az_drive_link_pivot = 32;
r_horn_link = 18;
coupler_link_length = 28;
// TODO:  Calculate y_pusher_assembly from plate dimensions
y_pusher_assembly = -42;
dy_pusher_servo = 2;// 2;
dx_slider_pivot_offset = 17; // [-6:0.1:20]



/* [Pusher Coupler Link Design] */
angle_moving_clamp_fixed = 105; // [0:180]
dl_strut_moving_clamp = 0; // [0:0.1:5]
angle_horn_cam_fixed = -120; // [-180:180]
dl_strut_horn_cam = 0; // [0:0.1:5]
h_pivot = 11; //[10:0.25:15]
d_pivot_axle = 4; // [1:0.25:5]
moving_clamp_rim = 3; 

/* [Build Plate Layout] */

x_slide_plate_bp = 40;
y_slide_plate_bp = 0;

x_slider_bp = x_slide_plate_bp;
y_slider_bp = 0;

x_servo_filament_guide_bp = 80;
y_servo_filament_guide_bp = 40;
dy_servo_filament_guide_bp = -40;

x_clamp_cam_bp = 100;
y_clamp_cam_bp = 50;
dy_clamp_cam_bp = -40;

x_pusher_bp = 100;
y_pusher_bp = -20;

x_limit_cam_bp = 130;
y_limit_cam_bp = 0;

x_servo_mounting_nut_wrench_bp = 150;
y_servo_mounting_nut_wrench_bp = 40;


module end_of_customization() {}



/* Linkage Kinematicts  Calculations*/

dx_origin = dx_slide_plate + dx_pusher_servo_offset;
dy_origin = -40;  // TODO Calculate from frame size?
dx_slider_pivot = dx_slide_plate + dx_slider_pivot_offset;

dx_horn_pivot = function(a_horn_pivot) dx_origin + cos(a_horn_pivot) * r_horn_link;
dy_horn_pivot = function(a_horn_pivot) dy_origin + sin(a_horn_pivot) * r_horn_link; 

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
        
visualization_servo_filament_guide = 
    visualize_info(
        "Servo Filament Guide", PART_11, show(servo_filament_guide, "servo_filament_guide") , layout, show_parts);       
        
visualization_servo_mounting_nut_wrench = 
    visualize_info(
        "Servo Mounting Nut Wrench", PART_17, show(servo_mounting_nut_wrench, "servo_mounting_nut_wrench") , layout, show_parts);   
        
visualization_slide_plate = 
     visualize_info(
        "Slide Plate", PART_18, show(slide_plate, "slide_plate") , layout, show_parts);   
            
visualization_slider = 
     visualize_info(
        "Slider", PART_20, show(slider, "slider") , layout, show_parts);               
        
visualization_infos = [
    visualization_clamp_cam,
    visualization_limit_cam,
    visualization_moving_clamp_bracket,
    visualization_pusher_coupler_link,
    visualization_pusher_driver_link,    
    visualization_servo_filament_guide,
    visualization_servo_mounting_nut_wrench,
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
            translate([0, 0, dz_screw_head])  color(STAINLESS_STEEL) screw("M2x12", $fn=12);
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


module servo_filament_guide(
    moving_clamp = false, fixed_clamp = false, pusher_guide=false, item = 0) {
    
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
   
    module blank() {
        
        translate([dx_core_offset, 0, 0]) block(core, center = ABOVE);
        translate([-dx_slide_plate, 0, 0]) block(guide, center = ABOVE);
        if (use_cam)  {
            translate([0, dy_cam_offset, 0]) block(cam_backer, center = ABOVE + BEHIND);    
        }
        if (fixed_clamp) {
            collet_blank(is_exit=true);
       } if (pusher_guide) {
           collet_blank(is_exit=false);
       }
   } 

  
    module cam_cavity() {
        d_cam_clearance = d_bottom_for_clamp_cam;
        dz_horn_clearance = z_guide - 2; 
        d_horn_clearance = 34;
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
            visualize_vitamins(visualization_servo_filament_guide) {
                translate([dx_core_offset, 0, 0]) 
                    rotate([0, ay_mounting_screws, 0]) 
                        servo_mounting_screws(dz_nut = dz_nut, dz_screw_head= dz_screw_head);             
            }
        }
        visualize(visualization_servo_filament_guide) shape();
    }  
    
}


module moving_clamp_bracket(a_horn_pivot) {
    z_moving_clamp_bracket = 10;
           
    base = [
        2 * moving_clamp_rim + 9g_servo_body_width,
        2 * moving_clamp_rim + 9g_servo_body_length,
        z_moving_clamp_bracket
    ]; 
    servo_wire_clearance = [ 6, 20, 12]; 
    slot = 1.02* [9g_servo_body_width, 9g_servo_body_length, a_lot];
    module shape() {    
        render(convexity=10) difference() {
            block(base, center=ABOVE);
            block(slot);
            translate([0, 0, 2]) block(servo_wire_clearance, center=RIGHT+ABOVE);
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0, 0, 0] :
        [0, 0, 0];
    dy = 9g_servo_body_length/2 + moving_clamp_rim/2 + dy_pivot(a_horn_pivot);
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
            translate([12, 0, 0]) can(d=7, h=h, center=ABOVE); 
        }
        // Create a blank to which the pivot can be attached
        hull() {
            can(d=d_center, h=2, center=ABOVE);
            rotate([0, 0, az_drive_link_pivot])  
                translate([r_horn_link - dr_horn_clearance, 0, 0]) 
                    can(d=d_horn_pivot_end, h=2, center=ABOVE);
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

    angle_moving_clamp_to_linkage =  + 90 - coupler_link_angle(a_horn_pivot);
    angle_horn_cam_to_linkage =   90 - coupler_link_angle(a_horn_pivot) + a_horn_pivot;
    air_gap = 0.60;
    radius_of_bearing = ahpb_r_bearing(h_pivot, d_pivot_axle);
    l_strut_moving_clamp = radius_of_bearing + d_pivot_axle + dl_strut_moving_clamp;
    l_strut_horn_cam = radius_of_bearing + d_pivot_axle + dl_strut_horn_cam;

    // Use the children to generate an attachment
    clipping_diameter = 10;  // Only helps in plane of rotation, so no help here. 
    child_idx_handle_for_bearing = 0;
    child_idx_handle_for_tcap = 1;
    child_idx_handle_for_lcap = 2;    
    
    attachment_instructions_mc = [
        [ADD_HULL_ATTACHMENT, AP_BEARING, child_idx_handle_for_bearing, clipping_diameter],
        [ADD_HULL_ATTACHMENT, AP_TCAP, child_idx_handle_for_tcap, clipping_diameter],
        [ADD_SPRUES, AP_LCAP, [0, 130, 216, 290]],  
    ]; 
    
    attachment_instructions_driver = [
        [ADD_HULL_ATTACHMENT, AP_BEARING, child_idx_handle_for_bearing, clipping_diameter],
        [ADD_HULL_ATTACHMENT, AP_TCAP, child_idx_handle_for_tcap, clipping_diameter],
        [ADD_SPRUES, AP_LCAP, [0, 72, 144, 216 ]],  //45, 135, 225, 315
    ]; 
    // The linkage connects the pivot of the horn linkage to the pusher pivot on the moving clamp. 
    module shape() {
        if (debug_kinematics) {
            #render(convexity=10) difference() {
                hull() center_reflect([1, 0, 0]) translate([coupler_link_length/2, 0, 0]) can(d=5, h = 2, center=ABOVE);
                center_reflect([1, 0, 0]) translate([coupler_link_length/2, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
            }
        }
        translate([coupler_link_length/2, 0, 0]) {
            audrey_horizontal_pivot(
                height = h_pivot, 
                d_axle = d_pivot_axle,
                air_gap = air_gap, 
                angle_bearing = angle_moving_clamp_to_linkage, 
                angle_pin = angle_moving_clamp_fixed , 
                attachment_instructions = attachment_instructions_mc) {
                    rotate([0, 0, 90]) 
                        translate([radius_of_bearing + d_pivot_axle, 0, 0]) 
                            can(d=moving_clamp_rim, h=h_pivot/3 , center=ABOVE);                       
                    rotate([0, 0, 90]) 
                        translate([radius_of_bearing + d_pivot_axle, 0, (0.6)*h_pivot]) 
                            can(d=d_pivot_axle, h=0.2*h_pivot , center=ABOVE);
                 
                };
            rotate([0, 0, 90 + angle_moving_clamp_fixed]) {
                hull() {
                    translate([radius_of_bearing + d_pivot_axle, 0, 0]) 
                        can(d=d_pivot_axle, h=0.8 * h_pivot, center=ABOVE);
                    translate([l_strut_moving_clamp, 0, 0]) 
                        can(d=d_pivot_axle, h=0.8 * h_pivot , center=ABOVE);
                }
            }
        }
        
        translate([-coupler_link_length/2, 0, 0]) {
            audrey_horizontal_pivot(
                height = h_pivot,  
                d_axle = d_pivot_axle,
                air_gap = air_gap, 
                angle_bearing = angle_horn_cam_to_linkage, 
                angle_pin = angle_horn_cam_fixed, 
                attachment_instructions = attachment_instructions_driver) {
                    rotate([0, 0,  90]) 
                        translate([radius_of_bearing + d_pivot_axle, 0, 0]) 
                            can(d=d_pivot_axle, h=0.8 * h_pivot, center=ABOVE);
                    
                    rotate([0, 0, 90]) 
                        translate([radius_of_bearing + 3, 0, h_pivot*2/3]) 
                            #can(d=4, h=h_pivot/3 , center=ABOVE);                        
             }
            rotate([0, 0, 90 + angle_horn_cam_fixed]) {
                
                hull() {
                    translate([radius_of_bearing + d_pivot_axle, 0, 0]) 
                        can(d=d_pivot_axle, h=0.8 * h_pivot, center=ABOVE);
                    translate([l_strut_horn_cam, 0, 0]) 
                        can(d=d_pivot_axle, h=0.8 * h_pivot, center=ABOVE);
                }
            }
            rotate([0, 0, 90 + angle_horn_cam_fixed]) {
                translate([radius_of_bearing + 3, 0, 0]) can(d=4, h=h_pivot, center=ABOVE);
            } 
        }
        
        hull() {
            translate([coupler_link_length/2, 0, 0]) 
                rotate([0, 0, 90 + angle_moving_clamp_fixed])
                    translate([l_strut_moving_clamp, 0, 0]) can(d=d_pivot_axle, h=0.8 * h_pivot, center=ABOVE);
                    
            translate([-coupler_link_length/2, 0, 0]) 
                rotate([0, 0, 90 + angle_horn_cam_fixed]) 
                    translate([l_strut_horn_cam, 0, 0]) can(d=d_pivot_axle, h=0.8 * h_pivot, center=ABOVE);
                    
        }
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
        x_sliding_blank = 2 * x_slide_plate_rim + 9g_servo_body_width;
        y_sliding_blank = y_slide + 2 * y_slide_plate_rim;
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
            // TODO: Allow pedistals?
        }
        
        
        // Pedistal for outer part of pusher servo:
//        dy_pusher_servo_outer_pedistal = -y/2;
//        x_outer_pedistal = 9g_servo_body_width;
//        translate([0, dy_pusher_servo_outer_pedistal, 0]) 
//            block([x_outer_pedistal, y_slide_plate_rim, z_pusher_servo_pedistal], center=BELOW + RIGHT);
        // Inner pedistal - must avoid interfering with wire and still allow assembly
     
//        translate([0, dy_pusher_servo_inner_pedistal, 0]) 
//            block([9g_servo_body_width, y_slide_plate_rim, z_pusher_servo_pedistal], center=BELOW+LEFT);
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
             translate([dx_pusher_servo_offset, dy_pusher_servo, dz_pusher_servo]) 
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
        servo_filament_guide(fixed_clamp = true);
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
        servo_filament_guide(moving_clamp=true);
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
    position_sensor(show_vitamins=show_vitamins);
    
    translate([dx_slide_plate, -dy_servo_offset_for_slide_plate, 0]) servo_filament_guide(pusher_guide=true);
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
        position_sensor();
    }
    if (print_fixed_clamp_cam) {
        clamp_cam(item=0);   
        servo_filament_guide(fixed_clamp=true, item=0);
    }    
    if (print_moving_clamp_cam) {
        clamp_cam(item=1); 
        servo_filament_guide(moving_clamp=true, item=1);
    }
    if (print_pusher_filament_guide) {
        servo_filament_guide(pusher_guide=true, item=2);
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
