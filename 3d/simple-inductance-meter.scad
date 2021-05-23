$fn=36;

box();
*battery_holder();
*banana_spacer();
*rotary_sw_spacer();

module box() {
    pcb_size_x = 90;            //tamaño en x de la pcb
    pcb_size_y = 150;           //tamaño en y de la pcb
    pcb_tolerance = 0.5;        //tolerancia entre la pcb y la caja
    pcb_drill_distance = 3.25;  //distancia del centro el taladro de la pcb a la esquina
    box_bottom_size_factor = 1; //multiplicador de la base de la caja con respecto al tamaño de la pcb
    box_height = 30;            //altura exterior
    box_thickness = 1.5;        //grosor de la caja en paredes y base
    box_rabbet_xy = 0.75;       //rebaje del grosor de las paredes de la caja para encajar la pcb
    box_rabbet_z = 1.6;         //altura del rebaje de las paredes de la caja para encajar la pcb
    box_tower_drill = 1.25;     //radio del taladro de las torres
    box_tower_drill_h = 10;     //profundidad del taladro de las torres
    box_tower_height = 10;      //alto del cuerpo de las torres
    box_tower_trans_h = 20;     //alto de la transición hasta el cuerpo de las torres
    //variables calculadas
    box_size_bottom_x = pcb_size_x * box_bottom_size_factor;
    box_size_bottom_y = pcb_size_y * box_bottom_size_factor;
    box_size_top_x = pcb_size_x + (pcb_tolerance * 2) + ((box_thickness - box_rabbet_xy) * 2);
    box_size_top_y = pcb_size_y + (pcb_tolerance * 2) + ((box_thickness - box_rabbet_xy) * 2);
    translate_bottom_x = (box_size_top_x - box_size_bottom_x) / 2;
    translate_bottom_y = (box_size_top_y - box_size_bottom_y) / 2;
    box_tower_rad = pcb_drill_distance + pcb_tolerance + box_thickness - box_rabbet_xy;
    battery_pos_x = box_size_top_x / 3 * 2;
    battery_pos_y = box_size_top_y / 8 * 6.5;
    //pcb
    *union() {
        translate([box_thickness - box_rabbet_xy + pcb_tolerance, box_thickness - box_rabbet_xy + pcb_tolerance, box_height - box_rabbet_z]) pcb();
        translate([box_thickness - box_rabbet_xy + pcb_tolerance, box_thickness - box_rabbet_xy + pcb_tolerance, box_height - box_rabbet_z]) translate([15.775, 15.775, -1.4]) banana_spacer();
        translate([box_thickness - box_rabbet_xy + pcb_tolerance, box_thickness - box_rabbet_xy + pcb_tolerance, box_height - box_rabbet_z]) translate([55.175, 15.775, -1.4]) banana_spacer();
        translate([box_thickness - box_rabbet_xy + pcb_tolerance, box_thickness - box_rabbet_xy + pcb_tolerance, box_height - box_rabbet_z]) translate([54.5, 51.883, -4.5]) rotary_sw_spacer();
    }
    //caja
    difference() {
        union() {
            hull() {
                translate([translate_bottom_x, translate_bottom_y, 0]) cube([box_size_bottom_x, box_size_bottom_y, 0.1]);
                translate([0, 0, box_height - 0.1]) cube([box_size_top_x, box_size_top_y, 0.1]);
            }
        }
        union() {
            difference() {
            //hueco interior
                hull() {
                    translate([translate_bottom_x + box_thickness, translate_bottom_y + box_thickness, box_thickness]) cube([box_size_bottom_x - (box_thickness * 2), box_size_bottom_y - (box_thickness * 2), 0.1]);
                    translate([box_thickness, box_thickness, box_height - 0.1 + box_thickness]) cube([box_size_top_x - (box_thickness * 2), box_size_top_y - (box_thickness * 2), 0.1]);
                }
                union() {
                    //torres
                    union() {
                        hull() {
                            translate([box_tower_rad, box_tower_rad, box_height - box_rabbet_z - box_tower_height]) cylinder(r = box_tower_rad, h = box_tower_height);
                            translate([0, 0, box_height - box_rabbet_z - box_tower_height - box_tower_trans_h]) cylinder(r = box_thickness / 2, h = box_tower_trans_h + box_tower_height);
                        }
                        hull() {
                            translate([box_size_top_x - box_tower_rad, box_tower_rad, box_height - box_rabbet_z - box_tower_height]) cylinder(r = box_tower_rad, h = box_tower_height);
                            translate([box_size_top_x, 0, box_height - box_rabbet_z - box_tower_height - box_tower_trans_h]) cylinder(r = box_thickness / 2, h = box_tower_trans_h + box_tower_height);
                        }
                        hull() {
                            translate([box_size_top_x - box_tower_rad, box_size_top_y - box_tower_rad, box_height - box_rabbet_z - box_tower_height]) cylinder(r = box_tower_rad, h = box_tower_height);
                            translate([box_size_top_x, box_size_top_y, box_height - box_rabbet_z - box_tower_height - box_tower_trans_h]) cylinder(r = box_thickness / 2, h = box_tower_trans_h + box_tower_height);
                        }
                        hull() {
                            translate([box_tower_rad, box_size_top_y - box_tower_rad, box_height - box_rabbet_z - box_tower_height]) cylinder(r = box_tower_rad, h = box_tower_height);
                            translate([0, box_size_top_y, box_height - box_rabbet_z - box_tower_height - box_tower_trans_h]) cylinder(r = box_thickness / 2, h = box_tower_trans_h + box_tower_height);
                        }
                    }
                }
            }
            //rebaje pcb
            translate([box_thickness - box_rabbet_xy, box_thickness - box_rabbet_xy, box_height - box_rabbet_z]) cube([box_size_top_x - (box_rabbet_xy * 2), box_size_top_y - (box_rabbet_xy * 2) ,box_rabbet_z + 1]);
            //taladros torres
            translate([box_tower_rad, box_tower_rad, box_height - box_rabbet_z - box_tower_drill_h]) cylinder(r = box_tower_drill, h = box_tower_drill_h + 1);
            translate([box_size_top_x - box_tower_rad, box_tower_rad, box_height - box_rabbet_z - box_tower_drill_h]) cylinder(r = box_tower_drill, h = box_tower_drill_h + 1);
            translate([box_size_top_x - box_tower_rad, box_size_top_y - box_tower_rad, box_height - box_rabbet_z - box_tower_drill_h]) cylinder(r = box_tower_drill, h = box_tower_drill_h + 1);
            translate([box_tower_rad, box_size_top_y - box_tower_rad, box_height - box_rabbet_z - box_tower_drill_h]) cylinder(r = box_tower_drill, h = box_tower_drill_h + 1);
        }
    }
    //portabaterias
    translate([battery_pos_x, battery_pos_y, 0]) rotate([0, 0, 180]) translate([-(48.5 / 2), -(36.1 / 2), 0]) battery_holder();
}

module pcb() {
    difference() {
        color("forestgreen") cube([90, 150, 1.6]);
        translate([0, 0, -1]) union() {
            translate([3, 3, 0]) cylinder(r = 1.5, h = 3);
            translate([87, 3, 0]) cylinder(r = 1.5, h = 3);
            translate([3, 147, 0]) cylinder(r = 1.5, h = 3);
            translate([87, 147, 0]) cylinder(r = 1.5, h = 3);
            translate([15.775, 15.775, 0]) cylinder(r = 5, h = 3);
            translate([34.825, 15.775, 0]) cylinder(r = 5, h = 3);
            translate([55.175, 15.775, 0]) cylinder(r = 5, h = 3);
            translate([74.225, 15.775, 0]) cylinder(r = 5, h = 3);
            translate([54.5, 51.883, 0]) cylinder(r = 4.5, h = 3);
            translate([43.84, 58.038, 0]) cylinder(r = 1.5, h = 3);
        }
        *translate([-1, 98, -1]) cube([92, 53, 3]);
    }
}

module battery_holder() {
    difference() {
        union() {
            translate([0, 3.5, 0]) hull() {
                translate([1.5, 1.5, 0]) cylinder(r = 1.5, h = 16.5);
                translate([1.5, 27.6, 0]) cylinder(r = 1.5, h = 16.5);
                translate([47.5, 0, 0]) cube([1, 29.1, 1]);
                translate([45.5, 0, 13.5]) rotate([-90, 0, 0]) cylinder(r = 3, h = 29.1);
            }
            translate([12.5, 0, 0]) hull() {
                translate([0, 1.5, 0]) cylinder(r = 1.5, h = 16.5);
                translate([5, 1.5, 0]) cylinder(r = 1.5, h = 16.5);
                translate([0, 34.6, 0]) cylinder(r = 1.5, h = 16.5);
                translate([5, 34.6, 0]) cylinder(r = 1.5, h = 16.5);
            }
            translate([31.5, 0, 0]) hull() {
                translate([0, 1.5, 0]) cylinder(r = 1.5, h = 16.5);
                translate([5, 1.5, 0]) cylinder(r = 1.5, h = 16.5);
                translate([0, 34.6, 0]) cylinder(r = 1.5, h = 16.5);
                translate([5, 34.6, 0]) cylinder(r = 1.5, h = 16.5);
            }
            translate([12.75, 3, 0]) cube([4.5, 6, 22.5]);
            translate([12.75, 27.1, 0]) cube([4.5, 6, 22.5]);
            translate([31.75, 3, 0]) cube([4.5, 6, 22.5]);
            translate([31.75, 27.1, 0]) cube([4.5, 6, 22.5]);
        }
        union() {
            difference() {
                union() {
                    translate([1.5, 5, 1.5]) cube([45.5, 26.1, 16]);
                    translate([1.5, 5, 5]) cube([48, 26.1, 12]);
                    translate([12.5, 1.5, 1.5]) cube([5, 33.1, 22]);
                    translate([31.5, 1.5, 1.5]) cube([5, 33.1, 22]);
                }
                union() {
                    translate([13, 3.5, 0]) cube([4, 1.5, 22.2]);
                    translate([13, 3.5, 17]) hull() {
                        cube([4, 5, 1.5]);
                        cube([4, 1.5, 5.2]);
                    }
                    translate([13, 27.6 + 3.5, 0]) cube([4, 1.5, 22.2]);
                    translate([13, 27.6, 17]) hull() {
                        cube([4, 5, 1.5]);
                        translate([0, 3.5, 0]) cube([4, 1.5, 5.2]);
                    }
                    translate([32, 3.5, 0]) cube([4, 1.5, 22.2]);
                    translate([32, 3.5, 17]) hull() {
                        cube([4, 5, 1.5]);
                        cube([4, 1.5, 5.2]);
                    }
                    translate([32, 27.6 + 3.5, 0]) cube([4, 1.5, 22.2]);
                    translate([32, 27.6, 17]) hull() {
                        cube([4, 5, 1.5]);
                        translate([0, 3.5, 0]) cube([4, 1.5, 5.2]);
                    }
                }
            }
        }
    }
}

module banana_spacer() {
    difference() {
        union() {
            cylinder(r = 4.9, h = 2.4);
            translate([25.4 * 0.75, 0, 0]) cylinder(r = 4.9, h = 2.4);
            hull() {
                cylinder(r = 5.5, h = 1.4);
                translate([25.4 * 0.75, 0, 0]) cylinder(r = 5.5, h = 1.4);
            }
        }
        union() {
            translate([0, 0, -1]) intersection() {
                cylinder(r = 4.1, h = 5);
                translate([-4.1, -3.1, 0]) cube([8.2, 6.2, 5]);
            }
            translate([25.4 * 0.75, 0, -1]) intersection() {
                cylinder(r = 4.1, h = 5);
                translate([-4.1, -3.1, 0]) cube([8.2, 6.2, 5]);
            }
        }
    }
}

module rotary_sw_spacer() {
    difference() {
        union() {
            cylinder(r = 15, h = 4.5);
            translate([-10.91, 5.905, 0]) cylinder(r = 1.35, h = 6);
        }
        union() {
            translate([0, 0, -1]) cylinder(r = 4.6, h = 6);
            translate([0, 0, -1]) cylinder(r = 5.6, h = 2);
            translate([-10.91, 5.905, -1]) cylinder(r = 1.5, h = 4.5);
        }
    }
}