include <./dimensions.scad>
use <./crenel.scad>

lidDepth = $height_gap + 3 * $material_thickness / 2;
width = $thick_gap * 6 + 7 * $material_thickness;
margin = 2;
flatHeight = 20;

circularRadius = 2 * lidDepth/3;

wedgePoints = [
  [0, 0, lidDepth - circularRadius], // 0
  [flatHeight + circularRadius, 0, 0], // 1
  [0, 0, 0], // 2
  [0, $material_thickness, lidDepth - circularRadius], // 3
  [flatHeight + circularRadius, $material_thickness, 0], // 4
  [0, $material_thickness, 0] // 5
];
wedgeFaces = [
 [0, 1, 2],
 [3, 4, 1, 0],
 [3, 4, 5],
 [4, 5, 2, 1],
 [5, 3, 0, 2]
];

module roundedCorner(r = circularRadius) {
  difference() {
    rotate([-90, 0, 0])
      cylinder($material_thickness, r = r, center = false);

    translate([- r - margin, - margin, 0])
      cube([2 * r + 2 * margin, $material_thickness + 2 * margin, r + margin]);

    translate([- margin - r, - margin, -r - margin])

      cube([r + margin, $material_thickness + 2 * margin, 2 * r + 2 * margin]);
  }
}

module roundedTop() {
  translate([0, width/2, circularRadius ])
    rotate([90, 0, 0])
    difference() {
      cylinder(width, r = circularRadius, center = true);

      cylinder(width + 2 * margin, r = circularRadius - $material_thickness, center = true);

      translate([- circularRadius - margin, - circularRadius - margin, - (width + margin) / 2])
        cube([circularRadius + margin, (circularRadius + margin)* 2, width +  margin]);

      translate([- circularRadius - margin, 0, - (width + margin) / 2])
        cube([(circularRadius + margin)* 2, circularRadius + margin, width +  margin]);
    }
}

module roundedSide() {
  w = round(width / 20);
  difference() {
    union() {
      cube([flatHeight, width, $material_thickness]);

      translate([flatHeight, 0, 0])
        roundedTop();
    }
    translate([flatHeight + circularRadius - $material_thickness, + w + (width - w * 20) / 2, circularRadius - margin])
      rotate([90, 0, 90])
      crenel(10, w);

  }
}

module standSide() {
  union() {
    cube([flatHeight, $material_thickness, circularRadius]);

    translate([flatHeight, 0, circularRadius])
      roundedCorner(circularRadius - $material_thickness);

    difference() {
      translate([0, 0, circularRadius])
        cube([flatHeight + circularRadius, $material_thickness, lidDepth - circularRadius]);

      translate([0, -margin, lidDepth])
        rotate([0,  atan((lidDepth - circularRadius) / (flatHeight + circularRadius)), 0])
        cube([width / 2, $material_thickness + 2 * margin, width / 2]);

      translate([flatHeight + circularRadius - $material_thickness - 10, - 10 + $material_thickness / 2, circularRadius - $material_thickness])
        cube([5, 20, $material_thickness]);

      translate([$material_thickness, $material_thickness, 0])
        rotate([90,0,0])
        crenel(2, $material_thickness);
    }
  }
}

module stabiliser() {
  w = round(width * 0.05);
  translate([0, $material_thickness, 0])
  difference() {
    union() {
      cube([10 + $material_thickness, width - 2 * $material_thickness, $material_thickness]);

      translate([0, -$material_thickness, 0])
        cube([5, width, $material_thickness]);

    }


    translate([10 + $material_thickness, 0, 0])
      rotate([0, 0, 90])
      crenel(11, w);
  }
}

module standLid() {
  standSide();

  translate([0, $thick_gap * 6 + $material_thickness * 6, 0])
    standSide();

  roundedSide();

  translate([flatHeight + circularRadius - $material_thickness - 10, 0, circularRadius - $material_thickness])
    stabiliser();
}

module otherSide() {
  union() {
    difference() {
      cube([flatHeight, $material_thickness, lidDepth]);

      translate([0, $material_thickness, lidDepth - $material_thickness + margin])
        rotate([90, 0, 0])
        crenel(5, $material_thickness);
    }

    translate([flatHeight, 0, lidDepth - circularRadius])
      rotate([0,-90, 0])
      roundedCorner(circularRadius - $material_thickness);

    difference() {
      translate([0, 0, -lidDepth + circularRadius])
        cube([flatHeight + circularRadius, $material_thickness, (lidDepth - circularRadius) * 2]);

      /* height: lidDepth - circularRadius, 
       * width: flatHeight + circularRadius
       *
       * tan x = height / width
       */
      translate([0, -margin, 0])
        rotate([0, 90 + atan((lidDepth - circularRadius) / (flatHeight + circularRadius)), 0])
        cube([width / 2, $material_thickness + 2 * margin, width / 2]);

      translate([flatHeight + circularRadius, 0, + flatHeight +  $material_thickness / 2])
        rotate([0,90,90])
        crenel(5, $material_thickness);
    }
  }
}

module otherRoundedCorner() {
  union() {
    difference() {
      translate([0, 0, lidDepth - $material_thickness])
        cube([flatHeight, width, $material_thickness]);

      translate([$material_thickness,0, lidDepth - $material_thickness])
        rotate([0, 0, 0])
        crenel(2, $material_thickness);

      translate([$material_thickness,width, lidDepth ])
        rotate([180, 0, 0])
        crenel(2, $material_thickness);
    }

    translate([flatHeight, width, lidDepth])
      rotate([180, 0, 0])
      roundedTop();

    difference() {
      translate([flatHeight + circularRadius - $material_thickness, 0, - lidDepth + circularRadius])
        cube([$material_thickness, width, (lidDepth - circularRadius) * 2]);

      translate([flatHeight + circularRadius - $material_thickness, 0, lidDepth - circularRadius - $material_thickness / 2])
        rotate([0, 90, 0])
        crenel(3, $material_thickness);

      translate([flatHeight + circularRadius - $material_thickness, width - $material_thickness + margin, lidDepth - circularRadius - $material_thickness / 2])
        rotate([0, 90, 0])
        crenel(3, $material_thickness);
    }
  }
}

module otherLid() {
  color("white")
    otherSide();

  translate([0, $thick_gap * 6 + $material_thickness * 6, 0])
    color("red")
    otherSide();

  /* color("green") */
    /* otherRoundedCorner(); */
}

module lid() {
  color("blue")
    standLid();

  translate([0, 0, lidDepth])
    otherLid();
}



standLid();
