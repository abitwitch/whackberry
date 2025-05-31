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
outer_rear_depth=2;
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
keyboard_support_front_width=0.1;
keyboard_support_front_depth=outer_lower_depth+outer_rear_depth-global_thickness;
keyboard_support_front_height=1;
keyboard_support_front_rounding=0.05;
keyboard_support_front_offset=[3,outer_lower_depth-keyboard_support_front_depth,1];
keyboard_support_rear_width=keyboard_support_front_width;
keyboard_support_rear_depth=keyboard_support_front_depth;
keyboard_support_rear_height=keyboard_support_front_height;
keyboard_support_rear_rounding=keyboard_support_front_rounding;
keyboard_support_rear_offset=[3,outer_lower_depth-keyboard_support_front_depth-global_thickness,3.5];
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
slider_hollow_growth_factor=1.10;
slider_hollow_y_offset=-(((slider_panel_width*slider_hollow_growth_factor)+(2*slider_track_width*slider_hollow_growth_factor))-(slider_panel_width+(2*slider_track_width)))/2;
screwhole_radius=0.22/2;
screwhole_support_radius=screwhole_radius+global_thickness;
screwhole_nudge=global_nudge;
screwhole_offsets=[ //lateral offsets are to center of screwholes
  [0.5,0,0.5],
  [1.5,0,12.5],
  [9.5,0,12.5],
  [9.5,0,5.5],
];
//holepeg_support_height=outer_upper_depth;
holepeg_peg_height=global_pcb_thickness;
holepeg_peg_radius=0.1;
holepeg_support_radius=0.2;
holepeg_offsets=[ //lateral offsets are to center of screwholes
  [3,0,0.5],
  [4.5,0,12.5],
  [4.2,0,5.5],
  [7.5,0,5.5],
];
holepeg_rear_offsets=[ //lateral offsets are to center of screwholes
  [7,0,12.5],
  [1,0,5.5],
];
screwhole_counterbore_radius=0.3;
screwhole_counterbore_radius_primary=0.25;
pqty_reset_button_hole_radius=0.15;
pqty_reset_button_hole_offset=[8.5,0,11];
sd_slot_offset=[5,0.5,outer_upper_height+outer_lower_height-global_thickness-global_nudge];
sd_slot_width=2;
sd_slot_depth=1;
cable_hook_strut_length=1.3;
cable_hook_saddle_length=1.5;
cable_hook_rounding=0.2;
lower_cable_hook_offset=[0,-2,0];
upper_cable_hook_offset=[-outer_rear_depth,11.7,0];
screwdriver_slot_radius=0.6;
screwdriver_slot_offset=[0,outer_rear_depth-screwdriver_slot_radius-global_thickness-global_nudge,3];

//slider
translate(slider_offset)
//translate([0,0,$t*slider_panel_height])
rotate(90,[0,0,1])
slider(slider_panel_width,slider_panel_depth,slider_panel_height,slider_track_width);

//front piece
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
    roundedcube([usbc_bump_width-(global_thickness), slider_panel_width/2, usbc_bump_height-(2*global_thickness)], false, usbc_bump_rounding, "ymax");
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
    //slider - hollow (for track)
    translate([0,slider_hollow_y_offset,0])
    translate(slider_offset)
    rotate(90,[0,0,1])
    slider(slider_panel_width*slider_hollow_growth_factor,slider_panel_depth*slider_hollow_growth_factor,usbc_bump_height-(global_thickness*2),slider_track_width*slider_hollow_growth_factor);
}
//Keyboard support (attached to front)
translate(keyboard_support_front_offset)
roundedcube([keyboard_support_front_width, keyboard_support_front_depth, keyboard_support_front_height], false, keyboard_support_front_rounding, "y");

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
//back screwholes (counterbore) - without holes
color("blue")
difference () {
  for (i = [ 0 : len(screwhole_offsets)-1 ]) {
    rotate([0,0,180])
    translate(screwhole_offsets[i])
    translate([-(2*screwhole_offsets[i][0]),global_pcb_thickness,0])
    rotate([-90,0,0])
    cylinder(h=outer_rear_depth-global_pcb_thickness, r1=screwhole_counterbore_radius+global_thickness, r2=screwhole_counterbore_radius+global_thickness, center=false, $fn=256);
  }
  //back screwholes (counterbore) - holes - major (where screw head can fit through)
  for (i = [ 0 : len(screwhole_offsets)-1 ]) {
    rotate([0,0,180])
    translate(screwhole_offsets[i])
    translate([-(2*screwhole_offsets[i][0]),global_thickness+global_pcb_thickness,0])
    rotate([-90,0,0])
    cylinder(h=outer_rear_depth-global_pcb_thickness+global_nudge, r1=screwhole_counterbore_radius, r2=screwhole_counterbore_radius, center=false, $fn=256);
  }
  //back screwholes (counterbore) - holes - primary (where screw head cannot fit through)
  for (i = [ 0 : len(screwhole_offsets)-1 ]) {
    rotate([0,0,180])
    translate(screwhole_offsets[i])
    translate([-(2*screwhole_offsets[i][0]),-global_nudge+global_pcb_thickness,0])
    rotate([-90,0,0])
    cylinder(h=outer_rear_depth-global_pcb_thickness+global_nudge, r1=screwhole_counterbore_radius_primary, r2=screwhole_counterbore_radius_primary, center=false, $fn=256);
  }
}
//back holepegs
color("purple")
for (i = [ 0 : len(holepeg_rear_offsets)-1 ]) {
  holepeg_rear_offsets_mod=[holepeg_rear_offsets[i][0],holepeg_rear_offsets[i][1],holepeg_rear_offsets[i][2]];
  holepeg_support_height=outer_upper_depth-global_pcb_thickness;
  rotate([0,0,180])
  translate(holepeg_rear_offsets[i])
  translate([-(2*holepeg_rear_offsets[i][0]),-holepeg_peg_height+global_pcb_thickness,0])
  holepeg(holepeg_support_height, holepeg_peg_height, holepeg_support_radius, holepeg_peg_radius);
}
//back piece
#color("green")
rotate([0,180,180])
mirror([0,0,1])
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
      //lower cable hook
      rotate([270,0,90])
      translate(lower_cable_hook_offset)
      union(){
        roundedcube([outer_rear_depth, global_thickness, cable_hook_strut_length], false, cable_hook_rounding, "zmax");
        translate([0,0,cable_hook_strut_length-(2*global_thickness)])
        roundedcube([outer_rear_depth, cable_hook_saddle_length, global_thickness], false, cable_hook_rounding, "all");
      }
      //lower cable hook
      rotate([270,180,90])
      translate(upper_cable_hook_offset)
      union(){
        roundedcube([outer_rear_depth, global_thickness, cable_hook_strut_length], false, cable_hook_rounding, "zmax");
        translate([0,0,cable_hook_strut_length-(2*global_thickness)])
        roundedcube([outer_rear_depth, cable_hook_saddle_length, global_thickness], false, cable_hook_rounding, "all");
      }
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
    roundedcube([usbc_bump_width-(global_thickness), slider_panel_width/2, usbc_bump_height-(2*global_thickness)], false, usbc_bump_rounding, "ymax");
    //back screwholes (counterbore) - holes - major (where screw head can fit through)
    rotate([0,180,180])
    mirror([0,0,1])
    for (i = [ 0 : len(screwhole_offsets)-1 ]) {
      rotate([0,0,180])
      translate(screwhole_offsets[i])
      translate([-(2*screwhole_offsets[i][0]),global_thickness,0])
      rotate([-90,0,0])
      cylinder(h=outer_rear_depth+global_nudge, r1=screwhole_counterbore_radius, r2=screwhole_counterbore_radius, center=false, $fn=256);
    }
    //slider - hollow (for track)
    translate([0,slider_hollow_y_offset,0])
    translate(slider_offset)
    rotate(90,[0,0,1])
    slider(slider_panel_width*slider_hollow_growth_factor,slider_panel_depth*slider_hollow_growth_factor,usbc_bump_height-(global_thickness*2),slider_track_width*slider_hollow_growth_factor);
    //QTpy reset button hole
    translate(pqty_reset_button_hole_offset)
    rotate(90,[-1,0,0])
    cylinder(h=outer_rear_depth+global_thickness, r1=pqty_reset_button_hole_radius, r2=pqty_reset_button_hole_radius, center=false, $fn=256);
    //sd slot hole
    translate(sd_slot_offset)
    cube([sd_slot_width, sd_slot_depth, global_thickness+(2*global_nudge)], false);
}
//Keyboard support (attached to front)
translate(keyboard_support_rear_offset)
roundedcube([keyboard_support_rear_width, keyboard_support_rear_depth, keyboard_support_rear_height], false, keyboard_support_rear_rounding, "y");
//screwdriver slot
color("cyan")
rotate([0,180,180])
mirror([0,0,1])
translate(screwdriver_slot_offset)
rotate([0,90,0])
difference () {
  cylinder(h=outer_upper_width-global_thickness, r1=screwdriver_slot_radius+global_thickness, r2=screwdriver_slot_radius+global_thickness, center=false, $fn=256);
  translate ([0,0,-global_nudge])
  cylinder(h=outer_upper_width-global_thickness, r1=screwdriver_slot_radius, r2=screwdriver_slot_radius, center=false, $fn=256);
}
