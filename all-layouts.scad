use <./box-inset-plans.scad>
use <./box-outset-plans.scad>
use <./lid-plans.scad>


projection(cut = true) {
  flatPieces();

  /* translate([300, 0, 0]) */
  /* outsideBoxLayout(); */

  translate([-300, 0, 0])
  insideBoxLayout();
}
