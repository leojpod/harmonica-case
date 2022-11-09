include <./dimensions.scad>
use <./box-inset.scad>
use <./crenel.scad>

width = 6 * $thick_gap + 7 * $material_thickness;
depth = 2 * $height_gap + 3 * $material_thickness;

margin = 2;


module bottom() {
  module sideCrenel() {
    translate([2 * margin, 0, (depth - 50) / 2 + 10])
    rotate([0,-90, 0])
      crenel(2);
    translate([-margin, -  margin, 0]){
      translate([0, 0, (depth - 50) / 2 - 20 ])
        cube([$material_thickness + 2 * margin, $material_thickness +  margin, 20]);
      translate([0, 0, (depth) - ((depth - 50) / 2)  ])
        cube([$material_thickness + 2 * margin, $material_thickness +  margin, 20]);
    }
  };
  difference() {
    cube([$material_thickness, width, depth]);
    rotate([90, 0, 90])
      crenel(10);
    translate([0, 0, depth - margin])
    rotate([90, 0, 90])
      crenel(10);
    sideCrenel();
    translate([0, width - margin, 0])
    sideCrenel();
  }
}

module long_side(height) {
  difference() {
    cube([height, width, $material_thickness]);
    //long-side <-> short side 
    translate([- 10 + $material_thickness, 0, 0])
      crenel(7);
    translate([- 10 + $material_thickness, width - margin, 0])
      crenel(7);
    // long-side <-> bottom
    translate([margin, -10, 0])
    rotate([0, 0, 90])
      crenel(10);
    translate([$material_thickness, $material_thickness, $material_thickness])
      boxInset();
  }
}

module short_side(height) {
  difference() {
    cube([height, $material_thickness, depth]);
    // short-side <-> long-side
    translate([$material_thickness, 0, margin])
    rotate([-90,0, 0])
      crenel(6);
    translate([$material_thickness, 2 * margin, depth - margin])
    rotate([90,0, 0])
      crenel(6);
    // short-side <-> bottom
    translate([0, 0, (depth - 50) / 2])
    rotate([-90,-90, 0])
      crenel(3);
    translate([$material_thickness, $material_thickness, $material_thickness])
      boxInset();
  }
}

module boxOutset(insetHeight = $insideHeight, outsetMargin = $outsetMargin) {
  height = insetHeight + outsetMargin;

  color("red")
  bottom();

  color("green")
  long_side(height);
  color("blue")
  translate([0,0, depth - $material_thickness])
  long_side(height);

  color("violet")
  short_side(height);
  color("yellow")
  translate([0,width - $material_thickness,0])
  short_side(height);
}


boxOutset();
