// This is for a Creality CR 6 SE!

// Which screws are the original ones???


include <lib/logging.scad>
include <lib/centerable.scad>
use <lib/shapes.scad>
use <lib/not_included_batteries.scad>
include <nutsnbolts-master/cyl_head_bolt.scad>

/* [Show] */

show_adapter = true;
show_original_screws = true;

show_relocated_runout_detector = false;
show_runout_detector_original = true;
show_screws=true;
show_filament_guide = true;
testing = false;
z_testing_connector = 20; // [0:0.5:20]
z_testing_plate = 10; // [0:0.5:10]

end_of_customization() {}

a_lot = 100;

runout_detector = [40, 31.12, 17.75];

dimmer_switch = [35.62, 40.12, 20];

plate = [runout_detector.x, dimmer_switch.y, 6];

connector = [10, 10, runout_detector.z];

tapped_screw_location = [-5.34, 4.22, 0];


   

    
screw_offset_1 =  [5.34, 27.06, runout_detector.z];
screw_offset_2 = [-24.94, 4.22, runout_detector.z];
echo("screw_offset_2", screw_offset_2);

//original_screw_offsets = [
//    screw_offset_1,
//    screw_offset_2
//];


module original_screws() {
    color("black") translate(screw_offset_1) screw("M4x20");
    color("green") translate(screw_offset_2) screw("M4x20");    
}

if (show_original_screws) {
    original_screws();
}

if (show_runout_detector_original) {
    color("magenta") translate([10, 0, 0]) block(runout_detector, center= ABOVE+RIGHT+BEHIND);
}

module M3(length, as_clearance = false, inset=false) {
    screw_family = "M3";
    inset_translation = inset ? [0, 0, -3.5] : [0, 0, 0];
    if (as_clearance) {
        translate([0, 0, 10]) hole_through(screw_family, $fn=12);
        z_clearance = 25;
        if (inset) {
            translate([0, 0, z_clearance] + inset_translation) hole_through(screw_family, h=z_clearance, $fn=12);
        }
    } else {
        color("SteelBlue") translate(inset_translation) screw(str(screw_family, "x", length));
    }    
}


module runout_detector_screws(z) {
    translate([5.34, 26.06+1, z]) children();
    translate([33.62 + 1, 4.22, z]) children();   
}


module relocated_runout_detector(show_screws=false) {
    color("blue") {
        difference() { 
            block(runout_detector, center=ABOVE+FRONT+RIGHT);
            runout_detector_screws(runout_detector.z) M3(as_clearance=true);
        }
    }
    if (show_screws) {
        runout_detector_screws(runout_detector.z) M3(20);
    }
}

if (show_relocated_runout_detector) {
    relocated_runout_detector();
}


module dimmer_screws(z) {
    translate([5.84, 34.46, z]) children();
    translate([25.71, 34.46, z]) children();    
}


module dimmer() {
    color("green") {
        base = [dimmer_switch.x, dimmer_switch.y, 0.90];
        body = [dimmer_switch.x, 31.06, dimmer_switch.z]; //dimmer_switch - [0, 10.34, 0]
        difference() { 
            union() {
                block(body, center=ABOVE+FRONT+RIGHT);
                block(base, center=ABOVE+FRONT+RIGHT);
            }
            dimmer_screws(dimmer_switch.z) M3(as_clearance=true);
        }
    }

}


module plate(show_screws=false) {
    color("orange") {  
        //runout_detector_holes(plate.z);
        difference() { 
            block(plate, center=BELOW+FRONT+RIGHT);
            runout_detector_screws(-plate.z) mirror([0, 0, 1]) M3(as_clearance=true, inset=true);
            dimmer_screws(plate.z) M3(as_clearance=true);
            translate([33.62 + 1, 34.46, -plate.z]) mirror([0, 0, 1])  M3(as_clearance=true, inset=true);
        }
    }
    if (show_screws) {
        runout_detector_screws(-plate.z) mirror([0, 0, 1]) M3(25, inset=true);
    }        

}

module connector_screws(z) {
    translate([-5.34, 4.22, z]) children();
    //translate([-5.34,26.06, z]) children();
}

module connector() {
    color("pink") {
        difference() {
            union() {
                block(connector, center=BEHIND+ABOVE+RIGHT);
                block([connector.x, connector.y, plate.z], center=BEHIND+BELOW+RIGHT);
            }
            connector_screws(-plate.z) mirror([0, 0, 1]) M3(as_clearance=true, inset=true);
        }
    }
}



//runout_detector();
//translate([0, 0, runout_detector.z+plate.z]) dimmer();
module adapter() {
    plate(show_screws);
    connector();
}


if (show_adapter) {
    if (testing) {
        difference() {
            adapter();
            translate([0, 0, z_testing_connector]) plane_clearance(ABOVE);
            translate([0, 0, -z_testing_plate]) plane_clearance(BELOW);
        }    
    } else {
        adapter();
    }
}

// 20, 11



if (show_filament_guide) {
    z = testing ? 0.5 : 20;
    x_gap = 18;
    dx = 9.68;
    echo("dx: ", dx);
    guide_plate = [runout_detector.x, runout_detector.y, z];
    extension =  [runout_detector.x + x_gap, 10, z];
    entrance_plate = [2, 15, z];
    for_test = true;
    dz = for_test ? 0 : runout_detector.z;
    difference() {
        translate([dx, 0, dz]) {
            block(guide_plate, center=BELOW+BEHIND+RIGHT);
            translate([0, runout_detector.y, 0]) block(extension, center=BELOW+BEHIND+LEFT);
            translate([-runout_detector.x-x_gap, runout_detector.y, 0])block(entrance_plate, center=BELOW+FRONT+LEFT);
        }
        original_screws();
        if (testing) {
            translate([-19, 20, 0]) plane_clearance(FRONT+LEFT);
           
        }
    }
}







module nuts_demo() {

    translate([0, 50, 0]) nut("M3");

    translate([10, 50, 0]) screw("M3x25");


    translate([20, 50, 0]) hole_through("M3");

    translate([20, 50 + 10, 0]) hole_through("M3", h=5);
    translate([20, 50 + 10, 0]) hole_through("M3", cld=0.4);

    translate([30, 50, 0]) nutcatch_parallel("M3");

    translate([40, 50, 0]) nutcatch_parallel("M3", clh=10);

    translate([40, 50, 0]) nutcatch_parallel("M3", clk=0.5);

    translate([70, 50, 0]) nutcatch_sidecut("M3");
    
}



//color("violet") connector_screws();

//connector_holes();
//connector();


//translate([50, 0, 0]) nutcatch_parallel("M3", clh=25);