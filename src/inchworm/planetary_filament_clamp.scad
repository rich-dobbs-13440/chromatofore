include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
use <ScadApotheka/m2_helper.scad>
include <nutsnbolts-master/cyl_head_bolt.scad>
include <nutsnbolts-master/data-metric_cyl_head_bolts.scad>
use <PolyGear/PolyGear.scad>
use <ScadApotheka/9g_servo.scad>


a_lot = 200;
d_filament = 1.75 + 0.;
d_filament_with_clearance = d_filament + 0.75;  // Filament can be inserted even with elephant footing.
od_ptfe_tube = 4 + 0;
id_ptfe_tube = 2 + 0;
d_ptfe_insertion = od_ptfe_tube + 0.5;
d_m2_nut_driver = 6.0 + 0;
d_number_ten_screw = 4.7 + 0;
od_three_eighths_inch_tubing = 9.3 + 0;
od_one_quarter_inch_tubing = 6.5 + 0;

NEW_DEVELOPMENT = 0 + 0;
DESIGNING = 1 + 0;
MESHING_GEARS = 2 + 0;
ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;



/* [Output Control] */

mode = 2; // [0:"New development, hide other parts", 1:"Designing, no rotation or translation", 2:"Meshing gears", 3: "assembly", 4: "Printing"]

function layout_from_mode(mode) = 
    mode == NEW_DEVELOPMENT ? "hidden" :
    mode == DESIGNING ? "as_designed" :
    mode == MESHING_GEARS ? "mesh_gears" :
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";
    
show_parts = true;
show_vitamins = true;
show_filament = true;
filament_length = 50; // [1 : 1 : 99.9]
show_drive_gear_construction_lines = false;
assert_for_not_implemented = false;
explode  = false;  
    
/* [Visibility] */

hub = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
spokes = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
rim = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
clamp_gear  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
drive_gear = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
hub_shaft_retainer = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
drive_gear_shaft_retainer = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
drive_shaft = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
shaft_bearing = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
drive_shaft_base = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
transmission_gear = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

include_drive_gear_spacer = true;
include_drive_shaft_side = true;
include_exit_side = false;
  
screw_lift = 0; // [-.1 : .1 : 1]

/* [Hub Design] */
r_hub = 7;
s_nut_block = 5;
h_hub = s_nut_block;
r_nut_cut_clamp_screw = 3.5;
r_hub_attachment_screw = 3;

/* [Hub Shaft Retainer Design] */
od_hub_shaft_retainer = 2*r_hub + 4;

/* [Drive Gear Retainer Design] */
od_driver_gear_retainer = 2*r_hub + 2;

/* [Clamp Gearing Design] */
module_clamp_gear = 1.2;
n_teeth_clamp_gear = 14; // [9, 10, 11, 12, 13. 14]
cone_angle_clamp_gear = 45; // [-90:5:85]
tooth_width_clamp_gear = 7;
clamp_slide_clearance = 0.2;
range_of_rotation_clamp_gear = 500;
include_outer_hub_clamp_gear = false;
 h_outer_hub = 0;
 h_inner_hub_clamp_gear = 6.2;  // [0 : 0.1 : 10]
 
 
 
/* [Drive Gearing Design] */
//The tooth width needs to be wide enough that the
// clamp bearing overlaps the slide, but it can't
// be too wide or the the outer ptfe won't engage the
// the outer bearing

tooth_width_drive_gear = 4;
cone_angle_drive_gear = 90 - cone_angle_clamp_gear;
module_drive_gear = module_clamp_gear;
h_base_drive_gear = 2; 



/* [Slide Design] */

l_slide_screws = 20; // [8, 10, 12, 16, 20]
// Make it big enough that the overlaps the drive gear id so it will extend into the clamp gear
h_inner_bearing = 0.5;
clamping = 0.2;
dx_clamp_screw = d_filament/2 - clamping + screw_lift;



/* [Frame Design] */
frame_slide_tubing = "1/4 inch PE"; // ["1/4 inch PE",  "3/8 inch PE"]
od_frame_tubing = 
    frame_slide_tubing == "1/4 inch PE" ? od_one_quarter_inch_tubing :
    frame_slide_tubing == "3/8 inch PE" ? od_three_eighths_inch_tubing :  
    assert(false);
frame_rod = "#10"; //"#8", "#10", "M3", "M4", "M5"]
od_frame_rod = // Includes clearance
    frame_rod == "#8" ? 4.37 : 
    frame_rod == "#10" ? 5.16:
    frame_rod == "M3" ? 3.5: 
    frame_rod == "M4" ? 4.5:
    frame_rod == "M5" ? 5.5:
    assert(false);

spoke_to_gear_clearance = 2;
spoke_wall = 2;
r_spoke = 24;
h_spoke = 4;  // [2:8]
y_spoke_base = 4; // [0:10]
xs_dt_spokes = 2;
h_rim = 8;
y_rim_connector = 22.0; // [21: 0.1 : 23]
rim_wall = 2;

dz_shaft_base = 40;  // [10:70]
h_base = 6;

/* [Drive Shaft Design] */
gear_height_shaft = 70;
gear_module_shaft = 0.8;
n_teeth_shaft = 9;


/* [Servo Transmission  Design] */
servo_transmission_gear_height = 5;
gear_module_servo_transmission = 1.4;
az_servo = 180; // [0:360]
z_servo = -10; // [0: 100]
range_of_rotation_servo = 135;

/* [Build Plate Layout] */

dx_hub_bp  = -50; // [-100: 100]
dy_hub_bp  = -10; // [-100: 100]

dx_clamp_gear_bp = 12; // [-100: 100]
dy_clamp_gear_bp = -18; // [-100: 100]

dx_drive_gear_bp = 25; // [-100: 100]
dy_drive_gear_bp = 10; // [-100: 100]

dx_drive_shaft_bp = 0; // [-100: 100]
dy_drive_shaft_bp = -15; // [-100: 100]

dx_hub_shaft_retainer_bp = -25;  // [-100: 100]
dy_hub_shaft_retainer_bp = 10;  // [-100: 100]

dx_rim_bp = 50;  // [-100: 100]
dy_rim_bp = 36;  // [-100: 100]

dx_base_bp = -40;  // [-100: 100] 
dy_base_bp = 30;  // [-100: 100]

dx_servo_transmission_gear_bp = -30;  // [-100: 100]
dy_servo_transmission_gear_bp = -35;  // [-100: 100]

dx_drive_gear_shaft_retainer_bp  = 0;  // [-100: 100]
dy_drive_gear_shaft_retainer_bp  = -32;  // [-100: 100]

dx_drive_shaft_bearing_bp   = 0;  // [-100: 100]
dy_drive_shaft_bearing_bp   = 50;  // [-100: 100]

module end_of_customization() {}



/* Visualization  */ 

layout = layout_from_mode(mode);
//echo("mode", mode, "layout", layout);

visualization_hub = 
    visualize_info(
        "Hub", PART_1, hub, layout, show_parts); 

visualization_spokes = 
    visualize_info(
        "Spoke", PART_2, spokes, layout, show_parts); 

visualization_clamp_gear = 
    visualize_info(
        "Clamp Gear", PART_3, clamp_gear, layout_from_mode(layout), show_parts); 

//visualization_slide = 
//    visualize_info(
//        "Screw Slide", PART_4, slide, layout_from_mode(DESIGNING), show_parts); 

visualization_drive_gear = 
    visualize_info(
        "Drive Gear", PART_5, drive_gear, layout_from_mode(layout), show_parts); 

visualization_hub_shaft_retainer = 
    visualize_info(
        "Hub Shaft Retainer", PART_6, hub_shaft_retainer, layout_from_mode(layout), show_parts);

visualization_drive_gear_shaft_retainer = 
    visualize_info(
        "Drive Gear Shaft Retainer", PART_7, drive_gear_shaft_retainer, layout_from_mode(layout), show_parts);
    
visualization_drive_shaft = 
    visualize_info(
        "Clamp Drive Shaft", PART_8, drive_shaft, layout_from_mode(layout), show_parts);
           
visualization_rim =         
    visualize_info(
        "Gear Retention Rim", PART_9, rim, layout_from_mode(layout), show_parts);
        
visualization_drive_shaft_base = 
    visualize_info(
        "Drive Shaft Base", PART_10, drive_shaft_base, layout_from_mode(layout), show_parts);     
  
visualization_drive_shaft_bearing =         
    visualize_info(
        "Drive Shaft Bearing", PART_11, shaft_bearing, layout_from_mode(layout), show_parts);
        
        
visualization_servo_transmission_gear =         
    visualize_info(
        "Drive Shaft Bearing", PART_12, transmission_gear, layout_from_mode(layout), show_parts);
        
/* Gear Calculations */

function shallow_bevel_gear_od(teeth, gear_module, cone_angle_degrees, tooth_width) = 
    teeth * gear_module * sin(cone_angle_degrees);

function shallow_bevel_gear_id(teeth, gear_module, cone_angle_degrees, tooth_width) =
    shallow_bevel_gear_od(teeth, gear_module, cone_angle_degrees, tooth_width) - 2 * tooth_width;
    
function shallow_bevel_gear_md(teeth, gear_module, cone_angle_degrees, tooth_width) = 
    shallow_bevel_gear_od(teeth, gear_module, cone_angle_degrees, tooth_width) - tooth_width;


function teeth_for_od_shallow_bevel_gear(od, gear_module, cone_angle_degrees) =
    ceil(od/(gear_module * sin(cone_angle_degrees)));
    
function teeth_for_id_bevel_gear(id, gear_module, cone_angle_degrees, tooth_width) = 
   ceil((id + 2*sin(cone_angle_degrees) * tooth_width) / gear_module);
    


// Calcs for values that need to be shared to calculate displacements
id_clamp_gear = (n_teeth_clamp_gear - 2) * module_clamp_gear;
    
od_clamp_gear  = (n_teeth_clamp_gear + 2) * module_clamp_gear;
    
md_clamp_gear  = (n_teeth_clamp_gear) * module_clamp_gear;

clamp_gear_z_offset = bevel_gear_z_offset(n_teeth_clamp_gear, m=module_clamp_gear, cone_angle=cone_angle_clamp_gear);

teeth_adjustment_drive_gear = 0;

target_id_drive_gear = 2*(r_hub + 4); //od_spacer;

n_teeth_drive_gear = 
        teeth_for_id_bevel_gear(
            target_id_drive_gear, 
            module_drive_gear, 
            cone_angle_drive_gear, 
            tooth_width_drive_gear) ;

id_drive_gear = shallow_bevel_gear_id(
    n_teeth_drive_gear, module_drive_gear, cone_angle_drive_gear, tooth_width_drive_gear);
    
od_drive_gear  = shallow_bevel_gear_od(
    n_teeth_drive_gear, module_drive_gear,  cone_angle_drive_gear, tooth_width_drive_gear);
    
md_drive_gear  = shallow_bevel_gear_md(
    n_teeth_drive_gear, module_drive_gear,  cone_angle_drive_gear, tooth_width_drive_gear);
  

drive_gear_z_offset = bevel_gear_z_offset(n_teeth_drive_gear, m=module_drive_gear, cone_angle=cone_angle_drive_gear);

flange_screw_offset = ceil(((od_drive_gear + 4)/2)/sqrt(2));
echo("flange_screw_offset", flange_screw_offset);


//r_spoke = ceil(od_drive_gear/2 + d_number_ten_screw/2 - r_hub + spoke_to_gear_clearance); // [0 : 20]

minimum_r_spoke = od_drive_gear/2 + d_number_ten_screw/2 + spoke_wall + spoke_to_gear_clearance;
echo("minimum_r_spoke", minimum_r_spoke);
assert(r_spoke > minimum_r_spoke);

echo("n_teeth_drive_gear", n_teeth_drive_gear);
echo("Clamp drive gear - id",  id_drive_gear);
echo("md", md_drive_gear);
echo("od", od_drive_gear);
echo("target_id_drive_gear", target_id_drive_gear);
if (show_drive_gear_construction_lines) {  
    color(COPPER) can(d=target_id_drive_gear, hollow=target_id_drive_gear-1, h=5);     
    color(BRONZE) can(d=id_drive_gear, hollow=id_drive_gear-0.5, h=5);
    color(SILVER) can(d=md_drive_gear, hollow=md_drive_gear-0.5, h=5);  
    color(GOLD) can(d=od_drive_gear, hollow=od_drive_gear-0.5, h=5);     
   
}    

dz_drive_gear_inner_hub = id_clamp_gear/2 ; 

dz_top_of_drive_gear = 
    md_clamp_gear/2 + h_base_drive_gear + module_drive_gear/sin(cone_angle_drive_gear);


id_shaft_gear = (n_teeth_shaft - 2) * gear_module_shaft;
    
od_shaft_gear   = (n_teeth_shaft + 2) * gear_module_shaft;
    
md_shaft_gear   = (n_teeth_shaft) * gear_module_shaft;

md_shaft_bearing = od_shaft_gear + 4;
md_shaft_bearing_gear   = (n_teeth_shaft) * gear_module_servo_transmission;

planetary_gear_ratio = n_teeth_drive_gear/n_teeth_clamp_gear;
echo("planetary_gear_ratio", planetary_gear_ratio);
range_of_rotation_drive_shaft = range_of_rotation_clamp_gear/planetary_gear_ratio; 
echo("range_of_rotation_drive_shaft", range_of_rotation_drive_shaft);


required_gear_ratio_servo_transmission = range_of_rotation_drive_shaft / range_of_rotation_servo;
echo("required_gear_ratio_servo_transmission", required_gear_ratio_servo_transmission);
n_teeth_servo_transmission = ceil(n_teeth_shaft * required_gear_ratio_servo_transmission);
echo("n_teeth_servo_transmission", n_teeth_servo_transmission);
md_servo_transmission = n_teeth_servo_transmission * gear_module_servo_transmission;
echo("md_servo_transmission", md_servo_transmission);

/*  Rendering order */

// Render from inside to outside, not by part number, for use with ghostly view


filament(as_clearance=false);
//pure_vitamin_slide(center=BEHIND); 

//alt_drive_gear_retainer();

clamp_gears(show_vitamins=show_vitamins, include_outer_hub = include_outer_hub_clamp_gear);
hub(show_vitamins=show_vitamins);
drive_shaft(show_vitamins = true);
drive_gear(show_vitamins=show_vitamins);
drive_gear_shaft_retainer();
hub_shaft_retainer(show_vitamins=show_vitamins);
spokes();
rim();
drive_shaft_bearing();
drive_shaft_base();
servo_transmission_gear();





/*   Mocks and separate vitamains */ 

module filament(as_clearance=false) {
    d = as_clearance ? d_filament_with_clearance : d_filament;
    alpha = as_clearance ? 0 : 1;
    if (as_clearance) {
        can(d=d, h=a_lot, $fn=12); 
    } else {
        hide = (mode == PRINTING) || (mode==DESIGNING); 
        if (show_filament && !hide) {
            color("red", alpha) {
                can(d=d, h=filament_length, $fn=12);
            }
        }
    }  
}


module clamp_screw_nut(as_clearance=false) {
    if (as_clearance) {
        rotate([0, 90, 0]) {
            hole_through("M2", $fn = 12);
        } 
        translate([-r_nut_cut_clamp_screw, 0, 0]) {
            rotate([0, 90, 0]) {  //[0, -90, 180]
                tuned_M2_nutcatch_side_cut(as_clearance=true);
            } 
        }
//        translate([-r_nut_cut_clamp_screw - 3.6, 0, 0]) 
//            rod(d = d_ptfe_insertion, l = a_lot, center=BEHIND);
        
    } else {
        color(BLACK_IRON) {
            translate([-r_nut_cut_clamp_screw, 0, 0]) rotate([0, -90, 180]) {
                 nut("M2");
            }
        }          
    }            
}



module pure_vitamin_slide(as_clearance = false, center = ABOVE, show_for_design = false) {
    
    m2_nut_height = 1.6;
    m2p5_nut_height = 2;
    h_outer_ptfe_bearing = 
        l_slide_screws 
        + (d_filament/2 - clamping)
        -r_hub 
        -h_inner_bearing
        -m2_nut_height 
        -m2p5_nut_height
        -m2_nut_height; 
    // Origin of stack is going to be at the foot of the screw
    dz_screw = 0;
    dz_inner_bearing = dz_screw + od_hub_shaft_retainer/2 - (d_filament/2 - clamping);
    dz_nut_1 = dz_inner_bearing + h_inner_bearing;
    dz_nut_2 = dz_nut_1 + m2_nut_height;
    dz_nut_3 = dz_nut_2 + m2p5_nut_height;
    dz_ptfe_outer = dz_nut_3  + m2_nut_height;
    
    use_pfte_inner_bearing = false;
    d_inner_bearing = use_pfte_inner_bearing ? d_ptfe_insertion : 2.25;
    inner_bearing_color = use_pfte_inner_bearing ? PTFE : "gray";
    
    //echo("h_outer_ptfe_bearing", h_outer_ptfe_bearing);
    module up(dz, h) {
        translate([0, 0, dz + h]) children();
    }
    
    module stack() {
        up(dz_screw, l_slide_screws) color(BLACK_IRON) screw(str("M2x", l_slide_screws), $fn=12);
        up(dz_inner_bearing, h_inner_bearing) color(inner_bearing_color) can(d=d_inner_bearing, h=h_inner_bearing, center=BELOW);
        up(dz_nut_1,  m2_nut_height) color(BLACK_IRON) nut("M2");
        up(dz_nut_2, m2p5_nut_height) color(STAINLESS_STEEL) nut("M2.5");
        up(dz_nut_3, m2_nut_height) color(BLACK_IRON) nut("M2");
        up(dz_ptfe_outer, h_outer_ptfe_bearing) color(PTFE) can(d=od_ptfe_tube, h=h_outer_ptfe_bearing, center=BELOW);
    }
    
    module cavity() { 
        //can(d=d_inner_bearing, h=l_slide_screws, center=ABOVE);
        translate([0, 0, dz_inner_bearing]) hull() {
            //up(dz_nut_1, l_slide_screws) can(d=d_inner_bearing, h=l_slide_screws, center=BELOW);
             rotate([180, 0, 0]) nutcatch_parallel("M2", clh = a_lot, clk=0.2);
             translate([0, 0, m2_nut_height]) rotate([180, 0, 0]) nutcatch_parallel("M2.5", clh = a_lot, clk=0.4);
        }        
    }
    rotation = 
        center == ABOVE ? [0, 0, 0] :
        center == BELOW ? [180, 0, 0] :
        center == FRONT ? [0, -90, 0] :
        center == BEHIND ? [0, 90, 0] :
        assert(false);
    
    translation = 
            as_clearance ? [0, 0, 0] :
            mode == PRINTING ? [0, 0, 0] : // Doesn't matter, since we don't print this
            mode == DESIGNING ? [0, 0, 0] :
            mode == MESHING_GEARS ? [0, 0, 14.2] : // //[, 0, 0] :
            mode == NEW_DEVELOPMENT ? [0, 0, 0] :
            assert(false, "Not determined");  
    
    hide = (mode == PRINTING) || (mode==DESIGNING); 
    translate(translation) {
        rotate(rotation) {
            if (as_clearance) {
                cavity();
            } else {
                if (show_vitamins && !hide) {
                    stack();
                } else if (show_vitamins && show_for_design && mode == DESIGNING) {
                    stack();
                }
            }
        }
    }
}


/*   Implementation */ 

module hub(as_clearance = false, show_vitamins=true) {
    
    module cutouts() {
        rotate([0, 0, 180]) clamp_screw_nut(as_clearance=true);
        filament(as_clearance=true);        
    }
    
    if (as_clearance) {
        can(d = 2 * r_hub, h = a_lot);  
    } else {  
        rotation = mode == PRINTING ? [180, 0, 0] : [0, 0, 0];
        translation = mode == PRINTING ? [dx_hub_bp, dy_hub_bp, h_hub/2] : [0, 0, 0]; 
    
        translate(translation) {
            rotate(rotation) {
                if (show_vitamins) {
                    visualize_vitamins(visualization_hub) {
                        rotate([0, 0, 180]) clamp_screw_nut(as_clearance=false);
                    }
                }
                visualize(visualization_hub) {
                    render(convexity=10) difference() {
                        can(d = 2 * r_hub, h = h_hub);
                        triangle_placement(r=0) {
                            cutouts();
                        }
                    }
                }
            }
        }
    }
}

module spokes(as_clearance=false) {
    dz_printing = h_spoke;
    dz = h_hub/2 + 3.75 - h_spoke;
    z_dovetail = as_clearance ? 10: h_spoke;
    module shape() {
        difference() {
            rotate([0, 0, 60]) triangle_placement(r=r_hub-1) scale([xs_dt_spokes, 1, 1]) rotate([0, 0, 45]) block([5, 5, z_dovetail], center=ABOVE); 
            hub(as_clearance=true);
        }
        triangle_placement(r=0) {
            rotate([0, 0, 60]) {
                render(convexity=10) difference() {
                    hull() {
                        translate([r_hub+1, 0, 0]) block([1, y_spoke_base, h_spoke], center=FRONT+ABOVE);
                        translate([r_spoke, 0, 0]) frame_rider(as_clearance = false, on_rod = true, h = h_spoke);
                    }
                    translate([r_spoke, 0, 0])  frame_rider(as_clearance=true, on_rod=true);
                }
            }
        }
    }
    if (as_clearance) {
        translation =  [0, 0, h_rim/2];
        rotation = [180, 0, 0];
        translate(translation)  rotate(rotation) shape();
    } else {
        // Spokes move with hub and rime
        rotation = [180, 0, 0];
        translation = mode == PRINTING ? [dx_rim_bp, dy_rim_bp, dz_printing] : [0, 0, h_rim/2]; 
        translate(translation) {
            rotate(rotation) {
                visualize(visualization_spokes) {
                    shape();
                }
            }
        }
    }
}

module rim() {
    r = od_hub_shaft_retainer/2 + h_inner_hub_clamp_gear - clamp_gear_z_offset; 
    echo("r rim", r);
    module shape() {
        triangle_placement(r=r) difference() {
            block([2, od_clamp_gear, h_rim], center=FRONT);
            rod(d=6, l=a_lot);
        }
        rotate([0, 0, 60]) triangle_placement(r=r) block([rim_wall, y_rim_connector, h_rim], center=FRONT);
    }
    translation = mode == PRINTING ? [dx_rim_bp, dy_rim_bp, h_rim/2]  : [0, 0, 0]; 
     translate(translation) {
        visualize(visualization_rim) shape();
     }
}



module drive_gear(show_vitamins=true, include_bottom_gear=false) {
    //dz_base = module_drive_gear/sin(cone_angle_drive_gear);
    od_hub_retainer = od_shaft_gear + 8;
    id_hub_retainer = od_shaft_gear + 4;
    h_hub_retainer = 3.25; // (od_clamp_gear - id_clamp_gear)/2;
    module additions() {        
//        *translate([0, 0, -dz_base]) can(d=od_drive_gear, h=h_base_drive_gear, center=BELOW);     
//        * translate([0, 0, -dz_base]) 
//            can(d=od_hub_retainer, h=h_hub_retainer, center=ABOVE);
    }
    module removals() {
        drive_shaft(as_clearance=true, clearance_scaling=[1.06, 1.06, 1] );
    }
    module shape() { 

        general_bevel_gear(
                n_teeth_drive_gear, 
                module_drive_gear, 
                tooth_width_drive_gear, 
                cone_angle = cone_angle_drive_gear, 
                body_child = 0, 
                cutout_child = 1,
                add_printing_support=false) {
            additions();
            removals();
        }
    } 
    pop = explode ? 10 : 0;
    dz_printing = -drive_gear_z_offset;
    top_rotation = mode == PRINTING ? [0, 0, 0] : [180, 0, 0];
    top_translation = 
        mode == PRINTING ? [dx_drive_gear_bp, dy_drive_gear_bp, dz_printing] : 
        [0, 0, md_clamp_gear/2 + pop];
    bottom_rotation = [0, 0, 0];
    bottom_translation = -top_translation;
    if (show_vitamins  && mode != PRINTING) {
        visualize_vitamins(visualization_drive_gear) {
            //drive_shaft_screws(as_clearance=false, include_head = true);
        }
    }
    visualize(visualization_drive_gear) {
        translate(top_translation) rotate(top_rotation) shape(); 
        if (include_bottom_gear) {
            translate(bottom_translation) rotate(bottom_rotation) shape();
        }
    }
}


module drive_gear_shaft_retainer() {
    module retention_screws() {
        center_reflect([1, 0, 0]) translate([2.5, -25, 2]) rotate([90, 0, 0]) hole_through("M2", cld = 0.4, $fn=12);
    }
     translation = mode == PRINTING ? [dx_drive_gear_shaft_retainer_bp, dy_drive_gear_shaft_retainer_bp, 0] : [0, 0, dz_top_of_drive_gear]; 
    visualize(visualization_drive_gear_shaft_retainer) {
        translate(translation) {
            render(convexity=10) difference() {
                can(d=od_driver_gear_retainer, h=4, center=ABOVE);
                drive_shaft(as_clearance=true, clearance_scaling=[1.06, 1.06, 1]);
                retention_screws();
            }
        }
    }
}


module clamp_gears(show_vitamins = true, include_outer_hub = true, screw_length=16) {
    if (mode == PRINTING) {
        triangle_placement(r=10) {
            clamp_gear(
                show_vitamins = show_vitamins, 
                include_outer_hub = include_outer_hub, 
                screw_length=screw_length);
        }
    } else if (mode == DESIGNING) {
        clamp_gear(
            show_vitamins = show_vitamins, 
            include_outer_hub = include_outer_hub, 
            screw_length=screw_length);
    } else if (mode == MESHING_GEARS) {
        triangle_placement(r=0) {
            clamp_gear(
                show_vitamins = show_vitamins, 
                include_outer_hub = include_outer_hub, 
                screw_length=screw_length);
        }
    }
}


module clamp_gear(show_vitamins = true, include_outer_hub = false, screw_length=16) {
    
    dz_outer_hub = 0.2;  // Offset because of the printing support for the gear;
    z_slide_padding = 2;
    dz_nut_block = dz_outer_hub - z_slide_padding;
    
    h_clamp_gear = h_inner_hub_clamp_gear + abs(clamp_gear_z_offset);
    echo("h_clamp_gear", h_clamp_gear);
   
    d_inner_hub = 8;
    //elephant_foot_adjustment = 1;
    dx_slide = od_hub_shaft_retainer/2 + h_inner_hub_clamp_gear;// od_drive_gear/2  + elephant_foot_adjustment;

    module additions() {
        can(d=d_inner_hub, h=h_inner_hub_clamp_gear, center=ABOVE);
        if (include_outer_hub) {
            translate([0, 0, dz_outer_hub]) can(d=od_clamp_gear, h=h_outer_hub, center=BELOW);
        }
    }
    dz_plane_clearance = 0.5;
    module removals() {
        dx = 0;
        //translate([0, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
        translate([0, 0, dx_slide]) pure_vitamin_slide(as_clearance = true, center = BELOW);
        //translate([0, 0, dz_plane_clearance]) plane_clearance(BELOW);
    }
    module shape() {
        general_bevel_gear(
                n_teeth_clamp_gear, 
                module_clamp_gear, 
                tooth_width_clamp_gear, 
                cone_angle = cone_angle_clamp_gear, 
                body_child = 0, cutout_child = 1) {
            additions();
            removals();
        }
    }
    module vitamins(dx) {
        translate([0, 0, 0]) pure_vitamin_slide(as_clearance = false, center = BELOW, show_for_design = true);
        //net_dx = -screw_length + dx - d_filament/2 + 0.1;
        //color(STAINLESS_STEEL) translate([0, 0, net_dx]) rotate([180, 0, 0]) m2_screw(screw_length) ;
    }
    
    rotation = 
        mode == PRINTING ? [0, 0, 0] :
        mode == DESIGNING ? [0, 0, 0] :
        mode == MESHING_GEARS ? [0, -90, 0] :
        mode == NEW_DEVELOPMENT ? [0, 0, 0] :
        assert(false, "Not determined");
    pop = explode ? 10 : 0;
    
    dx = dx_slide + pop;
    dz_printing = -clamp_gear_z_offset; 
    translation =  
        mode == PRINTING ? [dx_clamp_gear_bp, dy_clamp_gear_bp, dz_printing] :
        mode == DESIGNING ? [0, 0, 0] :
        mode == MESHING_GEARS ? [dx, 0, 0] :
        mode == NEW_DEVELOPMENT ? [0, 0, 0] :
        assert(false, "Not determined");
    translate(translation) {
        rotate(rotation) {
            if (show_vitamins && mode != PRINTING) {
                visualize_vitamins(visualization_clamp_gear) 
                    vitamins(dx);
            }
            visualize(visualization_clamp_gear)
                shape();
        }
    }
}


module hub_shaft_retainer(
        show_vitamins = true,
        as_clearance = false, 
        clearance = 0.25) {
           
    id = od_shaft_gear + 2*clearance;
    md =  2*r_hub + 2*clearance;     
    module shape() {
          render(convexity=10) difference() {
                union() {
                    translate([0, 0, h_hub/2]) can(d=od_hub_shaft_retainer, hollow=md, h = 3.75, center=ABOVE);        
                    translate([0, 0, h_hub/2+2+clearance]) can(d=od_hub_shaft_retainer, hollow=id, h = 1.5 , center=ABOVE); 
                    translate([0, 0, h_hub/2]) can(d=od_hub_shaft_retainer, hollow=md, h = h_hub, center=BELOW);    
                }
                triangle_placement(r=0) rotate([0, 0, 180]) clamp_screw_nut(as_clearance=true);
                spokes(as_clearance = true);
            }         
    }
    rotation = 
        mode == PRINTING  ? [180, 0, 0] : 
        [0, 0, 0];
    dz_printing = h_hub/2 + 3.75;
    translation =  
            mode == PRINTING ? [dx_hub_shaft_retainer_bp, dy_hub_shaft_retainer_bp, dz_printing] :
            [0, 0, 0];
    translate(translation) {
        rotate(rotation) {
            visualize(visualization_hub_shaft_retainer) shape();
        }
    }     
            
}



module drive_shaft(show_vitamins = true, as_clearance=false, clearance_scaling=[1, 1, 1]) {
    h_allowance_for_screws = 5;
    h_retainer_cap =14.5;
    h_attachment = 2;
    h_base = 2;
    dz_drive_shaft = h_hub/2 + h_base + 0.25;
    module shaft(as_clearance=false) {
        translation =as_clearance ? [0, 0, 0] : [0, 0, gear_height_shaft/2];  
        scaling = as_clearance ? clearance_scaling : [1, 1, 1];
        translate(translation) 
            scale(scaling) 
                general_straight_spur_gear(
                    n_teeth_shaft, 
                    gear_module_shaft, 
                    gear_height_shaft, 
                    body_child = -1, 
                    cutout_child = -1);
    }

    module base() {
        can(d = od_shaft_gear, h = h_base, center=ABOVE);
        translate([0, 0, 0]) can(d = od_shaft_gear + 4,  h = h_base, center=BELOW);
    }
    module blank() {
        shaft();
        base(); 
    }
    module shape() {
        difference() {
            blank();
            filament(as_clearance=true);
            //translate([0, 0, -10]) drive_shaft_screws(as_clearance=true);
        }
    }
    if (as_clearance) {
        shaft(as_clearance=true);  
    } else {
        translation =  
            mode == PRINTING ? [dx_drive_shaft_bp, dy_drive_shaft_bp, h_base] :
            [0, 0, dz_drive_shaft]; // Just do assembled for now!
        visualize(visualization_drive_shaft)
            translate(translation) shape();
    }
}





module frame_rider(
        as_clearance = false, 
        on_tubing = false, 
        on_rod = false,
        wall = 2, 
        h = 2) {
    

    od_inner = 
        on_tubing ? od_frame_tubing : 
        on_rod ? od_frame_rod :
        assert(false);
    clearance = 
        on_tubing ? 1 : 0;  // The rod od already contains clearance 
    id =  od_inner + 2*clearance;
    od = id + 2 * wall;
    if (as_clearance) {
        can(d=id, h=a_lot);
    } else {
        difference() {
            can(d=od, h=h, center=ABOVE);
            can(d=id, h=a_lot);
        }
    } 
}


module shaft_rider(as_clearance=false, clearance = 0.25, wall = 2, h = 2) {
    id = md_shaft_bearing + 2 * clearance;
    od = id  + 2 * wall;
    if (as_clearance) {
        can(d = id, h = a_lot);
    } else {
        difference() {
            can(d=od, h=h, center=ABOVE);
            can(d=id, h=a_lot);
        }        
    }
}



module drive_shaft_base() {
    
    //h_hub = h + 4;
    module blank() {
        triangle_placement(r=0) {
            hull() {
                can(d=2, h=h_base, center=ABOVE); 
                translate([r_spoke, 0, 0]) can(d=4, h=h_base, center=ABOVE); 
            }
            translate([r_spoke, 0, 0]) 
                frame_rider(h=h_base, on_tubing=true);
            shaft_rider(h=h_base);
        } 
        hull() {
            rotate([0, 0 , 60]) mounted_servo(as_mounting=true, h=h_base);
            can(d=18, h=h_base, center=ABOVE);
        }
    }   
    module shape() {
        difference() {
            blank();
            triangle_placement(r=r_spoke) {
                translate([0, 0, 0]) 
                    frame_rider(on_tubing=true, as_clearance=true);
            }
            shaft_rider(as_clearance=true);
            translate([0, 0, 10]) rotate([180, 0, 60])  mounted_servo(as_clearance=true);
            
        }
    }
    rotation = 
        mode == DESIGNING ? [0, 0, 0] :
        mode == PRINTING ? [0, 0, 0] :
        mode == MESHING_GEARS ? [180, 0, 60] : 
        assert(false);
    translation = 
        mode == DESIGNING ? [0, 0, 0] :
        mode == PRINTING ? [dx_base_bp, dy_base_bp, 0] :
        mode == MESHING_GEARS ? [0, 0, dz_shaft_base] :     
        assert(false);

    if (show_vitamins && mode != PRINTING) {
        visualize_vitamins(visualization_drive_shaft_base) { 
            translate(translation) {
                mounted_servo(as_clearance=false) ; 
            }   
        }
    }  
    translate(translation) {
        rotate(rotation) {     
            visualize(visualization_drive_shaft_base) {
                shape();
            }
        }    
    }
}

module drive_shaft_bearing(print_bearing=true, print_clip=true) {
    h_bearing_gear = 1.5* servo_transmission_gear_height;
    h_retention = 3.5;
    base_clearance = 0;
    h = h_retention + h_base + base_clearance;
    echo("h drive_shaft_bearing", h);
    z_offset = 3.5;
    module clip_slot() {
        render(convexity=10) difference() {
            translate([0, -0, -1]) can(d = md_shaft_bearing+4, hollow = od_shaft_gear+2, h=2.5, center=BELOW);
            translate([0, -0, -1]) can(taper = md_shaft_bearing, d = od_shaft_gear+2, h=1.5, center=BELOW);
        }
    }
    module clip_retention_clip(as_clearance) {
        module opening() {
            hull() {
                can(d = od_shaft_gear, h=a_lot);
                translate([od_shaft_gear, 0, 0]) can(d = od_shaft_gear, h=a_lot); 
            }
        }
        module clip_shape() {
            render(convexity=10) difference() {
                translate([0, -0, -1]) can(d = md_shaft_bearing+4, hollow = od_shaft_gear+2, h=2.5, center=BELOW);
                translate([0, -0, -1]) can(taper = md_shaft_bearing, d = od_shaft_gear+2, h=1.5, center=BELOW);
                if (!as_clearance) {
                    opening(); 
                }
            }
        }
        clip_shape();
    }
    module gear() {
        translate([0, 0, -h - h_bearing_gear/2]) 
        general_straight_spur_gear(
            n_teeth_shaft , 
            gear_module_servo_transmission,
            h_bearing_gear, 
            body_child = -1, 
            cutout_child = -1) ;
    }
    module shape() {
        render(convexity=20) difference() {
            union() {
                can(d=md_shaft_bearing, h=h, center=BELOW);
                gear(); 
            }
            drive_shaft(as_clearance=true, clearance_scaling=[1.1, 1.1, 1]);
            //clip_slot();
            clip_retention_clip(as_clearance=true);
        }        
    }
    dz_printing = h + h_bearing_gear;
    translation =  
        mode == PRINTING ? [dx_drive_shaft_bearing_bp, dy_drive_shaft_bearing_bp, dz_printing] : 
        [0, 0, dz_shaft_base + z_offset];
    
    printing_clip_translation = [dx_drive_shaft_bearing_bp + 2 * od_shaft_gear, dy_drive_shaft_bearing_bp, 3.5];
    
    if (mode == PRINTING) {
        if (print_bearing) {
            translate(translation) visualize(visualization_drive_shaft_bearing)  shape();
        }
        if (print_clip) {
            translate(printing_clip_translation) clip_retention_clip(as_clearance=false);
        }
    } else {
        translate(translation) {
            visualize(visualization_drive_shaft_bearing) shape();
            clip_retention_clip(as_clearance=false);
        }
    }
}


module mount_servo() {
    r_servo = md_servo_transmission/2 + md_shaft_bearing_gear/2;
    translate([r_servo, 0, z_servo]) children();
}


module mounted_servo(as_clearance=false, as_mounting=false, h=2) {
    assert(!is_undef(as_clearance));
    
    x_offset = 6;
    if (as_clearance) {
        mount_servo() {
            rotate([180, 0, az_servo]) scale([1.1, 1.05, 1]) {
                9g_motor_sprocket_at_origin();
            }
        }
    } else if (as_mounting) {
        mount_servo() {
            translate([x_offset, 0, -z_servo]) block([32, 18, h], center=ABOVE);
        }
    } else {
        mount_servo() {
            rotate([180, 0, az_servo]) 9g_motor_sprocket_at_origin();
        }
    }
}


module servo_transmission_gear() {
    module shape() {     
        general_straight_spur_gear(
            n_teeth_servo_transmission , 
            gear_module_servo_transmission,
            servo_transmission_gear_height, 
            body_child = -1, 
            cutout_child = 0)  {
                union() {
                    //translate([5, 0, 0]) plane_clearance(FRONT);
                    can(d=7, h=a_lot);
                    center_reflect([1, 0, 0]) translate([14.32/2, 0, 25]) hole_through("M2", $fn=12);
                    center_reflect([0, 1, 0]) translate([0, 14.32/2, 25]) hole_through("M2", $fn=12);
                }
            }  
    }
    visualize(visualization_servo_transmission_gear) {    
        if (mode == PRINTING) {
            translate([dx_servo_transmission_gear_bp, dy_servo_transmission_gear_bp, servo_transmission_gear_height/2]) shape(); 
        } else {
            mount_servo() {
                translate([0, 0, -2]) shape(); 
            }
        }
    }
}

/*   General Routines */ 

module general_bevel_gear(
        n_teeth, 
        gear_module, 
        tooth_width, 
        cone_angle = 45, 
        body_child = -1, 
        cutout_child = -1, 
        add_printing_support = false) { 
    render(convexity=10) difference() {
        union() {    
            bevel_gear(
                //basic options
                n = n_teeth,  // number of teeth
                m = gear_module,   // module
                w = tooth_width,   // tooth width
                cone_angle     = cone_angle,
                pressure_angle = 25,
                helix_angle    = 0,   // the sign gives the handiness
                backlash       = 0.1 // in module units
            );            
            if (body_child >= 0 && $children > body_child) {
                children(body_child);
            }
            // print support
            if (add_printing_support) {
                translate([0, 0, -0.4]) spur_gear(
                    n = n_teeth,  // number of teeth
                    m = gear_module,   // module
                    z=1);
            }
        }
        if (cutout_child >= 0 && $children > cutout_child) {
            children(cutout_child);
        }  
    }
}



module general_straight_spur_gear(n_teeth, gear_module, gear_height, body_child = -1, cutout_child = -1) {
    render(convexity=10) difference() {
        union() {
            spur_gear(
                n = n_teeth,  // number of teeth, just enough to clear rider.
                m = gear_module,   // module
                z = gear_height,   // thickness
                pressure_angle = 25,
                helix_angle    = 0,   // the sign gives the handiness, can be a list
                backlash       = 0.1 // in module units
            );
            if (body_child >= 0 && $children > body_child) {
                children(body_child);
            }
        }
        if (cutout_child >= 0 && $children > cutout_child) {
            children(cutout_child);
        }  
    }
}