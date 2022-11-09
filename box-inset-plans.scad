// In that file we'll line up all the pieces on a flat plane

include <./dimensions.scad>
use <./box-inset.scad>

margin = 5;
insideWidth = 6 * $thick_gap + 5 * $material_thickness;

// Outside box

module insideBoxLayout() {
  horizontalPlank($insideHeight);

  translate([-10, - 2 * $material_thickness - margin, 0])
  rotate([90, 0, 0])
  verticalSeparator($insideHeight);

  translate([-10, - (2 * $height_gap + 5 * $material_thickness) - 2 * margin, 0])
  rotate([90, 0, 0])
  verticalSeparator($insideHeight, false);


  translate([-10, 0, 0])
  rotate([0, -90, 0])
  insideSlant($insideHeight);
}

projection(cut = true) {
  insideBoxLayout();
}
