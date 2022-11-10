include <./dimensions.scad>
use <./lid.scad>

width = $thick_gap * 6 + 7 * $material_thickness;

margin = 5;

module standLidPieces() {
  translate([0, -margin, 0])
  rotate([90, 0, 0])
  standSide();

  translate([0, width + margin, 0])
  mirror([0, 1,0])
  rotate([90, 0, 0])
  standSide();

  roundedSideFlatten();


  translate([70, 0, 0])
  mirror([1,0,0])
  stabiliser();
}

module otherLidPieces() {
  translate([0, -10 -margin, 0])
  rotate([90, 0, 0])
  otherSide();

  translate([0, width + 10 + margin, 0])
  mirror([0,1,0])
  rotate([90, 0, 0])
  otherSide();

  otherRoundedCornerFlatten();
}

module flatPieces () {
  standLidPieces();

  translate([-80, 0, 0])
  otherLidPieces();
}

projection(cut= true) {
  flatPieces();
}
