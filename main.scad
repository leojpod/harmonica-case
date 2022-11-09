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

use <./harmonica-body.scad>

include <./box-inset.scad>
include <./dimensions.scad>

color("white")
  translate([32, 0, 0])
  for (i=[0:5]) {
    translate([0, i * ($thick_gap + $material_thickness), 0])
      harmonicaBody();
  }

