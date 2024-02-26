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

width = $boxWidth - 2*$materialThickness;
depth = $boxDepth - 2*$materialThickness;
height = $boxHeight;

margin = 2;

module bottom_V1() {
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


module bottom() {
  module sideCrenel() {
    translate([2 * margin, 0, 0]) // (depth - 50) / 2 + 10])
    rotate([0,-90, 0])
      crenel(6, depth/12, depth = 2*$materialThickness);
  };
  union() {
    difference() {
      cube([$materialThickness, $boxWidth, $boxDepth]);
      translate([0,$materialThickness,0])
      rotate([90, 0, 90])
        crenel(6, width/12, depth = 2*$materialThickness);
      translate([$materialThickness, $materialThickness, $boxDepth ])
      rotate([-90, 0,90])
        crenel(6, width/12, depth = 2*$materialThickness);
      translate([0, 0, $materialThickness])
      sideCrenel();
      translate([$materialThickness, $boxWidth, $materialThickness])
        rotate([0,0,180])
        sideCrenel();
      translate([-$materialThickness,-$materialThickness, -$materialThickness])
        cube(3*$materialThickness);
      translate([-$materialThickness,$boxWidth - 2*$materialThickness,-$materialThickness])
        cube(10);
    }
    translate([0,0,$boxDepth - 2*$materialThickness])
      cube([$materialThickness, 2*$materialThickness, 2*$materialThickness]);
  }
}

module roundedClearing(clearingHeight = 30) {
  linear_extrude($materialThickness + 2*margin)
  offset(5, $fn=24) offset(-5, $fn=24)
  polygon([[0,0], [0, $thickGap - 2*margin], [clearingHeight, $thickGap - 2*margin], [clearingHeight, 0]]);
}
module long_side_a() {
  difference() {
    cube([$boxHeight, $boxWidth, $materialThickness]);
    //long-side <-> short side
    translate([- (height/10) + $materialThickness, 0, 0])
      crenel(6, height / 10, depth = 2*$materialThickness);
    translate([- (height/10) + $materialThickness, $boxWidth - $materialThickness - margin, 0])
      crenel(6, height / 10, depth = 2*$materialThickness);
    // long-side <-> bottom
    translate([margin, $materialThickness + width/ 12, 0])
    rotate([0, 0, 90])
      crenel(6, width / 12);
    translate([$materialThickness, 2*$materialThickness, 1*$materialThickness])
      boxInset();
    for(i=[0:2:$horizontalPlacements -1]) {
    translate([$boxHeight - 15,2*$materialThickness+margin + i*($thickGap + $materialThickness),-margin])
      roundedClearing(40);
    }
  }
}
module long_side_b() {
  difference() {
    cube([$boxHeight, $boxWidth, $materialThickness]);
    //long-side <-> short side
    translate([- (height/10) + $materialThickness, 0, 0])
      crenel(6, height / 10, depth = 2*$materialThickness);
    translate([- (height/10) + $materialThickness, $boxWidth - $materialThickness - margin, 0])
      crenel(6, height / 10, depth = 2*$materialThickness);
    // long-side <-> bottom
    translate([margin, $materialThickness + width/ 12, 0])
    rotate([0, 0, 90])
      crenel(6, width / 12);
  }
}

module short_side_a() {
  difference() {
    cube([$boxHeight, $materialThickness, $boxDepth]);
    // short-side <-> long-side
    translate([$materialThickness, 0, margin + $materialThickness])
    rotate([-90,0, 0])
      crenel(5, height/10, depth = 2*$materialThickness);
    translate([$materialThickness, 2 * margin, $boxDepth - $materialThickness - margin])
    rotate([90,0, 0])
      crenel(5, height/10, depth = 2*$materialThickness);
    translate([- 2*$materialThickness, -$materialThickness, $boxDepth - 3*$materialThickness])
      cube(3*$materialThickness);
    translate([- $materialThickness, -$materialThickness, $boxDepth - 2*$materialThickness])
      cube(3*$materialThickness);

    // short-side <-> bottom
    translate([0, 0, 10 + $materialThickness ])
    rotate([-90,-90, 0])
      crenel(6, (depth / 12));
    translate([$materialThickness, $materialThickness, 2*$materialThickness])
      boxInset();
  }
}

module short_side_b() {
  difference() {
    cube([$boxHeight, $materialThickness, $boxDepth]);
    // short-side <-> long-side
    translate([$materialThickness, 0, margin + $materialThickness])
    rotate([-90,0, 0])
      crenel(5, height/10, depth = 2*$materialThickness);
    translate([$materialThickness, 2 * margin, $boxDepth - $materialThickness - margin])
    rotate([90,0, 0])
      crenel(5, height/10, depth = 2*$materialThickness);
    translate([- 2*$materialThickness, -$materialThickness, $boxDepth - 3*$materialThickness])
      cube(3*$materialThickness);
    translate([- $materialThickness, -$materialThickness, $boxDepth - 2*$materialThickness])
      cube(3*$materialThickness);

    // short-side <-> bottom
    translate([0, 0, 10 + $materialThickness ])
    rotate([-90,-90, 0])
      crenel(6, (depth / 12));
  }
}

module boxOutset(extraSpace = 0) {

  color("white")
  bottom();

  /*
  color("purple")
  translate([-1*$materialThickness,$materialThickness,$materialThickness])
  bottom_VL1();
  */

  color("green")
  translate([0,0, $materialThickness - extraSpace])
  long_side_a();
  color("blue")
  translate([0,0, $boxDepth - 2*$materialThickness + extraSpace])
  long_side_a();

  color("orange")
  translate([0,0, 0 - 2*extraSpace])
  long_side_b();
  color("purple")
  translate([0,0, $boxDepth - $materialThickness + 2*extraSpace])
  long_side_b();

  color("violet")
  translate([0, $materialThickness - extraSpace, 0])
  short_side_a();
  color("yellow")
  translate([0,$boxWidth - 2*$materialThickness + extraSpace,0])
  short_side_a();

  color("green")
  translate([0, - 2*extraSpace, 0])
  short_side_b();
  color("blue")
  translate([0,$boxWidth - $materialThickness + 2*extraSpace,0])
  short_side_b();
}


boxOutset(extraSpace = 20);
