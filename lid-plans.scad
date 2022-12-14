include <./dimensions.scad>
use <./lid.scad>

width = $thick_gap * 5 + 6 * $material_thickness;

margin = 5;

module standLidPieces() {
  color("green")
  translate([0, -margin, 0])
  rotate([90, 0, 0])
  standSide();

  color("blue")
  translate([0, width + margin, 0])
  mirror([0, 1,0])
  rotate([90, 0, 0])
  standSide();

  color("red")
  roundedSideFlatten();

  color("black")
  translate([80, 0, 0])
  mirror([1,0,0])
  stabiliser();
}

module otherLidPieces() {
  translate([0, -35 -margin, $material_thickness])
  rotate([-90, 0, 0])
  otherSide();

  translate([0, width + 35 + margin, $material_thickness])
  mirror([0,1,0])
  rotate([-90, 0, 0])
  otherSide();

  otherRoundedSideFlatten();
}

module flatPieces () {
  standLidPieces();

  translate([-90, 0, 0])
  otherLidPieces();
}

projection(cut= true) {
  flatPieces();
}
