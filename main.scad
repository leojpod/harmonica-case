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
 *  - roughly: 105 x 20 x 30
 *
 * harmonica stored along the X axis
 */
include <./dimensions.scad>

use <./harmonica-body.scad>

use <./box-inset.scad>
use <./box-outset.scad>
use <./lid.scad>

rotate([0, -17, 0]) {
  translate([$material_thickness, $material_thickness, $material_thickness]) {
    boxInset();
    color("white") {
      translate([(2 * $height_gap + $material_thickness) / tan(90-$slant_angle) + $material_thickness, 0, 0])
      for (i=[0:($horizontalPlacements - 1)]) {
        translate([0, i * ($thick_gap + $material_thickness), 0])
          harmonicaBody();
      }
      translate([$height_gap/(tan(90-$slant_angle)) + $material_thickness + 2, 0, $height_gap + $material_thickness])
      for (i=[0:($horizontalPlacements - 1)]) {
        translate([0, i * ($thick_gap + $material_thickness), 0])
          harmonicaBody();
      }
    }
  }

  boxOutset();
  /* translate([$insideHeight + $outsetMargin, 0, 0]) */
  /* lid(); */
  translate([$insideHeight + $outsetMargin, 0, 0])
  rotate([0, 180, 0])
  standLid();
  translate([$insideHeight + $outsetMargin, 0, 1.5 * (2 * $height_gap + 3 * $material_thickness)])
  rotate([0, 180, 0])
  otherLid();
}
