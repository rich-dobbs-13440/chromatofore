include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
use <ScadApotheka/m2_helper.scad>
include <nutsnbolts-master/cyl_head_bolt.scad>
include <nutsnbolts-master/data-metric_cyl_head_bolts.scad>
use <PolyGear/PolyGear.scad>


a_lot = 200;
d_filament = 1.75 + 0.;
od_ptfe_tube = 4 + 0;
id_ptfe_tube = 2 + 0;

d_ptfe_insertion = od_ptfe_tube + 0.5;
d_m2_nut_driver = 6.0;

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
show_drive_gear_construction_lines = false;
hide_sample_gear_keys = true;  
assert_for_not_implemented = false;
explode  = false;  
    
/* [Visibility] */

hub_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
gear_for_clamp  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
slide_for_clamp   = 0; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
drive_gear_for_clamp = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
drive_gear_retainer =1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
shaft_for_clamp = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
   
slide_length = 50; // [1 : 1 : 99.9]
screw_lift = 0; // [-.1 : .1 : 1]

clamp_slide_clearance = 0.2;

/* [Clamp Gearing Design] */

module_clamp_gear = 1.2;
n_teeth_clamp_gear = 9; // [9, 10, 11, 12, 13]
cone_angle_clamp_gear = 5; // [-90:5:85]
tooth_width_clamp_gear = 8;


/* [Drive Gear_Retainer Design] */
d_drive_gear_retainer_shaft = 10;
od_drive_gear_retainer = 10;
clearance_drive_gear_retainer_shaft = 0.5;

h_clamp_drive_gear_flange = 2;
flange_screw_padding = 6; //[4, 6, 8]



/* [Clamp Drive Gearing Design] */
tooth_width_clamp_drive_gear = 4;
target_id_drive_gear_adjustment = 4.5; // [0 : 0.5 : 10]

cone_angle_clamp_drive_gear = 90 - cone_angle_clamp_gear;

module_clamp_drive_gear = module_clamp_gear;

h_base_clamp_drive_gear = 4; // Provide clearance for retention screw versus clamp gear
h_bottom_clamp_gear = 1;

/* [Hub Design] */
r_hub = 9;
s_nut_block = 5;
r_nut_cut_clamp_screw = 4;
r_hub_attachment_screw = 3;


/* [Clamp Drive Shaft Design] */
gear_height_shaft = 50;
gear_module_shaft = 0.8;
n_teeth_shaft = 9;


module end_of_customization() {}




/* Visualization  */ 

layout = layout_from_mode(mode);
//echo("mode", mode, "layout", layout);

visualization_clamp_hub = 
    visualize_info(
        "Clamp Hub", PART_1, hub_visibility, layout, show_parts); 

visualization_slide = 
    visualize_info(
        "Clamp Screw Slide", PART_2, slide_for_clamp, layout_from_mode(DESIGNING), show_parts); 

visualization_clamp_drive_gear = 
    visualize_info(
        "Clamp Drive Gear", PART_3, drive_gear_for_clamp, layout_from_mode(layout), show_parts); 

visualization_clamp_gear = 
    visualize_info(
        "Clamp Gear", PART_4, gear_for_clamp, layout_from_mode(layout), show_parts); 

        
visualization_clamp_drive_shaft = 
    visualize_info(
        "Clamp Drive Shaft", PART_5, shaft_for_clamp, layout_from_mode(layout), show_parts);
        
        
visualization_clamp_drive_retainer = 
    visualize_info(
        "Clamp Drive Gear Retainer", PART_6, drive_gear_retainer, layout_from_mode(layout), show_parts);
              
        
/* Gear Calculations */

function shallow_bevel_gear_od(teeth, gear_module, cone_angle_degrees, tooth_width) = 
    teeth * gear_module * sin(cone_angle_degrees);

function shallow_bevel_gear_id(teeth, gear_module, cone_angle_degrees, tooth_width) =
    shallow_bevel_gear_od(teeth, gear_module, cone_angle_degrees, tooth_width) - 2 * tooth_width;
    
function shallow_bevel_gear_md(teeth, gear_module, cone_angle_degrees, tooth_width) = 
    shallow_bevel_gear_od(teeth, gear_module, cone_angle_degrees, tooth_width) - tooth_width;


function teeth_for_od_shallow_bevel_gear(od, gear_module, cone_angle_degrees) =
    ceil(od/(gear_module * sin(cone_angle_degrees)));
    
function teeth_for_id_shallow_bevel_gear(id, gear_module, cone_angle_degrees, tooth_width) = 
    teeth_for_od_shallow_bevel_gear(id + 2*tooth_width, gear_module, cone_angle_degrees);     

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


// The calculations for id are a bit off, so adjustment is desired.


target_id_drive_gear = 2 * r_hub + 2;



n_teeth_clamp_drive_gear = 
    teeth_for_id_shallow_bevel_gear(
        target_id_drive_gear + target_id_drive_gear_adjustment, 
        module_clamp_drive_gear, 
        cone_angle_clamp_drive_gear, 
        tooth_width_clamp_drive_gear);

id_clamp_drive_gear = shallow_bevel_gear_id(
    n_teeth_clamp_drive_gear, module_clamp_drive_gear, cone_angle_clamp_drive_gear, tooth_width_clamp_drive_gear);
    
od_clamp_drive_gear  = shallow_bevel_gear_od(
    n_teeth_clamp_drive_gear, module_clamp_drive_gear,  cone_angle_clamp_drive_gear, tooth_width_clamp_drive_gear);
    
md_clamp_drive_gear  = shallow_bevel_gear_md(
    n_teeth_clamp_drive_gear, module_clamp_drive_gear,  cone_angle_clamp_drive_gear, tooth_width_clamp_drive_gear);
    
retainer_screw_offset = ceil(((od_clamp_drive_gear + 4)/2)/sqrt(2));
echo("retainer_screw_offset", retainer_screw_offset);
d_retainer_screw_circle = 2 * sqrt(2) * retainer_screw_offset;



echo("n_teeth_clamp_drive_gear", n_teeth_clamp_drive_gear);
echo("Clamp drive gear - id",  id_clamp_drive_gear);
echo("md", md_clamp_drive_gear);
echo("od", od_clamp_drive_gear);
echo("d_retainer_screw_circle", d_retainer_screw_circle); 
echo("target_id_drive_gear", target_id_drive_gear);
if (show_drive_gear_construction_lines) {  
    color(BLACK_IRON) can(d=d_retainer_screw_circle, hollow=d_retainer_screw_circle-1, h=5);
    color(COPPER) can(d=target_id_drive_gear, hollow=target_id_drive_gear-1, h=5);     
    color(BRONZE) can(d=id_clamp_drive_gear, hollow=id_clamp_drive_gear-0.5, h=5);
    color(SILVER) can(d=md_clamp_drive_gear, hollow=md_clamp_drive_gear-0.5, h=5);  
    color(GOLD) can(d=od_clamp_drive_gear, hollow=od_clamp_drive_gear-0.5, h=5);     
   
}    



dz_top_of_drive_gear = od_clamp_gear/2 + dz_total_of_clamp_drive_gear();


if (show_filament) {
    filament(as_clearance=false);
}

clamp_gear_slide();
clamp_gear(show_vitamins=show_vitamins);
clamp_hub(show_vitamins=show_vitamins);
//retainer_clip();
clamp_drive_gear(show_vitamins=show_vitamins);
clamp_gear_drive_shaft(show_vitamins = true);
drive_gear_retainer();

module filament(as_clearance=false) {
    d = as_clearance ? 2.5 : d_filament;
    alpha = as_clearance ? 0 : 1;
    if (as_clearance) {
        can(d=d, h=a_lot, $fn=12); 
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





module drive_gear_retainer(as_clearance=false, clearance=1) {
    // Provides feature to retain the gear the nut block, 
    // the inner axle for drive gear to rotate on, 
    // and printing support for the nut block.
    
    // The clearance is generous, since it is just used to avoid
    // interference between the shaft (which rotates a lot to 
    // open and close the clamp), and the retainer (which only
    // rotates if the filament gets stuck on something and filament
    // rotation is used to get past the obstacle(. 
    h_drive_gear_total_base = 3;
    h_width_of_m2_screw_head = 3.8;
    retainer_clearance = 0.5;
    h_shaft = 
        od_clamp_gear/2 
        - s_nut_block/2 
        + h_drive_gear_total_base 
        + h_width_of_m2_screw_head/2 + retainer_clearance;
    
    module filament_entrance() {
        translate([0, 0, h_shaft]) can(d=d_ptfe_insertion, h=4, center=BELOW, rank = 10);
        translate([0, 0, h_shaft-4]) can(d=d_filament, taper= d_ptfe_insertion, h=2, center=BELOW);        
    }
    
    module shape() {
        difference() {
            union() {
                // printing support to attach to gear retariner
                // #can(d = 2*r_hub, taper = 6, h=4, center=ABOVE);
                // Shaft to retain gear
                can(d=d_drive_gear_retainer_shaft, h=h_shaft, center=ABOVE);
                translate([0, 0, h_shaft]) 
                    can(d = d_drive_gear_retainer_shaft + 4, h=2, center=BELOW);
                
            }
            filament(as_clearance=true);
            filament_entrance();
            
        }         
}
    
    if (as_clearance) {
        can(d = d_drive_gear_retainer_shaft + 2 * clearance, h=h_shaft + od_drive_gear_retainer, center=ABOVE);
        can(d = d_ptfe_insertion, h = h_shaft + od_drive_gear_retainer + 4, center=ABOVE);
    } else {
        pop = explode ? 20 : 0;
        translate([0, 0, s_nut_block/2 + pop]) {
            if (show_vitamins) {
                // rotate([0, 0, 45])  rotate([90, 0, 0]) translate([0, 0, 5]) 
                 //translate([4, -4, 0] ) translate([0, 0, h_shaft-2]) rotate([90, 0, 0]) #screw("M2x6", $fn=12); 
            }
            shape();

        }
    }
}





module retainer_screws(as_clearance=false, include_head = false) {

    dz_screw = 0;
    head_clearance = include_head ? 25 :0;
    dz = as_clearance && include_head ? head_clearance : 
         as_clearance ? 25: 
         dz_screw;
    center_reflect([1, 0, 0]) {
        center_reflect([0, 1, 0]) {
            translate([retainer_screw_offset, retainer_screw_offset, dz]) {
                if (as_clearance) {
                    hole_through("M2", h=head_clearance, cld=0.4, $fn=12);
                } else {
                    rotate([180, 0, 0]) 
                    color(BLACK_IRON) screw("M2x6", $fn=12);
                }
            }
        }
    }
}


module clamp_drive_gear_flange(center=ABOVE) {
    s = 2 * retainer_screw_offset + flange_screw_padding;
    difference() {
        block([s, s, h_clamp_drive_gear_flange], center=center);
        retainer_screws(as_clearance=true, include_head = false);
    }
//        if (show_vitamins) {
//            retainer_screws();
//        }    
}


function dz_total_of_clamp_drive_gear() = 2 + h_clamp_drive_gear_flange;


module clamp_drive_gear(show_vitamins=true) {
    d_inner_hub = d_drive_gear_retainer_shaft + 4;
    h_inner_hub = 2.5;
    id_clip_ring = d_inner_hub - 2;
    dz_base = module_clamp_drive_gear/sin(cone_angle_clamp_drive_gear);
    module additions() {
        can(d=d_inner_hub, h=h_inner_hub, center=ABOVE, $fn=30);
        can(d=d_inner_hub, h=module_clamp_drive_gear, center=BELOW);
        
            translate([0, 0, -dz_base]) can(d=od_clamp_drive_gear, h=h_base_clamp_drive_gear, center=BELOW); 
            translate([0, 0, -4]) clamp_drive_gear_flange(BELOW);

        
    }
    module removals() {
        can(d = d_drive_gear_retainer_shaft + 2*clearance_drive_gear_retainer_shaft,  h = a_lot, $fn=24);
        retainer_screws(as_clearance=true, include_head = false);
    }
    module shape() { 
        rotate([180, 0, 0]) {
            general_bevel_gear(
                    n_teeth_clamp_drive_gear, 
                    module_clamp_drive_gear, 
                    tooth_width_clamp_gear, 
                    cone_angle = cone_angle_clamp_drive_gear, 
                    body_child = 0, 
                    cutout_child = 1,
                    add_printing_support=false) {
                additions();
                removals();
            }
        }
    } 
    pop = explode ? 10 : 0;
    translate([0, 0, md_clamp_gear/2 + pop]) {

        visualize(visualization_clamp_drive_gear) {
            shape(); 
        }
    } 
}


module clamp_gear_slide(as_clearance=false, extra_slide_clearance = 0, screw_length=20) {
    z_slide = s_nut_block;     
    module shape() {
         // adapts to existing 
 
        slide = [s_nut_block, s_nut_block, z_slide];        
        difference() {
            block(slide +  [-extra_slide_clearance, -extra_slide_clearance, 0], center=BELOW );
            translate([0, 0, 25]) hole_through("M2", cld=0.4, $fn=12); 
        }
    }
    module vitamins() {
        color(BLACK_IRON) screw(str("M2x", screw_length), $fn=12);
    }
    if (as_clearance) {
        nut_thickness = 1.5;
        clearances = 2 * [clamp_slide_clearance, clamp_slide_clearance, clamp_slide_clearance];
        slide = [s_nut_block, s_nut_block, a_lot];
        translate([0, 0, s_nut_block + nut_thickness]) block(slide + clearances, center=BELOW);
    } else {
        rotation = 
            mode == PRINTING ? [0, 0, 0] :
            mode == DESIGNING ? [0, 0, 0] :
            mode == MESHING_GEARS ? [0, -90, 0] :
            mode == NEW_DEVELOPMENT ? [0, 0, 0] :
            assert(false, "Not determined");
        pop = explode ? 10 : 0;
            clamping = 0.2;
        dx = d_filament/2 - clamping + screw_length - z_slide + pop;
        translation =  
            mode == PRINTING ? [0, 0, 0] :
            mode == DESIGNING ? [0, 0, 0] :
            mode == MESHING_GEARS ? [dx, 0, 0] :
            mode == NEW_DEVELOPMENT ? [0, 0, 0] :
            assert(false, "Not determined");  
        translate(translation) {
            rotate(rotation) {
                if (show_vitamins) {
                    visualize_vitamins(visualization_slide) {
                        vitamins();
                    }
                }
                visualize(visualization_slide)  {
                    shape();
                }
            }
        }  
    } 
}


module clamp_gear(show_vitamins = true, include_outer_hub = true, screw_length=16) {
    
    h_inner_hub_clamp_gear = 1; 
    dz_outer_hub = 0.2;  // Offset because of the printing support for the gear;
    z_slide_padding = 2;
    dz_nut_block = dz_outer_hub - z_slide_padding;
    h_outer_hub = 4;
    d_inner_hub = r_hub;
    screw_name = str("M2x", screw_length);
    
    module additions() {
        translate([0, 0, tooth_width_clamp_gear]) 
        translate([0, 0, -0.5]) can(d=d_inner_hub, h=h_inner_hub_clamp_gear, center=ABOVE);
        if (include_outer_hub) {
            translate([0, 0, dz_outer_hub]) can(d=od_clamp_gear, h=h_outer_hub, center=BELOW);
        }
    }
    module removals() {
        translate([0, 0, 25]) hole_through("M2", cld=0.6, $fn=12);
        translate([0, 0, -4]) clamp_gear_slide(as_clearance=true);
        //translate() plane_clearance(BELOW);
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
        net_dx = -screw_length + dx - d_filament/2 + 0.1;
        color(STAINLESS_STEEL) translate([0, 0, net_dx]) rotate([180, 0, 0]) screw(screw_name, $fn=12);
    }
    rotation = 
        mode == PRINTING ? [0, 0, 0] :
        mode == DESIGNING ? [0, 0, 0] :
        mode == MESHING_GEARS ? [0, -90, 0] :
        mode == NEW_DEVELOPMENT ? [0, 0, 0] :
        assert(false, "Not determined");
    pop = explode ? 10 : 0;
    dx = r_hub + tooth_width_clamp_gear + h_inner_hub_clamp_gear + pop;
    translation =  
        mode == PRINTING ? [0, 0, 0] :
        mode == DESIGNING ? [0, 0, 0] :
        mode == MESHING_GEARS ? [dx, 0, 0] :
        mode == NEW_DEVELOPMENT ? [0, 0, 0] :
        assert(false, "Not determined");
    
    
    translate(translation) {
        rotate(rotation) {
            if (show_vitamins) {
                visualize_vitamins(visualization_clamp_gear) 
                    vitamins(dx);
            }
            visualize(visualization_clamp_gear)
                shape();
        }
    }
}




module nut_block(
        show_vitamins = true, 
        visualization = false, 
        as_cutouts = false,
        clearance = 0) {
    
    nut_block = [s_nut_block, s_nut_block, s_nut_block];
    module cutouts() {
        rotate([0, 0, 180]) clamp_screw(as_clearance=true);
        filament(as_clearance=true);        
    }        
//    if (as_clearance) {
//        clearances =  2 * [clearance, clearance, clearance];
//        block(nut_block + clearances, center=FRONT);
//    } else 
    if (as_cutouts) { 
        cutouts();
    } else {
        if (show_vitamins) {
            visualize_vitamins(visualization)
            rotate([0, 0, 180]) clamp_screw(as_clearance=false);
        }        
        visualize(visualization) {
            difference() {
                block(nut_block, center=FRONT);
                cutouts();
            }
            drive_gear_retainer();
        }
    }
}


module clamp_hub(show_vitamins=true) {
    visualize(visualization_clamp_hub) {
        render(convexity=10) difference() {
            can(d = 2 * r_hub, h = s_nut_block);
            triangle_placement(r=0) {
                nut_block(as_cutouts = true);
                rotate([0, 0, 60]) translate([4, 0, 25]) hole_through("M2", cld=0.4, $fn=12);
            }
        }
    }
}


module clamp_screw(as_clearance=false) {
    if (as_clearance) {
        rotate([0, 90, 0]) {
            hole_through("M2", $fn = 12);
        } 
        translate([-r_nut_cut_clamp_screw, 0, 0]) rotate([0, 90, 0]) {  //[0, -90, 180]
             tuned_M2_nutcatch_side_cut(as_clearance=true); 
        }
    } else {
        color(BLACK_IRON) {
            translate([-r_nut_cut_clamp_screw, 0, 0]) rotate([0, -90, 180]) {
                 tuned_M2_nutcatch_side_cut(as_clearance=false);
            }
            translate([-d_filament/2-screw_lift, 0, 0]) rotate([0, 90, 0]) {
                hole_through("M2", $fn = 12, l=12);
            } 
        }          
    }            
}


module clamp_gear_drive_shaft(show_vitamins = true) {
    h_allowance_for_screws = 5;
    h_retainer_cap =14.5;
    h_attachment = 2;
    module shaft() {
        // will be a long sliding spur gear, but fake it for a bit
        //can(d = 6, h = 50, center = ABOVE);
        translate([0, 0, gear_height_shaft/2]) 
            general_straight_spur_gear(
                n_teeth_shaft, 
                gear_module_shaft, 
                gear_height_shaft, 
                body_child = -1, 
                cutout_child = -1);
    }

    module retainer_cap() {
        can(d = 18 + 4 + 4, taper = 10, h = h_allowance_for_screws + 8, center=ABOVE);
    }
    module blank() {
        shaft();
        clamp_drive_gear_flange(center=ABOVE);
        retainer_cap(); 
    }
    module shape() {
        difference() {
            blank();
            filament(as_clearance=true);
            translate([0, 0, -.1]) can(d=18, h=h_allowance_for_screws, center=ABOVE);
            // Transition at printable angle
            translate([0, 0, h_allowance_for_screws-0.1]) can(d=18, taper=0, h=9, center=ABOVE);
        }
    }
    translation = [0, 0, dz_top_of_drive_gear]; // Just do assembled for now!
    visualize(visualization_clamp_drive_shaft)
        translate(translation) shape();
}