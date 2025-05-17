 module screwhole(support_height, screwhole_height, support_radius, screwhole_radius, nudge){
  rotate(90,[-1,0,0])
  difference () {
    cylinder(h=support_height, r1=support_radius, r2=support_radius, center=false, $fn=256);
    translate([0,0,-(((support_height-screwhole_height)/2)+nudge)])
    cylinder(h=screwhole_height, r1=screwhole_radius, r2=screwhole_radius, center=false, $fn=256);
  }
}


