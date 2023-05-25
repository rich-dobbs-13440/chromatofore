//include <lib/logging.scad>
include <centerable.scad>
// use <lib/not_included_batteries.scad>
include <material_colors.scad>
include <nutsnbolts-master/cyl_head_bolt.scad>
include <nutsnbolts-master/data-metric_cyl_head_bolts.scad>
include <MCAD/servos.scad>
include <NopSCADlib/vitamins/ball_bearings.scad>
include <NopSCADlib/vitamins/zipties.scad>
use <PolyGear/PolyGear.scad>
use <servo_horn_cavity.scad>
use <triangular_bearing_shaft.scad>
use <skate_bearing_fittings.scad>
use <small_servo_cam.scad>


a_lot = 100;


d_filament = 1.75 + 0.;
od_ptfe_tube = 4 + 0;

od_bearing = 22.0 + 0;
id_bearing = 8.0 + 0;
h_bearing = 7.0 + 0;
md_bearing = 14.0 + 0;

ORIENT_AS_ASSEMBLED = 0 + 0;
ORIENT_FOR_BUILD = 1 + 0;
ORIENT_AS_DESIGNED = 2 + 0;



/* [Output Control] */

orientation = 0; // [0:"As assembled", 1:"For build", 2: "As designed"]

orient_for_build = orientation == ORIENT_FOR_BUILD;

show_vitamins = true;
show_filament = true;

build_base_gear_pair = true;
build_leg_gear_pair = true;
build_bearing_plate  = true;
build_bearing_shaft_coupling = true;
build_alt_shaft_gearing = true;
build_drive_gear = true;


build_shaft = true;
build_shaft_gear = false; // Currently using the same beveled gear used for the clamp


build_clamp_gear = true;
build_clamp_slide = true;
build_filament_clamp = true;

build_end_caps = true;
build_both_end_caps = true;
build_ptfe_glides = false;

build_bearing_holder = false;
build_traveller = false; // Old implementation is being incrementally replaced

build_shaft_bearing_retainer = false;
build_clamp_skate_bearing_holder = false;
build_traveller_pivot_arms = false;
build_servo_hubbed_gear = false;


clamping_lift = 0; // [0: 0.1: 1]

show_cross_section = false;
build_slider_shaft_bearing_insert = false;



/* [Clearances] */ 
ptfe_snap_clearance = 0.17;
ptfe_slide_clearance = 0.5; // [0.5:Actual, 1:test]
ptfe_insert_clearance = 0.3;
part_push_clearance  = 0.2;

elephant_clearance = 1;
slider_clearance = 0.4;


/* [Filament_clamp_design] */ 
dx_clamp_bearing_to_clamp_nut_block = 13;
include_servo_attachment = false;

//*********************************************
/* [Bearing Holder Design] */ 


test_bearing_block = false;
include_shaft_bearing_block_base = true;
include_clamp_bearing_block_base = false;
join_block = false;



/* [Glide Design] */
slide_length = 50; // [1 : 1 : 99.9]
r_glide = 4;
glide_engagement = 1; // [0 : 0.1 : 2]
glide_filament_clearance = 2;
dx_glides = r_glide + od_ptfe_tube/2 + glide_filament_clearance; 



/* [General Gear Design] */
gear_height = 5;
gear_modulus = 1.7; 
hub_height = 4.6;
hub_diameter = 12.5;
z_gear_clearance = 1;
h_traveller_glide = 8;



/* [Clamp Gear Design] */
// 9 teeth => 16.9
clamp_gear_teeth = 9;
clamp_gear_diameter = 16.9 + 0; 

h_slider = 2; // [5: 0.1 : 8]
screw_length = 10; //[4, 6, 8, 10, 12, 16, 20]
x_clamp_nut_block = 7;
h_slide_to_bearing_offset = 0;
h_slide_to_gear_offset = 10;
dx_clamp_bearing = dx_clamp_bearing_to_clamp_nut_block  + x_clamp_nut_block; 

dx_clamp_gear = dx_clamp_bearing  + h_bearing;

traveller_bearing_clearance = 4;
dz_clamp_screw = od_bearing/2 + traveller_bearing_clearance; 
    
    
/* [Triangular Transmission Design] */

isosceles_base_shaft_spacing  = 28; // [22:35]
// The default altitude isthe same as the isosceles base shaft spacing.  This allows the same bearing holder to be used
isosceles_altitude = 28; // [22:35]
isosceles_leg_shaft_spacing = 
    right_triangle_hypotenuse(
        isosceles_base_shaft_spacing/2, 
        isosceles_altitude);
    
/* [Shaft Gear Design] */
// 19 teeth => 35.1, 22 teeth => 41, 17 teeth  = 31.6
shaft_gear_teeth = 19;
shaft_gear_diameter = 35.1; //[30: 0.1: 50]
h_shaft_bearing_base = 2; // [0: 0.1: 10]
h_shaft_rider = 9; // [5 : 0.1: 10]


dx_clamp_slide = x_clamp_nut_block + h_bearing + h_slide_to_bearing_offset + h_slider-1; 

/* [End Cap Design] */
end_cap_pad = 4;

dx_clamp_shaft = dx_clamp_bearing + h_bearing + shaft_gear_diameter/2;
dx_end_cap = -dx_clamp_shaft - shaft_gear_diameter/2 - end_cap_pad; 
x_end_cap = dx_glides  + r_glide + dx_clamp_shaft + shaft_gear_diameter/2 + od_ptfe_tube/2 + 2 * end_cap_pad; // [1:0.1:40]
y_end_cap = 10; //max(d_shaft_clearance, 2*dx_glides); 
z_end_cap = 6; // [1:0.1:20]

end_cap = [x_end_cap, y_end_cap, z_end_cap];

/* [Clamp Shaft Design] */
gear_filament_clearance = 6;
shaft_length = slide_length + 2*z_end_cap +  2*gear_height; //+ 2*z_clearance


/* [Traveller Design] */
z_traveller = 2; // [0.5:"Test fit", 2:"Prototype", 4:"Production"]
bearing_block_wall = z_traveller;

dx_traveller = dx_end_cap;
z_bearing_engagement = 2.5; //[0.5:"Test fit", 1:"Prototype", 2.5:"Production"]

// 
wall_skate_bearing_retainer = 2;



/* [Colors] */

alpha_clamp_gear = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]
alpha_clamp_gear_slide = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]
alpha_filament_clamp = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]
alpha_traveller = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]
alpha_shaft_gear = 1; // [1:Solid, 0.25:Ghostly, 0:Invisible]


filament_clamp_show_parts = false;
color_filament_clamp = PART_10;
filament_clamp_visualization = visualize_info(color_filament_clamp, alpha_filament_clamp); 

color_coupling = PART_11;

color_base_small_gear = PART_12;
color_base_large_gear = PART_13;
color_leg_small_gear = PART_14;
color_leg_large_gear = PART_15;


module end_of_customization() {}

function right_triangle_hypotenuse(a, b) = sqrt(a * a + b * b);


function mod(a, b) = a - b * floor(a / b);

* color("green") ziptie(small_ziptie);

* color("blue")  ziptie(small_ziptie, r = 5, t = 20); //! Draw specified ziptie wrapped around radius `r` 
                                                    //and optionally through panel thickness `t`





module filament(as_clearance) {
    d = as_clearance ? 2.5 : d_filament;
    alpha = as_clearance ? 0 : 1;
    color("red", alpha) {
        can(d=d, h=slide_length + 40, $fn=12);
    }
    
}



if (show_vitamins && show_filament && !orient_for_build ) {
    filament(as_clearance=false);
}


module end_cap(orient_for_build) {
    module blank() {
        translate([dx_end_cap, 0, 0]) block(end_cap, center=ABOVE+FRONT); 
    }
    module shape() {
        z_glide = 100;
        a_lot = 4*z_end_cap;
        color("aquamarine") {
            render(convexity=10) difference() {
                blank();
                filament(as_clearance=true);
//                translate([0, 0, -slide_length/2]) 
//                   ptfe_glides(orient_for_build = false, as_clearance = true, clearance=part_push_clearance); 
                translate([0, 0, -slide_length/2]) 
                   //slider_shaft(orient_for_build = false, as_clearance = true, clearance=ptfe_slide_clearance); 
                    slider_shaft(orient_for_build = false, as_clearance = true); 
                translate([-dx_clamp_shaft, 0, 0]) 
                    //can(d=d_shaft_clearance , h=a_lot);    
                    slider_shaft(orient_for_build = false, as_circular_clearance = true); 
            }
        }
    }
    
    if (orient_for_build) {
        translate([0, 0, z_end_cap]) rotate([180, 0, 0]) shape();
        if (build_both_end_caps) {
            translate([0, 20, z_end_cap]) rotate([180, 0, 0]) shape();
        }
    } else {
        center_reflect([0, 0, 1]) translate([0, 0, slide_length/2]) shape();
    }
}



module base_gear(teeth) {
    translate([0, 0, 1.2]) 
        bevel_gear(
          n = teeth,  // number of teeth
          m = gear_modulus,   // module
          w = 7,   // tooth width
          cone_angle     = 45,
          pressure_angle = 25,
          helix_angle    = -45,   // the sign gives the handiness
          backlash       = 0.1);
} 




module shaft_gear(orient_for_build = false, orient_to_center_of_rotation=false,  show_vitamins=false) {
    translation = 
        orient_for_build ? [0, 0, 0] : 
        orient_to_center_of_rotation ? [0, 0, -clamp_gear_diameter/2] :
        [-dx_clamp_shaft, 0, -clamp_gear_diameter/2];
    
    clearance = 0.5;  // 
    
    module splines(as_clearance) {
        clearance = as_clearance ? 0.5 : 0;
        clearances = 2*[clearance, clearance, clearance];
        r = as_clearance ? md_bearing/2 - 1 : md_bearing/2 - 1 - clearance;
        dz = as_clearance ? 0.2: 0;
        spline = [2.5, 2, 2.5]; 
        
        rotate([0, 0, 15]) 
            triangle_placement(r=r) 
                translate([0, 0, -dz]) 
                    block(spline + clearances, center=FRONT+ABOVE);
        rotate([0, 0, -15]) 
            triangle_placement(r=r) 
                translate([0, 0, -dz]) 
                    block(spline + clearances, center=FRONT+ABOVE);
    }
    module splined_shaft_rider() {
        translate([0, 0, -9]) shaft_rider(h=30, orient_for_build=false, show_vitamins=false);
        //splines(as_clearance = false);
    }
    module set_screw_clearance() {
        module holes(z) {
            triangle_placement(r=0) translate([110, 0, z]) rotate([0, 90, 0]) hole_through("M2", h = 100);
        }
        holes(-3);
        holes(14);
    }
    
    module shape() {
        render(convexity=20) difference() {
            union() {
                base_gear(teeth=shaft_gear_teeth);
                translate([0, 0, -6]) can(d=20, h=24, center=ABOVE);
                can(d=22, taper=27.5, h=6, center=BELOW);
            }
            can(d=md_bearing+1 + 2*clearance, h=100); 
            set_screw_clearance(); 
        }


//        translate([0, 0, h_shaft_rider]) 
//            slider_shaft_bearing_insert(orient_for_build=true, protect_from_elephant_foot=false);
    }
    
    if (show_vitamins) {
        dz_bb = -h_bearing/2 - clamp_gear_diameter/2 - h_shaft_bearing_base;
        dz_insert = dz_bb + h_bearing/2 ; // -clamp_gear_diameter/2;
        //translate([0, -11, 12]) rotate([90, 0, 0]) screw("M2x6");
//        translate([0, 0, dz_bb]) ball_bearing(BB608);
        //translate([0, 0, dz_insert]) slider_shaft_bearing_insert();
        //translate(translation) shaft_rider(h=10, orient_for_build=orient_for_build, show_vitamins=show_vitamins);
    }
    color("pink", alpha_shaft_gear) {
        if (orient_for_build) {
            translate([0, 0, h_shaft_bearing_base]) shape();
            translate([50, 0, h_shaft_bearing_base]) splined_shaft_rider();
        } else {
            translate(translation) {
                shape();
                splined_shaft_rider();
            }
        } 
    }   
}





module clamp_gear(orient_for_build, orient_to_center_of_rotation=false, show_vitamins=false) {
    
    translation = 
        orient_to_center_of_rotation ? [shaft_gear_diameter/2, 0, 0] :
        [-dx_clamp_gear, 0, 0]; //dz_clamp_screw];
    a_lot = 100;
    h_neck = 2;
    dz = h_neck + h_bearing + h_slider + elephant_clearance ;
    module shape() {
        base_gear(teeth=clamp_gear_teeth);
        can(d=id_bearing, taper= id_bearing + 4, h=h_neck, center=BELOW);
        translate([0, 0, -h_neck]) 
            can(d=id_bearing, h=h_bearing, center=BELOW);
        translate([0, 0, -h_neck-h_bearing]) 
            can(d=id_bearing, h=h_slider, center=BELOW, $fn=6);
        translate([0, 0, -h_neck-h_bearing-h_slider]) 
            can(d = id_bearing-2*elephant_clearance, taper=id_bearing, h=elephant_clearance, center=BELOW, $fn=6);        
    }
    if (show_vitamins) {
        translate(translation + [3, 0, 0])  rotate([0, 90, 0]) ball_bearing(BB608);
    }
    color(PART_20, alpha=alpha_clamp_gear) {
        if (orient_for_build) {
            translate([0, 0, dz]) shape();
        } else {
            translate(translation) rotate([0, -90, 0])  shape();
        } 
    }     
}


module clamp_slide(orientation, show_vitamins=false) {
    wall = 1;
    a_lot = 100;
    d_cavity = id_bearing + 2*slider_clearance;
    d_slider = d_cavity + 2 * wall;
    h_base = 4; 
    module shape() {
        render(convexity=10) difference() {
            union() {
                can(d=d_slider, h=h_slider + 3, center=ABOVE, $fn=6);
                can(d=d_slider, h=h_base, center=BELOW, $fn=6);
            }
            can(d=d_cavity, h=a_lot, center=ABOVE, $fn=6);
            translate([0, 0, 25]) hole_through("M2", cld=0.6,  $fn=12);
            translate([0, 0, -2]) nutcatch_parallel("M2", clh=5, clk=0.4, $fn=12);
        }
    }

    translation = 
        orientation == ORIENT_FOR_BUILD ? [0, 0, h_base] :
        orientation == ORIENT_AS_ASSEMBLED ? [-(screw_length + clamping_lift), 0, 0] :
        [0, 0, 0];
    
    rotation = 
        orientation == ORIENT_AS_ASSEMBLED ? [0, -90, 0] : 
        [0, 0, 0];
        
        
     
    translate(translation) rotate(rotation) {
        if (show_vitamins && orientation != ORIENT_FOR_BUILD) {
            color(BLACK_IRON) screw(str("M2x", screw_length));
            translate([0, 0, -2]) color(BLACK_IRON) nut("M2");
        }        
        color(PART_25, alpha=alpha_clamp_gear_slide) shape() ;
    }
//        } else {
//            //translate(translation) rotate([0, -90, 0])  
//            shape();
//        } 
//    }  
}



module bearing_block(show_vitamins=false) {
    
    a_lot = 100;
    bearing_wall = 2;
    h_neck = 2;
    s = od_bearing + 2 * bearing_wall;
    d_bearing_retention = od_bearing - 1;
    dz_shaft = clamp_gear_diameter/2 + h_bearing  + h_shaft_bearing_base;
    dx_clamp = shaft_gear_diameter/2 + h_bearing  + h_neck;
    
    module block_joiner() {
        if (join_block) {
            translate([dx_clamp+bearing_wall, 0, -dz_shaft]) 
                block([2*bearing_wall, s/2, 2*bearing_wall], center=BEHIND);
        }
    }
    module blank() {
        union() {
            if (include_shaft_bearing_block_base) {
                hull() {
                    translate([0, 0, -dz_shaft]) can(d=s, h=2*bearing_wall);
                    block_joiner();
                }
            }
            if (include_clamp_bearing_block_base) {
                hull() {
                    translate([dx_clamp, 0, 0]) rotate([0, 90, 0]) can(d=s, h=2*bearing_wall);
                    block_joiner();
                }   
            }
        }        
    }
    difference() {
        blank();
        clamp_gear(orient_to_center_of_rotation=true, show_vitamins=true);
        shaft_gear(orient_to_center_of_rotation=true, show_vitamins=true);
        can(d=d_bearing_retention, h=a_lot);
        rotate([0, 90, 0]) can(d=d_bearing_retention, h=a_lot);

    }
    if (show_vitamins) {
        clamp_gear(orient_to_center_of_rotation=true, show_vitamins=true);
        shaft_gear(orient_to_center_of_rotation=true, show_vitamins=true);
    }
}


if (test_bearing_block) {
    bearing_block(show_vitamins = show_vitamins);
} 

module tuned_M2_nutcatch_side_cut(as_clearance = true) {
    if (as_clearance) {
        nutcatch_sidecut("M2", $fn = 12, clh=.5); 
    } else {
        nut("M2");
    }
}


module filament_clamp(
        include_servo_attachment=true, 
        include_vitamins=true, 
        include_bearing_mounting_adapter = true,
        as_mounting_screw_clearance=false) {
    z = 8;
    screw_wall = 2;
    wall = 2;
    
    y_clamp_nut_block = 8;
    pivot_screw_length = 16;
    module clamp_screw_clearance() {
        translate([0, 0, 0]) {
            rotate([0, 90, 0]) {
                hole_through("M2", $fn = 12);
            } 
            translate([-2.2, 0, 0]) rotate([0, -90, 180]) {
                 tuned_M2_nutcatch_side_cut(); 
            }            
        }
    }
    module nut_block() {
        block([x_clamp_nut_block, y_clamp_nut_block, z], center=BEHIND);
        can(d=5, h=z);
    }

    module mounting_screws(as_clearance = true) {
        module basic_bearing_mount() {
            if (as_clearance) {
                translate([-dx_clamp_bearing_to_clamp_nut_block, od_bearing/2 + 4, 0]) {
                    rotate([0, 90, 0]) {
                        hole_through("M2", cld=0.4, $fn = 12);
                    } 
                } 
            } 
        } 
        module vertical_mount() {
            if (as_clearance) {
                translate([0,0, 25]) hole_through("M2", cld=0.4, $fn = 12);
            }
        }
        center_reflect([0, 1, 0]) {
            basic_bearing_mount();
            translate([0, 4, 0]) basic_bearing_mount();
            translate([0,0, -4]) basic_bearing_mount();
            // Just in case holes
            translate([0 , 8, 0]) vertical_mount();
            translate([-6 , 9, 0]) vertical_mount();
            translate([-14 , 11, 0]) vertical_mount();
        }

        
    }
    
    module pivot_attachment() {
        color(PART_30) {
            center_reflect([0, 1, 0]) rotate([0, 0, 90]) nut_block();
        }        
    }
    
    module platform_mount() {
        dz = include_bearing_mounting_adapter ? 14 : -z/2;
        z_wings = include_bearing_mounting_adapter ? 28 : z;
        color("RED") hull() { // PART_28
            nut_block();
            if (include_servo_attachment) {
                pivot_attachment();
            }
            block([x_clamp_nut_block, y_clamp_nut_block, 14], center=BELOW);
        }
        color(PART_34) 
            translate([0, 0, -dz]) 
                block([x_clamp_nut_block, 28, screw_wall]); 
        if (include_servo_attachment) {
            color("indigo")
            center_reflect([0, 1, 0]) {
                rotate([0, 0, 90]) nut_block();
                translate([0, 3+pivot_screw_length, 0]) 
                    block([x_clamp_nut_block, screw_wall, z_wings], center=LEFT); 
                translate([6, 0, -dz]) 
                    block([15, 3+pivot_screw_length, screw_wall], center=ABOVE+RIGHT+BEHIND); 
            }
            
        }

        
    }
    module pivot_screws(as_clearance = false) {
        center_reflect([0, 1, 0]) {
            translate([0, 3, 0]) { 
                if (as_clearance) {
                     rotate([90, 0, 0]) hole_through("M2", $fn=12, cld=0.4);
                     rotate([0, -90, 90]) tuned_M2_nutcatch_side_cut(as_clearance=true);  
                } else {
                    color(BLACK_IRON) {
                        rotate([0, -90, -90]) 
                            translate([0, 0, pivot_screw_length]) 
                                screw(str("M2x", pivot_screw_length));
                        rotate([0, -90, 90]) 
                           tuned_M2_nutcatch_side_cut(as_clearance=false);  
                    }
                    
                }
            }
        }
    }
    
    
    module shape() {
        difference() {
            union() {
                nut_block();
                platform_mount();
            }
            filament(as_clearance=true);
            clamp_screw_clearance();
            mounting_screws(as_clearance = true); 
            if (include_servo_attachment) {
                pivot_screws(as_clearance = true);
            }
            translate([0, 0, 3]) plane_clearance(ABOVE); 
        }
            
    } 
    module vitamins() {
        if (include_servo_attachment) {
            pivot_screws(as_clearance = false);
        }
        mounting_screws(as_clearance = false);  
    }
    if (as_mounting_screw_clearance) {
        mounting_screws(as_clearance = true);
    } else {
        if (include_vitamins && !orient_for_build) {
            vitamins();
        }
        visualize(filament_clamp_visualization, filament_clamp_show_parts) { 
            shape();
        }
    }
    
}
// **************************************************************************************

module traveller_pivot_arms(orientation, show_vitamins) {
    a_lot = 100;
    d_horn = 6.2;
    wall = 2;
    id = od_ptfe_tube  + 2*ptfe_insert_clearance;
    od = id + 2*wall;
    iy_pivot = x_clamp_nut_block;
    dy_inside_bearing = 2;
    dx_pivot_arm = 6;
    dy_i = iy_pivot + dy_inside_bearing;
    arm_length = 20;
    x_yoke = 20;
    
    z_cavity = 3.5;
    z_screw_hold = 0.75;
    z_total = z_cavity+ z_screw_hold;
    z_arm = 2;

    horn_blank = [8, 8, z_total];
    module traveller_pivot() {
        can(d=od, hollow=id, h=dx_pivot_arm, center=ABOVE); 
    }
    module servo_horn() {
        render(convexity=10) difference() {
            block(horn_blank, center=ABOVE); 
            translate([0, 0, z_screw_hold]) { 
                horn_cavity(
                    diameter=d_horn,
                    height=a_lot,
                    shim_count = 5,
                    shim_width = 1,
                    shim_length = .5);
            }
            can(d=2, h=a_lot);
        }
    }
    module located_horn() {
        translate([arm_length, 0, 0]) servo_horn();
    }
    module barrel_servo_connector() {
        render(convexity = 10) difference() {
            hull() {
                located_horn();
                traveller_pivot(); 
            }
            translate([0, 0, z_arm]) plane_clearance(ABOVE);
            hull() located_horn();
            hull() traveller_pivot(); 
        }
    }
    module yoke() {
        center_reflect([0, 1, 0]) {
            translate([0, dy_i, 0]) {
                rotate([-90, 0, 0]) traveller_pivot();
                difference() {
                    block([x_yoke, wall, od], center=FRONT+RIGHT);
                    rod(d=id, l=a_lot, center=SIDEWISE);
                }
            }
        }
        translate([x_yoke, 0, 0]) block([wall, 2* dy_i, od], center=BEHIND);
    }
    
    module yoke_holes() {
        center_reflect([0, 1, 0]) 
            translate([0, 3.5, 0]) 
                rotate([0, -90, 0]) 
                    hole_through("M2", $fn=12, cld=0.4);
    }
    render(convexity = 10) difference() {    
        yoke();
        // Temporary development expedient
        yoke_holes();
        
    }
    //connector();
    //located_horn();  
}



module traveller(orient_for_build, show_vitamins) {
    //translation = orient_for_build ? [0, 0, 0] : [-dx_clamp_shaft, 0, 0];
    r_glide_mod = r_glide + od_ptfe_tube/2 + ptfe_slide_clearance;


    dx_clamp_bearing = -h_bearing/2 - x_clamp_nut_block;
    
    module blank() {
        hull() {
            translate([-dx_clamp_shaft, 0, 0]) 
                can(d=od_bearing + 2*bearing_block_wall, h=z_traveller, center=ABOVE);
            translate([dx_glides, 0, 0]) 
                can(
                    d=2*r_glide_mod + 2 + bearing_block_wall, 
                    h=z_traveller, 
                    hollow=2*r_glide_mod + 1, 
                    center=ABOVE);
        }
        translate([-dx_clamp_shaft, 0, 0]) 
                can(
                    d=od_bearing + 2*bearing_block_wall, 
                    hollow = od_bearing - 2,
                    h=z_bearing_engagement +z_traveller, 
                    center=ABOVE);        
        translate([dx_glides, 0, -z_traveller]) can(d=2*r_glide_mod + 2, h=10, hollow=2*r_glide_mod + 1, center=ABOVE);
        // riders on glides:
      
    }

    module shape() {
        a_lot = 30;
        render(convexity=20) difference() {
            blank();
            
            translate([-dx_clamp_shaft, 0, 0]) can(d=od_bearing, h=z_bearing_engagement, center=ABOVE);
            ptfe_tube(as_clearance=true, h=20, clearance=ptfe_snap_clearance);
            filament(as_clearance=true); 
            //ptfe_glides(glide_length=a_lot, orient_for_build = false, as_traveller_clearance = true, clearance=ptfe_slide_clearance); 
            //clamp_screw_clearance();
        }
        translate([dx_glides, 0, -z_traveller]) 
            triangle_placement(r=r_glide_mod) block([1,4, 10], center=FRONT+ABOVE);  
        
        
    }    
    if (show_vitamins && !orient_for_build) {
//        * translate([-dx_clamp_shaft, 0, -h_bearing/2 + z_bearing_engagement]) 
//            ball_bearing(BB608);
//        translate([-dx_clamp_shaft, 0, z_bearing_engagement])
//            slider_shaft_bearing_insert(orient_for_build=false, show_vitamins=false);
//        translate([dx_clamp_bearing, 0, dz_clamp_screw]) 
//            rotate([0, 90, 0]) ball_bearing(BB608);
    }
    color(PART_6, alpha_traveller) {
        if (orient_for_build) {
            translate([0, 0, z_traveller]) shape();
        } else {
            translate([0, 0, 0]) shape();
        } 
    }   
}   

module clamp_skate_bearing_holder() {
    translate([-dx_clamp_bearing, 0, 0]) 
        rotate([0, -90, 0]) {
            skate_bearing_holder(cap=true, show_mocks=show_vitamins);
            // Add attachment block
            difference() {
                union() {
                    block([25, 25, 8], center=ABOVE);
                    translate([3, 0, 0]) block([12, 43, 2], center=ABOVE+BEHIND);
                }
                skate_bearing_holder(as_clearance=true);
                skate_bearing_retainer(as_screw_clearance=true);
                translate([0, 0, -30]) rotate([0, 90, 0]) filament_clamp(as_mounting_screw_clearance = true);
            }
        }
}


if (build_end_caps) {
    if (orient_for_build) {
        translate([0, 0, 0]) end_cap(orient_for_build=true);
    } else {
        end_cap(orient_for_build=false);
    }
}


if (build_ptfe_glides) {
    if (orient_for_build) {
        translate([30, 0, 0]) ptfe_glides(orient_for_build=true, show_vitamins=false);
    } else {
        ptfe_glides(orient_for_build=false, show_vitamins=show_vitamins);
    }
}


if (build_shaft) {
    if (orient_for_build) {
        translate([40, 0, 0]) slider_shaft(orient_for_build=true);
    } else {
        slider_shaft(orient_for_build=false);
    }    
}


if (build_shaft_gear) {
    if (orient_for_build) {
        translate([70, 0, 0]) shaft_gear(orient_for_build=true, show_vitamins=show_vitamins);
    } else {
        shaft_gear(orient_for_build=false, show_vitamins=show_vitamins);
    }    
}


if (build_clamp_slide) {
    translation = orient_for_build ? [40, 20, 0] : [0, 0, 0];
    translate(translation) clamp_slide(orientation=orientation, show_vitamins=show_vitamins);   
}


if (build_filament_clamp) {
    filament_clamp(include_servo_attachment=include_servo_attachment);
}


if (build_traveller_pivot_arms) {
    translation = orient_for_build ? [100, 0, 0] : [0, 0, 0]; 
    translate(translation) 
        traveller_pivot_arms(
            orientation=orientation, 
            show_vitamins = show_vitamins && ! orient_for_build);
}


if (build_clamp_gear) {
    if (orient_for_build) {
        translate([60, 30, 0]) clamp_gear(orient_for_build=true, show_vitamins=false);
    } else {
        clamp_gear(orient_for_build=false, show_vitamins=false); //show_vitamins);
    }    
}


if (build_slider_shaft_bearing_insert) {
    if (orient_for_build) {
        translate([60, -30, 0]) slider_shaft_bearing_insert(orient_for_build=true, show_vitamins=false);
    } else {
        //Is placed as a vitamin for the traveller
    }      
}


if (build_traveller) {
    if (orient_for_build) {
        translate([0, -20, 0]) traveller(orient_for_build=true, show_vitamins=false);
    } else {
        traveller(orient_for_build=false, show_vitamins=show_vitamins);
    }    
}


if (build_clamp_skate_bearing_holder) {
    clamp_skate_bearing_holder();
}


if (build_servo_hubbed_gear) {
    servo_hubbed_gear();
}


if (build_drive_gear) {
    drive_gear(orient_for_build=orient_for_build, show_vitamins=show_vitamins);
}


if (build_bearing_plate) {
    translation = orient_for_build ? [100, 0, 0] : [0, 0, z_end_cap + 5];
    translate(translation) bearing_plate(orient_for_build, isosceles_layout=true);
}


if (build_base_gear_pair) {
    rotation = [0, 0, 0];
    rotate(rotation) 
    triangular_shaft_gear_pair(
        axle_spacing = isosceles_base_shaft_spacing,
        small_gear_color = color_base_small_gear, 
        large_gear_color = color_base_large_gear, 
        orient_for_build=orient_for_build);
}


if (build_leg_gear_pair) {
    rotation = [180, 0, 0];
    rotate(rotation) 
    triangular_shaft_gear_pair(
        axle_spacing=isosceles_leg_shaft_spacing, 
        small_gear_color  = color_leg_small_gear,
        large_gear_color = color_leg_large_gear, 
        orient_for_build=orient_for_build);
}


module shaft_bearing_retainer(orientation) {
    wall = 2;
    a_lot = 100;
    x_beyond = 40;
    dx = dx_clamp_bearing + h_bearing;
    base = [x_beyond, 25, wall];
    module enforce_clearances() {

            difference() {
                children();
                translate([-shaft_gear_diameter/2, 0, 0]) can(d=16, h=a_lot);
                rod(d=od_bearing, l=a_lot, center=BELOW);
            }
        
    }
    module shape() {
        translate([-dx, 0, od_bearing/2]) {    
            translate([-1, 0, -1]) {
                block(base, center = ABOVE+BEHIND);
                block([2, 25, 8], center = BELOW+BEHIND);
            } 
        }        
    }
//    *enforce_clearances() {
//
//    }   
    shape();
    //translate() mirror([0, 0, 1]) shape(); 

}



module bearing_shaft_coupling(orient_for_build, cl_hex=0.6, cl_tri=0.6, h = 16) {
    a_lot = 100;
    d_body = 12;
    color(PART_11) {
        render(convexity=10) difference() {
            can(d=d_body, h=h);
            can(d=7 + 2*cl_hex, h=a_lot, $fn=6, center=ABOVE);
            can(d=8 + 2*cl_tri, h=a_lot, $fn=3, center=BELOW);
            translate([0, 0, 5]) rotate([90, 0, 0]) hole_through("M2", $fn=12);
            translate([0, 0, -5]) rotate([90, 0, -30]) hole_through("M2", $fn=12);
            can(d=0, taper=9, h=h/2, $fn=20, center=ABOVE);
            translate([0, 0, -h/2]) can(d=9.5, taper=0, h=2, $fn=20, center=ABOVE);
        }
        can(d=d_body, h=0.5);
    }
    
}

if (build_shaft_bearing_retainer) {
    translation  = orient_for_build ? [500, 0, 0] : [0, 0, 0]; 
    translate(translation) shaft_bearing_retainer(orientation=orientation);   
}


module bearing_holder(show_vitamins=false) {
    dz = -(od_bearing/2 + h_bearing);
    translate([0, 0, dz])
        skate_bearing_holder(cap=true, body_is_block = true, show_mocks=show_vitamins);
    dx = (od_bearing/2);
    translate([dx, 0, 0])    
        rotate([0, 90, 0]) 
            skate_bearing_holder(cap=true, body_is_block = true, show_mocks=show_vitamins);
    dx_filament = dx_clamp_gear + clamp_gear_diameter/2;
    difference() {
        translate([14, 0, -14]) block([dx_clamp_gear, 28, 4], center=FRONT+BELOW);
        translate([dx_filament, 0, 0]) {
            filament(as_clearance=true);
            center_reflect([0, 1, 0]) {
                translate([0, 8, 25]) hole_through("M2", cld=0.4, $fn = 12); 
            }
        }
    }
}

if (build_alt_shaft_gearing) {
    dx = dx_clamp_gear + clamp_gear_diameter/2;
    dz = clamp_gear_diameter/2;
    if (!orient_for_build) {
        translate([-dx , 0, -dz]) base_gear(teeth=clamp_gear_teeth);
    }
        
    translate([-dx, 0, 0]) bearing_holder(show_vitamins=show_vitamins);
    
}


if (build_bearing_shaft_coupling) {
    translate([100, 100, 0]) bearing_shaft_coupling();
}

module drive_gear(orient_for_build=true, show_vitamins=false, h_rider=8) {
    module rider(as_clearance=false) {
        if (as_clearance) {
            scale([0.99, 0.99, 1]) 
                hull() 
                    translate([0, 0, -a_lot/2])
                        shaft_rider(h=a_lot);
        } else {
            dz = +gear_height/2;
            translate([0, 0, dz]) 
                shaft_rider(
                    h=h_rider, 
                    orient_for_build=false, 
                    show_vitamins=show_vitamins);
        }
        
  

    }
    module shape() {
        render(convexity=10) difference() {
            spur_gear(
                n = 9,  // number of teeth, just enough to clear rider.
                m = gear_modulus,   // module
                z = gear_height,   // thickness
                pressure_angle = 25,
                helix_angle    = 0,   // the sign gives the handiness, can be a list
                backlash       = 0.1 // in module units
            );
            //rider(as_clearance=true);
            slider_shaft(as_clearance=true);
        }
        rider(as_clearance=false);
        
    }
    if (orient_for_build) {
        // Move origin to the bottom of the gear
        dz = gear_height/2;
        translate([0, 0, dz]) shape();
    } else {
        // Origin is at center of gear vertically
        translate([0, 0, 0])  shape();
    }
}


module servo_hubbed_gear() {
    module shape() {
        render(convexity=10) difference() {
            spur_gear(
                n = 25,  // number of teeth, just enough to clear rider.
                m = gear_modulus,   // module
                z = gear_height,   // thickness
                pressure_angle = 25,
                helix_angle    = 0,   // the sign gives the handiness, can be a list
                backlash       = 0.1 // in module units
            );
            can(d=30, h=a_lot);
            
        }
        hub(horn_thickness=small_servo_cam_horn_thickness(), hub_diameter=small_servo_cam_hub_diameter()); 
        
    }
    color(PART_34)
        shape(); 
}


module zip_tie_attached_gear() {
    
    
}



// ************************************************************************************

module bearing_plate(orient_for_build, linear_layout=false, isosceles_layout = false) {
    module retainer() {
        skate_bearing_retainer(
            wall = wall_skate_bearing_retainer, 
            orient_for_build=true, 
            show_mock=false, 
            as_screw_clearance=false);
    }
    module linear_layout() {
        for (i = [0:2]) {
            translate([i*28, 0, 0]) 
                retainer();
        }
    }
    module isosceles_layout() {
        retainer();
        center_reflect([0, 1, 0]) {
            translate([28, 14, 0]) {
                retainer();
            }
            // Additional mounting holes
            translate([0, 28, 0]) {
                difference() {
                    retainer();
                    translate([0, -9, 0]) plane_clearance(RIGHT);

                }
            }
            translate([0, 28+5, 0]) {
                difference() {
                    retainer();
                    translate([0, -9, 0]) plane_clearance(RIGHT);

                }
            }            
            
        }
    }
    module shape() {
        if (linear_layout) {
            linear_layout();
        } else if (isosceles_layout) {
            isosceles_layout();
        } else {
            assert(false);
        }
    }
    translation = orient_for_build ? [0, 0, wall_skate_bearing_retainer] : [0, 0, wall_skate_bearing_retainer];
    color(PART_33) translate(translation) shape();
}





function maximum_matching_gear_teeth(n_teeth_small, d_small_minimum, axle_spacing) = let(
        minimum_module = d_small_minimum / n_teeth_small,
        d_big_maximum = 2 * axle_spacing - d_small_minimum,
        maximum_teeth_big = d_big_maximum / minimum_module,
        n_teeth_big = floor(maximum_teeth_big)
    ) n_teeth_big;    

function calc_gear_module(n_teeth_1, n_teeth_2, axle_spacing) = 2*axle_spacing/(n_teeth_1 + n_teeth_2);


function meshing_rotation_angle(n_teeth_1, n_teeth_2) = mod(n_teeth_1 + n_teeth_2, 2) * 180/n_teeth_2;


module triangular_shaft_gear_pair(axle_spacing, small_gear_color, large_gear_color, orient_for_build=false) { 
   assert(is_num(axle_spacing));
    // Default axle spacing to separately mounted bearings as close.  Could be as small as 22, or as large as desired.
    n_teeth_small = 9;
    d_small_minimum = 18.9; // Enough to pass through zip ties without interfering with teeth
//    minimum_module = d_small_minimum / n_teeth_small;
//    echo("minimum_module", minimum_module);
//    
//    d_big_maximum = 2*axle_spacing - d_small_minimum;
//    echo("d_big_maximum", d_big_maximum);
//    maximum_teeth_big = d_big_maximum / minimum_module;
    n_teeth_big = maximum_matching_gear_teeth(n_teeth_small, d_small_minimum, axle_spacing);
    gear_module = calc_gear_module(n_teeth_small, n_teeth_big, axle_spacing);
    
    // echo("maximum_teeth_big", maximum_teeth_big);
    //n_teeth_big = floor(maximum_teeth_big);
    echo("n_teeth_big", n_teeth_big);
    //gear_module = 2*axle_spacing/(n_teeth_small + n_teeth_big);
    echo("gear_module", gear_module);
    //meshing_rotation_angle = mod(n_teeth_small + n_teeth_big, 2) * 180/n_teeth_big;
    
    echo("gear ratio", n_teeth_big/n_teeth_small);

    
    module small_gear() {
        ziptie_attached_spur_gear(
            n_teeth = n_teeth_small, 
            gear_modulus = gear_module, 
            gear_height = 6, 
            hub_height = 4,
            zip_angle = 0,
            color_code = small_gear_color
        );
        // Something seems awry, so expand the diameter for the tip
        adjustment = 6;
        d_tip = (n_teeth_small * gear_modulus) + 2 * gear_modulus + adjustment;
        echo("d_tip", d_tip);
        color(small_gear_color)
        translate([0, 0, 10]) {
            rotate([0, 0, 0])
                ziptie_bearing_attachment(h=2, zip_angle=20, d=md_bearing) {
                    can(d=d_tip, h=6, center=ABOVE);
                }
        }
        
    }
        
        
    module large_gear() {
        angle = meshing_rotation_angle(n_teeth_small, n_teeth_big);
        rotate([0, 0, angle]) {
            ziptie_attached_spur_gear(
                n_teeth = n_teeth_big, 
                gear_modulus = gear_module, 
                gear_height = 4, 
                hub_height = 4, 
                color_code = large_gear_color
            );  
        }      
    }

    small_gear();
    layout_spacing = orient_for_build ? axle_spacing + 3 : axle_spacing;
    translate([layout_spacing, 0, 0]) large_gear();
}




        
