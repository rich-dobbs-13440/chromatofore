include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
include <ScadApotheka/material_colors.scad>
use <ScadApotheka/ptfe_filament_tubing_connector.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>
use <medusa_filament_detector.scad>

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


hub = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

/* [Animation] */    

roller_switch_depressed = false;
az_lock_connection = 90; // [90:Locked, 0:Unlocked]

/* [Printing] */
print_one_part = false;
part_to_print = "hub"; // [hub]

/* [Hub Design] */
r_hub = 15;
connector_count = 6;

/* [Manifold Design] */

// [r_connection, d_sphere, h_i, z_i]

f2 = 0.75; //[0:0.05:1]
f3 = 0.5; //[0:0.05:1]
f4 = 0.25; //[0:0.05:1]
f5 = 0; //[0:0.05:1]

r1 = r_hub;
r2 = f2*r_hub;
r3 = f3*r_hub;
r4 = f4*r_hub;
r5 = 0;

//d1 = 2;
//d2 = 2;
//d3 = 2;
//d4 = 2;
//d5 = 2;

h1 = 10;  
h2 = 10;  
h3 = 10; 
h4 = 10; 
h5 = 10;  

d_outer = 5;
d_inner = 3;
manifold_outer = [
    [r1, d_outer, h1, 0],
    [r2, d_outer, h2, h1],
    [r3, d_outer, h3, h1 + h2],
    [r4, d_outer, h4, h1 + h2 + h3],
    [r5, d_outer, h5, h1 + h2 + h3 + h4],
];

manifold_inner = [
    [r1, d_inner, h1, 0],
    [r2, d_inner, h2, h1],
    [r3, d_inner, h3, h1 + h2],
    [r4, d_inner, h4, h1 + h2 + h3],
    [r5, d_inner, h5, h1 + h2 + h3 + h4],
];

module end_of_customization() {}

 module generate_manifold(manifold) {
     function r(i) = manifold[i][0];
     function d(i) = manifold[i][1];
     function z(i) = manifold[i][3];
     for (i = [1: len(manifold)-1]) {
        hull() {
            translate([r(i-1), 0, z(i-1)]) sphere(d=d(i-1));
            translate([r(i), 0, z(i)]) sphere(d=d(i));
         }
     }
     
} 

function layout_from_mode(mode) = 
    mode == ASSEMBLE_SUBCOMPONENTS ? "assemble" :
    mode == PRINTING ? "printing" :
    "unknown";

layout = layout_from_mode(mode);

function show(variable, name) = 
    (print_one_part && (mode == PRINTING)) ? name == part_to_print :
    variable;
    
 
visualization_hub  =        
    visualize_info(
        "Hub", PART_2, show(hub, "hub") , layout, show_parts);  

        
connector = flute_connector_dimensions();    
connector_extent = gtcc_extent(connector);
clamp = flute_clamp_dimensions();    
clamp_extent = gtcc_extent(clamp);

 h_hub = connector_extent.z + 2;
 
 module for_all_connections(daz_offset=0) {
    daz = 360/connector_count; 
    for (idx = [0: connector_count - 1]) {
        az = idx * daz + daz_offset;
        rotate([0, 0, az]) {   
            children();
        }
    } 
 }
 



      

module cone_shape(d = 5, dz_cone=40) {
    hull() {
        translate([0, 0, dz_cone]) sphere(d=d, $fn=15);
        for_all_connections() {
            translate([r_hub, 0, h_hub]) {
                sphere(d=d , $fn=15);
            }
        }
    }
}

module cone() {
    dz_cone = 40;
    dz_outlet = dz_cone + 8;
    render() difference() {
        cone_shape(d = 5);
        hull() {
            cone_shape(d=3, dz_cone=dz_cone);
            translate([0, 0, -5]) cone_shape(d=3, dz_cone=dz_cone);
        }
        can(d=2, h=200, center=ABOVE);
       
    }
     translate([0, 0, dz_outlet]) rotate([180, 0, 0]) flute_collet();
    
}
//    if (use_center_barrel) {
//        filament_detector_barrel(ay_barrel = 0);
//        ///limit_switch_holder();
////        if (show_vitamins) {
////            rotate([0, 0, 45]) flute_collet_nut(); 
////        } 
//        cone();
//        dz_outlet = z_barrel + clamp_extent.z + 58;
//        translate([0, 0, dz_outlet]) rotate([180, 0, 0]) flute_collet();
//    }
//}



module hub() {
    cam_wall = 2;
    cam = gtcc_cam(connector);
    d = 2 * (r_hub + cam.y + cam_wall);
    module blank() {
        can(d = d, h = connector_extent.z + 2, center=ABOVE);
    }
    
    module cavity() {
        for_all_connections() {
            translate([r_hub, 0, 0]) {
                flute_keyhole(is_filament_entrance=false, print_from_key_opening=true);
            }
        } 
        flute_keyhole(is_filament_entrance=false, print_from_key_opening=true);
    }
    if (show_vitamins) {
        for_all_connections() {
            translate([r_hub, 0, -10]) {
                rotate([0, 0, az_lock_connection]) rotate([0, 90, 0]) medusa_filament_detecter();
                
            }
        }
    }
    difference() {
        blank();
        cavity();
    }
    
    if (show_vitamins) {
        for_all_connections() {
            translate([r_hub, 0, -10]) {
                // Show insertion as ghost
                color("Ivory", alpha=0.1) rotate([0, 90, 0]) medusa_filament_detecter();                
            }
        }
    }    

}

module pipes() {
    difference() {
        for_all_connections() {
                generate_manifold() {
                }
        }
    }
}
        

//hub();
pipes();

            
