
module slider(panel_width, panel_depth, panel_height, track_width){
    tab_hieght=panel_depth/2;
    module prism(l, w, h){
      polyhedron(//pt 0        1        2        3        4        5
              points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
              faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
              );
    }
    translate([track_width,-panel_depth,0]){

    //panel
    cube([panel_width, panel_depth, panel_height], false);

    //tracks (top)
    translate([-track_width,panel_depth,panel_height])
    rotate(90,[0,1,0])
    rotate(90,[1,0,0])
    prism(panel_height, track_width, panel_depth);
    //tracks (top)
    translate([track_width+panel_width,panel_depth,0])
    rotate(90*3,[0,1,0])
    rotate(90,[1,0,0])
    prism(panel_height, track_width, panel_depth);
    //tab
    difference () {
        translate([panel_width/2,0,panel_height/2])
        cylinder(h = tab_hieght, r1 = panel_width/2, r2 = panel_width/2, center = true, $fn=256);
        translate([0,panel_depth,0])
        cube([panel_width, panel_width, panel_height], false);
    }
    }
}