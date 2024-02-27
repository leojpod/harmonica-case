// In that file we'll line up all the pieces on a flat plane

use <./../3d-models/box-outset.scad>
include <./../3d-models/dimensions.scad>

margin = 5;

module outsideBoxLayout(piece) {
  if(piece == "all" || piece == "bottom") {
    rotate([0, -90, 0])
    bottom();
  }

  if(piece == "all" || piece == "long_side_a") {
    translate([margin, 0, 0])
    long_side_a();
  }

  if(piece == "all" || piece == "long_side_b") {
    translate([-$boxDepth - margin, 0, 0])
    rotate([0, -180, 0])
    long_side_b();
  }

  if(piece == "all" || piece == "short_side_a") {
    translate([0, -margin, 0])
    rotate([90, 0, 0])
    rotate([0, -90, 0])
    short_side_a();
  }

  if(piece == "all" || piece == "short_side_b") {
    translate([0, margin  -2*$boxDepth, 0])
    rotate([-90,0,0])
    rotate([0, -90, 0])
    short_side_b();
  }
}

projection(cut = true) {
  outsideBoxLayout("all");
}
