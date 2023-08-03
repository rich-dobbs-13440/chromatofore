include <ScadStoicheia/centerable.scad>
include <ScadApotheka/material_colors.scad>

use <ScadApotheka/ptfe_filament_tubing_connector.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>

//     flute_collet(is_filament_entrance = true, as_clearance = false);
//     
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

/* [Animation] */    

roller_switch_depressed = false;

/* [Printing] */
print_one_part = false;
part_to_print = "barrel"; // [barrel]

/* [Multiplexer Design] */
r_barrel = 25;
barrel_count = 6;
use_center_barrel = true;
dz_cone = 80;

/* [Filament Barrel Design] */
core_length = 1;
// Adjust to go beyond barrel, so that the detector is independ of the path to the junction
z_barrel = 26;
d_barrel = 4;


/* [Limit Switch Holder Design] */
// Adjust the angle, so that the limit switch is triggered when the filament is loaded.
ay_barrel = -45;
dx_limit_switch_holder = 5.1;  
// Should not have to move from center line. 
dy_limit_switch_holder = 0;  // [0:20]
// Set to clear nut 
dz_limit_switch_holder = 10;  // [0:20]

// Displacement of cl of switch body to cl of servo
dy_switch_body = 0; // [-20:15]
// Displayment relative to bottom of nut block

dz_switch_body = 0; // [-20:0]
right_handed_limit_switch_holder = false;
limit_switch_holder_base_thickness = 4;
roller_arm_length = 20; // [18:Short, 20:Long]

module end_of_customization() {}

 

function layout_from_mode(mode) = 
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";

layout = layout_from_mode(mode);

function show(variable, name) = 
    (print_one_part && (mode == PRINTING)) ? name == part_to_print :
    variable;
    
 
visualization_barrel  =        
    visualize_info(
        "Barrel", PART_2, show(barrel, "barrel") , layout, show_parts);  

visualization_limit_switch_support =        
    visualize_info(
        "Limit Switch Support ", PART_3, show(limit_switch_support, "limit_switch_support") , layout, show_parts);  
        
connector = flute_connector_dimensions();    
connector_extent = gtcc_extent(connector);
clamp = flute_clamp_dimensions();    
clamp_extent = gtcc_extent(clamp);

 daz = 360/barrel_count; 
      
module filament_detector_barrel(ay_barrel, rib = false) {     
    module blank() {
        visualize(visualization_barrel) {
            //quarter_turn_clamping_connector_key(core_length = core_length,  dimensions_1=clamp);
            translate([0, 0, -2]) { //connector_extent.z+3]) {
                //hull() {
                    rotate([0, ay_barrel, 0]) can(d = d_barrel, h = z_barrel, center=ABOVE);
//                    if (is_num(rib)) {
//                        z_contact = 5;
//                        translate([-rib, 0, 0]) can(d = d_barrel, h = z_barrel, center=ABOVE);
//                        translate([-4, -6, z_barrel- z_contact]) rotate([0, ay_barrel, 0]) can(d = d_barrel, h = z_contact, center=ABOVE);
//                    }
                //}
            }
        }
        
    } 
    module shape() {
        difference() {
           blank(); 
           flute_barbed_tubing_clearance();
           #translate([0, 0, -2]) rotate([0, ay_barrel, 0]) flute_filament_path(is_entrance=false, multiplier = 5, include_below=false);
           translate([0, 0, clamp_extent.z]) sphere(d = 2.5, $fn=30);
            
        }   
    }
    shape();
}  

module limit_switch_holder() {
    
    // The switch can't contact the barrel, and has to clear the tube clamp. 
    // It also must be place so that removing the unprintable overhang doesn't interfer 
    // with mounting.
    
    dx_nut_clearance =  12.5;
    x_sw = 8;
    y_sw = 8;
    z_sw = dz_limit_switch_holder - 10;    
    switch_support = [x_sw, y_sw, z_sw];
    x_t = 10;
    y_t = 12;
    z_t = dz_limit_switch_holder - 11;
    terminal_support = [x_t, y_t, z_t];
    dx_t = dx_limit_switch_holder + 10;  
    dy_upo = -3.25; // TODO: Get from limit switch dimensions!   
    
    module top_clamp() {
        translation = [dx_limit_switch_holder, dy_limit_switch_holder, dz_limit_switch_holder];
        rotation = [0, 90 + ay_barrel, 0];
        translate(translation) rotate(rotation) 
            nsrsh_top_clamp(
                show_vitamins=show_vitamins && mode != PRINTING , 
                right_handed = right_handed_limit_switch_holder,
                alpha=1, 
                thickness=limit_switch_holder_base_thickness, 
                recess_mounting_screws = true,
                use_dupont_connectors = true,
                roller_arm_length = roller_arm_length,
                switch_depressed = roller_switch_depressed); 
    }
    module joiner() {
        // join the limit switch holder to the ribs
        joiner = [24, 3, z_barrel + 4];
        visualize(visualization_limit_switch_support) {
            hull() {
                translate([dx_nut_clearance -2, dy_upo-0.5, 0])  block(joiner, center = ABOVE+BEHIND+LEFT);
            }
        }
        
    }
    module printing_support() {
        visualize(visualization_limit_switch_support) {
        
            translate([dx_nut_clearance, -8, 0])  block(switch_support, center = ABOVE+FRONT+RIGHT);
            translate([dx_t, -8, 0])  block(terminal_support, center = ABOVE+FRONT+RIGHT);
        }
    }
    module unprintable_overhang() {
//        // Need to cut off a corner of the base,
//        s_upo  = 50;
//        
//        dx_upo = dx_nut_clearance - s_upo*sqrt(2)/2;
//        translate([dx_upo, dy_upo, switch_support.z])  {
//            hull() {
//                rotate([0, 45, 0]) block([s_upo, a_lot, s_upo], center=LEFT);
//                translate([0, 0, -20]) rotate([0, 45, 0]) block([s_upo, a_lot, s_upo], center=LEFT);
//            }
//        }
    }
    module blank() {
        top_clamp();
        // joiner();
        printing_support();        
    }
    difference() {
        blank(); 
        unprintable_overhang();
    }
} 

module barrel_assembly(daz_offset = 0) {
   
    for (idx = [0: barrel_count - 1]) {
        az = idx * daz + daz_offset;
        rotate([0, 0, az]) {
            translate([r_barrel, 0, 10]) {
                filament_detector_barrel(ay_barrel = ay_barrel, rib = r_barrel - 3.2);
                limit_switch_holder();
//                if (show_vitamins) {
//                    rotate([0, 0, 45]) flute_collet_nut(); 
//                }             
            } 
        }
    }
    module cone_shape(d = 5) {
        hull() {
            translate([0, 0, dz_cone]) sphere(d=d, $fn=15);
            for (idx = [0: barrel_count - 1]) {
                az = idx * daz + daz_offset;
                rotate([0, 0, az]) {
                    translate([r_barrel-3, 0, z_barrel + clamp_extent.z ]) {
                        sphere(d=d , $fn=15);
                    }
                }
            }
        }
    }
    module cone() {
        render() difference() {
            cone_shape(d = 5);
            hull() {
                cone_shape(d=3);
                translate([0, 0, -5]) cone_shape(d=3);
            }
            can(d=2, h=200, center=ABOVE);
            
        }
        
    }
    if (use_center_barrel) {
        filament_detector_barrel(ay_barrel = 0);
        ///limit_switch_holder();
//        if (show_vitamins) {
//            rotate([0, 0, 45]) flute_collet_nut(); 
//        } 
        cone();
        dz_outlet = z_barrel + clamp_extent.z + 58;
        translate([0, 0, dz_outlet]) rotate([180, 0, 0]) flute_collet();
    }
}

barrel_assembly();

module base(daz_offset=0) {
    cam_wall = 2;
    cam = gtcc_cam(connector);
    d = 2 * (r_barrel + cam.y + cam_wall);
    module blank() {
        can(d = d, h = connector_extent.z + 2, center=ABOVE);
    }
    
    module cavity() {
        for (idx = [0: barrel_count - 1]) {
            az = idx * daz + daz_offset;
            rotate([0, 0, az]) {
                translate([r_barrel, 0, 0])
                    flute_keyhole(is_filament_entrance=false, print_from_key_opening=true);
            }
        }        
    }
    
    difference() {
        blank();
        cavity();
    }

}

base(daz_offset = 0);

            
