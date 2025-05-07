include <./modules/roundedcube.scad>
include <./modules/slider.scad>
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
keyboard_bump_rounding=0.1;
keyboard_bump_height=1;
keyboard_bump_width=0.5+outer_rounding+keyboard_bump_rounding;
keyboard_bump_depth=outer_depth;
keyboard_bump_offset=[outer_width-outer_rounding-keyboard_bump_rounding,0,3];
keyboard_bump_hollow_offset=[keyboard_bump_offset[0]+global_thickness,keyboard_bump_offset[1]-global_nudge,keyboard_bump_offset[2]+global_thickness];
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
display_bump_rounding=0.1;
display_bump_height=1.5;
display_bump_width=0.5+outer_rounding+display_bump_rounding;
display_bump_depth=outer_depth;
display_bump_offset=[-display_bump_width+outer_rounding+display_bump_rounding,0,10];
display_bump_hollow_offset=[display_bump_offset[0]+global_thickness,display_bump_offset[1]-global_nudge,display_bump_offset[2]+global_thickness];
usbc_bump_rounding=0.1;
usbc_bump_height=4.5;
usbc_bump_width=0.25+outer_rounding+usbc_bump_rounding;
usbc_bump_depth=outer_depth;
usbc_bump_offset=[outer_width-outer_rounding-usbc_bump_rounding,0,7.5];
usbc_bump_hollow_offset=[usbc_bump_offset[0]+(global_thickness*0),usbc_bump_offset[1]-global_nudge,usbc_bump_offset[2]+global_thickness]; //(global_thickness*0) to make is 2x thickness



//outer shape
difference () {
    union () {
    //main shell
    roundedcube([outer_width, outer_depth, outer_height], false, outer_rounding, "ymax");
    //keyboard_bump
    translate(keyboard_bump_offset)
    roundedcube([keyboard_bump_width, outer_depth, keyboard_bump_height], false, keyboard_bump_rounding, "ymax");
    //display bump
    translate(display_bump_offset)
    roundedcube([display_bump_width, outer_depth, display_bump_height], false, display_bump_rounding, "ymax");
    //usbc bump
    translate(usbc_bump_offset)
    roundedcube([usbc_bump_width, outer_depth, usbc_bump_height], false, usbc_bump_rounding, "ymax");
    }
    //main shell hollow
    translate([global_thickness,-global_nudge,global_thickness]) 
    roundedcube([outer_width-(global_thickness*2), outer_depth-global_thickness, outer_height-(global_thickness*2)], false, outer_rounding, "ymax");
    //keyboard bump hollow
    translate(keyboard_bump_hollow_offset)
    roundedcube([keyboard_bump_width-(global_thickness*2), outer_depth-(2*global_thickness), keyboard_bump_height-(2*global_thickness)], false, keyboard_bump_rounding, "ymax");
    //display bump hollow
    translate(display_bump_hollow_offset)
    roundedcube([display_bump_width-(global_thickness*2), outer_depth-(2*global_thickness), display_bump_height-(2*global_thickness)], false, display_bump_rounding, "ymax");
    //usbc bump hollow
    translate(usbc_bump_hollow_offset)
    roundedcube([usbc_bump_width-(global_thickness*2), outer_depth-(2*global_thickness), usbc_bump_height-(2*global_thickness)], false, usbc_bump_rounding, "ymax");
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

    