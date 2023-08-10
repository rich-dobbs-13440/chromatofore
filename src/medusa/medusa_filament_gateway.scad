include <ScadStoicheia/centerable.scad>
use <ScadStoicheia/visualization.scad>
use <ScadStoicheia/hermetian_cubic_spline.scad>
include <ScadApotheka/material_colors.scad>
use <ScadApotheka/ptfe_filament_tubing_connector.scad>
use <ScadApotheka/quarter_turn_clamping_connector.scad>
use <ScadApotheka/no_solder_roller_limit_switch_holder.scad>
use <medusa_filament_detector.scad>

//     flute_collet(is_filament_entrance = true, as_clearance = false);
//     


a_lot = 100 + 0;
d_filament_with_clearance = 2.5;
 /* [Output Control] */
 
 mode = 3; // [3: "Assembly", 4: "Printing"]
show_vitamins = true;
show_filament = true;
show_cross_section = false;
show_parts = true; // But nothing here has parts yet.
show_legend = false;


hub = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
pipes  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]
outlet  = 1; // [1:Solid, 0.25:Ghostly, 0:"Invisible, won't print" ]

/* [Animation] */    

roller_switch_depressed = false;
az_lock_connection = 90; // [90:Locked, 0:Unlocked]
// TODO:  Retrieve offset from filament detector file and calculations 
dz_filament_detectors = -8; // [-10:0.1:0]
dr_filament_detector = 2; // [0: 0.1 : 5]

i_manifold_focus = 1; // [1:6]

/* [Printing] */
print_one_part = false;
part_to_print = "hub"; // [hub, pipes]

/* [Hub Design] */
r_hub = 20;
cam_wall = 2;
h_base = 2;

connector_count = 1; // [1:1:8]
dz_keyhole = 0;

// Tilt of the keyhole radially.
ay_keyhole = -15; // [-45: 5: 0]
// Rotation of the keyhole , in the locking plane.
az_keyhole = 200;
h_tilt = abs(sin(ay_keyhole)) * (r_hub + 5); // [0:10]
//echo("h_tilt", h_tilt, "h_tilt_calc", sin(ay_keyhole) * r_hub);


/* [Manifold Design] */


z_convergence = 40; //[20:40]
dz_manifold_exit = 0;

use_central_pipe = true;

d_outer = 7;
d_inner = 3;
d_outlet = 9;
d_inner_entrance = 5;
d_outer_entrance = d_inner_entrance + 2;


module end_of_customization() {}


// Calculations

connector = flute_connector();    
connector_extent = gtcc_extent(connector);
clamp = flute_clamp_connector();    
clamp_extent = gtcc_extent(clamp);
cam = gtcc_cam(connector);

h_hub = connector_extent.z + 2; 

r_pipe = r_hub  + connector_extent.z* sin(ay_keyhole);
dz_pipes = abs(connector_extent.z* cos(ay_keyhole)) + 1.5;

d_cam_blank = 2 * (cam.y + cam_wall);

r_filament_detector = r_hub + dr_filament_detector;

function filament_offset(z, z_t, path_offset) =
    let(M = tan(ay_keyhole), Y=path_offset) 
    hermetian_cubic_spline(z, z_t, M, Y);

//function filament_offset(z, z_t, path_offset) = 
//    z > z_t ? 0 :
//    let(
//        c_1 = 12*path_offset/z_t^3,
//        c_2 = -c_1 * z_t/2)   
//    c_1 * z ^ 3/ 6 - c_1 * z_t * z ^2 / 4 + path_offset;

h_manifold = z_convergence + dz_manifold_exit;


h0 = z_convergence/5;  
h1 = z_convergence/5;  
h2 = z_convergence/5;  
h3 = z_convergence/5;  
h4 = z_convergence/5; 
h5 = z_convergence/5; 

z0 = 0;
z1 = z0 + h0;
z2 = z1 + h1;
z3 = z2 + h2;
z4 = z3 + h3;
z5 = z4 + h4;

r0 = filament_offset(z0,  z_convergence, r_pipe);
r1 = filament_offset(z1,  z_convergence, r_pipe);
r2 = filament_offset(z2,  z_convergence, r_pipe);
r3 = filament_offset(z3,  z_convergence, r_pipe);
r4 = filament_offset(z4,  z_convergence, r_pipe);
r5 = filament_offset(z5, z_convergence, r_pipe);


manifold_outer = [
    [r0, d_outer_entrance, h0, z0],
    [r1, d_outer, h1, z1],
    [r2, d_outer, h2, z2],
    [r3, d_outer, h3, z3],
    [r4, d_outer , h4, z4],
    [r5, d_outlet, h5, z5],
    [0, d_outlet, h_manifold-h5, h_manifold],
];

manifold_inner = [
    [r0, d_inner, h0, z0],
    [r1, d_inner, h1, z1],
    [r2, d_inner, h2, z2],
    [r3, d_inner, h3, z3],
    [r4, d_inner, h4, z4],
    [r5, d_inner, h5, z5 ],
    [0, 1.75, h_manifold-h5, h_manifold],
];




layout = layout_from_mode(mode);

function show(variable, name) = 
    (print_one_part && (mode == PRINTING)) ? name == part_to_print :
    variable;
    
 
visualization_hub  =        
    visualize_info(
        "Hub", PART_21, show(hub, "hub") , layout, show_parts);  

visualization_pipes  =        
    visualize_info(
        "Pipes", PART_22, show(pipes, "pipes") , layout, show_parts);  
        
visualization_outlet =         
    visualize_info(
        "Outlet", PART_23, show(outlet, "outlet") , layout, show_parts);  
        

 module for_all_connections(daz_offset=0) {
    daz = 360/connector_count; 
    for (idx = [0: connector_count - 1]) {
        az = idx * daz + daz_offset;
        rotate([0, 0, az]) {   
            children();
        }
    } 
 }
 

module hub() {
    dz = 5;
    z_offset = 5;
    r_offset = 1;
    module blank() {
        for_all_connections() {
                translate([r_hub, 0, 0]) {
                    rotate([0, ay_keyhole, 0]) {
                        can(d = d_cam_blank, h = h_hub, center=ABOVE);
                        // Central post to make joining with pipes easier
                        can(d = 8, h = h_hub + 2, center=ABOVE);
                    }
                }
        }
        can(d = d_cam_blank, h = h_hub, center=ABOVE);
        can(d = 2*r_hub, h = h_base, center=ABOVE, $fn=connector_count);
    }
    
    module cavity() {
        for_all_connections() {
            translate([r_hub, 0, dz_keyhole]) {  
                rotate([0, ay_keyhole, 0]) rotate([0, 0, az_keyhole]) {
                    flute_keyhole(is_filament_entrance=false, print_from_key_opening=false) {
                    }
                }
            }
        } 
        use_bridging = false; // will print from top!  abs(ay_keyhole) < 15;
        flute_keyhole(is_filament_entrance=false, print_from_key_opening=use_bridging);
    }
    if (show_vitamins) {
        for_all_connections() {
            translate([r_filament_detector, 0, dz_keyhole + dz_filament_detectors]) {
                rotate([0, ay_keyhole, 0])
                    rotate([0, 0, 90 + az_keyhole + az_lock_connection]) 
                        rotate([0, 90, 0]) {
                            medusa_filament_detecter_assembly();  
                        }
                
            }
        }
    }
    visualize(visualization_hub) {
        difference() {
            blank();
            cavity();
        }
    }
    
    if (show_vitamins) {
        for_all_connections() {
            translate([r_filament_detector, 0, dz_keyhole + dz_filament_detectors]) {
                // Show insertion as ghost
                color("Ivory", alpha=0.2) 
                    rotate([0, ay_keyhole, 0]) 
                        rotate([0, 0, 90 + az_keyhole]) 
                            rotate([0, 90, 0]) 
                                medusa_filament_detecter_assembly();                
            }
        }
    }    

}

 module generate_manifold(manifold) {
     function r(i) = manifold[i][0];
     function d(i) = manifold[i][1];
     function z(i) = manifold[i][3];
     for (i = [1: len(manifold)-1]) {
         color_name = i == i_manifold_focus ? "Red" : PART_3;
         color(color_name) {
            hull() {
                translate([r(i-1), 0, z(i-1)]) can(d=d(i-1), h=0.1);
                translate([r(i), 0, z(i)]) can(d=d(i), h=0.1);
             } 
         }
     }
} 

module pipes() {
    module blank() {
        for_all_connections() {
            generate_manifold(manifold_outer);
        }
         if (use_central_pipe) {
            can(d = d_outer, h =  z_convergence, center=ABOVE);   
         } 
    }
    module cavity() {
        for_all_connections() {
            generate_manifold(manifold_inner);
        }  
        if (use_central_pipe) {
            can(d = d_filament_with_clearance, h =  z_convergence, center=ABOVE); 
        }
    }
    visualize(visualization_pipes) {
        translate([0, 0, dz_pipes]) {
            difference() {
                blank();
                cavity();
            }
        }
    }
}

module outlet() {
    dz_outlet = h_manifold + dz_pipes + h_hub;
//    visualize(visualization_outlet) {
    translate([0, 0, dz_outlet]) {
        rotate([180, 0, 0]) {
            render(convexity = 10) difference() {
                can(d = d_cam_blank+4, h = h_hub, center=ABOVE);
                flute_keyhole(is_filament_entrance=false, print_from_key_opening=true);
            }
        }
    }
}
        
module medusa_filament_gateway() {
    difference() {
        union() {
            hub();
            pipes();
            outlet(); 
        }
        if (show_cross_section) {
            plane_clearance(LEFT);
        }
    }
}

medusa_filament_gateway();
            
