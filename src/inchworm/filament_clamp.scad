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
    
show_parts = true;
show_vitamins = true;
show_filament = true;
hide_sample_gear_keys = true;

traveller_body_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
gear_holder_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
clamp_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
clamp_slot_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
small_bevel_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
big_bevel_gear_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ] 
gear_mesh_keys_visibility = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]




slide_length = 50; // [1 : 1 : 99.9]
screw_lift = 0; // [-.1 : .1 : 1]

/* [Design] */

print_clearance = 0.1; // Just making it enough that Mesh tools can separate parts
x_clamp_nut_block = 7;
n_teeth_small = 9; // [9, 10, 11]




/* [Clamp Gearing Design] */
clamp_gear_height = 8;
h_bottom_clamp_gear = 1;
clamp_gear_module = 1;
ptfe_insert_clearance = 0.2;


/* [Bevel Gearing Design] */

bevel_gear_module = 1.5; //[1:0.1:2]
small_bevel_gear_cone_angle = 45; // [-90:90]
small_gear_tooth_width = 6; // [0 : 20]
dz_small_bevel_gear = 7.4; // [7:0.1: 9]
dz_shaft_small_bevel_gear = 0; // [-5:0.1:5]
h_small_bevel_shaft = 2; // [0:40]
l_bevel_shaft_bearing = 10;

flip_small_bevel_gear = false;
dz_plane_clearance_above_small_bevel = 6; // [-20 : 20]
n_teeth_big_bevel = 21; //[9 : 23]

use_mesh_keys_small_bevel = true;

/* [Slot Gearing Design] */
use_mesh_keys_slot_gear = true;
n_teeth_big_slot = 21; //[9 : 22]

/* [Gear Keying Design] */
gear_key_size = 3;
gear_key_clearance = 0.0;
gear_key_height = 4;
gear_key_displacement = 4;
gear_key_bridge_height = 0.5;
gear_key_platform_height = 2;  


module end_of_customization() {}
// Calcs for values that need to be shared to calculate displacements
id_clamp_gear = (n_teeth_small - 2) * clamp_gear_module;
od_clamp_gear  = (n_teeth_small + 2) * clamp_gear_module;
md_clamp_gear  = (n_teeth_small) * clamp_gear_module;

id_clamp_slot_gear = (n_teeth_big_slot - 2) * clamp_gear_module;
od_clamp_slot_gear = (n_teeth_big_slot + 2) * clamp_gear_module;
md_clamp_slot_gear = (n_teeth_big_slot) * clamp_gear_module;


id_small_bevel_gear = (n_teeth_small - 2) * bevel_gear_module;
od_small_bevel_gear  = (n_teeth_small + 2) * bevel_gear_module;
md_small_bevel_gear  = (n_teeth_small) * bevel_gear_module;

id_big_bevel_gear = (n_teeth_big_bevel - 2) * bevel_gear_module;
od_big_bevel_gear  = (n_teeth_big_bevel + 2) * bevel_gear_module;
md_big_bevel_gear  = (n_teeth_big_bevel) * bevel_gear_module;

overall_gear_ratio = (n_teeth_big_slot/n_teeth_small) * (n_teeth_big_bevel/n_teeth_small);

echo("Overall Gear Ratio", overall_gear_ratio);

z_traveller = md_clamp_gear/2 + od_clamp_slot_gear + l_bevel_shaft_bearing;


l_filament_to_cl_big_bevel = dz_small_bevel_gear + md_big_bevel_gear/2;

if (show_filament) {
    filament(as_clearance=false);
}

rotate_to_cl_clamp_gear = [0, 90, 0];
translate_to_cl_clamp_gear =  [
    0, 
    0, 
    -x_clamp_nut_block - clamp_gear_height/2-2]; //-14];

function filament_and_clamp_rotation() = 
    (mode == MESHING_GEARS) ? rotate_to_cl_clamp_gear : [0, 0, 0];    

function filament_and_clamp_translation() = 
    (mode == MESHING_GEARS) ? translate_to_cl_clamp_gear : [0, 0, 0];

module filament(as_clearance) {
    d = as_clearance ? 2.5 : d_filament;
    alpha = as_clearance ? 0 : 1;
    if (as_clearance) {
        can(d=d, h=slide_length + 40, $fn=12); 
    } else {
            translate(filament_and_clamp_translation() ) rotate(filament_and_clamp_rotation()) { 
            color("red", alpha) {
                can(d=d, h=slide_length + 40, $fn=12);
            }
        }
    }
    
}

layout = layout_from_mode(mode);
echo("mode", mode, "layout", layout);

gear_holder_visualization = 
    visualize_info(
        "Gear Holder", PART_1, gear_holder_visibility, layout, show_parts); 

clamp_gear_visualization = 
    visualize_info(
        "Clamp Gear", PART_2, clamp_gear_visibility, layout, show_parts);  

clamp_slot_gear_visualization = 
    visualize_info(
        "Clamp Slot Gear", PART_3, clamp_slot_gear_visibility, layout, show_parts);  

small_bevel_gear_visualization = 
    visualize_info(
        "Small Bevel Gear", PART_4, small_bevel_gear_visibility, layout, show_parts); 


big_bevel_gear_visualization = 
    visualize_info(
        "Big Bevel Gear", PART_5, big_bevel_gear_visibility, layout, show_parts); 
        
        
traveller_body_visualization  = 
    visualize_info(
        "Traveller Body", PART_6, traveller_body_visibility, layout, show_parts);       

gear_mesh_keys_visualization =
    visualize_info(
        "Gear Mess Keys", PART_30, gear_mesh_keys_visibility, layout, show_parts); 





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


module general_bevel_gear(n_teeth, gear_module, tooth_width, cone_angle = 45,body_child = -1, cutout_child = -1) { 
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
        }
        if (cutout_child >= 0 && $children > cutout_child) {
            children(cutout_child);
        }  
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

module slot_gear_pivot_screw(as_clearance=false) {
    l_screw = 20;
    dz = md_clamp_gear/2 + md_clamp_slot_gear/2;
    translate([0, 0, dz]) {
        rotate([0, 90, 0]) {
            if (as_clearance) {
                translate([0, 0, -2]) hole_through("M2", $fn = 12);
            } else {
                color(COPPER) {
                    translate([0, 0, -2-l_screw]) rotate([180, 0, 0]) screw("M2x20", $fn=12);
                }
            }
        }
    }
}

module big_bevel_bearing(as_clearance=false) {
    dz = md_clamp_gear/2 + od_clamp_slot_gear + 4;
    dx = -42; // -l_filament_to_cl_big_bevel + 2; 
    if (as_clearance) {
        translate([dx, 0, 0]) block([12, 12, a_lot]);
        #translate([dx, 0, dz]) block([16, 16, a_lot], center=BELOW);
    } else {
    }
}


module gear_holder_clearances() {
    filament(as_clearance=true);
    clamp_screw(as_clearance=true);
    slot_gear_pivot_screw(as_clearance=true);
    big_bevel_bearing(as_clearance=true);
}

traveller_body();

module traveller_body() {
    triangle_placement(r=-2*x_clamp_nut_block) {
        rotate([0, -90, 0]) 
            gear_holder(
            show_vitamins=false, 
            visualization=traveller_body_visualization,
            standalone = false);
    }
    
}


gear_holder(show_vitamins=show_vitamins, visualization=gear_holder_visualization); 


//        hull() {
//            translate([-l_filament_to_cl_big_bevel, 0, z_traveller]) can(d=24, h=l_bevel_shaft_bearing, center=BELOW);
//            translate([0, 0, z_traveller]) can(d=5, h=l_bevel_shaft_bearing-2, center=BELOW);
//        }
   
#big_bevel_holder();

module big_bevel_holder() {
    
    x = x_clamp_nut_block + dz_small_bevel_gear +  od_big_bevel_gear/2 + 10;
    translate([0, 0, z_traveller]) block([x, 14, 4], center=BEHIND+BELOW);
}
        
module gear_holder(
        show_vitamins=true, 
        include_bearing_mounting_adapter = true,
        as_mounting_screw_clearance=false,
        visualization=gear_holder_visualization, 
        screw_lift = screw_lift,
        standalone = true) {
            
    
    screw_wall = 2;
    wall = 2;
    
    y_clamp_nut_block = 8;
    pivot_screw_length = 16;

    module nut_block() {
        d_filament_wrap = standalone ? 5 : d_filament;
        hull() {
            translate([-x_clamp_nut_block, 0, 0]) block([5, y_clamp_nut_block, 2.5], center=FRONT+BELOW);
            can(d=d_filament_wrap, h=2.5, center=BELOW);
        }
        hull() {    
            translate([-x_clamp_nut_block, 0, 0]) block([5, y_clamp_nut_block, z_traveller], center=FRONT+ABOVE);
            can(d=d_filament_wrap, h=z_traveller, center=ABOVE);
        }

    }

    module shape() {
        difference() {
            union() {
                nut_block();
            }
            gear_holder_clearances();
        }
            
    } 
    
    module vitamins() {
        clamp_screw(as_clearance=false);
        slot_gear_pivot_screw(as_clearance=false);
        
    }
    translate(filament_and_clamp_translation() ) rotate(filament_and_clamp_rotation()) {
        if (show_vitamins) {
            visualize_vitamins(visualization) vitamins();
        }
        visualize(visualization) { 
            shape();
        }
    }
    
}  

if (!hide_sample_gear_keys) {
    gear_mesh_keys(as_clearance = false);
}

module gear_mesh_keys(
        as_clearance = true, 
        clearance = gear_key_clearance,
        key_height = gear_key_height,
        platform_height = gear_key_platform_height,
        bridge_height = gear_key_bridge_height,
        center = CENTER) {
    module item() {
        if (as_clearance) {
            d = gear_key_size*sqrt(2) + 2 * clearance;
            can(d=d, h=a_lot);
        } else {
            block([gear_key_size,gear_key_size, key_height], center=BELOW);
        }        
    }
    module keys() {
        center_reflect([1, 0, 0]) 
            center_reflect([0, 1, 0]) 
                translate([gear_key_displacement, gear_key_displacement, 0]) 
                    item();
    }
    module bridging() {
        center_reflect([1, 0, 0]) 
            hull() 
                center_reflect([0, 1, 0]) 
                    translate([gear_key_displacement, gear_key_displacement, 0])
                        block([gear_key_size,gear_key_size, bridge_height], center=ABOVE);
    }
    module platform() {
        hull() 
            center_reflect([1, 0, 0]) 
                center_reflect([0, 1, 0]) 
                    translate([gear_key_displacement, gear_key_displacement, bridge_height])
                        block([gear_key_size, gear_key_size, platform_height], center=ABOVE);        
    }
    if (as_clearance) {
        keys();
    } else {
        translation = 
            center == CENTER ? [0, 0, 0] :
            center == BELOW ? [0, 0, -(bridge_height + platform_height)] :  
            center == ABOVE ? [0, 0, key_height] : 
            assert(false, "The argument center can only be CENTER, BELOW, or ABOVE");
        visualize(gear_mesh_keys_visualization) {
            translate(translation) {
                keys();
                bridging();
                platform();
            }
        }
    }
    
}



clamp_gear(orient_for_build=false, orient_to_center_of_rotation=false, show_vitamins=true);

module clamp_gear(orient_for_build, orient_to_center_of_rotation=false, show_vitamins=false) {
    module shape() {


        h_top = 2;
        h_total = h_bottom_clamp_gear + clamp_gear_height + h_top;
        h_hold_screw = 6;
        dz_nut_cut = -clamp_gear_height/2 - h_bottom_clamp_gear + 2;
        general_straight_spur_gear(
                n_teeth_small, 
                clamp_gear_module, 
                clamp_gear_height, 
                body_child = 0, 
                cutout_child = 1) {
            union() {
                translate([0, 0, -clamp_gear_height/2]) 
                    can(d=od_clamp_gear, h=h_bottom_clamp_gear, center=BELOW);
                translate([0, 0, clamp_gear_height/2]) 
                    can(d=id_clamp_gear-0.5, h=h_top, center=ABOVE);
            }
            union() {
                translate([0, 0, clamp_gear_height/2+h_top+h_hold_screw]) 
                   hole_through("M2", h=h_total, cld=0.4, $fn=12); 
                translate([0, 0, dz_nut_cut]) nutcatch_parallel("M2", clh=10, clk=0.2);
                
            }
        }
    }
    rotation = (mode == MESHING_GEARS) ? [0, 0, 0] : [90, 0, 0];
    visualize(clamp_gear_visualization) 
        rotate(rotation)
            shape(); 
}

clamp_slot_gear();

module clamp_slot_gear() {
    // This drives the clamp gear, and provides a slot for it to slide in
    // Print it from the top
    module shape() {
        print_from_top = false;
        h_bottom = 3;
        dz_bottom = print_from_top ? 0 : -clamp_gear_height/2 - h_bottom/2;
        d1_bottom = print_from_top ? 10 : id_clamp_slot_gear;
        d2_bottom = print_from_top ? 10 : id_clamp_slot_gear;
        d2_top = print_from_top ? 0 : od_clamp_slot_gear;
        h_top = print_from_top ? od_clamp_slot_gear/3: 1;
        h_total = h_bottom + clamp_gear_height + h_top;
        h_hold_screw = 6;
        //dz_nut_cut = -clamp_gear_height/2 - h_bottom + 2;
        general_straight_spur_gear(
                n_teeth_big_slot, 
                clamp_gear_module, 
                clamp_gear_height, 
                body_child = 0, 
                cutout_child = 1) {
            union() {
                translate([0, 0, dz_bottom]) 
                    cylinder(d1=d1_bottom, d2=d2_bottom, h=h_bottom, center=true);
                translate([0, 0, clamp_gear_height/2+h_top/2]) 
                    cylinder(d1=od_clamp_slot_gear, d2=d2_top, h=h_top, center=true);
            }
            union() {
                // Axle, rotates around an M2 with ptfe tubing around it.
                can(d=od_ptfe_tube+ptfe_insert_clearance, h=a_lot);
                if (use_mesh_keys_slot_gear) {
                    // Keys for attaching with the beveled gear
                    gear_mesh_keys(as_clearance = true);
                }
                if (!print_from_top) {
                    // Trim from bottom of teeth so that the teeth build
                    // from inner diameter
                    h_trim = (od_clamp_slot_gear - id_clamp_slot_gear)/2;
                    translate([0, 0, -clamp_gear_height/2])
                    difference() {
                        cylinder(d = od_clamp_slot_gear + 1, h = h_trim);
                        cylinder(
                            d1 = id_clamp_slot_gear, 
                            d2 = od_clamp_slot_gear, 
                            h = h_trim);
                        
                    }
                }                
            }
        }
    }
    dx_slot = md_clamp_gear/2 + md_clamp_slot_gear/2 + print_clearance;
    rotation = mode == MESHING_GEARS ? [0, 0, 0] : [90, 0, 0];
    translation = mode == MESHING_GEARS ? [dx_slot, 0, 1] : [90, 0, 0];
    visualize(clamp_slot_gear_visualization) 
        translate(translation) 
            rotate(rotation)
                shape(); 
}




small_bevel_gear();

module small_bevel_gear(use_mesh_keys=use_mesh_keys_small_bevel) {
    // Should calculate this, but eyeball for now 
    use_plane_clearance_small_bevel = false;
    module shape() {
        
        general_bevel_gear(
                n_teeth_small, 
                bevel_gear_module, 
                small_gear_tooth_width, 
                cone_angle = small_bevel_gear_cone_angle, 
                body_child = 0, cutout_child = 1) {
            union() {
                translate([0, 0, dz_shaft_small_bevel_gear]) 
                    can(d = od_ptfe_tube + 4, h=h_small_bevel_shaft, center=BELOW);
                if (use_mesh_keys) {
                    translate([0, 0, -h_small_bevel_shaft]) 
                        gear_mesh_keys(as_clearance = false, center=BELOW);
                }  
            }
            union() {
                can(d=od_ptfe_tube+ptfe_insert_clearance, h=a_lot);
                // Need to consider flipping
                if (use_plane_clearance_small_bevel) {
                    direction = flip_small_bevel_gear ? BELOW : ABOVE;
                    translate([0, 0, dz_plane_clearance_above_small_bevel]) 
                        plane_clearance(direction);
                }
            }            
        }
    }   
    dx_slot = md_clamp_gear/2 + md_clamp_slot_gear/2+print_clearance;
    ax = flip_small_bevel_gear ? 180 : 0;
    rotation = mode == MESHING_GEARS ? [ax, 0, 0] : [90, 0, 0];
    translation = mode == MESHING_GEARS ? [dx_slot, 0, dz_small_bevel_gear] : [90, 0, 0];
    visualize(small_bevel_gear_visualization) 
        translate(translation) 
            rotate(rotation)
                shape(); 
}

big_bevel_gear();

module big_bevel_gear() {
    
    module shape() {
        
        general_bevel_gear(
                n_teeth_big_bevel, 
                bevel_gear_module, 
                small_gear_tooth_width, 
                cone_angle = 90-small_bevel_gear_cone_angle, 
                body_child = 0, cutout_child = 1) {
            union() {
 //               translate([0, 0, dz_shaft_small_bevel_gear]) can(d = od_ptfe_tube + 4, h=h_small_bevel_shaft, center=BELOW);
//                if (use_mesh_keys) {
//                    translate([0, 0, -h_small_bevel_shaft]) gear_mesh_keys(as_clearance = false, center=BELOW);
//                }  
            }
            union() {
               translate([0, 0, 25]) hole_through("M2", cld=0.4, $fn=12);
               gear_mesh_keys(as_clearance = true); 
            }            
        }
    }   
    dx_slot = md_clamp_gear/2 + md_clamp_slot_gear/2 + md_small_bevel_gear/2 + 15* print_clearance;
    //ax = flip_small_bevel_gear ? 180 : 0;
    
    rotation = mode == MESHING_GEARS ? [0, -90, 0] : [90, 0, 0];
    translation = mode == MESHING_GEARS? [dx_slot, 0, l_filament_to_cl_big_bevel] : [90, 0, 0];
    visualize(big_bevel_gear_visualization) 
        translate(translation) 
            rotate(rotation)
                shape(); 
}
