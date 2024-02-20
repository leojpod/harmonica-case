include <../dimensions.scad>

margin = 2;

module crenel(repetitions, size = 10, thickness = $materialThickness, clearing = $materialThickness) {
  for(i=[1:repetitions]) {
    translate([2 * size * (i -1), -margin, -margin])
    cube([size, thickness + margin, clearing + 2 * margin]);
  }
}

module hole_crenel(repetitions, size = 10, thickness = $materialThickness, clearing = $materialThickness) {
  for(i=[1:repetitions]) {
    translate([2 * size * (i -1), 0, -margin])
      cube([size, thickness, clearing + 2 * margin]);
  }
}

