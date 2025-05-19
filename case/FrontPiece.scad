include <./modules/roundedcube.scad>
include <./modules/slider.scad>
include <./modules/screwhole.scad>
include <./modules/holepeg.scad>
//Note objects are anchored to the bottom right corner

//Vars
global_thickness=0.2;
global_nudge=0.01; //used as a tiny push to prevent two shapes from overlapping in digital rendering
global_pcb_thickness=0.2;
outer_upper_height=8;
outer_upper_width=11;
outer_upper_depth=2;
outer_upper_rounding=0.25;
outer_lower_height=5;
outer_lower_width=outer_upper_width;
outer_lower_depth=1;
outer_lower_rounding=outer_upper_rounding;
keyboard_height=4;
keyboard_width=7;
keyboard_offset=[outer_lower_width-keyboard_width-0.5,0,0.5];
keyboard_rounding=0.5;
keyboard_bump_rounding=0.1;
keyboard_bump_height=1;
keyboard_bump_width=0.5+outer_lower_rounding+keyboard_bump_rounding;
keyboard_bump_depth=outer_lower_depth;
keyboard_bump_offset=[outer_lower_width-outer_lower_rounding-keyboard_bump_rounding,0,3];
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
//display_rounding=0.1;
display_bump_rounding=0.1;
display_bump_height=1.5;
display_bump_width=0.5+outer_upper_rounding+display_bump_rounding;
display_bump_depth=outer_upper_depth;
display_bump_offset=[-display_bump_width+outer_upper_rounding+display_bump_rounding,0,10];
display_bump_hollow_offset=[display_bump_offset[0]+global_thickness,display_bump_offset[1]-global_nudge,display_bump_offset[2]+global_thickness];
usbc_bump_rounding=0.1;
usbc_bump_height=4.5;
usbc_bump_width=0.25+outer_upper_rounding+usbc_bump_rounding;
usbc_bump_depth=outer_upper_depth;
usbc_bump_offset=[outer_upper_width-outer_upper_rounding-usbc_bump_rounding,0,7.5];
usbc_bump_hollow_offset=[usbc_bump_offset[0]+(global_thickness*0),usbc_bump_offset[1]-global_nudge,usbc_bump_offset[2]+global_thickness]; //(global_thickness*0) to make is 2x thickness
slider_panel_width=2;
slider_panel_depth=0.4;
slider_panel_height=2;
slider_track_width=0.5;
slider_offset=[outer_upper_width,-(slider_panel_width+(2*slider_track_width))/2,usbc_bump_offset[2]+global_thickness];
screwhole_radius=0.22/2;
screwhole_support_radius=screwhole_radius+global_thickness;
screwhole_nudge=global_nudge;
screwhole_offsets=[ //lateral offsets are to center of screwholes
  [0.5,0,0.5],
  [1.5,0,12.5],
  [9.5,0,12.5],
  [9.5,0,5.5],
];
//holepeg_support_height=outer_upper_depth; //TODO make dependant on location
holepeg_peg_height=global_pcb_thickness;
holepeg_peg_radius=0.1;
holepeg_support_radius=0.2;
holepeg_offsets=[ //lateral offsets are to center of screwholes
  [3,0,0.5],
  [4.5,0,12.5],
  [4.2,0,5.5],
  [7.5,0,5.5],
];

//slider
translate(slider_offset)
rotate(90,[0,0,1])
slider(slider_panel_width,slider_panel_depth,slider_panel_height,slider_track_width);

//front piece
translate([50,0,0]) //comment out line
color("yellow")
difference () {
    union () {
      //main shell upper shelf
      translate([0,0,outer_lower_height])
      roundedcube([outer_upper_width, outer_upper_depth, outer_upper_height], false, outer_upper_rounding, "y");
      //main shell lower shelf
      roundedcube([outer_lower_width, outer_lower_depth, outer_lower_height], false, outer_lower_rounding, "y"); 
      //main shell upper lower rounded corner bridge
      translate([0,0,outer_lower_height-outer_lower_rounding])
      cube([outer_lower_width, outer_lower_depth, outer_upper_rounding+outer_lower_rounding],false);
      //keyboard_bump
      translate(keyboard_bump_offset)
      roundedcube([keyboard_bump_width, outer_lower_depth, keyboard_bump_height], false, keyboard_bump_rounding, "ymax");
      //display bump
      translate(display_bump_offset)
      roundedcube([display_bump_width, outer_upper_depth, display_bump_height], false, display_bump_rounding, "ymax");
      //usbc bump
      translate(usbc_bump_offset)
      roundedcube([usbc_bump_width, outer_upper_depth, usbc_bump_height], false, usbc_bump_rounding, "ymax");
    }
    //main shell upper shelf hollow
    translate([0,0,outer_lower_height])
    translate([global_thickness,-global_nudge,global_thickness]) 
    roundedcube([outer_upper_width-(global_thickness*2), outer_upper_depth-global_thickness, outer_upper_height-(global_thickness*2)], false, outer_upper_rounding, "y");
    //main shell lower shelf hollow
    translate([global_thickness,-global_nudge,global_thickness]) 
    roundedcube([outer_lower_width-(global_thickness*2), outer_lower_depth-global_thickness, outer_lower_height-(global_thickness*2)], false, outer_lower_rounding, "y");
    //main shell upper lower rounded corner bridge hollow
    translate([0,0,outer_lower_height-(2*outer_lower_rounding)])
    translate([global_thickness,-global_nudge,0]) 
    cube([outer_lower_width-(global_thickness*2), outer_lower_depth-global_thickness, 2*(outer_upper_rounding+outer_lower_rounding)],false);
    //keyboard bump hollow
    translate(keyboard_bump_hollow_offset)
    translate([-global_thickness,0,0])
    roundedcube([keyboard_bump_width-global_thickness, outer_lower_depth-(global_thickness), keyboard_bump_height-(2*global_thickness)], false, keyboard_bump_rounding, "ymax");
    //display bump hollow
    translate(display_bump_hollow_offset)
    roundedcube([display_bump_width-(global_thickness)+global_nudge, outer_upper_depth-(global_thickness), display_bump_height-(2*global_thickness)], false, display_bump_rounding, "ymax");
    //usbc bump hollow
    translate(usbc_bump_hollow_offset)
    roundedcube([usbc_bump_width-(global_thickness), outer_upper_depth-(global_thickness), usbc_bump_height-(2*global_thickness)], false, usbc_bump_rounding, "ymax");
    //Keyboard hole
    translate(keyboard_offset) 
    roundedcube([keyboard_width, outer_lower_depth*2, keyboard_height], false, keyboard_rounding, "y");
    //Mouse nav hole
    translate(mouse_nav_offset) 
    roundedcube([mouse_nav_width, outer_lower_depth*2, mouse_nav_height], false, mouse_nav_rounding, "y");
    //Mouse left button hole
    translate(mouse_left_offset) 
    roundedcube([mouse_left_width, outer_lower_depth*2, mouse_left_height], false, mouse_left_rounding, "y");
    //Mouse right button hole
    translate(mouse_right_offset) 
    roundedcube([mouse_right_width, outer_lower_depth*2, mouse_right_height], false, mouse_right_rounding, "y");
    //Display hole
    translate(display_offset) 
    cube([display_width, outer_upper_depth*2, display_height], false);
    //TODO add slider
}

//front screwholes
color("red")
for (i = [ 0 : len(screwhole_offsets)-1 ]) {
  if (holepeg_offsets[i][2]<outer_lower_height) {
    screwhole_support_height=outer_lower_depth;
    screwhole_height=screwhole_support_height-(global_thickness);
    translate(screwhole_offsets[i])
    screwhole(screwhole_support_height-global_nudge, screwhole_height, screwhole_support_radius, screwhole_radius, screwhole_nudge);
  } else {
    screwhole_support_height=outer_upper_depth;
    screwhole_height=screwhole_support_height-(global_thickness*4);
    translate(screwhole_offsets[i])
    screwhole(screwhole_support_height-global_nudge, screwhole_height, screwhole_support_radius, screwhole_radius, screwhole_nudge);
  }
}
//front holepegs
color("orange")
for (i = [ 0 : len(holepeg_offsets)-1 ]) {
  if (holepeg_offsets[i][2]<outer_lower_height) {
    holepeg_support_height=outer_lower_depth;
    translate(holepeg_offsets[i])
    translate([0,-holepeg_peg_height,0])
    holepeg(holepeg_support_height, holepeg_peg_height, holepeg_support_radius, holepeg_peg_radius);
  } else {
    holepeg_support_height=outer_upper_depth;
    translate(holepeg_offsets[i])
    translate([0,-holepeg_peg_height,0])
    holepeg(holepeg_support_height, holepeg_peg_height, holepeg_support_radius, holepeg_peg_radius);
  }
}






outer_rear_depth=2;

//back piece
color("green")
rotate([0,0,180])
translate([-outer_upper_width,0,0])
difference () {
    union () {
      //main shell
      roundedcube([outer_upper_width, outer_rear_depth, outer_upper_height+outer_lower_height], false, outer_upper_rounding, "y");
      //keyboard_bump
      translate(keyboard_bump_offset)
      roundedcube([keyboard_bump_width, outer_lower_depth, keyboard_bump_height], false, keyboard_bump_rounding, "ymax");
      //display bump
      translate(display_bump_offset)
      roundedcube([display_bump_width, outer_upper_depth, display_bump_height], false, display_bump_rounding, "ymax");
      //usbc bump
      translate(usbc_bump_offset)
      roundedcube([usbc_bump_width, outer_upper_depth, usbc_bump_height], false, usbc_bump_rounding, "ymax");
    }
    //main shell shelf hollow
    translate([global_thickness,-global_nudge,global_thickness]) 
    roundedcube([outer_lower_width-(global_thickness*2), outer_rear_depth-global_thickness, outer_upper_height+outer_lower_height-(global_thickness*2)], false, outer_lower_rounding, "y");
    //main shell upper lower rounded corner bridge hollow
    translate([0,0,outer_lower_height-(2*outer_lower_rounding)])
    translate([global_thickness,-global_nudge,0]) 
    cube([outer_lower_width-(global_thickness*2), outer_lower_depth-global_thickness, 2*(outer_upper_rounding+outer_lower_rounding)],false);
    //keyboard bump hollow
    translate(keyboard_bump_hollow_offset)
    translate([-global_thickness,0,0])
    roundedcube([keyboard_bump_width-global_thickness, outer_lower_depth-(global_thickness), keyboard_bump_height-(2*global_thickness)], false, keyboard_bump_rounding, "ymax");
    //display bump hollow
    translate(display_bump_hollow_offset)
    roundedcube([display_bump_width-(global_thickness)+global_nudge, outer_upper_depth-(global_thickness), display_bump_height-(2*global_thickness)], false, display_bump_rounding, "ymax");
    //usbc bump hollow
    translate(usbc_bump_hollow_offset)
    roundedcube([usbc_bump_width-(global_thickness), outer_upper_depth-(global_thickness), usbc_bump_height-(2*global_thickness)], false, usbc_bump_rounding, "ymax");
    //TODO move the bumps on the back
    //TODO add slider 
}

