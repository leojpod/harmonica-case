include <./dimensions.scad>

margin = 2;

module crenel(repetitions, size = 10) {
  for(i=[1:repetitions]) {
    translate([2 * size * (i -1), -margin, -margin])
    cube([size, $material_thickness + margin, $material_thickness + 2 * margin]);
  }
}

module hole_crenel(repetitions, size = 10) {
  for(i=[1:repetitions]) {
    translate([2 * size * (i -1), 0, -margin])
      cube([size, $material_thickness, $material_thickness + 2 * margin]);
  }
}

