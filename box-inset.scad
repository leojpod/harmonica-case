include <./dimensions.scad>

// inside-slant offset ->
offset = $material_thickness + ($height_gap + $material_thickness) / tan (90-$slant_angle) + 2;
margin = 5;

insideWidth = $horizontalPlacements * $thick_gap + ($horizontalPlacements - 1) * $material_thickness;

module horizontalPlank(height) {
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
    // notches
    for(i=[0:($horizontalPlacements - 2)]) {
      horizontalShift = (i + 1) * $thick_gap + (i *  $material_thickness);
      if (i % 2 == 0){
        translate([- margin, horizontalShift, - margin ])
        cube([offsetted_height / 2 + margin, $material_thickness, 2*margin +  $material_thickness]);
      } else {
        translate([offsetted_height / 2, horizontalShift, - margin])
        cube([offsetted_height / 2 + margin, $material_thickness, 2*margin + $material_thickness]);
      }
    }
  }
}

module insideSlant() {
  slantHeight = (2 * $height_gap + $material_thickness) / sin(90 - $slant_angle) - $material_thickness;
  union() {
    cube([$material_thickness, insideWidth, slantHeight]);
    translate([0, - $material_thickness, (slantHeight / 3) - 5])
    cube([$material_thickness, insideWidth + 2 * $material_thickness, 10]);
    translate([0, - $material_thickness, 2 * (slantHeight / 3) - 5])
    cube([$material_thickness, insideWidth + 2 * $material_thickness, 10]);
  }
}

module verticalSeparator(height, front_notch = true) {
  offsetted_height = height - offset;
  separatorWidth = 2 * $height_gap + $material_thickness;

  base = 4 + margin;
  bottomOffset = base + (separatorWidth + 2 * margin) / tan(90-$slant_angle);

  // wedge cutout
  wedgePoints = [
    [0, 0, separatorWidth + 2 * margin], // 0
    [base, 0, separatorWidth + 2 * margin], // 1
    [bottomOffset, 0, 0], // 2
    [0, 0, 0], // 3
    [0, $material_thickness + 2 * margin, separatorWidth + 2 * margin], // 4
    [base, $material_thickness + 2 * margin, separatorWidth + 2 * margin], // 5
    [bottomOffset, $material_thickness + 2 * margin, 0], // 6
    [0, $material_thickness + 2 * margin, 0] // 7
  ];
  wedgeFaces = [
    [4, 5, 1, 0], // top
    [0, 1, 2, 3], // front
    [5, 6, 2, 1], // side
    [7, 6, 5, 4], // back
    [6, 7, 3, 2], // bottom
    [7, 4, 0, 3] // other side
  ];


  difference() {
    union() {
      cube([height, $material_thickness, separatorWidth]);
      translate([2 * height / 3 - 5, 0, - $material_thickness])
        cube([10, $material_thickness, separatorWidth + 2 * $material_thickness]);
    }
    translate([-margin, -margin, -margin])
      polyhedron(wedgePoints, wedgeFaces);
    if (front_notch) {
      translate([offset + offsetted_height / 2, -margin, $height_gap])
        cube([offsetted_height / 2 + margin, $material_thickness + 2 * margin, $material_thickness]);
    } else {
      translate([offset - margin, -margin, $height_gap])
        cube([offsetted_height / 2 + margin, $material_thickness + 2 * margin, $material_thickness]);
    }
  }
}

module boxInset(height = $insideHeight) {
  translate([offset, 0, 30])
    horizontalPlank(height);

  translate([($height_gap * 2 + $material_thickness)/ tan(90 - $slant_angle) - 0.25 * $material_thickness, 0, 0.25 * $material_thickness])
  rotate([0, -$slant_angle, 0])
    insideSlant();

  for(i=[0:($horizontalPlacements - 2)]) {
    horizontalShift = [0, (i + 1) * $thick_gap + i * $material_thickness, 0];
    if(i % 2 == 0) {
      color("blue")
      translate(horizontalShift)
      verticalSeparator(height, true);
    } else {
      color("green")
      translate(horizontalShift)
      verticalSeparator(height, false);
    }
  }
}

boxInset();
