include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>


use <PolyGear/PolyGear.scad>
use <ScadApotheka/9g_servo.scad>
use <ScadApotheka/hs_311_standard_servo.scad>
use <ScadApotheka/roller_limit_switch.scad>
use <ScadApotheka/ptfe_tubing_quick_connect.scad> 
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>



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
print_frame = true;

print_one_part = false;
part_to_print = "frame"; // [servo_base, horn_cam, filament_guide, rails, pusher_body, collet, clip, horn_linkage, linkage, tie_bracket, tie, limit_switch_holder]


/* [Show] */
servo_base = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
pusher_body = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
collet = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
clip = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_cam = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
filament_guide = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
rails = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
horn_linkage = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
linkage = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
tie_bracket  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
tie =  1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
limit_switch_holder  =  1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

/* [Animation ] */
servo_angle_moving_clamp = 0; // [0:180]
servo_angle_fixed_clamp = 0; // [0:180]
servo_angle_pusher  = 0; // [0:180]
servo_offset_angle_pusher  = 110; // [0:360]


/* [Base Design] */
dz_servo = 3.5;
x_base_pillar = 34;
z_base_pillar = 8.8;
z_base_joiner = 3.8;
x_base_offset = -5;

/* [Cam Design] */
od_cam = 11;
dz_cam = 0.6; // [0: 0.1 : 3]
ay_cam = 10; // [0: 1: 20]
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
rail_wall = 2;
dz_rail_screws = -4;

/* [Dove Tail Design] */
x_dovetail = 4;
y_dovetail = 6;
z_dovetail = 4;
dovetail_clearance = 0.25;
tie_length = 30;

/* [Linkage Design] */
az_horn_linkage_pivot = 20;
r_horn_linkage = 14;
linkage_length = 26;


/* [Limit Switch Holder Design] */
dx_limit_switch_holder = -17.5; // [-30:0]
dz_limit_switch_holder = -11; // [-30:0]
dx_top_clamp = -5.2; // [-6: 0.1: -5]
dy_top_clamp = 7; // [-10:10]
dz_top_clamp = -16; // [-20:-10]

/* [Build Plate Layout] */
x_rail_bp = 30; 
y_rail_bp = 0; 
dx_rail_bp = 15;

x_servo_base_bp = 0;
y_servo_base_bp = 0;
dx_servo_base_bp = -50;

x_filament_guide_bp = 0; 
y_filament_guide_bp = 20;
dx_filament_guide_bp = -50; 

x_horn_cam_bp = 0;
y_horn_cam_bp = -15;
dx_horn_cam_bp = -15;

x_pusher_body_bp = 0;
y_pusher_body_bp =40;

x_collet_bp  =-40;
y_collet_bp  = 40;

x_clip_bp  =-60;
y_clip_bp  =40;

x_horn_linkage_bp = 0;
y_horn_linkage_bp = 55;

x_linkage_bp = -30;
y_linkage_bp = 50;

x_tie_bracket_bp = x_rail_bp;
y_tie_bracket_bp = -30;
dx_tie_bracket_bp = dx_rail_bp;

x_tie_bp = x_rail_bp;
y_tie_bp = -50;
dx_tie_bp = dx_rail_bp;

x_limit_switch_holder_bp = -20; 
y_limit_switch_holder_bp = -30;

module end_of_customization() {}

/* Linkage kinematicts */

// Move servo origin
dx_origin = 0;
dy_origin = 8;
//translate([dx_origin, dy_origin, 0]) color("yellow") can(d=1, h=a_lot);

a_horn_pivot = servo_angle_pusher + servo_offset_angle_pusher + az_horn_linkage_pivot;
dx_horn_pivot = dx_origin + cos(a_horn_pivot) * r_horn_linkage;
dy_horn_pivot = dy_origin + sin(a_horn_pivot) * r_horn_linkage; 
//translate([dx_horn_pivot, dy_horn_pivot, 0]) color("blue") can(d=1, h=a_lot);

 linkage_angle = acos(-dx_horn_pivot/linkage_length); 

dx_pivot = dx_horn_pivot + cos(linkage_angle) * linkage_length;
dy_pivot = dy_horn_pivot + sin(linkage_angle) * linkage_length; 
//translate([dx_pivot, dy_pivot, 0]) color("green") can(d=1, h=a_lot);
   
dx_linkage_midpoint = dx_horn_pivot/2;
dy_linkage_midpoint = (dy_pivot+dy_horn_pivot)/2;
//translate([dx_linkage_midpoint, dy_linkage_midpoint, 0]) color("brown") can(d=1, h=a_lot);
// But translation is applied after rotation, so dy must be adjusted;
dx_linkage = dx_linkage_midpoint;
dy_linkage = dy_horn_pivot- dy_origin + sin(linkage_angle) * linkage_length/2;

y_moving_clamp = dy_pivot +10;

s_dovetail = s_guide_dovetail + 2*frame_clearance; 

x_rail = 1 + s_guide_dovetail + 1 + rail_wall;
z_rail = z_guide + s_guide_dovetail + 2 * rail_wall;

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
   
visualization_pusher_body = 
    visualize_info(
        "Pusher Body", PART_8, show(pusher_body, "pusher_body") , layout, show_parts);     
        
visualization_collet = 
    visualize_info(
        "Quick Connect Collet", PART_9, show(collet, "collet") , layout, show_parts);       
     
  visualization_clip = 
    visualize_info(
        "Quick Connect Clip", PART_10, show(clip, "clip") , layout, show_parts);         
       
visualization_tie = 
    visualize_info(
        "Tie", PART_11, show(tie, "tie") , layout, show_parts);     
        
visualization_tie_bracket = 
    visualize_info(
        "Tie Bracket", PART_2, show(tie_bracket, "tie_bracket") , layout, show_parts);           
        
 if (mode ==  ASSEMBLE_SUBCOMPONENTS) {     
    filament();
    pusher();
    moving_clamp();
    fixed_clamp();
    rails();
    frame();
     
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
         limit_switch_holder();         
     }
     if (print_pusher) {
         pusher_body();
         collet();
         clip();
         horn_linkage();
         linkage();
     }
     if (print_frame) {
         tie_bracket(item = 0);
         tie_bracket(item = 1);
         tie_bracket(item = 2);
         tie_bracket(item = 3);
         tie(item = 0);
         //tie(item = 1);
         //tie(item = 0);
         //tie(item = 1);         
     }
 }
 
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
        filament_length = y_frame + 40;
        translate(filament_translation + [0, -20, 0]) 
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


// Assemblies


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
        limit_switch_holder();
    }
}

module pusher() {
    y_pusher_assmebly = y_guide/2;
    translate([0, y_pusher_assmebly, 0]) {
        pusher_body();
        one_arm_horn(servo_angle=servo_angle_pusher, servo_offset_angle=servo_offset_angle_pusher);
        horn_linkage(servo_angle=servo_angle_pusher, servo_offset_angle=servo_offset_angle_pusher); 
        linkage();
    }
}


module rails() {  
    translate([x_base_offset+x_guide/2, 0, 0]) rail(); 
    translate([x_base_offset-x_guide/2, y_frame, 0])  rotate([0, 0, 180]) rail(); 
}

module frame() {

        translate([x_base_offset + x_guide/2 + rail_wall, y_rail_attachment/2, 0]) tie_bracket();
        translate([x_base_offset - x_guide/2 - rail_wall, y_rail_attachment/2, 0])  rotate([0, 0, 180]) tie_bracket(); 
        translate([x_base_offset + x_guide/2 + rail_wall, y_frame - y_rail_attachment/2, 0]) tie_bracket();
        translate([x_base_offset - x_guide/2 -rail_wall, y_frame - y_rail_attachment/2, 0])  rotate([0, 0, 180]) tie_bracket();     
}


// Parts


module limit_switch_holder() {
    base_thickness = 2;
    dx_screw = -2.6;
    module shape() {
        
        
        color(PART_25) 
            render(convexity = 10) difference() {
                union() { 
                    block([5, 10, 5], center = BELOW+BEHIND);
                    translate([0, 3, 0]) block([base_thickness, 15, 8], center = BELOW+BEHIND+RIGHT);
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
        translate([dx_top_clamp, dy_top_clamp, dz_top_clamp])
            rotate([0, 90, 90]) nsrsh_top_clamp(
                show_vitamins=show_vitamins, 
                right_handed = false,
                alpha=1, 
                thickness=base_thickness, 
                use_dupont_pins = true);   
    }
    rotation = 
        mode == PRINTING ? [0,  90, 0] :
        [0,  0, 0];
    translation = 
        mode == PRINTING ? [x_limit_switch_holder_bp, y_limit_switch_holder_bp, , 0]:
        [dx_limit_switch_holder, 0, dz_limit_switch_holder];
    translate(translation) rotate(rotation) shape();
}

module tie(item = 0, dovetail_clearance=dovetail_clearance) {
    module shape() { 
        center_reflect([0, 0, 1]) translate([0, 0, tie_length/2]) tie_dovetail(as_clearance = false, clearance=dovetail_clearance);
        block([x_dovetail, y_dovetail, tie_length], center=BEHIND); 
    }
    
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, 180];
    translation = 
        mode == PRINTING ? [x_tie_bp, y_tie_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        visualize(visualization_tie) shape();  
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
            translate([0, 0, -dz_rail_screws]) rail_screws(as_clearance=true, cld=0.4); 
        }
    }
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, 180];
    translation = 
        mode == PRINTING ? [x_tie_bracket_bp, y_tie_bracket_bp, z_printing] :
        [0, 0, dz_rail_screws];
    translate(translation) rotate(rotation) {
        visualize(visualization_tie_bracket) shape();  
    }
}

module pusher_body() {
    dy_qc = -15;
    quick_connect_translation = filament_translation + [0, -21 + dy_qc, 0];
    blank_offset = 8;
    x_locked_guide = x_guide + 2 * frame_clearance;
    z_locked_guide = z_guide + 2 * frame_clearance;
    dx_p_locked_guide = x_base_offset + x_guide/2 + frame_clearance;
    dx_m_locked_guide = x_base_offset - x_guide/2 - frame_clearance;;
    module blank() {
        translate(quick_connect_translation) rotate([-90, 0, 0]) quick_connect_body();
        translate([x_base_offset, blank_offset, 0]) block([x_base_pillar, 14, z_base_pillar], center=BELOW+LEFT);
        translate([dx_p_locked_guide, blank_offset, -frame_clearance]) block([12, 14, z_locked_guide], center=ABOVE+LEFT+BEHIND);
        translate([dx_m_locked_guide, blank_offset, -frame_clearance]) block([12, 14, z_locked_guide], center=ABOVE+LEFT+FRONT);
        hull() {
           #translate([x_base_offset, -6, 0]) block([30, 0.1, 4], center=BELOW);
           translate(quick_connect_translation+[0, 14.5, 0])  rod(d=11., l=0.1, center=SIDEWISE+RIGHT);
        }
    }
    module cutout_for_printablility() {
        // Alter roof (when printing in the minus y direction) to remove unsupported, but also unnecessary material
        hull() {
            translate([-6, -6.1, 1]) block([8.5, 5, 5.5], center=RIGHT+FRONT+BELOW);
            translate([-9, -3, 1]) block([14, 5.5, 5.5], center=RIGHT+FRONT+BELOW);
        }
    }
    module shape() {
        render(convexity=10) difference() {
            blank();
            servo_base(as_clearance = true);
            filament(as_clearance = true, clearance_is_tight=false);
            translate(filament_translation) rod(d=1, taper=10, l=10-dy_qc, center=SIDEWISE+LEFT);
            cutout_for_printablility();
        }
    }
    z_printing = blank_offset;
    rotation = 
        mode == PRINTING ? [-90,  0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_pusher_body_bp, y_pusher_body_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        if (show_vitamins && mode != PRINTING) {
            visualize_vitamins(visualization_pusher_body) translate([0, 0, dz_servo]) 9g_motor_sprocket_at_origin(); ; 
        }
        visualize(visualization_pusher_body) shape();  
    }
}

module collet() {
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_collet_bp, y_collet_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        visualize(visualization_collet) quick_connect_collet(tubing_allowance=0);
    }      
}

module clip() {
    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, 0];
    translation = 
        mode == PRINTING ? [x_clip_bp, y_clip_bp, z_printing] :
        [0, 0, 0];
    translate(translation) rotate(rotation) {
        visualize(visualization_clip) quick_connect_c_clip(orient_for_build=true);
    }      
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

    z_printing = 0;
    rotation = 
        mode == PRINTING ? [0,  0, 0] :
        [0, 0, linkage_angle];    
    translation = 
        mode == PRINTING ? [x_linkage_bp, y_linkage_bp, z_printing] :
        [dx_linkage, dy_linkage, 8];  
    translate(translation) rotate(rotation) visualize(visualization_linkage) shape();  
}



module rail_screws(as_clearance=false, cld=0.2) {
    if (as_clearance) {
        center_reflect([0, 1, 0]) 
            translate([5, y_rail_screw_offset, dz_rail_screws]) 
                rotate([0, 90, 0]) 
                    hole_through("M2", l=20, cld=cld, $fn=12);
    } else {
        assert(false);
    }
} 

module rail(item=0) {
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

module rail_riders() {
    center_reflect([1, 0, 0]) translate([x_guide/2, 0, 0]) {
        hull() {
            block([1, y_guide, z_guide + s_guide_dovetail], center=ABOVE+BEHIND);
            block([1+s_guide_dovetail, y_guide, z_guide], center=ABOVE+BEHIND);   
        }
    }
}




module filament_guide(item=0, include_pusher_pivot=false) {
    cam_clearance = 1.5;
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
            rail_riders();
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
            * translate([0, 0, z_guide]) block([16, 8, 8], center=ABOVE+BEHIND); 
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


module horn_cam(item=0, servo_angle=0, servo_offset_angle=0, clearance=0.5) {
    h_above =2.2;
    h_barrel = 3.77;
    h_arm = 1.3; 
    h_below = 2;
    h = h_above + h_arm + h_below;
    dz_horn_engagement = -1;
    dz_horn = dz_horn_engagement -h_barrel + h_arm + h_below;
    dx_print_base = od_cam/2;
    module cam_blank() {
        render(convexity=10) difference() {
            hull() {
                translate([0, 0, 0]) can(d=od_cam, h=h, center=ABOVE);
                translate([dx_print_base, 0, 0]) block([2, 8, h], center=BEHIND+ABOVE);
            }
            translate([0, 0, dz_horn])  one_arm_horn(as_clearance=true);
             translate([0, 0, dz_horn-clearance])  one_arm_horn(as_clearance=true);
            hull() {
                    translate([0, 0, dz_horn])  rotate([0, 0, 180]) one_arm_horn(as_clearance=true);
                    translate([-5, 0, dz_horn])  rotate([0, 0, 180]) one_arm_horn(as_clearance=true);
            }
            can(d=2.5, h=a_lot); //Screw 
            // Screw used as filament stop:
            translate([dx_print_base-1.7, -3, 25]) hole_through("M2", $fn=12, cld=0.2); // Tight fit, use screw to tap out hole to avoid using a nut.
        }
    }        
    module shape() {
        rotate([0, 0, -az_cam]) {
            render(convexity=10) difference() {
                rotate([0, 0, az_cam])  cam_blank();
                // cam_surface
               translate([0, 0, dz_cam]) rotate([0, ay_cam, 0]) plane_clearance(BELOW); 
            }
        }
    }
    z_printing = dx_print_base;
    rotation = 
        mode == PRINTING ? [0, 90, 0] :
        [0, 0, servo_angle + servo_offset_angle + az_cam];
    translation = 
        mode == PRINTING ? [x_horn_cam_bp + item*dx_horn_cam_bp, y_horn_cam_bp, z_printing] :
        [0, 0, h_barrel-dz_horn_engagement-h_arm-h_below];
    translate(translation) rotate(rotation) visualize(visualization_horn_cam) shape();   
}

module servo_screws(as_clearance = true) {
    if (as_clearance) {
        translate([8.5, 0, 25]) hole_through("M2", cld=0.4, $fn=12);
        translate([-19.5, 0, 25]) hole_through("M2", cld=0.4, $fn=12);
    } else {
        assert(false);
    }    
}


module servo_base(item=0, visualization = visualization_servo_base, as_clearance=false) {
    module cavity() {
        translate([0, 0, dz_servo]) 9g_motor_sprocket_at_origin();
        servo_screws(as_clearance = true);
        translate([x_base_offset, 0, 0]) 
            center_reflect([1, 0, 0]) 
                translate([25, 0, 0]) 
                    rail_screws(as_clearance=true, cld=0.2); // Tight fit, will hold screws        
    }
    module shape() {
        render(convexity=10) difference() {
            union() {
                translate([x_base_offset, 0, 0]) block([x_base_pillar, 10, z_base_pillar], center=BELOW);
                block([14, 14, z_base_joiner], center=BELOW);
            } 
            cavity();
        }
    }
    if (as_clearance) {
        cavity();
    } else {
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
}

