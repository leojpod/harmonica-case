/*
 * This file models the outwards part of the case:
 *
 *    ______________________________
 *   / /                         / /|
 *  / /   Width * depth         / / |
 * /_/_________________________/_/  |
 * | |                         | |  |
 * | |                         | |  | <- short side
 * | |                         | |  | (height * depth)
 * | |    Width * height       | |  |
 * | |                         | |  |
 * | |                        <----------- long side
 * | |                         | |  |
 * | |                         | |  /
 * | |                         | | /
 * |_|_________________________|_|/
 *       ^ bottom
 *
 *
 * *short side*: has notches for inside slant's wings and the horizontal plank's short side wings
 * *long side*: has notches for veritcal separators' wings
 * *bottom*: no notches
 */
include <./dimensions.scad>
use <./box-inset.scad>
use <./utils/crenel.scad>

width = $horizontalPlacements * $thickGap + ($horizontalPlacements + 1) * $materialThickness;
depth = $materialThickness + $verticalPlacements * ($materialThickness + $heightGap);

margin = 2;


module bottom() {
  module sideCrenel() {
    translate([2 * margin, 0, 0]) // (depth - 50) / 2 + 10])
    rotate([0,-90, 0])
      crenel(6, depth/12);
  };
  union() {
    difference() {
      cube([$materialThickness, width, depth]);
      rotate([90, 0, 90])
        crenel(6, width/12);
      translate([0, 0, depth - margin])
      rotate([90, 0, 90])
        crenel(6, width/12);
      sideCrenel();
      translate([0, width - margin, 0])
      sideCrenel();
      translate([-$materialThickness,-$materialThickness,depth - $materialThickness])
        cube(10);
      translate([-$materialThickness,width - $materialThickness,-$materialThickness])
        cube(10);
    }
    translate([0,0,depth - $materialThickness])
      cube($materialThickness);
  }
}

module long_side(height) {
  difference() {
    cube([height, width, $materialThickness]);
    //long-side <-> short side
    translate([- (height/10) + $materialThickness, 0, 0])
      crenel(6, height / 10);
    translate([- (height/10) + $materialThickness, width - margin, 0])
      crenel(6, height / 10);
    // long-side <-> bottom
    translate([margin, width/ 12, 0])
    rotate([0, 0, 90])
      crenel(6, width / 12);
    translate([$materialThickness, $materialThickness, $materialThickness])
      boxInset();
  }
}

module short_side(height) {
  difference() {
    cube([height, $materialThickness, depth]);
    // short-side <-> long-side
    translate([$materialThickness, 0, margin])
    rotate([-90,0, 0])
      crenel(5, height/10);
    translate([$materialThickness, 2 * margin, depth - margin])
    rotate([90,0, 0])
      crenel(5, height/10);
    translate([- $materialThickness, -$materialThickness, depth - $materialThickness])
      cube([10, 20, 30]);

    // short-side <-> bottom
    translate([0, 0, 10 ])
    rotate([-90,-90, 0])
      crenel(6, (depth / 12));
    translate([$materialThickness, $materialThickness, $materialThickness])
      boxInset();
  }
}

module boxOutset(insetLength = $insetLength, outsetMargin = $outsetMargin, extraSpace = 0) {
  height = insetLength + outsetMargin;

  color("red")
  bottom();

  color("green")
  translate([0,0, - extraSpace])
  long_side(height);
  color("blue")
  translate([0,0, depth - $materialThickness + extraSpace])
  long_side(height);

  color("violet")
  translate([0, - extraSpace, 0])
  short_side(height);
  color("yellow")
  translate([0,width - $materialThickness + extraSpace,0])
  short_side(height);
}


boxOutset(extraSpace = 0);
