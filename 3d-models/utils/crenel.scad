include <../dimensions.scad>

margin = 2;

module crenel(repetitions, size = 10, depth = $materialThickness, clearing = $materialThickness) {
  for(i=[1:repetitions]) {
    translate([2 * size * (i -1), -margin, -margin])
    cube([size, depth + margin, clearing + 2 * margin]);
  }
}

module hole_crenel(repetitions, size = 10, depth = $materialThickness, clearing = $materialThickness) {
  for(i=[1:repetitions]) {
    translate([2 * size * (i -1), 0, -margin])
      cube([size, depth, clearing + 2 * margin]);
  }
}

