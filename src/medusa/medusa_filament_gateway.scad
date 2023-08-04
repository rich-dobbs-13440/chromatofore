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
d_filament_with_clearance = 2;
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
// TODO:  Retrieve offset from filament detector file. 
dz_filament_detectors = -18; // [-20:0.5:-10]

/* [Printing] */
print_one_part = false;
part_to_print = "hub"; // [hub]

/* [Hub Design] */
r_hub = 15;
connector_count = 1; // [1:1:8]
az_keyhole = -70; // [-90:5:90]

/* [Manifold Design] */

h1 = 5;  
h2 = 20;  
h3 =2; 
h4 = 2;
h5 = 2;

d_outer = 5;
d_inner = 3;
d_outlet = 9;



module end_of_customization() {}

function filament_offset(z, z_t, path_offset) = 
    let(
        c_1 = 12*path_offset/z_t^3,
        c_2 = -c_1 * z_t/2)   
    c_1 * z ^ 3/ 6 - c_1 * z_t * z ^2 / 4 + path_offset;

h_manifold = h1 + h2 + h3 + h4;

z1 = 0;
z2 = h1;
z3 = z2 + h2;
z4 = z3 + h3;
z5 = z4 + h4;
z6 = z5 + h5;

z_total = z6;

r1 = filament_offset(z1,  z_total, r_hub);
r2 = filament_offset(z2,  z_total, r_hub);
r3 = filament_offset(z3,  z_total, r_hub);
r4 = filament_offset(z4,  z_total, r_hub);
r5 = filament_offset(z5, z_total, r_hub);
r6 = filament_offset(z6,  z_total, r_hub);

manifold_outer = [
    [r1, d_outer, h1, z1],
    [r2, d_outer, h2, z2],
    [r3, d_outlet, h3, z3],
    [r4, d_outlet , h4, z4],
    [r5, d_outlet, h5, z5],
    [r6, d_outlet, 0, z5],
];

manifold_inner = [
    [r1, d_inner, h1, z1],
    [r2, d_inner, h2, z2],
    [r3, d_inner, h3, z3],
    [r4, d_filament_with_clearance, h4, z4],
    [r5, d_filament_with_clearance, h5, z5],
    [r6, d_filament_with_clearance, 0, z6],
];


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

visualization_pipes  =        
    visualize_info(
        "Pipes", PART_3, show(pipes, "pipes") , layout, show_parts);  
        
visualization_outlet =         
    visualize_info(
        "Outlet", PART_4, show(outlet, "outlet") , layout, show_parts);  
        
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
 

module hub() {
    cam_wall = 2;
    cam = gtcc_cam(connector);
    d = 2 * (r_hub + cam.y + cam_wall);
    module blank() {
        can(d = d, h = h_hub, center=ABOVE);
    }
    
    module cavity() {
        for_all_connections() {
            translate([r_hub, 0, 0])             
                rotate([0, 0, az_keyhole])
                    flute_keyhole(is_filament_entrance=false, print_from_key_opening=true);
        } 
        flute_keyhole(is_filament_entrance=false, print_from_key_opening=true);
    }
    if (show_vitamins) {
        for_all_connections() {
            translate([r_hub, 0, dz_filament_detectors]) {
                rotate([0, 0, 90 + az_keyhole + az_lock_connection]) rotate([0, 90, 0]) medusa_filament_detecter();
                
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
            translate([r_hub, 0, dz_filament_detectors]) {
                // Show insertion as ghost
                color("Ivory", alpha=0.2) 
                    rotate([0, 0, 90 + az_keyhole]) rotate([0, 90, 0]) medusa_filament_detecter();                
            }
        }
    }    

}

 module generate_manifold(manifold) {
     function r(i) = manifold[i][0];
     function d(i) = manifold[i][1];
     function z(i) = manifold[i][3];
     render(convexity=10) difference() {
         for (i = [1: len(manifold)-1]) {
             render(convexity=10) {
                hull() {
                    translate([r(i-1), 0, z(i-1)]) can(d=d(i-1), h=0.1);
                    translate([r(i), 0, z(i)]) can(d=d(i), h=0.1);
                 }
             }
         }
     }
} 

module pipes() {
    module blank() {
        for_all_connections() {
            generate_manifold(manifold_outer);
        }
        can(d=d_outer, h =  h_manifold, center=ABOVE);    
    }
    module cavity() {
        for_all_connections() {
            generate_manifold(manifold_inner);
        }  
        can(d=d_filament_with_clearance, h =  h_manifold, center=ABOVE); 
    }
    visualize(visualization_pipes) {
        translate([0, 0, h_hub]) {
            render(convexity=10) difference() {
                blank();
                cavity();
            }
        }
    }
}

module outlet() {
    dz_outlet = h_hub + h_manifold;
    visualize(visualization_outlet) {
        translate([0, 0, dz_outlet]) rotate([180, 0, 0]) {
            render(convexity = 10) difference() {
                translate([0, 0, -clamp_extent.z]) flute_collet();
                plane_clearance(ABOVE);
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
            
