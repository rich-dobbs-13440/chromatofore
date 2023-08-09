include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>
use <ScadApotheka/roller_limit_switch.scad>
use <ScadApotheka/ptfe_filament_tubing_connector.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>



a_lot = 100 + 0;
 /* [Output Control] */
 
 mode = 3; // [3: "Assembly", 4: "Printing"]
show_vitamins = true;
show_filament = true;
show_filament_holder = true;
show_adjuster = true;
show_adjustable_mount_clip = true;
show_parts = true; // But nothing here has parts yet.
show_legend = false;


filament_holder = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
adjuster = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

/* [Animation] */    

roller_switch_depressed = true;


/* [Limit Switch Holder Design] */

dz_switch_body = 0; // [-20:0]
right_handed_limit_switch_holder = false;
limit_switch_holder_base_thickness = 4;
roller_arm_length = 20; // [18:Short, 20:Long]

dx_limit_switch_holder = 10;  // [0:20]
dy_limit_switch_holder = 0;  // [-20:0] 
dz_limit_switch_holder = -1;  // [-3:0.1:3]


/* [Filament Holder Design] */

dx_roller_clearance = 1;
x_roller_clearance = 10;
y_roller_clearance = 6;
x_extra_for_inlet = 4;
nut_block = [7, 7, 6];

/* [Adjuster design] */

adjustable_mount_slide_length = 12;
adjuster_slide_length = 20;
adjuster_screw_length = 20;


switch_translation = [dx_limit_switch_holder, dy_limit_switch_holder, adjustable_mount_slide_length + dz_limit_switch_holder];

/* [Outlet Design] */
dx_outlet = -10;
x_wrench = 6;
y_wrench = 0;

/* [Printing] */
print_one_part = false;
part_to_print = "barrel"; // [barrel]

module end_of_customization() {}


layout = layout_from_mode(mode);

function show(variable, name) = 
    (print_one_part && mode_is_print(mode)) ? name == part_to_print :
    variable;



visualization_filament_holder =        
    visualize_info(
        "Filament Holder ", PART_4, show(filament_holder, "filament_holder") , layout, show_parts);  

visualization_adjuster =        
    visualize_info(
        "Adjuster ", PART_1, show(adjuster, "adjuster") , layout, show_parts);  

roller_switch_body = rls_base();

connector = flute_connector();    
connector_extent = gtcc_extent(connector);
clamp = flute_clamp_connector();    
clamp_extent = gtcc_extent(clamp);
dx_filament_recapture = -x_roller_clearance/2 + dx_roller_clearance;
 


module filament_holder() {
    z_base = connector_extent.y/2;
    y_base = 8;
    y_pedistal = 6;
    x_fh_front = roller_switch_body.x + x_extra_for_inlet;
    x_fh_behind = abs(dx_outlet);
    roller_clearance_stiffener = [x_roller_clearance + 10, y_roller_clearance/2 + 4, 2 * z_base];
    
    module roller_clearance() {
        translate([dx_roller_clearance, 0, -1]) block([x_roller_clearance, y_roller_clearance, 5], center=ABOVE);
    }
    module filament_recapture_clearance() {
        //directs the filament  back into the path, even if the limit switch roller allows it deviate a bit. 
        translate([dx_filament_recapture, 0, 0]) intersection() {
            rod(d=0, taper=6, l=4, center=BEHIND);
            roller_clearance(); 
        }
    }
    module adjustable_mount() {
        mount_translation = [dx_limit_switch_holder, roller_switch_body.y + 8, adjustable_mount_slide_length + 3.6];
        translate(mount_translation) {
            nsrsh_adjustable_mount(
                show_vitamins=show_vitamins, 
                screw_length=adjuster_screw_length,
                slide_length = adjustable_mount_slide_length);     
        }

        
    } 
   
    if (show_vitamins && ! mode_is_printing(mode)) {
        visualize_vitamins(visualization_filament_holder) {
            
            translate(switch_translation) {
                nsrsh_terminal_end_clamp(
                    show_vitamins=show_vitamins && ! mode_is_printing(mode), 
                    right_handed = right_handed_limit_switch_holder,
                    alpha=1, 
                    thickness=limit_switch_holder_base_thickness, 
                    recess_mounting_screws = false,
                    use_dupont_connectors = true,
                    roller_arm_length = roller_arm_length,
                    switch_depressed = roller_switch_depressed); 

            }
        }
    }
    
    module shape() {
        render(convexity=10) difference() {
            union() {
                hull() {
                    block([x_fh_front, y_pedistal, z_base], center=BELOW+FRONT);
                    translate([0, 0, 0.5]) rod(d=5, l=x_fh_front, center=FRONT);
                }
                hull() {
                    block([x_fh_behind, y_pedistal, z_base], center=BELOW+BEHIND);
                    translate([0, 0, 0.5]) rod(d=6, l=x_fh_behind, center=BEHIND);
                }
                translate([dx_roller_clearance, 0, 0]) block(roller_clearance_stiffener, center = LEFT); 
                // Join the mount to the underneath the filament path
                translate([dx_limit_switch_holder, 0, -z_base]) block([10, 6, connector_extent.y], center=ABOVE+RIGHT);                
            }
            
            // Teardrop filament path
            hull() {
                rod(d=2, l=a_lot);
                block([a_lot, 0.7, 1.5], center=ABOVE);
            }
            roller_clearance();
            filament_recapture_clearance();
            
            
        }
        adjustable_mount();        
    }

    visualize(visualization_filament_holder) {
        shape();
    }

}

module outlet() {
    wrench = [x_wrench, y_wrench, clamp_extent.y];
    translate([dx_outlet, 0, 0]) {
        rotate([0, -90, 0]) rotate([0, 0, 90]) {
            render(convexity = 10) difference() {
                translate([0, 0, -clamp_extent.z]) flute_collet(is_filament_entrance = false);
                translate([0, 0, -2]) plane_clearance(BELOW);
            }
        }
        if (y_wrench > 0) {
            // Offset the wrench to avoid interference with keyhole surface
            translate([2, -1, 0]) block(wrench, center=FRONT+LEFT);
        }
    }
}

module inlet() {
    dx_inlet = roller_switch_body.x + x_extra_for_inlet;
    translate([dx_inlet, 0, 0]) 
        rotate([0, -90, 0]) rotate([0, 0, 90]) {
            difference() {
                translate([0, 0, -clamp_extent.z]) flute_collet(is_filament_entrance = false);  
                translate([0, 0, 3]) plane_clearance(ABOVE);
            }
    }    
}


module adjuster() {
    translation = mode_is_printing(mode) ? [0, -20, -roller_switch_body.y/2] : switch_translation;
    rotation = mode_is_printing(mode) ? [-90, 0, 0] : [0, 0, 180];
    translate(translation) {
        rotate(rotation) {
            nsrsh_adjuster(
                show_vitamins=show_vitamins, 
                screw_length=adjuster_screw_length, 
                slide_length=adjuster_slide_length);
        }
    }
}


module medusa_filament_detecter() {
    translation = mode_is_printing(mode) ? [0, 0, clamp_extent.y/2] : [0, 0, 0];
    translate(translation) {
        inlet();
        filament_holder();
        outlet();
    }
}

if (show_filament_holder) {
    medusa_filament_detecter();
}

if (show_adjuster) {
    adjuster();
}

if (show_adjustable_mount_clip) {
    dz_clip = adjustable_mount_slide_length-2;
   dy_clip = roller_switch_body.y + 8; // dy_limit_switch_holder; 
    translation = mode_is_printing(mode) ? [0, -25, -roller_switch_body.y/2] : [dx_limit_switch_holder, dy_clip, dz_clip];
    rotation = mode_is_printing(mode) ? [-90, 0, 0] : [0, 0, 0];
    translate(translation) {
        rotate(rotation) {
            nsrsh_adjustable_mount_clip(show_vitamins=show_vitamins && !mode_is_printing(mode));
        }
    }
}



