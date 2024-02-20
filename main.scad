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
use <./3d-models/lid-lock.scad>

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
  translate([$boxHeight, 0, 0])
  lid();
  translate([$boxHeight, 0, 0])
    rotate([0, 180, 0])
    standLid();
  translate([$boxHeight, 0, $boxDepth])
    rotate([0, 180, 0])
    translate([0, $boxWidth, 0])
    rotate([180, 0, 0])
    otherLid();

  translate([$boxHeight + $lidHeight/ 2, $boxWidth, $boxDepth - $lidRadius])
    mirror([0,1,])
    rotate([90, 180, 0])
    swingLock(length = 70);
  translate([$boxHeight + $lidHeight/ 2, 0, $boxDepth - $lidRadius])
    rotate([90, 180, 0])
    swingLock(length = 70);
}
