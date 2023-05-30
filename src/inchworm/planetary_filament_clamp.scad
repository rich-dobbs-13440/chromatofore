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

d_ptfe_insertion = od_ptfe_tube + 0.5;


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
  
assert_for_not_implemented = false;
explode  = false;  
    
nut_block_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
slide_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
drive_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
clamp_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
retainer_clip_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

//gear_holder_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
//clamp_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

//small_bevel_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
//big_bevel_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
//gear_mesh_keys_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]    
    
show_parts = true;
show_vitamins = true;
show_filament = true;
hide_sample_gear_keys = true;


slide_length = 50; // [1 : 1 : 99.9]
screw_lift = 0; // [-.1 : .1 : 1]

clamp_slide_clearance = 0.2;

/* [Clamp Gearing Design] */

module_clamp_gear = 1.7;
n_teeth_clamp_gear = 9; // [9, 10, 11]

cone_angle_clamp_gear = 5; // [-90:5:85]
tooth_width_clamp_gear = 7;
h_inner_hub_clamp_gear  = 3;

/* [Clamp Gearing Design] */

n_teeth_clamp_drive_gear = 18;
cone_angle_clamp_drive_gear = 90 - cone_angle_clamp_gear;
module_clamp_drive_gear = module_clamp_gear;
tooth_width_clamp_drive_gear = 4;

h_base_clamp_drive_gear = 2;
h_bottom_clamp_gear = 1;

/* [Nut Block Design] */
s_nut_block = 6;


/* [Drive Gear_Retainer Design] */
d_drive_gear_retainer_shaft = 8;
od_drive_gear_retainer = 10;
retainer_screw_offset = 5;
d_retainer_screw_circle = 2 * sqrt(2) * retainer_screw_offset;
h_retainer_clip = 2;  // 3 mm was too tight.  2 mm is minimum.   
od_retainer_clip = 25;

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

visualization_clamp_drive_gear = 
    visualize_info(
        "Clamp Drive Gear", PART_3, drive_gear_visibility, layout_from_mode(layout), show_parts); 

visualization_clamp_gear = 
    visualize_info(
        "Clamp Gear", PART_4, clamp_gear_visibility, layout_from_mode(layout), show_parts); 

visualization_retainer_clip = 
    visualize_info(
        "Retainer Clip", PART_5, retainer_clip_visibility, layout_from_mode(layout), show_parts);
        
        

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


dz_top_drive_gear = od_clamp_gear/2 + h_base_clamp_drive_gear;

if (show_filament) {
    filament(as_clearance=false);
}

clamp_gear_slide();
clamp_gear();
nut_blocks(show_vitamins=show_vitamins);
retainer_clip();
clamp_drive_gear(show_vitamins=show_vitamins);


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




module drive_gear_retainer() {
    // Provides a slot for a clip, the inner axle for drive gear to rotate on, 
    // and printing support for the nut block.abs
    h_shaft = od_clamp_gear/2 + 4;
    translate([0, 0, s_nut_block/2]) {
        difference() {
            union() {
                // printing support to attach to gear retariner
                can(d = 2*s_nut_block, taper = 6, h=4, center=ABOVE);
                // Shaft to retain gear
                can(d=d_drive_gear_retainer_shaft, h=h_shaft, center=ABOVE);
                translate([0, 0, h_shaft]) 
                    can(d = d_drive_gear_retainer_shaft, taper = od_drive_gear_retainer, h=2, center=BELOW);
                
            }
            filament(as_clearance=true);
            translate([0, 0, h_shaft]) can(d=d_ptfe_insertion, h=4, center=BELOW, rank = 10);
            
        } 
    }
}




module retainer_clip(shaft_clearance=0.4) {
    id_ring = d_retainer_screw_circle + 4;
    id_cams =  d_drive_gear_retainer_shaft + 2*shaft_clearance;
    gap = 0.5;
    module pivot_cutouts() {
        d_cutout = (id_ring - id_cams)/2;
        r_axis = d_drive_gear_retainer_shaft /2 + d_cutout/2 + shaft_clearance;
        offset_axis = r_axis/sqrt(2);
        for (angle = [0 : 90 : 270]) {
            rotate([0, 0, angle]) {
                translate([offset_axis, offset_axis, 0]) {
                    difference() {
                        can(d = d_cutout+2*gap, hollow = d_cutout, h = a_lot);
                        rotate([0, 0, -45]) plane_clearance(FRONT);
                    }
                }
            }
        }
    }
    module shape() {
        render(convexity=10) difference() {
            can(
                d=id_ring-gap, 
                hollow = id_cams, 
                h = h_retainer_clip, 
                center = ABOVE);
            translate([0, 0, 10]) retainer_screws(as_clearance = true);
            pivot_cutouts();
        }
        can(
            d=od_retainer_clip, 
            hollow = id_ring + gap, 
            h = h_retainer_clip, 
            center = ABOVE);
    }
    visualize(visualization_retainer_clip) {
        translate([0, 0, dz_top_drive_gear]) { 
            shape();
        }
    }
}

module retainer_screws(as_clearance=false) {

    dz_screw = 0;
    head_clearance = 5;
    dz = as_clearance ? head_clearance : dz_screw;
    center_reflect([1, 0, 0]) {
        center_reflect([0, 1, 0]) {
            translate([retainer_screw_offset, retainer_screw_offset, dz]) {
                if (as_clearance) {
                    hole_through("M2", h=head_clearance, cld=0.4, $fn=12);
                } else {
                    rotate([180, 0, 0]) 
                    color(BLACK_IRON) screw("M2x20", $fn=12);
                }
            }
        }
    }
}




module clamp_drive_gear(show_vitamins=true) {
    d_inner_hub = 2*s_nut_block;
    h_inner_hub = md_clamp_gear/2-s_nut_block/2-3;
    id_clip_ring = d_inner_hub - 2;
    module additions() {
        dz_base = module_clamp_drive_gear/sin(cone_angle_clamp_drive_gear) ; //0; //od_clamp_gear - md_clamp_gear;
        can(d=d_inner_hub, h=h_inner_hub, center=ABOVE, $fn=30);
        translate([0, 0, -dz_base]) can(d=od_clamp_drive_gear, h=h_base_clamp_drive_gear, center=BELOW);
        can(d=d_inner_hub, h=module_clamp_drive_gear, center=BELOW);
    }
    module removals() {
        can(d = od_drive_gear_retainer, h = a_lot, $fn=24);
        retainer_screws(as_clearance=true);
        
    }
    module shape() { 
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
    } 
    pop = explode ? 10 : 0;
    translate([0, 0, md_clamp_gear/2 + pop]) {
        if (show_vitamins) {
            retainer_screws();
        }
        visualize(visualization_clamp_drive_gear) {
            shape(); 
        }
    } 
}


module clamp_gear_slide(as_clearance=false) {
    if (as_clearance) {
        clearances = 2 * [clamp_slide_clearance, clamp_slide_clearance, clamp_slide_clearance];
        slide = [s_nut_block, s_nut_block, 1.6*s_nut_block];
        block(slide + clearances);
    } else {
        assert(!assert_for_not_implemented, "Not implemented");
    }   
}


module clamp_gear() {

    dz_outer_hub = 0.2;  // Offset because of the printing support for the gear;
    z_slide_padding = 2;
    dz_nut_block = dz_outer_hub - z_slide_padding;
    h_outer_hub = 2;
    
    module additions() {
        translate([0, 0, tooth_width_clamp_gear]) 
        translate([0, 0, -0.5]) can(d=sqrt(2)*s_nut_block, h=h_inner_hub_clamp_gear, center=ABOVE);
        translate([0, 0, dz_outer_hub]) can(d=od_clamp_gear, h=h_outer_hub, center=BELOW);
    }
    module removals() {
        translate([0, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
        clamp_gear_slide(as_clearance=true);
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
        mode == NEW_DEVELOPMENT ? [0, 0, 0] :
        assert(false, "Not determined");
    pop = explode ? 10 : 0;
    dx = s_nut_block + tooth_width_clamp_gear + h_inner_hub_clamp_gear + pop;
    translation =  
        mode == PRINTING ? [0, 0, 0] :
        mode == DESIGNING ? [0, 0, 0] :
        mode == MESHING_GEARS ? [dx, 0, 0] :
        mode == NEW_DEVELOPMENT ? [0, 0, 0] :
        assert(false, "Not determined");
    echo("rotation", rotation);
    
    visualize(visualization_clamp_gear)
    translate(translation) {
        rotate(rotation) {
            color(PART_14, alpha=0.75) shape();
            
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
        visualize(visualization) {
            difference() {
                block(nut_block, center=FRONT);
                rotate([0, 0, 180]) clamp_screw(as_clearance=true);
                filament(as_clearance=true);
            }
            drive_gear_retainer();
        }
    }
}


module nut_blocks(show_vitamins=true) {
    triangle_placement(r=0) {
        nut_block(show_vitamins=show_vitamins);
    } 
}


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