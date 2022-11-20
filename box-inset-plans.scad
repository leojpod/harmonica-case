// In that file we'll line up all the pieces on a flat plane

include <./dimensions.scad>
use <./box-inset.scad>

margin = 5;
insideWidth = $horizontalPlacements * $thick_gap + ($horizontalPlacements - 1) * $material_thickness;
echo("insideWidth: ", insideWidth);

// Outside box

module insideBoxLayout() {
  horizontalPlank($insideHeight);

  translate([-10, - 2 * $material_thickness - margin, 0])
  rotate([90, 0, 0])
  verticalSeparator($insideHeight);

  translate([-10, - (2 * $height_gap + 5 * $material_thickness) - 2 * margin, 0])
  rotate([90, 0, 0])
  verticalSeparator($insideHeight, false);

  translate([$insideHeight, 0, $material_thickness])
  rotate([0, 90, 0])
  insideSlant();
}

projection(cut = true) {
  insideBoxLayout();
}
