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
s_breadboard_perimeter = 6;

module end_of_customization() {}


dy_pcf8574 = (pcf8574_first_pin + 1.5) * 0.1 * 25.4 + dy_zero;
dy_pca9685 = (pca9685_first_pin + 2.5) * 0.1 * 25.4 + dy_zero;

//half_medium_breadboard_profile = [85, 29, z_base_connector];
//breadboard_perimeters = 2*[s_breadboard_perimeter, s_breadboard_perimeter, 0];
//bread_board_clearances = [4, 2, 0];
//vertical_clearances = [0, 0, a_lot];

module base() {
    module under_i2c_bus() {
        extent = [z_breadboard, x_i2c_breadboard, z_base_connector];
        block(extent, center=ABOVE+RIGHT+BEHIND);
    }
    module between_slides() {
        translate([0, 2*dy_pca9685, 0]) block([62, 2, 8], center=ABOVE+FRONT);
    }
    module behind_gpio_breadboard() {
        dx = x_breadboard + 5;
        dy = dy_pcf8574 + 9;
        extent = [4, y_half_breadboard, z_breadboard];
         translate([dx, dy, 0]) block(extent, center=ABOVE+RIGHT+BEHIND);
//        dx = -s_breadboard_perimeter;
//        dy = 8; 
//        extent = half_medium_breadboard_profile + bread_board_clearances + breadboard_perimeters;
//        translation = [
//            extent.x/2 + dx, 
//            extent.y/2 + dy, 
//        0]; 
//        translate(translation) {
//            render(convexity = 10) difference() {
//                block(extent, center=ABOVE);
//                block(half_medium_breadboard_profile + bread_board_clearances + vertical_clearances);
//            }
//        }
    }
    translate([0, dy_pcf8574, 0]) pcf8574_slide_rail_mount(board_count=2, center=FRONT, show_vitamins=show_vitamins);
    translate([0, dy_pca9685, 0]) pca9685_slide_rail_mount(center=FRONT, show_vitamins=show_vitamins);
    between_slides();
    #under_i2c_bus();
    behind_gpio_breadboard();
    
}




if (fit_test) {
    difference() {
        base();
        translate([10, 0, 0]) plane_clearance(FRONT);
    }
} else {
    base();
}