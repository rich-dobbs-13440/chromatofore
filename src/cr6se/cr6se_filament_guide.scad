/* 

The CR 6 SE filament guide serves as an attachment point of the Chromatofore filament exchanger
system to the stock filament runout detector.  It serves to guide the filament into stock extruder.  


Origin of the Coordinate System:

[0, 0, 0] is at the top of the mounting plate, at the corner where the part on which the extruder
is attached intersects with the part where the runout detector is mounted. 

Positive X is toward the runout detector.  Positive Y is toward the front of the printer,
so the runout detector is located in the quadrant with positive X and Y.  

TODO: 

1.  Not flat from printing direction.  
2.  Corners, mouse ears for better first layer adhesion.
3. Resolve overlap in y_lip vs dy_left_overhang
*/



include <ScadStoicheia/centerable.scad>
include <ScadStoicheia/logging.scad>
use <ScadStoicheia/not_included_batteries.scad>
include <nutsnbolts-master/cyl_head_bolt.scad>
include <ScadApotheka/material_colors.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>
use <ScadApotheka/ptfe_filament_tubing_connector.scad>

a_lot = 200+ 0;



/* [Output Control] */
    show_mocks = true;
    show_vitamins = true;

    orient_for_build = false;
    test_print = false;

    build_guide = true;
    build_outlet = true;
    build_inlet = false; // Currently, the inlet is built into the guide!
    build_mantis_support = true;
    build_mantis_holder_lock = true;

/* [Guide Design] */
    ptfe_lining = false;
    y_lip = 0;
    z_lip = 2;
    z_runout_screw_tab = 4;
    pivot_clearance_angle = 3;
    x_extruder_clearance = 0.5;
    x_runout_clearance =0.5;
    dx_slot = 0.1;
    dy_slot = 0.25;
    h_runout_pivot = 4;
    slot_translation = [dx_slot, dy_slot, 0];
    
/* [Inlet Attachment Design] */
    x_inlet_attachment = 4;
    dy_left_overhang = -2.4;
    y_top_cap = 30;
    z_attachment_inlet_face = 16;
    z_atttachment_bracket = 10;

/* [Tube Design] */
    od_ptfe_tube = 4 + 0;
    l_tube_holder = 7; 
    ptfe_tube_tolerance = 0.1;
    as_cavity = false;
    z_runout_detector_screw_lift = 2; //[0: 0.5: 2.5]
    
 /* [Mantis Support Design] */
    delta_mantis_screw = 9;
    x_mantis_support = 90;
    ay_mantis_holder = 40;   
    dx_mantis_support_base = -15; 
    dz_mantis_holder = 10;

/* [Colors] */
    guide_show_parts = false;
    guide_alpha = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]
    guide_inlet_alpha = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]
    guide_outlet_alpha = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible] 

    bracket_alpha = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]
    runout_alpha = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]
    extruder_alpha = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]
   
    idler_color = "Maroon"; 

/* [Build Plate Layout] */   
    x_mantis_support_bp  = 0;
    y_mantis_support_bp  = 20; 
    
    x_mantis_holder_bp = 100;
    y_mantis_holder_bp = -20;

module end_of_customization() {}

guide_visualization = visualize_info(PART_1, guide_alpha);
guide_inlet_visualization = visualize_info(PART_2, guide_inlet_alpha);
guide_outlet_visualization = visualize_info(PART_3, guide_outlet_alpha);

extruder_visualization = visualize_info(BLACK_PLASTIC_1, extruder_alpha);
bracket_visualization = visualize_info(CREALITY_POWDER_COATED_METAL_PLATE, bracket_alpha);
idler_visualization = visualize_info(idler_color, bracket_alpha);
runout_visualization = visualize_info(BLACK_PLASTIC_2, runout_alpha);



entrance_translation = [0, 15, 10.0]; //[0, 14.6, 10.0];

function visualize_info(color_code, alpha) = [color_code, alpha];
    
// TODO - move to a reusable location!
module visualize(info,  show_part_colors=false) {
    color_code = info[0];
    alpha = info[1];
    if (show_part_colors) {
        // Just pass through, so that underlying colors can be seen
        children();
    } else if (alpha == 0) {
        // Don't create anything.  This avoids some artifacts in rendering
        // such as wrong z ordering or not enough convexity being specified.
    } else {
        color(color_code, alpha) {
            children();
        }
    }
}

/* [ Dimensions] */


runout_detector = [40, 31.12, 17.75];
runout_detector_filament_offset  = [0, 16, entrance_translation.z];
runout_detector_translation = [19, entrance_translation.y - runout_detector_filament_offset.y, 0];
runout_detector_x_screw_offset = 5;
runout_detector_y_screw_offset = 3.5;

z_lifted_screw = runout_detector.z + z_runout_detector_screw_lift;
 
runout_detector_screw_offsets = [
    [runout_detector.x - runout_detector_x_screw_offset, runout_detector_y_screw_offset, runout_detector.z],
    [runout_detector_x_screw_offset, runout_detector.y - runout_detector_y_screw_offset, runout_detector.z],
];



extruder = [42.8, 43.3, 24.7];
dy_extruder_offset = -16.5;
bracket_front = [57, 45.6, 4.7];
dy_back_bracket = dy_extruder_offset + extruder.y + 4;


dz_bracket_screws = runout_detector.z - entrance_translation.z + 0.5 * z_attachment_inlet_face;

module Extruder() {
    translate([0, dy_extruder_offset, 0]) {
        visualize(extruder_visualization) { 
            difference() {
                block(extruder, center=ABOVE+RIGHT+BEHIND);
                translate(entrance_translation + [0, -dy_extruder_offset, 0]) rod(d=5, l=a_lot);
            }
        }
    }
}

module ExtruderSupportBracket() {
    visualize(bracket_visualization) {
        hull() {
            translate([-extruder.x, 0 , 0])  can(d=2, h=bracket_front.z, center=BELOW+RIGHT+FRONT);
            translate([-extruder.x, dy_back_bracket , 0])  can(d=2, h=bracket_front.z, center=BELOW+LEFT+FRONT);
            translate([bracket_front.x, bracket_front.y, 0]) can(d=2, h=bracket_front.z, center=BELOW+BEHIND+LEFT);
            translate([bracket_front.x, 0, 0]) can(d=2, h=bracket_front.z, center=BELOW+BEHIND+RIGHT);
        }
        hull() {
            translate([-extruder.x, dy_extruder_offset , 0])  can(d=2, h=bracket_front.z, center=BELOW+RIGHT+FRONT);
            translate([-extruder.x, 1 , 0])  can(d=2, h=bracket_front.z, center=BELOW+RIGHT+FRONT);
            translate([0, 1 , 0])  can(d=2, h=bracket_front.z, center=BELOW+RIGHT+BEHIND);
            translate([0, dy_extruder_offset, 0])  can(d=2, h=bracket_front.z, center=BELOW+RIGHT+BEHIND);
        }
    }
}

module RunoutDetector(as_screw_clearance=false) {
    translate(runout_detector_translation) { 
        if (as_screw_clearance) {
            translate(runout_detector_screw_offsets[0] + [0, 0, 25]) hole_through("M3", cld=0.6, $fn=12);
            translate(runout_detector_screw_offsets[1] + [0, 0, 25]) hole_through("M3", cld=0.6, $fn=12);            
        } else {
            difference() {
                visualize(runout_visualization) block(runout_detector, center=ABOVE+FRONT+RIGHT);
                translate(runout_detector_filament_offset) rod(d=4, l=a_lot);
                
            }
            color(STAINLESS_STEEL) {
                translate(runout_detector_screw_offsets[0] + [0, 0, z_runout_detector_screw_lift]) screw("M3x25");
                translate(runout_detector_screw_offsets[1] + [0, 0, z_runout_detector_screw_lift]) screw("M3x25");
            }
        }
    } 
    
    
}



module ZAxisIdlerRoller(offset_x = 0, offset_y = 0) {
    // Dimensions
    roller_diameter = 9.1;     // Diameter of the roller
    roller_thickness = 5.5;    // Thickness of the roller


    // Create Z-axis Idler Roller
    translate([offset_x, offset_y, roller_thickness/2]) {
        visualize(idler_visualization)
        cylinder(d = roller_diameter, h = roller_thickness, center = true);
    }
}



if (show_mocks && ! orient_for_build) {
    RunoutDetector();
    Extruder();
    ExtruderSupportBracket();
    ZAxisIdlerRoller(9.1, 16.5);
}



if (build_guide) {
    translation = orient_for_build ? [0, 0, 0] : [0, 0, 0];  // This is the main part, so keep it at the origin.
    translate(translation) 
        guide(
            show_vitamins=show_vitamins, 
            orient_for_build=orient_for_build,
            ptfe_lining=ptfe_lining); 
}

if (build_outlet && ptfe_lining) {
    if (orient_for_build) {
        translate([0, 20, 0]) outlet(orient_for_build=true);
    } else {
        outlet(orient_for_build=false); 
    }
}

if (build_inlet) {
    if (orient_for_build) {    
        translate([-10, 0, 0]) inlet(orient_for_build=true);
    } else {
        guide_inlet(orient_for_build, ptfe_lining = ptfe_lining, as_cavity=as_cavity);
    }
}

if (build_mantis_support) {
    mantis_support();   
}

if (build_mantis_holder_lock) {
    mantis_holder(as_lock=true, test_print=test_print);
}


module outlet(orient_for_build=false, as_clearance=false, ptfe_lining=false, l_tube_holder=7) {
    d_body = ptfe_lining ? 8 : 4; 
    id = 4.0 + 2*ptfe_tube_tolerance;
    h_taper = 5;
    dx_ptfe = l_tube_holder - h_taper;
    module shape() {    
        render(convexity=10) difference() {
            can(d=d_body, h=l_tube_holder, center=ABOVE);
            if (ptfe_lining) {
                can(d=2.0, taper=3, h=h_taper, center=ABOVE);
                translate([0, 0, l_tube_holder]) can(d=id, taper=6, h=h_taper, center=BELOW);
                translate([0, 0, 2]) can(d=id, h=a_lot, center=ABOVE);
            } else {
                hull() {
                    can(d=2.0, h = a_lot);
                    block([0.1, 1.5, a_lot], center=RIGHT);
                }
            }
        }
    }
    if (as_clearance) {
        if (ptfe_lining == false) {
            translate(entrance_translation) 
            rotate([0, 90, 0])
            hull() {
                can(d=2.0, h = a_lot);
                block([0.1, 1.5, a_lot], center=RIGHT);
            }
        }
    } else {
        if (orient_for_build) {
            shape();
        } else {
            
            translate(entrance_translation) {
                if (show_vitamins  && ptfe_lining) {
                    color(PTFE_COLOR) {
                        rod(d = od_ptfe_tube, l=l_tube_holder + 1, center=RIGHT); 
                    }
                }
                visualize(guide_outlet_visualization) {
                    rotate([0, 90, 0])  shape();
                }
            }
        }
    }
    
}


module guide_inlet(
            orient_for_build=false, 
            as_clearance=false, 
            ptfe_lining = false, 
            as_cavity=false, 
            l_tube_holder=7) {
    echo("orient_for_build", orient_for_build); 
    enough = 20;
    d_body = 8;
    d_taper = ptfe_lining ? 5 : d_body;
    h_taper = ptfe_lining ? 5 : l_tube_holder - 2; 
    
    d_ptfe_clearance = ptfe_lining ? 4.0 + 2*ptfe_tube_tolerance : 0;
    
    module cavity(ptfe_lining) {
        if (ptfe_lining) {
            hull() {
                can(d=6, taper=d_ptfe_clearance, h=h_taper, center=ABOVE);
                block([0.1, 6, h_taper], center=ABOVE+RIGHT);
                can(d=6, h=enough, center=BELOW);
            }
            
            hull() {
                translate([0, 0, l_tube_holder-2]) {
                    can(d=d_ptfe_clearance, h=enough, center=BELOW);
                    block([0.1, 6, enough], center=BELOW+RIGHT);
                }
            }                
        }
        translate([0, 0, l_tube_holder]) {
            hull() {
                can(d=2, taper=d_taper, h=h_taper, center=BELOW);
                block([0.1, 1.5, h_taper], center=BELOW+RIGHT);
                can(d=5, h=1, center=ABOVE);
            }
        }
        
        
        hull() {
            can(d=2, h=enough);
            block([0.1, 1.5, enough], center=RIGHT);
        }
    }
    
    
    module shape() {
        render(convexity=10) difference() {
            can(d=d_body, h=l_tube_holder, center=ABOVE);
            cavity(ptfe_lining);
        }
    }
    if (as_clearance) {
        translate(entrance_translation) {
            hull() {
                rod(d=d_body-.01, l=a_lot);
                if (ptfe_lining) {
                    block([a_lot, d_body, 1], center=RIGHT);
                }
            }
        }
    } else if (as_cavity) {
        cavity(ptfe_lining);
    } else if (orient_for_build) {
        translate([0, 0, l_tube_holder]) rotate([180, 0, 0]) shape();
    } else {
        translate(entrance_translation + [runout_detector_translation.x, 0, 0]) {
            visualize(guide_inlet_visualization) {
                translate([-l_tube_holder, 0, 0]) rotate([0, 90, 0])  shape();
            }
            if (show_vitamins && ptfe_lining) {
                color(PTFE_COLOR) {
                    translate([-h_taper, 0, 0])  { 
                        rod(d = od_ptfe_tube, l=l_tube_holder + 1, center=BEHIND); 
                    }
                }
            }            
        }
    }   
}


module adjustment_screws(as_clearance = false) {
    module item() {
        if (as_clearance) {
            translate([0, 0, 25])  hole_through("M2", cld=0.4, $fn=12);
        } else {
            translate([0, 0, z_lifted_screw]) screw("M2.5x16"); 
        }
    } 
    translate([runout_detector_translation.x/2, entrance_translation.y, 0]) 
        color(STAINLESS_STEEL)
            center_reflect([1, 0, 0])  
                translate([-5, -8, 0 ])
                    item();
                            
}



module guide(orient_for_build = false, show_vitamins = true, ptfe_lining = false) {
    d_screw_pad = 8;
    x_inlet = ptfe_lining ? l_tube_holder :  runout_detector_translation.x/2;
    x_outlet = ptfe_lining ? l_tube_holder : runout_detector_translation.x - x_inlet;
    x_face = z_runout_screw_tab;
    face = [
        x_face, 
        entrance_translation.y + abs(dy_left_overhang), 
        runout_detector.z - entrance_translation.z + z_runout_screw_tab];
    bottom_plate = [runout_detector_translation.x, 5, 4];
    lip = [bottom_plate.x, y_lip, 2 + runout_detector.z];
    if (show_vitamins) {
        if (ptfe_lining) {
            //adjustment_screws();
        }
    }
    
   

    module runout_face() {
        
        color("pink") 
        difference() {
            translate([runout_detector_translation.x-x_runout_clearance,  0, 0]) 
                translate([0, -y_lip + dy_left_overhang, runout_detector.z + z_runout_screw_tab]) 
                        block(face, center=BELOW+BEHIND+RIGHT);           
            translate([runout_detector_translation.x - x_runout_clearance, entrance_translation.y, 0]) 
                rotate([0, 0, -pivot_clearance_angle]) 
                    plane_clearance(FRONT);
            guide_inlet(as_clearance=true, ptfe_lining=ptfe_lining);
        }
    }
    
    module front_base() {
        color("brown") 
        translate([0, 0, -x_face]) {
            hull() {
                translate([lip.x/2, 0, 0]) block([lip.x/2, lip.y, 4], center=ABOVE+FRONT+LEFT);
                translate([lip.x, 0, 0]) block([2, lip.y, lip.z], center=ABOVE+BEHIND+LEFT);
            }
            
        }
        
    }        
    
    module back_base() {
        color("blue") {
            difference() {
                union() {
                    translate([x_extruder_clearance, 0, 0]) {
                        hull() {
                            block(bottom_plate - [x_extruder_clearance, 0, 0],  center=ABOVE+FRONT+RIGHT);
                            translate([0, 2, 0]) can(d=10, h=4, center=FRONT+ABOVE+RIGHT);
                            
                        }
                        translate([8, 2, 0]) can(d=10, h=4, center=FRONT+ABOVE+RIGHT);  
                    }  
                    translate([x_extruder_clearance, 0, -z_lip]) 
                        block([bottom_plate.x + 4, y_lip, 6], center=ABOVE+FRONT+LEFT); 
                }
                adjustment_screws(as_clearance=true);
            } 
        }
    }
    


    module runout_screw_tab() {
        color("orange") {
            
            dx_screw = runout_detector_translation.x + runout_detector_screw_offsets[1].x;
            dy_screw  = runout_detector_translation.y + runout_detector_screw_offsets[1].y; 
            dz = runout_detector.z;
            dx_base = runout_detector_translation.x-x_runout_clearance;
            base = [2*x_face, y_lip + entrance_translation.y, z_runout_screw_tab];
            echo("base: ", base);
            difference() {
                hull() {
                    translate([dx_screw, dy_screw, dz]) 
                        can(d=d_screw_pad, h=z_runout_screw_tab, center=ABOVE);
                    translate([dx_base, -y_lip + dy_left_overhang, dz]) block(base, center=ABOVE+RIGHT);  
                }
                RunoutDetector(as_screw_clearance=true);
                translate(slot_translation) RunoutDetector(as_screw_clearance=true);
                translate(-slot_translation) RunoutDetector(as_screw_clearance=true);
            }
            // Add a lip at front of detector.  Can't be to big or it will interfere with the socket.
            if (y_lip > 0) {
                translate([runout_detector_translation.x, 0, 0]) 
                    block([2, y_lip, runout_detector.z], center=ABOVE+FRONT+LEFT);
            }
        }
    }
    module runout_pivot(sturdy = true) {
        color("tan") {
            difference() {
                hull() {
                    translate([runout_detector_translation.x, runout_detector_translation.y, 0] + runout_detector_screw_offsets[0]) 
                        can(d=d_screw_pad, h=h_runout_pivot, center=ABOVE);
                    translate([runout_detector_translation.x, 0, runout_detector.z] ) { 
                        block([d_screw_pad,d_screw_pad, h_runout_pivot], center=ABOVE+RIGHT+FRONT);
                        if (sturdy) {
                            // Include a large amount on  top of detector
                            translate([0, dy_left_overhang, 0]) 
                                block([runout_detector.x + 1, y_top_cap, h_runout_pivot], center=ABOVE+RIGHT+FRONT);
                        }
                    }
                }
                RunoutDetector(as_screw_clearance=true);
            }
        }
    }
    

    
    module inlet_attachment() {
        module collet_blank() {
            connector =  flute_clamp_connector();
            connector_extent = gtcc_extent(connector);      
            connector_neck = gtcc_neck(connector); 
             echo("connector_neck", connector_neck);
            translation = [
                2 * connector_extent.z, 
                entrance_translation.y, 
                entrance_translation.z
            ];
            translate(translation) {
                rotate([0, -90, 0]) {
                    flute_collet(is_filament_entrance=false);
                }
            }
            // Printing support around neck
            translate([0, entrance_translation.y, entrance_translation.z]) {
                difference() {
                    rod(d = 2*connector_extent.x, taper=connector_neck.x, l=connector_extent.z, center = FRONT);
                    rod(d = 4,  l=a_lot);
                }      
            }      
            // Breakaway  printing support for flute
            flute_support = [0.4, 0.2, connector_extent.x];
            flute_support_translation = [
                2*connector_extent.z, 
                entrance_translation.y- connector_extent.y/2, 
                entrance_translation.z
            ];
            base = [2*connector_extent.z, 0.4, flute_support.z/2];
            hull() {
                translate(flute_support_translation) block(flute_support, center =BEHIND+LEFT);
                translate([2*connector_extent.z, dy_left_overhang, entrance_translation.z]) 
                    rod(d=base.z, l=2, center = SIDEWISE+RIGHT);
            }
            translate([0, dy_left_overhang, entrance_translation.z]) block(base, center = FRONT+RIGHT);
            
        }
        inlet_face_translation = [runout_detector_translation.x + runout_detector.x, 0, 0];
        face = [x_inlet_attachment, y_top_cap, z_attachment_inlet_face];
        bracket = [x_inlet_attachment, y_top_cap, z_atttachment_bracket];
        
        module bracket_screws(as_clearance) {
            translate(entrance_translation + inlet_face_translation + [0, 0, dz_bracket_screws]) {
                rotate([0, 90, 0]) {
                    if (as_clearance) {
                        translate([0, 0, 25]) hole_through("M3", cld=0.6, $fn=12);
                        center_reflect([0, 1, 0]) translate([0, 8, 25]) hole_through("M3", cld=0.6, $fn=12);
                    }
                }
            }
        }
        
        
        module blank() {
            translate(inlet_face_translation) {
                translate([0, dy_left_overhang, runout_detector.z+h_runout_pivot]) {
                    block(face, center=BELOW+RIGHT+FRONT);
                    block(bracket, center=ABOVE+RIGHT+FRONT);
                }
                collet_blank( );
            }
        }
            difference() {
                blank();
                translate(entrance_translation) rod(d = 2, l=a_lot);
                bracket_screws(as_clearance = true);
                translate([0, y_top_cap + dy_left_overhang, 0]) plane_clearance(RIGHT);
                translate([0, 0, 5]) plane_clearance(BELOW);
                
            }   
    }
    module outlet_printing_support(){
        color("yellow") 
        //render(convexity=10) 
        difference() {
            translate([0.5, 0, entrance_translation.z]) 
                block([x_outlet, entrance_translation.y-0.5, 2], center=RIGHT+FRONT);
            translate([x_extruder_clearance-2, entrance_translation.y, 0]) 
                rotate([0, 0, 45]) 
                    plane_clearance(BEHIND);            
        }
                
    }

    module inlet_printing_support() {
        color("limegreen") 
        difference() {
            translate([runout_detector_translation.x, dy_left_overhang, entrance_translation.z]) 
                block([x_inlet, entrance_translation.y-3.9 + abs(dy_left_overhang), 2], center=RIGHT+BEHIND);
            translate([0, entrance_translation.y, 0]) plane_clearance(RIGHT);

            translate([runout_detector_translation.x - x_runout_clearance, entrance_translation.y, 0]) 
                rotate([0, 0, -pivot_clearance_angle]) 
                    plane_clearance(FRONT);
        
            translate([12, 0, 0]) rotate([0, 0, 30]) plane_clearance(BEHIND);
        }
    }
    
    module printer_adhesion() {
        h_printer_adhesion_pad = 0.2;
        module pad(dx, dz, d) {
            translate([dx, dy_left_overhang, dz]) rod(d=d, l=h_printer_adhesion_pad, center = SIDEWISE+RIGHT);
        }
        pairwise_hull() {
            pad(dx=17, dz=15, d=16);
            pad(dx=70, dz=11, d=15);
            pad(dx=60, dz=25, d=15);
            pad(dx=17, dz=15, d=16);
        }
    }
    
    module parts() {

        if (ptfe_lining) {
            front_base();
            back_base();
        }
        runout_face();
        runout_screw_tab();
        runout_pivot();
        inlet_attachment();
        translate([-x_runout_clearance, -0, 0]) 
            guide_inlet(orient_for_build=false, ptfe_lining=ptfe_lining, l_tube_holder=x_inlet);
        if (!ptfe_lining) {
            translate([x_extruder_clearance, 0, 0]) 
                outlet(orient_for_build=false, ptfe_lining=false, l_tube_holder=x_outlet);
        }
        inlet_printing_support();
        if (!ptfe_lining) {
            outlet_printing_support();
        }
        printer_adhesion();
    }
    
    module shape() {
        difference() {
            parts();
            if (!ptfe_lining) {
                translate(entrance_translation) rod(d = 2, l=a_lot);
            }  
        }
    }
    
    visualize(guide_visualization, guide_show_parts) {
        if (orient_for_build) {
            rotate([90, 0, 0]) translate([0, y_lip, 0]) shape();
        } else {
            shape();
        }
    }
}

module footprint(h_layer = 0.2) {
    // Creates a foot print for the model
    // Assume that the model is oriented on the  build plate above
    difference() {
        children();
        translate([0, 0, h_layer]) plane_clearance(ABOVE); 
    }
}

module x_segmented_hull(x_range) {
    for (x = x_range) {
            hull() difference() {
                children(); 
                //echo("x", x);
                translate([x, 0, 0]) plane_clearance(BEHIND);
                xf = x + x_range[1];
                //echo("xf", xf);
                translate([xf, 0, 0]) plane_clearance(FRONT);
        }
    }
    
}

module chamfered_can(x, y, h=6, d=6, chamfer = 2) { 
    translate([x, y, 0]) {
        hull() {
            can(d = d-chamfer, h = h, center = ABOVE);
            translate([0, 0, chamfer]) can(d = d, h = h-chamfer, center = ABOVE);
        }
    }
}

module mantis_holder_blank(as_lock = false, mounting_target=false) {
    h = as_lock ? 5 : 8;
    difference() {
        hull() {
            chamfered_can(10, 10, h=h); 
            chamfered_can(10, -10, h=h);  
            chamfered_can(-10, 10, h=h); 
            chamfered_can(-10, -10, h=h);             
        }
        if (mounting_target) {
            translate([-9.8, 0, 0]) plane_clearance(FRONT);
        }
    }
}

module mantis_support() {

    module fillet(x, y, fd=6, h=4, az=0) {
        translate([x, y, 0]) {
            rotate([0, 0, az]) {
                render(convexity=10) 
                difference() {
                    hull() {
                        block([0.1, 0.1, h], center=ABOVE+FRONT);
                        translate([fd/2, 0, 0]) can(d=fd, h=h, center=FRONT + ABOVE, $fn=12);
                    }
                    translate([fd/2, 0, 0]) can(d=fd, h=3*h, center=FRONT, $fn=40);
                }
            }
        }
    }
    module hole(x, y, z) {
        translate([x, y, z]) 
            rotate([0, ay_mantis_holder, 0]) 
                translate([0, 0, 25]) 
                    hole_through("M3", cld=0.6, $fn=12);
    }

    module blank() {
        pairwise_hull() {
            translate([0, 0, 5]) rotate([0, ay_mantis_holder, 0]) can(d=10, h = 7, center=ABOVE);
            translate([0, 0, 5]) rotate([0, ay_mantis_holder, 0]) can(d=10, h = 2, center=BELOW);
            chamfered_can(5, 0, d=10);
            chamfered_can(x_mantis_support+dx_mantis_support_base, 0, d=10);
            translate([x_mantis_support, 0, dz_mantis_holder]) 
                rotate([0, -ay_mantis_holder, 0]) 
                    mantis_holder_blank(as_lock = false, mounting_target=true);
            translate([x_mantis_support, 0, dz_mantis_holder]) 
                rotate([0, -ay_mantis_holder, 0]) 
                    mantis_holder_blank(as_lock = false);
        }    
    }
    
    module cavity() {
        translate([x_mantis_support, 0, dz_mantis_holder]) {
            rotate([0, -ay_mantis_holder, 0]) {
                can(d=17, h=a_lot);
                translate([0, 0, 6]) can(d=19.2, h=a_lot, center=BELOW);
            }
        }
    } 
    module holder_screws(as_clearance = true) {
        translate([x_mantis_support, 0, dz_mantis_holder]) {
            rotate([0, -ay_mantis_holder, 0]) {
                center_reflect([1, 0, 0]) center_reflect([0, 1, 0]) 
                    translate([delta_mantis_screw, delta_mantis_screw, 25]) 
                        hole_through("M3", cld=0.6, $fn=12);   
            }
        }
    }

    module shape() {
        render(convexity=10) {
            difference() {
                blank();
                cavity();
                holder_screws(as_clearance=true) ;
                hole(0, 0, 5);
            }
        }
    }

    rotation = orient_for_build ? [0, 0, 0] :  [270, 270, 270];
    inner_rotation = orient_for_build ? [0, 0, 0] : [0, -45, 0];
    translation = orient_for_build ? [x_mantis_support_bp, y_mantis_support_bp, 0] : 
        [runout_detector_translation.x + runout_detector.x + x_inlet_attachment, 
        entrance_translation.y, 
        runout_detector.z + z_atttachment_bracket/2 + 3];
    translate(translation) rotate(rotation) {
        rotate(inner_rotation)  shape();
    }
}



module mantis_holder(as_lock = false, test_print = false) {
        
    module screws(as_clearance) {
        // Screws attaching holder to support
        if (!as_lock) {
            center_reflect([1, 0, 0]) center_reflect([0, 1, 0]) {
                translate([0, delta_mantis_screw, 4]) rotate([0, -90, 0]) {
                    if (as_clearance) {
                         translate([0, 0, 25]) hole_through("M3", cld=0.6, $fn=12);
                         translate([0, 0, 10]) nutcatch_sidecut(
                                name   = "M3",  // name of screw family (i.e. M3, M4, ...) 
                                l      = 50.0,  // length of slot
                                clk    =  0.0,  // key width clearance
                                clh    =  0.0,  // height clearance
                                clsl   =  0.1);  // slot width clearance
                    }
                }
            }
        }
        // Screws for attaching Mantis to holder base
        center_reflect([1, 0, 0]) center_reflect([0, 1, 0]) 
            translate([delta_mantis_screw, delta_mantis_screw, 25]) 
                hole_through("M3", cld=0.6, $fn=12);
    }
    
    module cavity() {
        can(d=17, h=a_lot);
        translate([0, 0, 2]) can(d=19.2, h=a_lot, center=ABOVE);
    }
    
    module clip_opening() {
        block([a_lot, 10, a_lot], center=FRONT);
    }
    
    module shape() {
        render(convexity=10) difference() {
            mantis_holder_blank(as_lock = true);
            screws(as_clearance=true);
            cavity();
            if (as_lock) {
                clip_opening();
            }
            if (test_print) {
                translate([0, 0, 1]) plane_clearance(ABOVE);
            }
        }
    }
    translation = orient_for_build ? [x_mantis_holder_bp, y_mantis_holder_bp, 0] :  [0, 0, 0];
    translate(translation) shape();
    
}




