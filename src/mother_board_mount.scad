/* 

Mother board mounting for the Chromatofore system. 

The mother board mounts:
    * an Arduino Uno R4, 
    * the first PCA9685 servo control board,
    * one or two PCF8574 GPIO multiplexer board
    * a medium size bread board cut in half
    
One half of the bread board serves as a I2C bus for the boards. 
The other half is used for connecting to switches and sensors,
as well as installing pull down resistors for switches.

*/
include <ScadStoicheia/centerable.scad>
include <ScadApotheka/material_colors.scad>

use <ScadApotheka/pca9685_slide_rail_mount.scad>
use <ScadApotheka/pcf8574_slide_rail_mount.scad>

a_lot = 100.0  + 0.0;

/* [Output Control] */

fit_test = false;
show_vitamins = true;

/* [Design] */
dy_zero = 6.1; // [0: 0.1 : 10]
pcf8574_first_pin = 12;
pca9685_first_pin = 1;
x_i2c_breadboard = 72.8;

z_breadboard = 11;
x_breadboard = 83.7;
y_half_breadboard = 29;
z_base_connector = 2;
// Set to make the holes on the breadboard to match up with the pins on the GPIO board!
dz_extra_under_board = 1.5; // [0:0.1:2]

dx_underwriters_knot = 25;
dx_strain_relief_2 = 90;
dx_strain_relief_1 = dx_strain_relief_2 - dx_underwriters_knot;
dx_strain_relief_base = 61;
z_strain_relief = 16;
z_strain_relief_base = 3;
d_power_cord = 2.9;


dy_bread_board_support = 28;
dy_arduino_connection = 15;
module end_of_customization() {}


dy_pcf8574 = (pcf8574_first_pin + 1.5) * 0.1 * 25.4 + dy_zero;
dy_pca9685 = (pca9685_first_pin + 2.5) * 0.1 * 25.4 + dy_zero;


module base() {
    module under_i2c_bus() {
        extent = [z_breadboard, x_i2c_breadboard, z_base_connector];
        color(PART_17) block(extent, center=ABOVE+RIGHT+BEHIND);
    }
    module between_slides() {
        translate([0, 2*dy_pca9685, 0]) block([62, 2, 8 + dz_extra_under_board], center=ABOVE+FRONT);
    }
    module behind_gpio_breadboard() {
        dx = x_breadboard + 5;
        dy = dy_pcf8574 + 9;
        extent = [4, y_half_breadboard, z_breadboard];
        color(PART_23) {
            translate([dx, dy, 0]) {
                block(extent, center=ABOVE+RIGHT+BEHIND);
            }
        }
    }
    module power_strain_relief() {
        color(PART_21) {
            x_sr = dx_strain_relief_2 - dx_strain_relief_base;
            strain_relief_block = [4, 2*dy_pca9685 + 2, z_strain_relief];
            dz_holes = (strain_relief_block.z - z_strain_relief_base)/2 + z_strain_relief_base;
            render(convexity=10) difference() {
                union() {
                    translate([dx_strain_relief_base, 0, 0]) block([x_sr, 2*dy_pca9685 +2, z_strain_relief_base], center=ABOVE+RIGHT+FRONT);
                    translate([dx_strain_relief_1, 0, 0]) block(strain_relief_block, center=ABOVE+RIGHT+FRONT);
                    translate([dx_strain_relief_2, 0, 0]) block(strain_relief_block, center=ABOVE+RIGHT+FRONT);
                }
                // Vertical slits for each strand internally
                translate([dx_strain_relief_1, strain_relief_block.y/2 + 3, dz_holes]) {
                    center_reflect([0, 1, 0]) translate([0, 5]) {
                        hull() {
                            rod(d = d_power_cord, l=4*strain_relief_block.x);
                            translate([0, 0, strain_relief_block.z]) rod(d = d_power_cord, l=4*strain_relief_block.x);
                        }
                    }
                } 
                // Horizontal pill shaped hole for the two parallel strands, for the external connection
                translate([dx_strain_relief_2, strain_relief_block.y/2, dz_holes]) {
                    hull() center_reflect([0, 1, 0]) translate([0, d_power_cord/2]) rod(d = d_power_cord, l=4*strain_relief_block.x);
                }
                // Holes for mounting
                dx_mounting = (dx_strain_relief_1 + dx_strain_relief_2)/2 + strain_relief_block.x/2;
                translate([dx_mounting, strain_relief_block.y/2, 0]) {
                    center_reflect([0, 1, 0]) translate([0, 10, 25]) hole_through("M2", cld=0.4, $fn=12);
                }
            }
        }
    }
    module connector() {
        // The connector allows installing support and securing of I2C bus breadboard,
        // and allows connecting the Arduino support. 
        // For development, initially these parts might be printed separately, although
        // later they might also be printed as one object. 
        extent = [6, x_i2c_breadboard, 6];
        dx = -z_breadboard - extent.x/2;
        dy = extent.y/2;
        translate([ dx, dy, 0]) {
            color(PART_16) {
                render(convexity=10) difference() {
                    block(extent, center=ABOVE);
                    center_reflect([0, 1, 0]) {
                        rotate([180, 0, 0]) translate([0, dy_bread_board_support, 2]) {
                            hole_through("M2", h=4, cld=0.4, $fn=12);
                        }
                    }
                    center_reflect([0, 1, 0]) {
                        translate([0, dy_arduino_connection, 25]) {
                            hole_through("M2", cld=0.4, $fn=12);
                        }
                    }                    
                }
            }
        }
    }
    translate([0, dy_pcf8574, 0]) 
        pcf8574_slide_rail_mount(
            board_count=2, 
            dz_extra_under_board = dz_extra_under_board,
            center=FRONT, 
            show_vitamins=show_vitamins);
    translate([0, dy_pca9685, 0]) 
        pca9685_slide_rail_mount(
            center=FRONT, 
            slide_from_left = true,
            dz_extra_under_board = dz_extra_under_board,
            show_vitamins=show_vitamins);
    between_slides();
    under_i2c_bus();
    connector();
    behind_gpio_breadboard();
    power_strain_relief();
    
}




if (fit_test) {
    difference() {
        base();
        translate([10, 0, 0]) plane_clearance(FRONT);
    }
} else {
    base();
}