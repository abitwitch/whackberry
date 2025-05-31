include <./roundedcube.scad>
global_thickness=0.5;
cable_hook_width=5;
cable_hook_strut_length=8;
cable_hook_saddle_length=4;
cable_hook_rounding=0.2;

roundedcube([cable_hook_width, global_thickness, cable_hook_strut_length], false, cable_hook_rounding, "zmax");
translate([0,0,cable_hook_strut_length-global_thickness])
roundedcube([cable_hook_width, cable_hook_saddle_length, global_thickness], false, cable_hook_rounding, "all");


