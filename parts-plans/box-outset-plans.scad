// In that file we'll line up all the pieces on a flat plane

use <./../3d-models/box-outset.scad>
include <./../3d-models/dimensions.scad>

margin = 5;

// Outside box
outsideHeight = $insideHeight + $outsetMargin;
outsideWidth = 6 * $thick_gap + 7 * $material_thickness;
outsideDepth = 2 * $height_gap + 3 * $material_thickness;

module outsideBoxLayout() {
  rotate([0, -90, 0])
  bottom();

  translate([margin, 0, 0])
  long_side(outsideHeight);

  translate([-outsideDepth - margin, 0, $material_thickness])
  rotate([0, -180, 0])
  long_side(outsideHeight);

  translate([0, -margin, 0])
  rotate([90, 0, 0])
  rotate([0, -90, 0])
  short_side(outsideHeight);

  translate([0, margin + outsideWidth, 0]);
  rotate([-90,0,0])
  rotate([0, -90, 0])
  short_side(outsideHeight);
}

projection(cut = true) {
  outsideBoxLayout();
}
