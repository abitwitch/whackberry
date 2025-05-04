include <./modules/roundedcube.scad>

//Note objects are anchored to the bottom right corner

//Vars
global_thickness=0.2;
global_nudge=0.01; //used as a tiny push to prevent two shapes from overlapping in digital rendering
outer_height=13;
outer_width=11;
outer_depth=2;
outer_rounding=0.5;
keyboard_height=4;
keyboard_width=7;
keyboard_offset=[outer_width-keyboard_width-0.5,0,0.5];
keyboard_rounding=0.5;
mouse_nav_height=1;
mouse_nav_width=1;
mouse_nav_offset=[1.5,0,3];
mouse_nav_rounding=0.1;
mouse_left_height=0.5;
mouse_left_width=0.5;
mouse_left_offset=[2.1,0,2.3];
mouse_left_rounding=0.1;
mouse_right_height=mouse_left_height;
mouse_right_width=mouse_left_width;
mouse_right_offset=[1.2,0,2.3];
mouse_right_rounding=mouse_left_rounding;
display_height=6;
display_width=10;
display_offset=[0.5,0,6];
display_rounding=0.5;



//outer shape
difference () {
    //main shell
    roundedcube([outer_width, outer_depth, outer_height], false, outer_rounding, "ymax");
    translate([global_thickness/2,-global_nudge,global_thickness/2]) 
    roundedcube([outer_width-global_thickness, outer_depth-global_thickness, outer_height-global_thickness], false, outer_rounding, "ymax");
    //Keyboard hole
    translate(keyboard_offset) 
    roundedcube([keyboard_width, outer_depth*2, keyboard_height], false, keyboard_rounding, "ymax");
    //Mouse nav hole
    translate(mouse_nav_offset) 
    roundedcube([mouse_nav_width, outer_depth*2, mouse_nav_height], false, mouse_nav_rounding, "ymax");
    //Mouse left button hole
    translate(mouse_left_offset) 
    roundedcube([mouse_left_width, outer_depth*2, mouse_left_height], false, mouse_left_rounding, "ymax");
    //Mouse right button hole
    translate(mouse_right_offset) 
    roundedcube([mouse_right_width, outer_depth*2, mouse_right_height], false, mouse_right_rounding, "ymax");
    //Display hole
    translate(display_offset) 
    roundedcube([display_width, outer_depth*2, display_height], false, display_rounding, "ymax");
}

    