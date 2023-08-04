include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>
use <ScadApotheka/roller_limit_switch.scad>
use <ScadApotheka/ptfe_filament_tubing_connector.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>







ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;

a_lot = 100 + 0;
 /* [Output Control] */
 
 mode = 3; // [3: "Assembly", 4: "Printing"]
show_vitamins = true;
show_filament = true;
show_parts = true; // But nothing here has parts yet.
show_legend = false;

barrel = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
limit_switch_support = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
filament_holder = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

/* [Animation] */    

roller_switch_depressed = true;


/* [Limit Switch Holder Design] */

dz_switch_body = 0; // [-20:0]
right_handed_limit_switch_holder = false;
limit_switch_holder_base_thickness = 4;
roller_arm_length = 20; // [18:Short, 20:Long]

// These are in coordinate system of switch before tilt
dx_limit_switch_holder = 10;  // [0:20]
dy_limit_switch_holder = -13.0;  // [-20:0] 
dz_limit_switch_holder = -0.5;  // [0:25]

tilt_limit_switch = -45;

/* [Barrel Design] */

dx_inlet_collet = 34; // [10:40]

/* [Printing] */
print_one_part = false;
part_to_print = "barrel"; // [barrel]

module end_of_customization() {}


function layout_from_mode(mode) = 
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";

layout = layout_from_mode(mode);

function show(variable, name) = 
    (print_one_part && (mode == PRINTING)) ? name == part_to_print :
    variable;

visualization_limit_switch_support =        
    visualize_info(
        "Limit Switch Support ", PART_1, show(limit_switch_support, "limit_switch_support") , layout, show_parts);  

visualization_filament_holder =        
    visualize_info(
        "Filament Holder ", PART_2, show(filament_holder, "filament_holder") , layout, show_parts);  

roller_switch_body = rls_base();

connector = flute_connector_dimensions();    
connector_extent = gtcc_extent(connector);
clamp = flute_clamp_dimensions();    
clamp_extent = gtcc_extent(clamp);


module limit_switch_holder() {
    base_thickness = connector_extent.y/2;
    dy_beneath_limit_switch = cos(tilt_limit_switch) * dy_limit_switch_holder;
    echo("dy_beneath_limit_switch", dy_beneath_limit_switch);
    switch_translation = [dx_limit_switch_holder, dy_limit_switch_holder, dz_limit_switch_holder];
    tilt = [tilt_limit_switch, 0, 0];
    
    nut_block = [7, 7, 6];
    joiner = [3, abs(dy_beneath_limit_switch), 5];
    
    module  adjustment_screw(as_clearance = false, as_nut_block=false) {
        head_height = 5;
        // screw_offset is in the coordinate system of the limit switch body
        screw_offset = [-roller_switch_body.x/2 - 6, 0, 0];
        rotate(tilt) translate(switch_translation + screw_offset) rotate([90, 0, 0]) {
            if (as_clearance) {
                translate([0, 0, head_height]) hole_through("M2", h=head_height, cld=0.4, $fn=12);
                // Rotate down
                translate([0, 0, -2])  rotate([0, 0, 90]) nutcatch_sidecut(

                    name   = "M2",  // name of screw family (i.e. M3, M4, ...) 
                    l      = 50.0,  // length of slot
                    clk    =  0.5,  // key width clearance
                    clh    =  0.5,  // height clearance
                    clsl   =  0.5); // slot width clearance
            } else if (as_nut_block) {
                block(nut_block, center=BELOW);
            } else {
                color(STAINLESS_STEEL)  screw("M2x16");
            }
        }
    }
    module adjustment_screw_block() {
        base = [nut_block.x, nut_block.y, base_thickness];
        hull() {
            adjustment_screw(as_nut_block = true);
            translate([-2, dy_beneath_limit_switch+2, 0]) block(base, center = LEFT+BEHIND+BELOW);
        }
        translate([+1, dy_beneath_limit_switch+2, 0]) block(base, center = LEFT+BEHIND+BELOW);
    }
    module pedistal() {
        x_extra = 9;
        x = roller_switch_body.x + x_extra;
        dx = -x_extra;
        target = [x, 5, limit_switch_holder_base_thickness];
        base = [x, target.y/cos(tilt_limit_switch) , base_thickness];
        target_offset = [-roller_switch_body.x/2, -1, -roller_switch_body.y/2];
        translate([dx, 0, 0]) {
            hull() {
                rotate(tilt) translate(switch_translation + target_offset) 
                    block(target, center=BELOW + FRONT);
                translate([0, dy_beneath_limit_switch, 0]) block(base,  center=BELOW + LEFT +FRONT);
            }  
        }      
    }
    
    module rib() {
        // Add a rib so that structure is less tippy
         s= 16;
        translate([roller_switch_body.x/2, -10, 0]) hull() {
            rotate([tilt_limit_switch, 0, 0]) block([4, 14, 1], center=BELOW+LEFT);
            translate([0, 0, -base_thickness]) block([4, 11, 0.1], center = ABOVE+LEFT);
        }        
    }
    
    rotate(tilt) translate(switch_translation) rotate([90, 0, 0])
            nsrsh_top_clamp(
                show_vitamins=show_vitamins && mode != PRINTING , 
                right_handed = right_handed_limit_switch_holder,
                alpha=1, 
                thickness=limit_switch_holder_base_thickness, 
                recess_mounting_screws = false,
                use_dupont_connectors = true,
                roller_arm_length = roller_arm_length,
                switch_depressed = roller_switch_depressed); 
    visualize(visualization_limit_switch_support) {
        render(convexity=10) difference() {
            union() {
                translate([roller_switch_body.x, -1, -base_thickness]) block(joiner, center=LEFT+ABOVE+BEHIND);
                pedistal();
                rib();
                adjustment_screw_block();
            }
            adjustment_screw(as_clearance=true);
        }
    }
    if (show_vitamins) {
        adjustment_screw(as_clearance = false);
    }
}


module filament_holder() {
    dx_roller_clearance = 1;
    x_roller_clearance = 10;
    module roller_clearance() {
        translate([1, 0, 0]) rotate([45, 0, 0]) block([x_roller_clearance, 8, 5], center=ABOVE);
    }
    module filament_recapture_clearance() {
        //directs the filament  back into the path, even if the limit switch roller allows it deviate a bit. 
        translate([-x_roller_clearance/2 + dx_roller_clearance, 0, 0]) intersection() {
            rod(d=0, taper=6, l=4, center=BEHIND);
            roller_clearance(); 
        }
    }
    l_collet = connector_extent.z + clamp_extent.z;
    x_fh_front = dx_inlet_collet - l_collet;
    x_fh_behind = 10;
    visualize(visualization_filament_holder) {
        render(convexity=10) difference() {
            union() {
                hull() {
                    translate([0, 0, -3]) block([x_fh_front, 6, 0.1], center=ABOVE+FRONT);
                    translate([0, 0, 0.5]) rod(d=5, l=x_fh_front, center=FRONT);
                }
                hull() {
                    translate([0, 0, -3])  block([x_fh_behind, 6, 0.1], center=ABOVE+BEHIND);
                    translate([0, 0, 0.5]) rod(d=6, l=x_fh_behind, center=BEHIND);
                    
                }
            }
            // Teardrop filament path
            hull() {
                rod(d=2, l=a_lot);
                block([a_lot, 0.7, 1.5], center=ABOVE);
            }
            roller_clearance();
            filament_recapture_clearance();
        }
    }

}
module outlet() {
    dx_outlet = -10;
    translate([dx_outlet, 0, 0]) {
        rotate([0, -90, 0]) rotate([0, 0, 90]) {
            render(convexity = 10) difference() {
                translate([0, 0, -clamp_extent.z]) flute_collet(is_filament_entrance = false);
                translate([0, 0, -2]) plane_clearance(BELOW);
            }
        }
    }
}

module inlet() {
    dx_inlet = roller_switch_body.x;
    translate([dx_inlet, 0, 0]) 
        rotate([0, -90, 0]) rotate([0, 0, 90]) {
            difference() {
                translate([0, 0, -clamp_extent.z]) flute_collet(is_filament_entrance = false);  
                translate([0, 0, 3]) plane_clearance(ABOVE);
            }
    }    
}


module medusa_filament_detecter() {
    inlet();
    filament_holder();
    outlet();
    limit_switch_holder();
}


medusa_filament_detecter();



