include <./dimensions.scad>
use <./box-outset.scad>
use <./box-inset.scad>

margin = $margin;

width = $boxWidth - 2*$materialThickness;
depth = $boxDepth - 2*$materialThickness;
// let's allow a margin for the fabric
fabricMargin = 0.2;

module frame() {
  // outer frame
  translate([$materialThickness/2, 0,0])
    semiCylinder(width-$materialThickness);
  translate([$materialThickness/2,depth - $materialThickness,0])
    semiCylinder(width-$materialThickness);
  translate([$materialThickness, $materialThickness/2, 0])
    rotate([0,0,90])
    semiCylinder(depth-$materialThickness);
  translate([width, $materialThickness/2,0])
    rotate([0,0,90])
    semiCylinder(depth-$materialThickness);
  semiSphere();
  translate([width - $materialThickness, 0,0])
    semiSphere();
  translate([0, depth - $materialThickness,0])
    semiSphere();
  translate([width - $materialThickness, depth - $materialThickness,0])
    semiSphere();
  //inner frames
  for(i = [1: ($horizontalPlacements - 1)]) {
    horizontalShift = i*$thickGap + (i +1)*$materialThickness;
    translate([horizontalShift, $materialThickness/2, 0]){
      rotate([0,0,90])
        semiCylinder(depth - $materialThickness);
      translate([-$materialThickness, $materialThickness/2, -$outsetMargin + $materialThickness + fabricMargin])
        cube([$materialThickness, depth - 2*$materialThickness, $outsetMargin- $materialThickness]);
    }
  }
  for(i = [1: ($verticalPlacements - 1)]) {
    verticalShift = i*$heightGap + (i)*$materialThickness;
    translate([$materialThickness/2, verticalShift,  0]){
      semiCylinder(width - $materialThickness);
      translate([$materialThickness/2, 0, -$outsetMargin+$materialThickness + fabricMargin])
        cube([width - 2*$materialThickness, $materialThickness, $outsetMargin - $materialThickness]);
    }
  }
  //top hole pins
  zOffset = 0.2; 
  for(i = [ 1: ($horizontalPlacements - 1) ]) {
    for (j = [0 : ($verticalPlacements - 1)]) {
    translate([i*($materialThickness + $thickGap), (j+1)*$materialThickness + j*$heightGap, zOffset])
    pin(true);
    translate([i*($materialThickness + $thickGap)+$materialThickness, (j+1)*$materialThickness + j*$heightGap, zOffset])
    pin(false);
    }
  }

  for(j = [0 : ($verticalPlacements - 1)]) {
    translate([width - $materialThickness, (j+1)*$materialThickness + j*$heightGap, zOffset])
    pin(true);
    translate([$materialThickness, (j+1)*$materialThickness + j*$heightGap, zOffset])
    pin(false);
  }

}
module pin(isLeft = false) {
  pinHeight = 18;
  rotate([0,0, isLeft? 180: 90]) {
  //rotate([0,0, 0]) {
    points  =  [[0,-3,0],[3,0,0], [0,$materialThickness/2,0], [-$materialThickness/2, 0,0], [-$materialThickness/2, 0, $materialThickness/3], [0,$materialThickness/2, $materialThickness/3]];
    faces = [[0,1,2,3], [5,4,3,2], [0,4,5,1], [0,3,4],[5,2,1]];
    polyhedron(points = points, faces = faces);
    *difference() {
      translate([-3,-3,0])
        semiSphere(diameter = $materialThickness);
      linear_extrude(3*pinHeight, center = true)
        polygon([[0,-3], [0,-6], [6,0], [3,0]]);
    }
    translate([0,0,-pinHeight])
    difference() {
      linear_extrude(pinHeight, center = false)
        polygon([[0,0], [0, -3], [3, 0]]);
      translate([-margin, -3-margin, 0])
        cube([margin+fabricMargin, 3 + 2*margin, pinHeight - $outsetMargin + $materialThickness]);
      translate([-margin, -fabricMargin, 0])
        cube([3 + 2*margin, margin+fabricMargin, pinHeight - $outsetMargin + $materialThickness]);
    }
  }
}
pin();

module semiSphere(diameter = $materialThickness) {
  translate([diameter/2, diameter/2, 0])
  difference() {
    sphere(d = diameter, $fn=18);
    translate([-diameter/2 - margin, -diameter/2 - margin, -diameter/2-margin])
      cube([diameter+2*margin, diameter+2*margin, diameter/2+margin]);
  }
}

module semiCylinder(length, diameter = $materialThickness) {
  translate([0, diameter / 2,0])
  rotate([0, 90, 0])
    difference() {
      cylinder(r = diameter / 2, center = false, h = length, $fn = 18);
      translate([0, -diameter/2 - margin, -margin])
        cube([diameter / 2 + margin, diameter +2*margin, length + 2*margin]);
    }
}

!frame();

translate([$boxWidth - $materialThickness, $boxDepth - $materialThickness, -$boxHeight - 00])
  rotate([90,-90,0]) {
  boxOutset();
  translate([$materialThickness,2*$materialThickness,2*$materialThickness])
    boxInset();
  }
