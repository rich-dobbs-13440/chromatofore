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
show_parts = true; // But nothing here has parts yet.
show_legend = false;

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
dz_limit_switch_holder = 0;  // [0:25]

tilt_limit_switch = 0;
tilt = [tilt_limit_switch, 0, 0];

/* [Filament Holder Design] */

dx_roller_clearance = 1;
x_roller_clearance = 10;
x_extra_for_inlet = 4;
nut_block = [7, 7, 6];

/* [Adjuster design] */

adjustable_mount_slide_length = 11;
adjuster_slide_length = 20;
adjuster_screw_length = 20;


/* [Outlet Design] */
dx_outlet = -20;
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

visualization_limit_switch_support =        
    visualize_info(
        "Limit Switch Support ", PART_1, show(limit_switch_support, "limit_switch_support") , layout, show_parts);  

visualization_filament_holder =        
    visualize_info(
        "Filament Holder ", PART_4, show(filament_holder, "filament_holder") , layout, show_parts);  

roller_switch_body = rls_base();

connector = flute_connector();    
connector_extent = gtcc_extent(connector);
clamp = flute_clamp_connector();    
clamp_extent = gtcc_extent(clamp);
dx_filament_recapture = -x_roller_clearance/2 + dx_roller_clearance;
//
//module limit_switch_holder() {
//    base_thickness = connector_extent.y/2;
//    dy_beneath_limit_switch = cos(tilt_limit_switch) * dy_limit_switch_holder;
//    echo("dy_beneath_limit_switch", dy_beneath_limit_switch);
//    switch_translation = [dx_limit_switch_holder, dy_limit_switch_holder, dz_limit_switch_holder];
//
//    module  adjustment_screw(as_clearance = false, as_nut_block=false,  as_filament_nut_block= false) {
//        head_height = 5;
//        dy_screw_offset = -10;
//        dz_filament_nutcatch = dy_screw_offset - 1;
//         
//        // screw_offset is in the coordinate system of the limit switch body
//        screw_offset = [-roller_switch_body.x/2 - nut_block.x/2 + dx_filament_recapture, dy_screw_offset, 0];
//        
//        module  nut_catch() {
//            rotate([0, 0, 90]) nutcatch_sidecut(
//
//                    name   = "M2",  // name of screw family (i.e. M3, M4, ...) 
//                    l      = 50.0,  // length of slot
//                    clk    =  0.5,  // key width clearance
//                    clh    =  0.5,  // height clearance
//                    clsl   =  0.2); // slot width clearance
//        }
//        rotate(tilt) translate(switch_translation + screw_offset) rotate([90, 0, 0]) {
//            if (as_clearance) {
//                translate([0, 0, head_height]) hole_through("M2", h=head_height, cld=0.4, $fn=12);
//                translate([0, 0, -2]) nut_catch();
//                // Attach a nut_catch to the filament holder 
//                translate([0, 0, dz_filament_nutcatch-2]) nut_catch();
//                
//
//            } else if (as_nut_block) {
//                block(nut_block, center=BELOW);
//            } else if (as_filament_nut_block) {  
//                translate([0, 0, dz_filament_nutcatch]) block(nut_block + [0, 0, 2], center=BELOW);
//            } else {
//                color(STAINLESS_STEEL)  screw("M2x16");
//            }
//        }
//    }
//    dy_adjustment_screw_base = -8;
//    module adjustment_screw_block() {
//        dy = dy_beneath_limit_switch + dy_adjustment_screw_base;
//        base = [nut_block.x, nut_block.y, base_thickness];
//        hull() {
//            adjustment_screw(as_nut_block = true);
//            translate([-2, dy, 0]) block(base, center = LEFT+BEHIND+BELOW);
//        }
//        adjustment_screw(as_filament_nut_block = true);
//        translate([+1, dy, 0]) block(base, center = LEFT+BEHIND+BELOW);
//    }
//    module pedistal() {
//        x_extra = 3;
//        x = roller_switch_body.x + x_extra;
//        dx = -x_extra;
//        target = [x, 5, limit_switch_holder_base_thickness];
//        base = [x, target.y/cos(tilt_limit_switch) , base_thickness];
//        target_offset = [-roller_switch_body.x/2, -1, -roller_switch_body.y/2];
//        translate([dx, 0, 0]) {
//            hull() {
//                rotate(tilt) translate(switch_translation + target_offset) 
//                    block(target, center=BELOW + FRONT+RIGHT);
//                translate([0, dy_beneath_limit_switch, 0]) block(base,  center=BELOW + LEFT +FRONT);
//            }  
//        }      
//    }
//    
//    module rib() {
//        // Add a rib so that structure is less tippy
//         s= 16;
//        translate([roller_switch_body.x/2, -10, 0]) hull() {
//            rotate([tilt_limit_switch, 0, 0]) block([4, 14, 1], center=BELOW+LEFT);
//            translate([0, 0, -base_thickness]) block([4, 11, 0.1], center = ABOVE+LEFT);
//        }        
//    }
//    
//    module spring() {
//        spring = [2, 16, 4];
//        dz_spring = -spring.y;
//        clearance =0.5;
//        dz_attachment = -roller_switch_body.y/2 - clearance ;
//        attachment = [3, 2, limit_switch_holder_base_thickness];
//        translate([roller_switch_body.x, 0 , 0]) rotate(tilt) {
//             translate([1, -2, 0]) block(spring, center=LEFT+FRONT);
//            hull() {
//                translate([1,  dz_spring, 0]) block([attachment.x, attachment.y, spring.z], center=LEFT+FRONT);
//                translate([0, dz_spring, dz_attachment]) block(attachment, center=LEFT+BELOW+FRONT);
//            }
//            translate([0, dz_spring, dz_attachment]) block(attachment, center=LEFT+BELOW);
//        }
//    }
//    
//    rotate(tilt) translate(switch_translation) rotate([90, 0, 0])
//            nsrsh_terminal_end_clamp(
//                show_vitamins=show_vitamins && ! mode_is_printing(mode), 
//                right_handed = right_handed_limit_switch_holder,
//                alpha=1, 
//                thickness=limit_switch_holder_base_thickness, 
//                recess_mounting_screws = false,
//                use_dupont_connectors = true,
//                roller_arm_length = roller_arm_length,
//                switch_depressed = roller_switch_depressed); 
//    visualize(visualization_limit_switch_support) {
//        render(convexity=10) difference() {
//            union() {
//                pedistal();
//                spring();
//                rib();
//                adjustment_screw_block();
//            }
//            adjustment_screw(as_clearance=true);
//        }
//    }
//    if (show_vitamins) {
//        adjustment_screw(as_clearance = false);
//    }
//}
//
module filament_holder() {
    z_base = connector_extent.y/2;
    y_base = 8;
    y_pedistal = 6;
    x_fh_front = roller_switch_body.x + x_extra_for_inlet;
    x_fh_behind = abs(dx_outlet);
    above_to_tilt =  [-tilt_limit_switch, 0, 0];
    adjustment_screw_contact = [nut_block.x, nut_block.y+1, connector_extent.y/2];
    
    module roller_clearance() {
        translate([dx_roller_clearance, 0, -1]) rotate(above_to_tilt) block([x_roller_clearance, 10, 5], center=ABOVE);
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
        // Join the mount to the underneath the filament path
        translate([dx_limit_switch_holder, 0, -z_base]) block([10, 4, 1], center=ABOVE+RIGHT);
        
    } 
   
    if (show_vitamins && ! mode_is_printing(mode)) {
        visualize_vitamins(visualization_filament_holder) {
            switch_translation = [dx_limit_switch_holder, dy_limit_switch_holder, dz_limit_switch_holder];
            switch_rotation = tilt + [-90, 0, 0];
            rotate(switch_rotation) translate(switch_translation) rotate([90, 0, 0]) {
                
                nsrsh_terminal_end_clamp(
                    show_vitamins=show_vitamins && ! mode_is_printing(mode), 
                    right_handed = right_handed_limit_switch_holder,
                    alpha=1, 
                    thickness=limit_switch_holder_base_thickness, 
                    recess_mounting_screws = false,
                    use_dupont_connectors = true,
                    roller_arm_length = roller_arm_length,
                    switch_depressed = roller_switch_depressed); 
                rotate([0, 0, 180]) nsrsh_adjuster(
                    show_vitamins=show_vitamins, 
                    screw_length=adjuster_screw_length, 
                    slide_length=adjuster_slide_length);
            }
        }
    }

    visualize(visualization_filament_holder) {
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
                // # rotate(above_to_tilt) translate([dx_filament_recapture, 0, 0.5]) block(adjustment_screw_contact, center=BEHIND+ABOVE);
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
        // Offset the wrench to avoid interference with keyhole surface
        translate([2, -1, 0]) block(wrench, center=FRONT+LEFT);
        // TODO: Use wrench to make a slot, to prevent twisting  with adjustment screw changes
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


module medusa_filament_detecter() {
    inlet();
    filament_holder();
    outlet();
    //limit_switch_holder();
}


medusa_filament_detecter();



