module holepeg(support_height, peg_height, support_radius, peg_radius){
  rotate(90,[-1,0,0])
  union () {
    cylinder(h=peg_height, r1=peg_radius, r2=peg_radius, center=false, $fn=256);
    translate([0,0,peg_height])
    cylinder(h=support_height, r1=support_radius, r2=support_radius, center=false, $fn=256);
  }
}
