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
show_legend = false;
print_rails = true;
print_both_rails = true;
print_moving_clamp = true;
print_fixed_clamp = true;
print_pusher = true;
print_frame = true;
print_filament_loader = true;

print_one_part = false;
part_to_print = "moving_clamp_body"; // [adjustable_linkage, clip, collet, filament_loader, filament_loader_clip, fixed_clamp_body, horn_cam, horn_linkage, linkage, limit_switch_bumper, limit_switch_holder, moving_clamp_body, pusher_body, rails, servo_base, tie, tie_bracket]

filament_length = 200; // [50:200]

/* [Show] */ 
// Order to match the legend:
adjustable_linkage = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
filament_loader  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
filament_loader_clip  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
fixed_clamp_body = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_cam = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_linkage = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
limit_switch_bumper = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
limit_switch_holder  =  1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
linkage = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
moving_clamp_body = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
pusher_body = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
rails = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
tie =  1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
tie_bracket  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]


/* [Legend] */
x_legend = 36; // [-200 : 200]
y_legend = 120; // [-200 : 200]
z_legend = -40; // [-200 : 200]
legend_position = [x_legend, y_legend, z_legend];

/* [Animation ] */
servo_angle_moving_clamp = 0; // [0:180]
servo_angle_fixed_clamp = 0; // [0:180]
servo_angle_pusher  = 25; // [0:180]
servo_offset_angle_pusher  = 50; // [0:360]
roller_switch_depressed = true;
roller_arm_length = 20; // [18:Short, 20:Long]

/* [Base Design] */
dz_servo = 3.5;
x_base_pillar = 34;
y_base_pillar = 12;
z_base_pillar = 8.8;
z_base_joiner = 3.8;
dx_base_offset = -5;
dy_base_offset = 5;
dy_base_offset_moving_clamp = 12;


/* [Outlet Design] */
y_outlet = 20;


/* [Cam Design] */
od_cam = 11;
dz_cam = 0.6; // [0: 0.1 : 3]
ay_cam = 10; // [0: 1: 20]
az_cam = 0;
d_horn_cam_clearance = 16;  


/* [Guide Design] */
filament_translation = [-4.5, 0, 1.7];
x_guide = 46;
y_guide = 16;
z_guide =2;
d_guide = 3.2;
s_guide_dovetail = 2;
y_guide_moving_clamp = 26;


/* [Frame Design] */
frame_clearance = 0.5;
y_frame = 100;
x_rail_attachment = 8;
y_rail_attachment = 16; 
z_rail_attachment = 8;
y_rail_screw_offset = 3;
rail_wall = 2;
dz_rail_screws = -4;
dy_pusher_rail_screws = -18; // [-20:0.1:-15]

/* [Dove Tail Design] */
x_dovetail = 4;
y_dovetail = 6;
z_dovetail = 5;
dovetail_clearance = 0.25;
tie_length = 30;

/* [Linkage Design] */
az_horn_linkage_pivot = 20;
r_horn_linkage = 14;
linkage_length = 29;
linkage_shorten_range = 4;
dz_linkage = -16; // [-20: 0]
y_pusher_assembly = 24;
dy_pusher_servo = 2;

/* [Limit Switch Holder Design] */
dx_limit_switch_holder = -17.1; // [-30:0]
dz_limit_switch_holder = -11; // [-30:0]

dx_top_clamp = -7.2; // [-15: 0.1: -5]
// Displacement of cl of switch body to cl of servo
dy_switch_body = 0; // [-20:15]
// Displayment relative to bottom of nut block
dz_switch_body = 0; // [-20:0]
right_handed_limit_switch_holder = false;
limit_switch_holder_base_thickness = 4;

/* [Limit Switch Bumper Design] */
x_limit_switch_bumper = 10;
y_limit_switch_bumper = 14;
z_limit_switch_bumper = 12;

// Relative to inside of nut block
dx_limit_switch_bumper = 0;
// Relative to center line of nut block
dy_limit_switch_bumper = 8;
// Relative to top of nut block
dz_limit_switch_bumper = 6; 

/* [Filament Holder Design] */
dy_filament_loader_clip = 12;


/* [Build Plate Layout] */
x_rail_bp = 30; 
y_rail_bp = 0; 
dx_rail_bp = 18;

x_servo_base_bp = 0;
y_servo_base_bp = 0;
dx_servo_base_bp = -50;

x_fixed_clamp_body_bp = 0;
y_fixed_clamp_body_bp = 0;

x_moving_clamp_body_bp = 0; 
y_moving_clamp_body_bp = -40;

x_horn_cam_bp = 15;
y_horn_cam_bp = -15;
dx_horn_cam_bp = -15;

x_pusher_body_bp = 0;
y_pusher_body_bp = 20;

x_horn_linkage_bp = 0;
y_horn_linkage_bp = 55;

x_linkage_bp = -30;
y_linkage_bp = 40;

x_adjustable_linkage_bp = -30;
y_adjustable_linkage_bp = 50;
dx_adjustable_linkage_bp = -30;

x_tie_bracket_bp = x_rail_bp;
y_tie_bracket_bp = -15;
dx_tie_bracket_bp = dx_rail_bp;

x_tie_bp = x_rail_bp;
y_tie_bp = -50;
dx_tie_bp = dx_rail_bp;

x_limit_switch_holder_bp = -20; 
y_limit_switch_holder_bp = -30;

x_limit_switch_bumper_bp = -40;
y_limit_switch_bumper_bp = -50;

x_filament_loader_clip_bp = 10;
y_filament_loader_clip_bp = 10;

x_filament_loader_bp = 10;
y_filament_loader_bp = 10;


module end_of_customization() {}

/* Linkage kinematicts */

// Move servo origin
dx_origin = 0;
dy_origin = 8;
//Debug: translate([dx_origin, dy_origin, 0]) color("yellow") can(d=1, h=a_lot);

a_horn_pivot = servo_angle_pusher + servo_offset_angle_pusher + az_horn_linkage_pivot;
dx_horn_pivot = dx_origin + cos(a_horn_pivot) * r_horn_linkage;
dy_horn_pivot = dy_origin + sin(a_horn_pivot) * r_horn_linkage; 
// Debug: ttranslate([dx_horn_pivot, dy_horn_pivot, 0]) color("blue") can(d=1, h=a_lot);

 linkage_angle = acos(-dx_horn_pivot/linkage_length); 

dx_pivot = dx_horn_pivot + cos(linkage_angle) * linkage_length;
dy_pivot = dy_horn_pivot + sin(linkage_angle) * linkage_length; 
// Debug: translate([dx_pivot, dy_pivot, 0]) color("green") can(d=1, h=a_lot);
   
dx_linkage_midpoint = dx_horn_pivot/2;
dy_linkage_midpoint = (dy_pivot+dy_horn_pivot)/2;
// Debug: translate([dx_linkage_midpoint, dy_linkage_midpoint, 0]) color("brown") can(d=1, h=a_lot);
// But translation is applied after rotation, so dy must be adjusted;
dx_linkage = dx_linkage_midpoint;
dy_linkage = dy_horn_pivot- dy_origin + sin(linkage_angle) * linkage_length/2;

y_moving_clamp = dy_pivot + y_pusher_assembly;

s_dovetail = s_guide_dovetail + 2*frame_clearance; 

x_rail = 1 + s_guide_dovetail + 1 + rail_wall;
z_rail = z_guide + s_guide_dovetail + 2 * rail_wall;



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
        
visualization_adjustable_linkage  =        
    visualize_info(
        "Adjustable Linkage", PART_3, show(adjustable_linkage, "adjustable_linkage") , layout, show_parts);          

visualization_moving_clamp_body =         
    visualize_info(
        "Moving Clamp Body", PART_4, show(moving_clamp_body, "moving_clamp_body") , layout, show_parts); 
        
visualization_fixed_clamp_body = 
    visualize_info(
        "Fixed Clamp Body", PART_5, show(fixed_clamp_body, "fixed_clamp_body") , layout, show_parts); 
 
        
visualization_pusher_body = 
    visualize_info(
        "Pusher Body", PART_6, show(pusher_body, "pusher_body") , layout, show_parts);  
        
visualization_horn_cam = 
    visualize_info(
        "Horn Cam", PART_7, show(horn_cam, "horn_cam") , layout, show_parts); 
        
visualization_limit_switch_holder =   
    visualize_info(
        "Limit Switch Holder", PART_8, show(limit_switch_holder, "limit_switch_holder") , layout, show_parts); 
  
visualization_limit_switch_bumper =   
    visualize_info(
        "Limit Switch Bumper", PART_9, show(limit_switch_bumper, "limit_switch_bumper") , layout, show_parts);   
        
 visualization_rails =         
    visualize_info(
        "Rails", PART_10, show(rails, "rails") , layout, show_parts);  

        
visualization_tie = 
    visualize_info(
        "Tie", PART_11, show(tie, "tie") , layout, show_parts);     
        
visualization_tie_bracket = 
    visualize_info(
        "Tie Bracket", PART_12, show(tie_bracket, "tie_bracket") , layout, show_parts);   
      

visualization_filament_loader =       
    visualize_info(
        "Filament Loader", PART_13, show(filament_loader, "filament_loader") , layout, show_parts);   
        
visualization_filament_loader_clip =       
    visualize_info(
        "Filament Loader Clip", PART_14, show(filament_loader_clip, "filament_loader_clip") , layout, show_parts);         

  

        
visualization_infos = [
    visualization_adjustable_linkage,
    visualization_filament_loader, 
    visualization_filament_loader_clip, 
    visualization_fixed_clamp_body,
    visualization_horn_cam,
    visualization_horn_linkage,
    visualization_limit_switch_bumper,
    visualization_limit_switch_holder,
    visualization_linkage,
    visualization_moving_clamp_body,
    visualization_pusher_body,
    visualization_rails,
    visualization_tie_bracket,
    visualization_tie,
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
        filament_luse_dupont_connectorsngth = y_frame + 90;
        translate(filament_translation + [0, -40, 0]) 
            color("red") 
                rod(d=d_filament, l=filament_length, center=SIDEWISE+RIGHT);
    }
}

module one_arm_horn(as_clearance=false, servo_angle=0, servo_offset_angle=0) {
    h_barrel_one_arm_horn = 3.77;
    h_arm_one_arm_horn = 1.3;
    dz_engagement_one_arm_horn = 1;
    
    dz_arm = h_barrel_one_arm_horn + dz_engagement_one_arm_horn;
    module blank() {
        translate([0, 0, dz_engagement_one_arm_horn]) can(d=7.5, h=h_barrel_one_arm_horn, center=ABOVE); 
        translate([0, 0, dz_engagement_one_arm_horn+h_barrel_one_arm_horn]) {
            hull() {
                can(d=6, h=h_arm_one_arm_horn, center=BELOW);
                translate([14, 0, 0]) can(d=4, h=h_arm_one_arm_horn, center=BELOW); 
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
module adjustable_linkage() {
    // The linkage connects the pivot of the horn linkage to the pusher pivot on the moving clamp. 
    // The adjustable linkage constis of two part that serve the purpose of the single piece linkage,
    // but can be fine tuned for length.  In the short term this is needed for development and 
    // experimentation, but is not likely to be included in the final product as geometry is 
    // locked down.
    linkage_width = 4;
    linkage_height = 6;
    pad_height = 4;
    pad_diameter = 5;
    slider_height = 6;
    
    slider = [linkage_length - pad_diameter - linkage_shorten_range, linkage_width/2, slider_height];
    linkage_adjustment_range = slider.x - 6;
    slot_translation = [linkage_adjustment_range/2, -25, slider_height/2];
    dy_slot = (pad_diameter-linkage_width)/2;
    dx_slot = 2;
    module blank() {
        hull() {
            translate([linkage_length/2, 0, 0]) {
                can(d=pad_diameter, h = pad_height, center=ABOVE);
                block([pad_diameter, pad_diameter/2, pad_height], center=ABOVE+RIGHT);
            }
        }
        translate([dx_slot, dy_slot, 0]) {
            block(slider, center = ABOVE + RIGHT);
            block([linkage_length/2, linkage_width/2, pad_height], center=ABOVE+FRONT+RIGHT);
        }
    }  
    module slot() {
        translate([dx_slot, 0, 0]) {
            hull() {
                center_reflect([1, 0, 0]) {
                    translate(slot_translation) {
                        rotate([90, 0, 0]) hole_through("M2", cld=0.2, $fn=12);
                    }
                }
            }
        }
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            translate([linkage_length/2, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
            slot();
        }
    }

    z_printing = pad_diameter/2;
    rotation = 
        mode == PRINTING ? [-90,  0, 0] :
        [0, 0, linkage_angle];    
    translation = 
        mode == PRINTING ? [x_adjustable_linkage_bp, y_adjustable_linkage_bp, z_printing] :
        [dx_linkage, dy_linkage, dz_linkage + 8];  
    translate(translation) rotate(rotation) {
        visualize(visualization_adjustable_linkage) {
            shape(); 
            if  (mode == PRINTING) {
                translate([0, 0, 2 * linkage_width]) shape(); 
            } else {
                shape(); 
                rotate([0, 0, 180]) shape();
            }
        }
    }
}


module rails_screws(as_clearance = true) {
    module item() {
        if (as_clearance) {
            translate([0, 2, 0]) vertical_rail_screws(as_clearance=true, cld=0.4); // Loose fit, screws pass through                
        } else {
            translate([0, 2, 0]) vertical_rail_screws(as_clearance=false);
        }
    }
    translate([dx_base_offset, 0, 0]) {
        center_reflect([1, 0, 0]) {
            translate([21.6, -2, 0]) {
                item();
            }
        }            
    }
}


module fixed_clamp_body() {
      
    module overhang() {
        translate([-1.5, 0, 0]) block([15, y_base_pillar, a_lot], center=LEFT);
    }

    module outlet_tubing_connector(as_clearance = false) {
        if (as_clearance) {
            translate([filament_translation.x, y_base_pillar/2 + y_outlet, filament_translation.z]) { 
                rotate([90, 0, 0]) flute_keyhole(is_filament_entrance = true, print_from_key_opening=true, entrance_multiplier=1); 
                block([6, 20, 6]);
            }
        }
    }    
    module cavity() {
        translate([0, 0, dz_servo]) 9g_motor_sprocket_at_origin();
        can(d=d_horn_cam_clearance, h=a_lot, center=ABOVE);
        outlet_tubing_connector(as_clearance = true);
        overhang();
        servo_screws(as_clearance = true, recess = true);
        rails_screws(as_clearance = true);
        filament_loader_clip(as_clearance=true);
    }
    module rail_engagement() {
        blank_offset = 8;
        x_locked_guide = x_guide + 2 * frame_clearance;
        z_locked_guide = z_guide + 2 * frame_clearance;
        dx_p_locked_guide = dx_base_offset + x_guide/2 + frame_clearance;
        dx_m_locked_guide = dx_base_offset - x_guide/2 - frame_clearance;
        translate([dx_p_locked_guide, blank_offset, -frame_clearance]) block([12, 14, z_locked_guide], center=ABOVE+LEFT+BEHIND);
        translate([dx_m_locked_guide, blank_offset, -frame_clearance]) block([12, 14, z_locked_guide], center=ABOVE+LEFT+FRONT);
    }
    module blank() {
        // The part around the servo:
        translate([dx_base_offset, 0, 0]) 
            block([x_base_pillar, y_base_pillar, z_base_pillar], center=BELOW);
        translate([dx_base_offset, y_base_pillar/2, 0]) {  
            // The part to the right of the servo:
            block([x_base_pillar + 16, y_outlet,  z_base_pillar], center=BELOW+RIGHT);
            // The part to the right and above servo   
            block([x_base_pillar + 16, y_outlet,  z_base_pillar], center=ABOVE+RIGHT);
        }
        rail_engagement();
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            cavity();
        }
    }
    z_printing = y_base_pillar/2 + y_outlet;
    rotation = 
        mode == PRINTING ? [-90, 0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_fixed_clamp_body_bp, y_fixed_clamp_body_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {    
        if (show_vitamins && mode != PRINTING) {
            translate([0, 0, dz_servo]) color(MIUZEIU_SERVO_BLUE) 9g_motor_sprocket_at_origin();
            servo_screws(as_clearance = false, recess=true);
            rails_screws(as_clearance = false);
        }  
        visualize(visualization_fixed_clamp_body) shape();
    }
}


module horizontal_rail_screws(as_clearance=false, cld=0.2) {
    if (as_clearance) {
         center_reflect([0, 1, 0]) 
            translate([5, y_rail_screw_offset, dz_rail_screws]) 
                rotate([0, 90, 0]) 
                    hole_through("M2", l=20, cld=cld, $fn=12);
    } else {
        assert(false);
    }
} 


module horn_cam(item=0, servo_angle=0, servo_offset_angle=0, clearance=0.5) {
    h_above =2.2;
    h_barrel = 3.77;
    h_arm = 1.3; 
    h_below = 2.5;
    dx_clear_horn = -3.9;
    h = h_above + h_arm + h_below;
    dz_horn_engagement = -1;
    dz_horn = dz_horn_engagement -h_barrel + h_arm + h_below;
    dz_assembly = h_barrel-dz_horn_engagement-h_arm-h_below;      
    module shape() {
        d_lock = 0.1;
        render(convexity=10) difference() {
            can(d=od_cam, h=h, center=ABOVE);
            // Push filament out of way to avoid catching on horn when filament loader is inserted. 
            // Angle at 45 to provide more options for printing
            translate([-8, 0, 0]) rotate([0, 45, 0]) plane_clearance(BEHIND); 
            // Provide path for filament to reach bottom of slot
            translate([dx_clear_horn, 0, 0]) plane_clearance(BEHIND); 
            // Slot to lock filament when cam is rotated
            hull() {
                translate([-3.7, 0, 0.8])  rod(d=d_filament_with_tight_clearance, l=50, center=SIDEWISE+BEHIND+RIGHT+ABOVE);
                rotate([0, 0, -90]) translate([-3.7, 0, 3])  rod(d=d_lock, l=50, center=SIDEWISE+BEHIND+RIGHT+ABOVE);
            }
            // Screw used to attach horn
            can(d=2.5, h=a_lot); //Screw 
            // The horn itself
            translate([0, 0, dz_horn])  one_arm_horn(as_clearance=true);
//                    translate([-5, 0, dz_horn])  rotate([0, 0, 180]) one_arm_horn(as_clearance=true);
        }
    }
    z_printing = -dx_clear_horn;
    rotation = 
        mode == PRINTING ? [0, -90, 0] :
        [0, 0, servo_angle + servo_offset_angle + az_cam];
    translation = 
        mode == PRINTING ? [x_horn_cam_bp + item*dx_horn_cam_bp, y_horn_cam_bp, z_printing] :
        [0, 0, dz_assembly];
    translate(translation) rotate(rotation) visualize(visualization_horn_cam) shape();   
}


module horn_linkage(servo_angle=0, servo_offset_angle=0) {
    //  The horn linkage sits on top of the horn, to avoid interference with the filament.
    module pivot(as_clearance) {
        rotate([0, 0, az_horn_linkage_pivot]) translate([r_horn_linkage, 0, 1.9]) rotate([180, 0, 0]) {
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
                    translate([12, 0, 0]) can(d=7, h=h, center=ABOVE);
                    
                }
                translate([0, 0, h-2]) {
                    hull() {
                        can(d=od_cam, h=2, center=ABOVE);
                        rotate([0, 0, az_horn_linkage_pivot])  translate([r_horn_linkage, 0, 0]) can(d=5, h=2, center=ABOVE);
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
        [0, 0, dz_servo + dz_linkage];
    translate(translation) rotate(rotation) {
        if (show_vitamins && mode != PRINTING) {
            visualize_vitamins(visualization_horn_linkage) 
                translate([0, 0, 0])
                    pivot(as_clearance = false) ; 
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
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, linkage_angle];    
    translation = 
        mode == PRINTING ? [x_linkage_bp, y_linkage_bp, z_printing] :
        [dx_linkage, dy_linkage, dz_linkage + 8];  
    translate(translation) rotate(rotation) visualize(visualization_linkage) shape();  
}

module limit_switch_bumper() {
    dx_screw = -2.6;
    nut_block = [6, 6, 6];
    bumper = [x_limit_switch_bumper, y_limit_switch_bumper, z_limit_switch_bumper];
    support = [0.1, 2, 4];
    connection = [5, nut_block.y, 0.1];
    bumper_translation = [dx_limit_switch_bumper, dy_limit_switch_bumper, dz_limit_switch_bumper - nut_block.z];
    module shape() {  
        color(PART_29) 
            render(convexity = 10) difference() {
                union() { 
                    block(nut_block, center = BELOW+BEHIND);
                    hull() {
                        translate(bumper_translation) block(bumper,  center = BELOW+BEHIND+LEFT);
                    }
                }
                translate([dx_screw, 0, 25]) hole_through("M2", $fn=12);
                translate([dx_screw, 0, -2]) {
                    rotate([0, 0, 180]) 
                        nutcatch_sidecut(
                            name   = "M2",  // name of screw family (i.e. M3, M4, ...) 
                            l      = 50.0,  // length of slot
                            clk    =  0.5,  // key width clearance
                            clh    =  0.5,  // height clearance
                            clsl   =  0.1); 
                } 
            }
    }
    rotation = 
        mode == PRINTING ? [0,  90, 0] :
        [0,  0, 0];
    translation = 
        mode == PRINTING ? [x_limit_switch_bumper_bp, y_limit_switch_bumper_bp, , 0]:
        [dx_limit_switch_holder, 0, dz_limit_switch_holder];
    translate(translation) rotate(rotation)  visualize(visualization_limit_switch_bumper) shape();
}

module limit_switch_holder() {
    limit_switch_base = rls_base();
    dx_screw = -2.6;
    joiner = [limit_switch_holder_base_thickness, 15, 3];
    dx_joiner = right_handed_limit_switch_holder ? -6.5 : 0;
    dx_top_clamp_adjustment = right_handed_limit_switch_holder? - limit_switch_holder_base_thickness : 0;
    nut_block = right_handed_limit_switch_holder ? [8.5, 10, 6] : [5, 8, 6];
    az_nutcatch_sidecut = right_handed_limit_switch_holder ? 0 : 180;
    module blank() {
        block(nut_block, center = BELOW+BEHIND);
        block([nut_block.x, 19.25, nut_block.z], center = BELOW+BEHIND+RIGHT);
    }
    module shape() {  
        color(visualization_limit_switch_holder[1]) 
            render(convexity = 10) difference() {
                blank();
                translate([dx_screw, 0, 25]) hole_through("M2", $fn=12);
                translate([dx_screw, 0, -2.]) {
                    rotate([0, 0, az_nutcatch_sidecut]) 
                        nutcatch_sidecut(
                            name   = "M2",  // name of screw family (i.e. M3, M4, ...) 
                            l      = 50.0,  // length of slot
                            clk    =  0.3,  // key width clearance
                            clh    =  0.5,  // height clearance
                            clsl   =  0.1); 
                } 
            }
        translate([dx_top_clamp - dx_top_clamp_adjustment, dy_switch_body, dz_switch_body - nut_block.z - limit_switch_base.x/2])
            rotate([0, 90, 90]) {
                nsrsh_terminal_end_clamp(
                    show_vitamins=show_vitamins && mode != PRINTING , 
                    right_handed = right_handed_limit_switch_holder,
                    alpha=1, 
                    thickness=limit_switch_holder_base_thickness, 
                    recess_mounting_screws = true,
                    use_dupont_connectors = true,
                    roller_arm_length = roller_arm_length,
                    switch_depressed = roller_switch_depressed,
                    extra_terminals = 0); 
            }  
    }
    ay_printing = right_handed_limit_switch_holder ? -90 : 90;
    rotation = 
        mode == PRINTING ? [0,  ay_printing, 0] :
        [0,  0, 0];
    dz_printing = right_handed_limit_switch_holder ? limit_switch_base.y + limit_switch_holder_base_thickness : 0;
    translation = 
        mode == PRINTING ? [x_limit_switch_holder_bp, y_limit_switch_holder_bp, dz_printing]:
        [dx_limit_switch_holder, 0, dz_limit_switch_holder];
    if (visualization_limit_switch_holder[2]) {
        translate(translation) rotate(rotation) shape();
    }
}

module moving_clamp_body() {
    dx_pivot = 2;
    
    module pusher_pivot(as_clearance=false) {
        
        if (as_clearance) {
            translate([dx_pivot, -y_guide/2-3, 0]) {
                translate([0, 0, 25]) hole_through("M2", cld=0.4, $fn=12); 
            }
        } else{
            translate([dx_pivot, -y_guide/2-2, 4]) {
                color(BLACK_IRON) screw("M2x16", $fn=12);
                translate([0, 0, -14]) rotate([180, 0, 0]) color(BLACK_IRON) nut("M2", $fn=12);
            }
        }  
    } 
    module filament_guide() {
        cam_clearance = 1.5;

        module blank() {
            translate([dx_base_offset, dy_base_offset_moving_clamp, 0]) {
                block([x_guide, y_guide_moving_clamp, z_guide], center=ABOVE+LEFT);
                rail_riders(left_right_centering=LEFT, y_guide = y_guide_moving_clamp);
            }
            translate([filament_translation. x, dy_base_offset_moving_clamp, filament_translation. z]) 
                block([6, y_guide_moving_clamp, 5], center=LEFT); 
        }
        module filament_entrance() {
            translate(filament_translation + [0, dy_base_offset_moving_clamp, 0]) {
                rod(d=5, taper=d_filament, l=10, center=SIDEWISE+RIGHT);
            }
        }
        module shape() {
            render(convexity=10) difference() {
                blank();
                hull() {
                    filament(as_clearance=true);
                    translate([1, 0, 5])  filament(as_clearance=true);
                    translate([-1, 0, 5])  filament(as_clearance=true);
                }
                translate([0,-6, 0]) filament_entrance();
                translate([0,-y_guide_moving_clamp, 0]) filament_entrance();
                can(d=d_horn_cam_clearance, h=a_lot);
                servo_screws(as_clearance = true, recess=true);
            }
        }  
        shape(); 

    }    
    module unprintable_overhang() {
        block([6, 6, a_lot], center=LEFT+FRONT);
        block([8, 6, a_lot], center=LEFT+BEHIND);
        translate([0, 2.5, 0]) rotate([45, 0, 0]) block([8, 6, a_lot], center=LEFT+BEHIND+ABOVE);
    }
    module blank() {
        filament_guide();
        translate([dx_base_offset, dy_base_offset_moving_clamp, 0]) {
            block([x_base_pillar-1, 20, z_base_pillar], center=BELOW+LEFT);
        }
        inner_bumper_support = [4, 6, 15];
        outer_bumper_support = [4, 6, 13];
        top_bumper_support = [10, 6, 2];
        bumper = [10, 2, outer_bumper_support.z];
        translate([-19, dy_base_offset_moving_clamp, -8]) {
            translate([0, -inner_bumper_support.y, -2]) block(bumper, center=BELOW+RIGHT+BEHIND);
            block(inner_bumper_support, center=BELOW+LEFT);
            translate([-10, 0, -2]) block(outer_bumper_support, center=BELOW+LEFT);
            translate([0, 0, -2])  block(top_bumper_support, center=BELOW+LEFT+ BEHIND);
            
        }        
        translate([dx_pivot, -d_horn_cam_clearance/2, 0]) block([4, 6,2], center=BELOW+LEFT);
    }
    
    module shape() {
        render(convexity=10) difference() {
            blank();
            9g_servo(as_clearance=true);
            pusher_pivot (as_clearance=true);
            unprintable_overhang();
        }
    }
    
    z_printing = 12;
    rotation = 
        mode == PRINTING ? [-90, 0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_moving_clamp_body_bp, y_moving_clamp_body_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        if (show_vitamins && mode != PRINTING) {
            visualize_vitamins(visualization_moving_clamp_body) {
                9g_servo(as_clearance=false);
                pusher_pivot (as_clearance = false);
                servo_screws(as_clearance = false, recess=true);    
            }        
        }
        visualize(visualization_moving_clamp_body) shape();    
    }
}


//

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



module pusher_body() {
    dy_qc = -15;
    blank_offset = 8;
    z_locked_guide = z_guide + 2 * frame_clearance;
    dx_p_locked_guide = dx_base_offset + x_guide/2 + frame_clearance;
    dx_m_locked_guide = dx_base_offset - x_guide/2 - frame_clearance;
    dy_locked_guides = -24;
    servo_housing = [x_base_pillar + 4, 16, z_base_pillar];
    servo_rotation = [0, 0, 90];

    locked_guide = [14, 16, z_locked_guide];
    servo_joiner = [servo_housing.y, 4, abs(dz_linkage)];

    module blank() {
        rotate(servo_rotation) 
            translate([dx_base_offset, blank_offset, dz_linkage]) {
                block(servo_housing,  center=BELOW+LEFT);
            }
        translate([0, dy_locked_guides, 0]) 
            block(servo_joiner, center=BELOW+RIGHT);
        translate([dx_p_locked_guide, dy_locked_guides, -frame_clearance]) 
            block(locked_guide, center=ABOVE+RIGHT+BEHIND);
        translate([dx_m_locked_guide, dy_locked_guides, -frame_clearance]) 
            block(locked_guide, center=ABOVE+RIGHT+FRONT);
        translate([filament_translation.x, dy_locked_guides, filament_translation.z])  {
            block([32, 4, 10], center=BELOW+RIGHT);
            block([9, 4, 2.2], center=ABOVE+RIGHT);
            center_reflect([1, 0, 0]) translate([3.9, 0, 3.]) rod(d=2.4, l=4, center=RIGHT+SIDEWISE);
        }
       
    }
    
    module shape() {
        render(convexity=10) difference() {
            blank();
            translate([0, dy_pusher_servo, dz_linkage]) rotate(servo_rotation) 9g_servo(as_clearance = true);
            translate([0, dy_pusher_servo, 0]) rotate(servo_rotation) servo_screws(as_clearance=true, recess=false, upper_nutcatch_sidecut=false);
            filament_loader(as_inlet_clip_clearance=true); 
            translate([0, dy_pusher_rail_screws, 0]) rails_screws(as_clearance = true);
        }
    }
    z_printing = -dy_locked_guides;
    rotation = 
        mode == PRINTING ? [90,  0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_pusher_body_bp, y_pusher_body_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        if (show_vitamins && mode != PRINTING) {
            visualize_vitamins(visualization_pusher_body) {
                translate([0, dy_pusher_servo, dz_servo + dz_linkage]) 
                    rotate(servo_rotation) 
                        color(MIUZEIU_SERVO_BLUE) 9g_motor_sprocket_at_origin(); 
                translate([0, dy_pusher_servo, dz_linkage]) 
                    rotate(servo_rotation) servo_screws(as_clearance=false, recess=true, upper_nutcatch_sidecut=false);
            }
        }
        visualize(visualization_pusher_body) shape();  
    }
}


module rail(item=0) {
    module attachment_block() {
        render(convexity=10) difference() {
            translate([0, 0, rail_wall-frame_clearance]) 
                block([x_rail_attachment, y_rail_attachment, z_rail_attachment], center = BELOW+RIGHT+BEHIND);
            translate([0, y_rail_attachment/2, rail_wall]) {
                horizontal_rail_screws(as_clearance=true, cld=0.4);
            }
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
        //render(convexity=10) 
            difference() {
            blank();
                translate([frame_clearance, 0, -frame_clearance]) {
                block([s_dovetail+2, a_lot, z_guide+2 * frame_clearance ], center=ABOVE+BEHIND);
                hull() {
                    block([1 +frame_clearance , a_lot, z_guide + s_dovetail], center=ABOVE+BEHIND);
                    block([1+s_dovetail, a_lot, z_guide+frame_clearance], center=ABOVE+BEHIND);
                }
                translate([-2, y_rail_attachment/2 - 2, rail_wall]) {
                    vertical_rail_screws(as_clearance=true, cld=0.4);
                }
                translate([0, y_frame - y_rail_attachment, 0]) {
                    translate([-2, y_rail_attachment/2 +2, rail_wall]) {
                        vertical_rail_screws(as_clearance=true, cld=0.4);
                    }  
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

module tie(item = 0, dovetail_clearance=dovetail_clearance) {
    module shape() { 
        center_reflect([0, 0, 1]) translate([0, 0, tie_length/2]) tie_dovetail(as_clearance = false, clearance=dovetail_clearance);
        block([x_dovetail, y_dovetail, tie_length], center=BEHIND); 
    }
    
    z_printing = x_dovetail;
    rotation = 
        mode == PRINTING ? [90,  -90, 0] :
        [0, 0, 180];
    translation = 
        mode == PRINTING ? [x_tie_bp + item*dx_tie_bp, y_tie_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        visualize(visualization_tie) shape();  
    }    
}

module tie_bracket(item = 0, clearance=dovetail_clearance) {
    wall = 2;
    z_bracket = 2*z_dovetail + z_rail;
    module blank() {
        blank = [wall, y_rail_attachment, z_bracket];
        block([wall + x_dovetail, 2*y_dovetail, z_bracket], center=BEHIND);
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            center_reflect([0, 0, 1]) translate([-wall, 0, -z_rail/2 - z_dovetail]) tie_dovetail(as_clearance = true, clearance=clearance);
            translate([0, 0, -dz_rail_screws]) horizontal_rail_screws(as_clearance=true, cld=0.4); 
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  90, 90] :
        [0, 0, 180];
    translation = 
        mode == PRINTING ? [x_tie_bracket_bp + item * dx_tie_bracket_bp, y_tie_bracket_bp, z_printing] :
        [0, 0, dz_rail_screws];
    translate(translation) rotate(rotation) {
        visualize(visualization_tie_bracket) shape();  
    }
}

module tie_dovetail(as_clearance = false, clearance = dovetail_clearance) {
    if (as_clearance) {
        cl = clearance;
        cl2 = 2*clearance;
        hull() {
            translate([0, 0, z_dovetail])  block([0.1, 0.75*y_dovetail + cl2, 0.1], center=BELOW+BEHIND);
            translate([-x_dovetail, 0, z_dovetail + cl]) block([0.1, y_dovetail + cl2, 0.1], center=BELOW+BEHIND);
            block([0.01,0.375*y_dovetail + cl2, 0.1], center=BELOW+BEHIND);
            translate([-x_dovetail, 0, 0]) block([0.01, 0.5*y_dovetail + cl2, 0.1], center=BELOW+BEHIND);
        }
    } else {
        hull() {
            translate([0, 0, z_dovetail])  block([0.1, 0.75*y_dovetail, 0.1], center=BELOW+BEHIND);
            translate([-x_dovetail, 0, z_dovetail]) block([0.1, y_dovetail, 0.1], center=BELOW+BEHIND);
            block([0.01,0.375*y_dovetail, 0.1], center=BELOW+BEHIND);
            translate([-x_dovetail, 0, 0]) block([0.01, 0.5*y_dovetail, 0.1], center=BELOW+BEHIND);    
        }    
    }
}


module vertical_rail_screws(as_clearance=false, cld=0.2) {
     center_reflect([0, 1, 0]) {
        translate([0, y_rail_screw_offset, 0]) {
            if (as_clearance) {
                translate([0, 0, 25]) hole_through("M2", cld=cld, $fn=12);
            } else {
                color(STAINLESS_STEEL)
                    translate([0, 0, 6]) screw("M2x16", $fn=12);
            }
        }
    }
} 


// Assemblies
module moving_clamp() {
    translate([0, y_moving_clamp, 0]) {
        moving_clamp_body();
        one_arm_horn(servo_angle=servo_angle_moving_clamp, servo_offset_angle=az_cam);
        horn_cam(servo_angle=servo_angle_moving_clamp); 
        limit_switch_bumper();
    }
}



module fixed_clamp() {
    dy_fixed_clamp = y_frame - y_base_pillar/2; 
    translate([0, dy_fixed_clamp, 0]) {
        fixed_clamp_body();
        one_arm_horn(servo_angle=servo_angle_fixed_clamp, servo_offset_angle=az_cam);
        horn_cam(servo_angle=servo_angle_fixed_clamp);
        limit_switch_holder();
        //ptfe_clamp();
    }
}

module pusher() {
    
    translate([0, y_pusher_assembly, 0]) {
        pusher_body();
        translate([0, dy_pusher_servo, dz_linkage]) 
            one_arm_horn(servo_angle=servo_angle_pusher, servo_offset_angle=servo_offset_angle_pusher);
        translate([0, dy_pusher_servo, 0]) 
            horn_linkage(servo_angle=servo_angle_pusher, servo_offset_angle=servo_offset_angle_pusher); 
        translate([0, dy_pusher_servo, 0]) 
            linkage();
         translate([0, dy_pusher_servo, 0]) 
            adjustable_linkage();
    }
}



module rails() {  
    translate([dx_base_offset+x_guide/2, 0, 0]) rail(); 
    translate([dx_base_offset-x_guide/2, y_frame, 0])  rotate([0, 0, 180]) rail(); 
}

module frame() {

        translate([dx_base_offset + x_guide/2 + rail_wall, y_rail_attachment/2, 0]) tie_bracket();
        translate([dx_base_offset - x_guide/2 - rail_wall, y_rail_attachment/2, 0])  rotate([0, 0, 180]) tie_bracket(); 
        translate([dx_base_offset + x_guide/2 + rail_wall, y_frame - y_rail_attachment/2, 0]) tie_bracket();
        translate([dx_base_offset - x_guide/2 -rail_wall, y_frame - y_rail_attachment/2, 0])  rotate([0, 0, 180]) tie_bracket();     
}



module visualize_assemblies() {
    if (show_filament) {
        filament();
    }
    pusher();
    moving_clamp();
    fixed_clamp();
    rails();
    frame();
     filament_loader(as_holder = true, show_bow = true, show_tip = true);
     filament_loader_clip();
     if (show_legend) {
        generate_legend_for_visualization(
            visualization_infos, legend_position, font6_legend_text_characteristics());
     }
 }
  
module print_assemblies() {
    if (print_rails) {
        rail(item=0);
         if (print_both_rails) {
             rail(item=1);
         }
    }
    if (print_moving_clamp) {
        moving_clamp_body();
        horn_cam(item=0);
        limit_switch_bumper();
    }
    if (print_fixed_clamp) {
        fixed_clamp_body();
        horn_cam(item=1);
        limit_switch_holder();       
    }
    if (print_pusher) {
        pusher_body();
        horn_linkage();
        linkage();
        adjustable_linkage();
    }
    if (print_frame) {
        tie_bracket(item = 0);
        tie_bracket(item = 1);
        tie_bracket(item = 2);
        tie_bracket(item = 3);
        tie(item = 0);
        tie(item = 1);
        tie(item = 2);
        tie(item = 3);         
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


