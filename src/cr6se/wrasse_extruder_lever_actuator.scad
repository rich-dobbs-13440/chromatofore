/* Orientation:  

    Origin is placed at a corner of the extruder closest to both engagement lever and filament entrance, 
    at the top away from support place.
    
    Filament entrance is positive y.  
    
    Lever is negative x.  

*/


include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
include <MCAD/servos.scad>
use <MCAD/boxes.scad>

a_lot = 100 + 0;

/* [Extruder Characteristics] */
extruder = [42.8, 43.3, 24.7];
entrance_translation = [0, 15, 11];
translation_attachment_screw = [-5, extruder.y-5, 0];
translation_pivot_screw = [-23, 5, 0];
lever = [extruder.x/2 -2, 5, 6];
lever_handle = [15.2, 3.9, 13.1];
dz_lever = -4.7 - lever_handle.z/2;
lever_slot = [extruder.x/2+10, 8, lever.z + 2];

/* [Output Control] */
show_mocks = true;
show_vitamins = true;

/* [Design] */


dx_servo = -10.4; // [-12:0.1:-10]

attachment = [10, 18, 4]; 


pedistal = [8, 18, 4];
dx_back_pedistal = -30;
dx_front_pedistal = 10;   

dx_servo_screw_offset = 4.5;
dy_screw_offset = 4.6;
dz_servo_mount = 19;

module Extruder(as_clearance = false, lever_angle = 0) {
    module blank() {
        translate([-extruder.x/2, extruder.y/2, -extruder.z/2]) 
        render() intersection() {
            block(extruder);
            // Cut off corners:
            rotate([0, 0, 45]) block([54.5, 54.5, extruder.z + 1]);
        }
    }
    
    module shape() {
        translate([0, 0, 0]) {
            color(BLACK_PLASTIC_1) { 
                difference() {
                    blank() ;
                    translate(entrance_translation + [0, 0, 0]) rod(d=5, l=a_lot);
                    translate(translation_attachment_screw + [0, 0, 10]) hole_through("M3", $fn=12);
                    translate(translation_pivot_screw + [0, 0, 10]) hole_through("M3", $fn=12);
                    translate([0, -1, dz_lever]) block(lever_slot, center = BEHIND+RIGHT);
                }
            }
            translate(translation_pivot_screw + [0, 0, dz_lever]) rotate ([0, 0, lever_angle]) {
                color(BLACK_PLASTIC_2) {
                    block(lever, center = FRONT);
                    translate([extruder.x/2-2, 0, 0]) rotate([0, 0, -45]) block(lever_handle, center=FRONT);
                }
            }
            
        }
    }
    
    if (as_clearance) {
        blank();
    } else {
        shape();
    }
}

module servo() {
    color(MIUZEIU_SERVO_BLUE) {
        //futabas3003(position=[-38,0,46],  rotation=[180, 0, 90]);
        futabas3003(position=[10,20,46],  rotation=[0, 180, 90]);
    }    
}

module servo_mounting_screws(as_clearance = false) {
    dx = (dx_front_pedistal - dx_back_pedistal + 2 * dx_servo_screw_offset) / 2;
    
    registration = [55, 1.6, 3];
    
    if (as_clearance) {
        translate([-10, 9.5, dz_servo_mount]) {
            center_reflect([0, 1, 0]) center_reflect([1, 0, 0]) 
                translate([dx, dy_screw_offset, 40]) hole_through("M3", $fn=12);
            // Divot for servo registration, at least on RadioShack servos. 
            hull() {
                translate([0, 0, -1.6])  block(registration, center=ABOVE);
                scale([1, 3, 0.01]) block(registration, center=ABOVE);
            }
        }
    }
}

module rounded_block(extent, radius = 2, sidesonly = false, center = CENTER) {
    extent_for_rounding =  sidesonly == "XZ" ? [extent.x, extent.z, extent.y] : extent;
    translation = 
        center == BEHIND + RIGHT + BELOW ? [-extent.x/2, extent.y/2, -extent.z/2] :
        center == BEHIND + RIGHT + ABOVE ? [-extent.x/2, extent.y/2, extent.z/2] :
        center == FRONT + RIGHT+ BELOW ? [extent.x/2, extent.y/2, -extent.z/2] :
        center == FRONT +RIGHT ?  [extent.x/2, extent.y/2, 0] :
        center == FRONT +RIGHT + ABOVE ? [extent.x/2, extent.y/2, extent.z/2] :
        center == FRONT + RIGHT + BELOW ? [extent.x/2, extent.y/2, -extent.z/2] :
                assert(false);
    rotation = sidesonly == "XZ" ? [90, 0, 0] : [0, 0, 0];
    translate(translation) rotate(rotation) {
        roundedBox(extent_for_rounding,  radius=radius, sidesonly=sidesonly != false, $fn=12);
    }
    
}

module Cap() {
    
    module front_pedistal() {
        translate([dx_front_pedistal, 0, dz_servo_mount]) 
            rounded_block(pedistal + [4, 0, 0], sidesonly = "XZ", center=FRONT+RIGHT+BELOW);
        rounded_block([dx_front_pedistal + pedistal.x + 4, pedistal.y, 4], sidesonly = "XZ", center=RIGHT+FRONT);     
        translate([dx_front_pedistal + pedistal.x, 0, -2])  
            rounded_block([4, pedistal.y, dz_servo_mount + 2], sidesonly = "XZ", center = FRONT+RIGHT+ABOVE);
    }
    
    
    module back_pedistal() {
        translate([dx_back_pedistal, 0, dz_servo_mount]) 
            rounded_block(pedistal + [8, 0, 0], sidesonly = "XZ", center = BEHIND + RIGHT + BELOW);
        translate([dx_back_pedistal - 12, 0, -2])  
            rounded_block([4, pedistal.y, dz_servo_mount + 2], sidesonly = "XZ", center = BEHIND + RIGHT + ABOVE);        
        block([dx_back_pedistal, pedistal.y, 4], center = RIGHT + BEHIND);   

    }   
    
    module cap_base() {
        translate([4, 0, 2]) 
            rounded_block([extruder.x + 7.3, extruder.y + 2, 5], sidesonly = "XZ", center = BEHIND + BELOW + RIGHT);
    }
    
    module cap_clip() {
        translate([2, 0, 0]) 
            rounded_block([extruder.x + 4, 4, extruder.z], sidesonly = "XZ", center = BEHIND + BELOW + RIGHT);
        
        translate([0, 0, -extruder.z - 3]) {
            translate([0, 0, -4]) rounded_block([4, 11, 12], sidesonly = "XZ", center = FRONT + RIGHT  + ABOVE);
            rounded_block([4, 28, 8], sidesonly = "XZ", center = FRONT + RIGHT + BELOW);
        }
    }
   
   module horn_clearance() {
       translate([-20, 6, 2]) can(d = 40, h=8, center=ABOVE);
   } 
    
    module blank() {
        cap_base();
        cap_clip();          
        back_pedistal();
        front_pedistal();
    }
    
    module shape() {
        render(convexity=10) difference() {
            blank();
            translate([0.7, -0.1, 0]) scale([1.03, 1, 1.01]) 
                Extruder(as_clearance = true);
            horn_clearance();
            servo_mounting_screws(as_clearance=true);
        }
    }
    if (show_mocks) {
        Extruder();
        servo();
    }
    
    shape();
    
}

Cap();

