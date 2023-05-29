include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
include <ScadApotheka/m2_helper.scad>
include <nutsnbolts-master/cyl_head_bolt.scad>
include <nutsnbolts-master/data-metric_cyl_head_bolts.scad>
use <PolyGear/PolyGear.scad>


a_lot = 200;
d_filament = 1.75 + 0.;
od_ptfe_tube = 4 + 0;
id_ptfe_tube = 2 + 0;


NEW_DEVELOPMENT = 0 + 0;
DESIGNING = 1 + 0;
MESHING_GEARS = 2 + 0;
ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;



/* [Output Control] */

mode = 0; // [0:"New development, hide other parts", 1:"Designing, no rotation or translation", 2:"Meshing gears", 3: "assembly", 4: "Printing"]

function layout_from_mode(mode) = 
    mode == NEW_DEVELOPMENT ? "hidden" :
    mode == DESIGNING ? "as_designed" :
    mode == MESHING_GEARS ? "mesh_gears" :
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";
  

explode  = true;  
    
nut_block_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
slide_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
//gear_holder_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
//clamp_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
//clamp_slot_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
//small_bevel_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
//big_bevel_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
//gear_mesh_keys_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]    
    
show_parts = true;
show_vitamins = true;
show_filament = true;
hide_sample_gear_keys = true;


slide_length = 50; // [1 : 1 : 99.9]
screw_lift = 0; // [-.1 : .1 : 1]


/* [Clamp Gearing Design] */

module_clamp_gear = 1.25;
n_teeth_clamp_gear = 9; // [9, 10, 11]

cone_angle_clamp_gear = 5; // [-90:5:85]
tooth_width_clamp_gear = 4;
h_inner_hub_clamp_gear  = 1;

/* [Clamp Gearing Design] */

n_teeth_clamp_drive_gear = 18;
cone_angle_clamp_drive_gear = 90 - cone_angle_clamp_gear;
module_clamp_drive_gear = module_clamp_gear;
tooth_width_clamp_drive_gear = 4;

//clamp_gear_height = 8;
h_bottom_clamp_gear = 1;

/* [Nut Block Design] */
s_nut_block = 6;



module end_of_customization() {}

layout = layout_from_mode(mode);
echo("mode", mode, "layout", layout);

// PART_1 is blue
visualization_nut_block = 
    visualize_info(
        "Nut Block", PART_1, nut_block_visibility, layout, show_parts); 

visualization_slide = 
    visualize_info(
        "Clamp Screw Slide", PART_2, slide_visibility, layout_from_mode(DESIGNING), show_parts); 
 

function shallow_bevel_gear_od(teeth, gear_module, cone_angle_degrees, tooth_width) = 
    teeth * gear_module * sin(cone_angle_degrees);

function shallow_bevel_gear_id(teeth, gear_module, cone_angle_degrees, tooth_width) =
    shallow_bevel_gear_od(teeth, gear_module, cone_angle_degrees, tooth_width) - 2 * tooth_width;
    
function shallow_bevel_gear_md(teeth, gear_module, cone_angle_degrees, tooth_width) = 
    shallow_bevel_gear_od(teeth, gear_module, cone_angle_degrees, tooth_width) - tooth_width;




//// Function to calculate Basic Diameter (BD) of a bevel gear
//function bevel_gear_md(teeth, gear_module, cone_angle_degrees) = 
//    (bevel_gear_id(teeth, gear_module, cone_angle_degrees) + 
//    bevel_gear_od(teeth, gear_module, cone_angle_degrees)) / 2;

//echo("adjustment", 2 * sin(cone_angle_clamp_drive_gear * 2*PI/360));

//echo("id", bevel_gear_id(teeth=10, gear_module=1, cone_angle_degrees=90));
//echo("od", bevel_gear_od(teeth=10, gear_module=1, cone_angle_degrees=90));

// Calcs for values that need to be shared to calculate displacements
id_clamp_gear = (n_teeth_clamp_gear - 2) * module_clamp_gear;
    
od_clamp_gear  = (n_teeth_clamp_gear + 2) * module_clamp_gear;
    
md_clamp_gear  = (n_teeth_clamp_gear) * module_clamp_gear;

id_clamp_drive_gear = shallow_bevel_gear_id(
    n_teeth_clamp_drive_gear, module_clamp_drive_gear, cone_angle_clamp_drive_gear, tooth_width_clamp_drive_gear);
    
od_clamp_drive_gear  = shallow_bevel_gear_od(
    n_teeth_clamp_drive_gear, module_clamp_drive_gear,  cone_angle_clamp_drive_gear, tooth_width_clamp_drive_gear);
    
md_clamp_drive_gear  = shallow_bevel_gear_md(
    n_teeth_clamp_drive_gear, module_clamp_drive_gear,  cone_angle_clamp_drive_gear, tooth_width_clamp_drive_gear);




if (show_filament) {
    filament(as_clearance=false);
}


clamp_gear();
nut_blocks(show_vitamins=show_vitamins);




module filament(as_clearance=false) {
    d = as_clearance ? 2.5 : d_filament;
    alpha = as_clearance ? 0 : 1;
    if (as_clearance) {
        can(d=d, h=slide_length + 40, $fn=12); 
    } else {
        color("red", alpha) {
            can(d=d, h=slide_length + 40, $fn=12);
        }
    }  
}


module general_bevel_gear(
        n_teeth, 
        gear_module, 
        tooth_width, 
        cone_angle = 45, 
        body_child = -1, 
        cutout_child = -1, 
        add_printing_support = true) { 
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

clamp_drive_gear();

module clamp_drive_gear() {
    d_inner_hub = 2*s_nut_block-2;
    h_inner_hub = md_clamp_gear/2-s_nut_block/2;
    id_clip_ring = d_inner_hub - 2;
    module additions() {
        
        dz_base = module_clamp_drive_gear/sin(cone_angle_clamp_drive_gear) ; //0; //od_clamp_gear - md_clamp_gear;
        can(d=d_inner_hub, h=h_inner_hub, center=ABOVE);
        translate([0, 0, -dz_base]) can(d=od_clamp_drive_gear, h=2, center=BELOW);
        can(d=d_inner_hub, h=module_clamp_drive_gear, center=BELOW);
    }
    module removals() {
        can(d = od_ptfe_tube, h = a_lot, $fn=12);
        // Clip ring 
        translate([0, 0, h_inner_hub-2]) can(d = 2*s_nut_block, hollow = id_clip_ring, h = 2, center=BELOW);
        // Engagement with shaft
        block([5, 5, a_lot], center=BELOW);
        
    }
    module shape() {
        translate([0, 0, md_clamp_gear/2]) {
            rotate([180, 0, 0]) {
                general_bevel_gear(
                        n_teeth_clamp_drive_gear, 
                        module_clamp_drive_gear, 
                        tooth_width_clamp_gear, 
                        cone_angle = cone_angle_clamp_drive_gear, 
                        body_child = 0, cutout_child = 1,
                        add_printing_support=false) {
                    additions();
                    removals();
                }
            }
            // Add a stop for the bearing ptfe tub
            center_reflect([1, 0, 0]) 
                translate([id_ptfe_tube/2, 0, 0]) 
                    block([od_ptfe_tube/2, 5, 1], center=FRONT); 
            
        }
    } 
    pop = explode ? 10 : 0;
    translate([0, 0, pop])
    shape();   
}



module clamp_gear() {

    dz_outer_hub = -0.75;  // Offset because of the printing support for the gear;
    z_slide_padding = 2;
    dz_nut_block = dz_outer_hub - z_slide_padding;
    h_outer_hub = s_nut_block + z_slide_padding;
    module slide(as_clearance) {
        clearance = as_clearance ? 1 : 0;
        translate([0, 0, dz_nut_block + clearance]) {
            rotate([0, 90, 0]) {
                nut_block(
                    as_clearance = as_clearance, 
                    clearance = clearance,
                    show_vitamins = show_vitamins && !as_clearance, 
                    visualization = visualization_slide);
            }
        }
    }
    
    module additions() {
        translate([0, 0, tooth_width_clamp_gear]) 
        can(d=id_clamp_gear, h=h_inner_hub_clamp_gear, center=ABOVE);
        translate([0, 0, dz_outer_hub]) can(d=od_clamp_gear, h=h_outer_hub, center=BELOW);
    }
    module removals() {
        translate([0, 0, 25]) hole_through("M2", cld=0.4, $fn=12);
        slide(as_clearance=true);
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
    rotation = 
        mode == PRINTING ? [0, 0, 0] :
        mode == DESIGNING ? [0, 0, 0] :
        mode == MESHING_GEARS ? [0, -90, 0] :
        assert(false, "Not determined");
    pop = explode ? 10 : 0;
    dx = s_nut_block + tooth_width_clamp_gear + h_inner_hub_clamp_gear + pop;
    translation =  
        mode == PRINTING ? [0, 0, 0] :
        mode == DESIGNING ? [0, 0, 0] :
        mode == MESHING_GEARS ? [dx, 0, 0] :
        assert(false, "Not determined");
    echo("rotation", rotation);
    
    
    translate(translation) {
        rotate(rotation) {
            color("brown") slide(as_clearance=false);
            color("green", alpha=0.75) shape();
            
        }
    }
}



module nut_block(show_vitamins=true, visualization=visualization_nut_block, as_clearance=false, clearance=0) {
    nut_block = [s_nut_block, s_nut_block, s_nut_block];
    if (as_clearance) {
        clearances =  2 * [clearance, clearance, clearance];
        block(nut_block + clearances, center=FRONT);
    } else {
        if (show_vitamins) {
            rotate([0, 0, 180]) clamp_screw(as_clearance=false);
        }        
        visualize(visualization)
        difference() {
            block(nut_block, center=FRONT);
            rotate([0, 0, 180]) clamp_screw(as_clearance=true);
            filament(as_clearance=true);
        }
    }
}

module nut_blocks(show_vitamins=true) {
    triangle_placement(r=0) {
        nut_block(show_vitamins=show_vitamins);
    }
}



//clamp_screw(as_clearance=true);
module clamp_screw(as_clearance) {
    if (as_clearance) {
        rotate([0, 90, 0]) {
            hole_through("M2", $fn = 12);
        } 
        translate([-2.2, 0, 0]) rotate([0, 90, 0]) {  //[0, -90, 180]
             tuned_M2_nutcatch_side_cut(as_clearance=true); 
        }
    } else {
        color(BLACK_IRON) {
            translate([-2.2, 0, 0]) rotate([0, -90, 180]) {
                 tuned_M2_nutcatch_side_cut(as_clearance=false);
            }
            translate([-d_filament/2-screw_lift, 0, 0]) rotate([0, 90, 0]) {
                hole_through("M2", $fn = 12, l=12);
            } 
        }          
    }            
}