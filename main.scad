// Box body

/*   top
 *   ____
 *  /    \ <- lid
 *  |    |
 *  |    | <- short sides: left & right
 *  |____| <- long sides: front & back
 *   ^ bottom
 *
 *
 *   base: left, right, front, back & bottom (i.e. all but lid)
 */


/*
 * DIMENSIONS
 *
 * Harmonica:
 *  - roughly: 105 x 25 x 30
 *
 * harmonica stored along the X axis
 */
include <./3d-models/dimensions.scad>

use <./3d-models/harmonica-body.scad>

use <./3d-models/box-inset.scad>
use <./3d-models/box-outset.scad>
use <./3d-models/lid.scad>

rotate([0, -($boxTiltingAngle), 0]) {
  translate([$materialThickness,$materialThickness,$materialThickness]) {
    boxInset();
    // harmonicas as example
    color("white") {
      translate([(2 * $heightGap + $materialThickness) / tan(90-$slantAngle) + $materialThickness, 0, 0])
      for (i=[0:($horizontalPlacements - 1)]) {
        translate([0, i * ($thickGap + $materialThickness), 0])
          harmonicaBody();
      }
      translate([$heightGap/(tan(90-$slantAngle)) + $materialThickness + 2, 0, $heightGap + $materialThickness])
      for (i=[0:($horizontalPlacements - 1)]) {
        translate([0, i * ($thickGap + $materialThickness), 0])
          harmonicaBody();
      }
    }
  }

  boxOutset(extraSpace = 0);
  translate([$insetLength + $outsetMargin, 0, 0])
  lid();
  translate([$insetLength + $outsetMargin, 0, 0])
    rotate([0, 180, 0])
    standLid();
  translate([$insetLength + $outsetMargin, 0, 1.5 * (2 * $heightGap + 3 * $materialThickness)])
    rotate([0, 180, 0])
    translate([0, $boxWidth, 0])
    rotate([180, 0, 0])
    otherLid();
}
