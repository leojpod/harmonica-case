include <./dimensions.scad>
include <./utils/cylinder-outer.scad>

margin = 2;

module pivot() {
  difference() {
    cylinder($materialThickness, r = 2*$materialThickness, center = false);
    translate([-.5*$materialThickness, -1.5*$materialThickness, -$materialThickness])
      cube([$materialThickness, 3*$materialThickness, 3*$materialThickness]);
    translate([-1.5*$materialThickness, -.5*$materialThickness, -$materialThickness])
      cube([3*$materialThickness, $materialThickness, 3*$materialThickness]);
  }
}

module insertA(extraLength = 0) {
  difference() {
    cube([$materialThickness, 3*$materialThickness, 3*$materialThickness]);
    translate([-margin, $materialThickness, -margin])
    cube([$materialThickness + 2*margin, $materialThickness, margin + 1.5 *$materialThickness]);
  }
  translate([0, -(1+(extraLength/2))*$materialThickness, 2*$materialThickness])
    cube([$materialThickness, (5+extraLength)*$materialThickness, $materialThickness]);
}
module insertB(){
  difference() {
    union() {
      cube([3*$materialThickness, $materialThickness, 3*$materialThickness]);
      translate([-$materialThickness, 0, 2*$materialThickness])
      cube([5*$materialThickness, $materialThickness, $materialThickness]);
    }
    translate([$materialThickness, -margin, 1.5*$materialThickness ])
      cube([$materialThickness, $materialThickness + 2*margin, margin + 1.5 *$materialThickness]);
  }
}
module insertC(){
  difference() {
    union() {
      cube([4*$materialThickness, $materialThickness, 3*$materialThickness]);
      translate([-$materialThickness, 0, 2*$materialThickness])
      cube([6*$materialThickness, $materialThickness, $materialThickness]);
    }
    translate([1.5* $materialThickness, -margin, 1.5*$materialThickness ])
      cube([$materialThickness, $materialThickness + 2*margin, margin + 1.5 *$materialThickness]);
  }
}

module pivotAssembly(spread = false) {
  translate([0,0,$materialThickness + (spread? (-2*$materialThickness -2 * margin) : 0)])
  pivot();
  translate([-.5*$materialThickness, -1.5*$materialThickness, spread? (3*$materialThickness + 2*margin) : 0])
  insertA();
  translate([-1.5*$materialThickness, -.5*$materialThickness, 0])
  insertB();
}
module bottomNotch() {

}

module movingArm(length) {
  difference() {
    cylinder($materialThickness, r = 3*$materialThickness, center = false);
    translate([0,0,-$materialThickness])
    cylinder_outer(3* $materialThickness, 2*$materialThickness, fn=50);
  }
  translate([-20, 2*$materialThickness, 0])
  cube([20 + length, 2*$materialThickness, $materialThickness]);
  translate([length, 0, 0])
  difference() {
    cylinder($materialThickness, r = 4*$materialThickness, center = false);
    translate([0,0,-$materialThickness])
      cylinder_outer(3* $materialThickness, 2*$materialThickness, fn=50);
    translate([-6*$materialThickness,-3*$materialThickness,-$materialThickness])
      cube(6*$materialThickness);
    translate([-3*$materialThickness,-6*$materialThickness,-$materialThickness])
      cube(6*$materialThickness);
  }
  translate([length+2*$materialThickness, -3*$materialThickness,0])
    cube([2*$materialThickness, 3*$materialThickness, $materialThickness]);
}

module offCenterPiece(){
  difference() {
    translate([-1*$materialThickness, -0*$materialThickness, 0])
      oblongShape(r = 5*$materialThickness, flatLenght = 7*$materialThickness);
    translate([0,0,-$materialThickness])
      union() {
        oblongShape(height = 3*$materialThickness, flatLenght = 3*$materialThickness);
        translate([4*$materialThickness, 2*$materialThickness, 0])
          oblongShape(height = 3*$materialThickness, flatLenght = 2*$materialThickness);
        translate([3*$materialThickness, 0, 0])
          oblongShape(height = 3*$materialThickness, flatLenght = 3*$materialThickness);
        translate([$materialThickness, 0, 0])
          cube([7*$materialThickness, 2*$materialThickness, 3*$materialThickness]);
      }
  }
}
module oblongShape(r= 2*$materialThickness, height = $materialThickness, flatLenght = $materialThickness) {
  cylinder(height, r = r, center = false);
  translate([flatLenght, 0, 0])
    cylinder(height, r = r, center = false);
  translate([0, -r, 0])
    cube([flatLenght, 2*r, height]);
}

module oblongPivot() {
  difference() {
    oblongShape(flatLenght = 2*$materialThickness);
    translate([0.5*$materialThickness, -1.5*$materialThickness, -$materialThickness])
      cube([$materialThickness, 3*$materialThickness, 3*$materialThickness]);
    translate([-1.0*$materialThickness, -.5*$materialThickness, -$materialThickness])
      cube([4*$materialThickness, $materialThickness, 3*$materialThickness]);

  }
}

module insertD() {
  insertA(3);
}

module oblongPivotAssembly(spread = false) {
  translate([0,0,$materialThickness + (spread? (-2*$materialThickness -2 * margin) : 0)])
    oblongPivot();
  translate([0.5*$materialThickness, -1.5*$materialThickness, spread? (3*$materialThickness + 2*margin) : 0])
    insertD();
  translate([-1.0*$materialThickness, -.5*$materialThickness, 0])
  insertC();
}

module offCenterLock(spread = false) {
  translate([0,0,-$materialThickness])
    oblongPivotAssembly(spread);
  offCenterPiece();
}

module swingLock(length = 50, spread = false) {
  translate([0,0,-$materialThickness])
    pivotAssembly(spread);
  translate([length, 0, -$materialThickness])
    pivotAssembly(spread);
  movingArm(length);

  translate([length + 1*$materialThickness, 9*$materialThickness,0])
  offCenterLock(spread);
}
swingLock(spread = true);

