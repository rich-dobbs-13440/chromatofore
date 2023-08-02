include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>

use <ScadApotheka/ptfe_filament_tubing_connector.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>

//     flute_collet(is_filament_entrance = true, as_clearance = false);
//     
ASSEMBLE_SUBCOMPONENTS = 3 + 0;
PRINTING = 4 + 0;

a_lot = 30 + 0;
 /* [Output Control] */
 
 mode = 3; // [3: "Assembly", 4: "Printing"]
show_vitamins = true;
show_filament = true;
show_parts = true; // But nothing here has parts yet.
show_legend = false;

roller_switch_depressed = false;

/* [Filament Barrel] */
core_length = 1;
// Adjust to go beyond barrel, so that the detector is independ of the path to the junction
z_barrel = 24;
d_barrel = 4;






/* [Limit Switch Holder Design] */
// Adjust the angle, so that the limit switch is triggered when the filament is loaded.
ay_barrel = -6;
// Should not have to move from center line. 
dy_limit_switch_holder = 0;  // [0:20]
// Set to clear nut 
dz_limit_switch_holder = 17;  // [0:20]

// Displacement of cl of switch body to cl of servo
dy_switch_body = 0; // [-20:15]
// Displayment relative to bottom of nut block
dz_switch_body = 0; // [-20:0]
right_handed_limit_switch_holder = false;
limit_switch_holder_base_thickness = 4;
roller_arm_length = 20; // [18:Short, 20:Long]

module end_of_customization() {}
 
    
connector = flute_connector_dimensions();         
clamp = flute_clamp_dimensions();    
clamp_extent = gtcc_extent(clamp);

      
module filament_detector_barrel() {     
    module blank() {
        quarter_turn_clamping_connector_key(core_length = core_length,  dimensions_1=clamp);
       
        translate([0, 0, clamp_extent.z]) rotate([0, ay_barrel, 0]) can(d = d_barrel, h = z_barrel, center=ABOVE);
        
    } 
    module shape() {
        render(convexity=10) difference() {
           blank(); 
           flute_barbed_tubing_clearance();
           translate([0, 0, clamp_extent.z]) rotate([0, ay_barrel, 0]) flute_filament_path(is_entrance=false, multiplier = 5, include_below=false);
           translate([0, 0, clamp_extent.z]) sphere(d = 2.5, $fn=30);
            
        }   
    }
    color(PART_15) {
        shape();
    }
}  

module limit_switch_holder() {
    
    // The switch can't contact the barrel, and has to clear the tube clamp. 
    // It also must be place so that removing the unprintable overhang doesn't interfer 
    // with mounting.
    dx_limit_switch_holder = 10;  
    dx_nut_clearance =  12.5;
    x_sw = 8;
    y_sw = 8;
    z_sw = dz_limit_switch_holder - 10;    
    switch_support = [x_sw, y_sw, z_sw];
    x_t = 10;
    y_t = 12;
    z_t = dz_limit_switch_holder - 11;
    dx_t = dx_limit_switch_holder + 10;    
    
    module top_clamp() {
        translation = [dx_limit_switch_holder, dy_limit_switch_holder, dz_limit_switch_holder];
        rotation = [0, 90, 0];
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
    module printing_support() {
        terminal_support = [x_t, y_t, z_t];
        translate([dx_nut_clearance, -8, 0])  block(switch_support, center = ABOVE +FRONT+RIGHT);
        translate([dx_t, -8, 0])  block(terminal_support, center = ABOVE +FRONT+RIGHT);
        
    }
    module unprintable_overhang() {
        // Need to cut off a corner of the base,
        s_upo  = 17;
        dy_upo = -3.25; // TODO: Get from limit switch dimensions! 
        dx_upo = dx_nut_clearance - s_upo*sqrt(2)/2;
        translate([dx_upo, dy_upo, switch_support.z]) rotate([0, 45, 0]) block([s_upo, a_lot, s_upo], center=LEFT);
    }
    module blank() {
        top_clamp();
        printing_support();        
    }
    difference() {
        blank(); 
        unprintable_overhang();
    }
} 

    

filament_detector_barrel();

limit_switch_holder();
            
if (show_vitamins) {
    rotate([0, 0, 45]) flute_collet_nut(); 
}             
