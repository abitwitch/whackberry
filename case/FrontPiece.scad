include <./modules/roundedcube.scad>


//Vars
outer_height=15;
outer_width=11;
outer_depth=2;
outer_rounding=0.5;
global_thickness=0.2;
global_nudge=0.01;

//outer shape
difference () {
    roundedcube([outer_width, outer_depth, outer_height], false, outer_rounding, "ymax");
    translate([global_thickness/2,-global_nudge,global_thickness/2]) 
    roundedcube([outer_width-global_thickness, outer_depth-global_thickness, outer_height-global_thickness], false, outer_rounding, "ymax");
    //cube ([8,8,8], center = true);
}