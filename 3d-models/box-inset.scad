include <./dimensions.scad>
use <./harmonica-body.scad>

margin = 5;

insideWidth = $horizontalPlacements * $thickGap + ($horizontalPlacements - 1) * $materialThickness;


function offsetCalculator(level) = 
  $materialThickness + ($verticalPlacements - level) *($heightGap + $materialThickness) / tan (90-$slantAngle) + 2;

echo("offset #1-> ", offsetCalculator(0));
echo("offset #2-> ", offsetCalculator(1));
echo("offset #3-> ", offsetCalculator(2));

module insideSlant() {
  // inside-slant offset ->
  slantHeight = ($heightGap + ( $heightGap + $materialThickness) * ($verticalPlacements -1)) / sin(90 - $slantAngle) - $materialThickness;
  union() {
    cube([$materialThickness, insideWidth, slantHeight]);
    translate([0, - $materialThickness, (slantHeight / 3) - 5])
    cube([$materialThickness, insideWidth + 2 * $materialThickness, 10]);
    translate([0, - $materialThickness, 2 * (slantHeight / 3) - 5])
    cube([$materialThickness, insideWidth + 2 * $materialThickness, 10]);
  }
}


module horizontalPlank(height, level = 1) {
  echo("horizontalPlank -> ", level);
  offset = offsetCalculator(level);
  offsetted_height = height - offset;
  translate([offset, 0, 0])
  difference () {
    union() {
      //base
      cube([offsetted_height, insideWidth, $materialThickness]);
      // first set of wings
      translate([20, - $materialThickness, 0])
        cube([10, insideWidth + 2 * $materialThickness, $materialThickness]);
      // second set of wings
      translate([offsetted_height - 30, - $materialThickness, 0])
        cube([10, insideWidth + 2 * $materialThickness, $materialThickness]);
    }
    // notches
    for(i=[0:($horizontalPlacements - 2)]) {
      horizontalShift = (i + 1) * $thickGap + (i *  $materialThickness);
      if (i % 2 == 0){
        translate([offsetted_height / 2, horizontalShift, - margin ])
        cube([offsetted_height / 2 + margin, $materialThickness, 2*margin +  $materialThickness]);
      } else {
        translate([- margin, horizontalShift, - margin])
        cube([offsetted_height / 2 + margin, $materialThickness, 2*margin + $materialThickness]);
      }
    }
  }
}

module verticalSeparator(height, is_even = true) {
  offset = offsetCalculator(1);
  offsetted_height = height - offset;
  separator_witdh = $heightGap + ($verticalPlacements - 1) * ($materialThickness + $heightGap);

  base = 4 + margin;
  bottomOffset = base + (separator_witdh + 2 * margin) / tan(90-$slantAngle);

  // wedge cutout
  wedgePoints = [
    [0, 0, separator_witdh + 2 * margin], // 0
    [base, 0, separator_witdh + 2 * margin], // 1
    [bottomOffset, 0, 0], // 2
    [0, 0, 0], // 3
    [0, $materialThickness + 2 * margin, separator_witdh + 2 * margin], // 4
    [base, $materialThickness + 2 * margin, separator_witdh + 2 * margin], // 5
    [bottomOffset, $materialThickness + 2 * margin, 0], // 6
    [0, $materialThickness + 2 * margin, 0] // 7
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
      cube([height, $materialThickness, separator_witdh]);
      translate([2 * height / 3 - 5, 0, - $materialThickness])
        cube([10, $materialThickness, separator_witdh + 2 * $materialThickness]);
    }
    translate([-margin, -margin, -margin])
      polyhedron(wedgePoints, wedgeFaces);

    for(i=[1:$verticalPlacements - 1]) {
      offset = offsetCalculator(i);
      offsetted_height = height - offset;
      if (is_even) {
        translate([offset + offsetted_height / 2, -margin, $heightGap + ($heightGap + $materialThickness) * (i-1)])
          cube([offsetted_height / 2 + margin, $materialThickness + 2 * margin, $materialThickness]);
      } else {
        translate([offset - margin, -margin, $heightGap + ($heightGap + $materialThickness) * (i-1)])
          cube([offsetted_height / 2 + margin, $materialThickness + 2 * margin, $materialThickness]);
      }
    }
  }
}

module boxInset(height = $insetLength) {
  for(i=[1:($verticalPlacements - 1)]) {
    translate([0, 0, $heightGap + (i-1) * ($heightGap + $materialThickness)])
      horizontalPlank(height, i);
  }

  translate([offsetCalculator(0) - $materialThickness * 2, 0, 0.25 * $materialThickness])
  rotate([0, -$slantAngle, 0])
    insideSlant();

  for(i=[0:($horizontalPlacements - 2)]) {
    horizontalShift = [0, (i + 1) * $thickGap + i * $materialThickness, 0];
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

if (false) {
  translate([offsetCalculator(0), 0, 0])
    union() {
      color("white")
      harmonicaBody();
      color("magenta")
      cube([$minHarpSeating, 20, 30]);
    }
  color("teal")
  translate([offsetCalculator(1), 0, $materialThickness + $heightGap])
    harmonicaBody();
  translate([offsetCalculator(2), 0, 2*$materialThickness + 2*$heightGap])
    union() {
      color("gray")
      harmonicaBody();
      color("blue")
      cube([$maxHarpSeating, 20, 30]);
    }
}
