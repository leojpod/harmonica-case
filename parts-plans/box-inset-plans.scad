// In that file we'll line up all the pieces on a flat plane

include <./../3d-models/dimensions.scad>
use <./../3d-models/box-inset.scad>

margin = 5;
insideWidth = $horizontalPlacements * $thickGap + ($horizontalPlacements - 1) * $materialThickness;
echo("insideWidth: ", insideWidth);

// Outside box

module insideBoxLayout(piece = "all") {
  if (piece == "all" || piece == "horizontalPlank") {
    for(level=[1:$verticalPlacements-1]) {
      translate([- (level - 1) * $insetLength, 0, 0])
      horizontalPlank($insetLength, level);
    }
  }

  if(piece == "all" || piece == "verticalSeparator") {
    translate([-15, - 2 * $materialThickness - margin, 0])
    rotate([90, 0, 0])
    verticalSeparator($insetLength);
  }

  if(piece == "all" || piece == "verticalSeparator_odd"){
    translate([-15, - ($verticalPlacements * $heightGap + ($verticalPlacements + 2) * $materialThickness) - 2 * margin, 0])
    rotate([90, 0, 0])
    verticalSeparator($insetLength, false);
  }

  if(piece == "all" || piece == "insideSlant") {
    translate([$insetLength + $materialThickness, 0, $materialThickness])
    rotate([0, 90, 0])
    insideSlant();
  }
}

projection(cut = true) {
  insideBoxLayout("verticalSeparator_odd");
}
