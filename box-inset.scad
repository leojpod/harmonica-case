include <./dimensions.scad>

// inside-slant offset -> 
offset = 8 + ($height_gap + $material_thickness) / tan (90-$slant_angle);
margin = 5;

insideWidth = 6 * $thick_gap + 5 * $material_thickness;

module horizontalPlank(height = 100) {
  offsetted_height = height - offset;
  difference () {
    union() {
      //base
      cube([offsetted_height, insideWidth, $material_thickness]);
      // first set of wings
      translate([20, - $material_thickness, 0])
        cube([10, insideWidth + 2 * $material_thickness, $material_thickness]);
      // second set of wings
      translate([offsetted_height - 30, - $material_thickness, 0])
        cube([10, insideWidth + 2 * $material_thickness, $material_thickness]);
    }
    // first set of knotches
    for (i=[0:2]) {
      translate([- margin, $thick_gap + (i * 2 * ($thick_gap + $material_thickness)), - margin ])
        cube([offsetted_height / 2 + margin, $material_thickness, 2*margin +  $material_thickness]);
    }
    // second set of knotches
    for (i=[0:1]) {
      translate([offsetted_height / 2, 2 * $thick_gap + $material_thickness + (i * 2 * ($thick_gap + $material_thickness)), - margin ])
        cube([offsetted_height / 2 + margin, $material_thickness, 2*margin + $material_thickness]);
    }
  }
}

module insideSlant() {
  slantHeight = 2 * $height_gap + $material_thickness;
  union() {
    cube([$material_thickness, insideWidth, slantHeight]);
    translate([0, - $material_thickness, (slantHeight / 2) - 5])
    cube([$material_thickness, insideWidth + 2 * $material_thickness, 10]);
  }
}

module boxInset(height = 100) {
  translate([offset, 0, 30])
    horizontalPlank(height);

  translate([30 - $material_thickness, 0, 0])
  rotate([0, -20, 0])
    insideSlant();
}
boxInset();
