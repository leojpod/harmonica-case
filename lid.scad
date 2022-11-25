/*
 * This file models the lid.
 * it has 2 parts, the part that can be used as a stand, and the other one.
 *
 * the stand part is a bit shorter and will hold a lock part that can attach to close the lid or to fix the cover in an open position.
 *
 */

include <./dimensions.scad>
use <./crenel.scad>

lidDepth = $height_gap + 3 * $material_thickness / 2;
echo("lidDepth -> ", lidDepth);
width = $thick_gap * $horizontalPlacements + ($horizontalPlacements + 1) * $material_thickness;
margin = 2;
// TODO compute that one based on the insideHeight, the outsetMargin and the slant angle
flatHeight = ceil(($length_gap + ($height_gap * 2 + $material_thickness)/tan(90-$slant_angle)) - $insideHeight - $outsetMargin) + 2* margin;
echo("flatHeight -> ", flatHeight);

circularRadius = 2 * lidDepth/3;
echo("Circular radius -> ", circularRadius);

bodyLength = $insideHeight + $outsetMargin;

wedgeLength =  floor(circularRadius * bodyLength/(bodyLength - flatHeight - circularRadius) - circularRadius);
echo("wedge length -> ", wedgeLength);

$angle = floor(asin((wedgeLength + circularRadius) / (bodyLength)));
echo("angle -> ", $angle);

wedgePoints = [
  [0, 0, wedgeLength], // 0
  [flatHeight + circularRadius, 0, 0], // 1
  [0,0,0], // 2
  [0, $material_thickness, wedgeLength], // 3
  [flatHeight + circularRadius, $material_thickness, 0], // 4
  [0, $material_thickness, 0] // 5
];
wedgeFaces = [
 [0, 1, 2],
 [3, 4, 1, 0],
 [3, 5, 4],
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

module roundedSideFlatten() {
  w = round(width * 0.05);
  flattenLength = PI * .5 * (circularRadius - $material_thickness);

  difference() {
    cube([flatHeight + flattenLength, width, $material_thickness]);

    translate([flatHeight + flattenLength, $material_thickness + w, 0])
      rotate([0, 0, 90])
      crenel(10, w);

    translate([$material_thickness, 0, 0])
    crenel(3, $material_thickness);

    translate([$material_thickness, width, $material_thickness])
    rotate([180, 0, 0])
      crenel(3, $material_thickness);
  }
}

module roundedSide() {
  w = round(width * 0.05);
  crenelOffset = round((width - w * 20) / 2);
  difference() {
    union() {
      cube([flatHeight, width, $material_thickness]);

      translate([flatHeight, 0, 0])
        roundedTop();
    }
    translate([flatHeight + circularRadius - $material_thickness, $material_thickness + w, circularRadius - margin])
      rotate([90, 0, 90])
      crenel(10, w);

    translate([$material_thickness, 0, 0])
    crenel(3, $material_thickness);

    translate([$material_thickness, width, $material_thickness])
    rotate([180, 0, 0])
      crenel(3, $material_thickness);
  }
}

module standSide() {
  difference() {
    union() {
      cube([flatHeight, $material_thickness, circularRadius]);

      translate([flatHeight, 0, circularRadius])
        roundedCorner(circularRadius - $material_thickness);

      translate([0, 0, circularRadius])
        polyhedron(wedgePoints, wedgeFaces);
    }
    translate([0, $material_thickness, 0])
      rotate([90,0,0])
      crenel(4, $material_thickness);

    translate([2 * $material_thickness * 3,-$material_thickness, - $material_thickness])
      cube([3 * $material_thickness, 3 * $material_thickness, $material_thickness + 2 * margin ]);

    translate([flatHeight + circularRadius - $material_thickness - 10, - 10 + $material_thickness / 2, circularRadius - $material_thickness])
      cube([5, 20, $material_thickness]);

    translate([flatHeight + circularRadius - $material_thickness,-margin,circularRadius])
      cube([$material_thickness, 2 * margin + $material_thickness, $material_thickness]);
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

  color("red")
  translate([0, width - $material_thickness, 0])
    standSide();

  color("blue")
  roundedSide();

  color("green")
  translate([flatHeight + circularRadius - $material_thickness - 10, 0, circularRadius - $material_thickness])
    stabiliser();
}


module otherSide() {
  difference() {
    union() {
      difference() {
        cube([flatHeight, $material_thickness, lidDepth]);

        translate([0, $material_thickness, lidDepth - $material_thickness + margin])
          rotate([90, 0, 0])
          crenel(4, $material_thickness);

        translate([2 * $material_thickness * 3,-$material_thickness, lidDepth - $material_thickness])
          cube([3 * $material_thickness, 3 * $material_thickness, $material_thickness + 2 * margin ]);
      }

      translate([flatHeight, 0, lidDepth - circularRadius])
        rotate([0,-90, 0])
        roundedCorner(circularRadius - $material_thickness);

      difference() {
        translate([0, 0, -lidDepth + circularRadius])
          cube([flatHeight + circularRadius, $material_thickness, (lidDepth - circularRadius) * 2]);


        translate([flatHeight + circularRadius, 0, 3.5 * $material_thickness])
          rotate([0,90,90])
          crenel(4, $material_thickness);
      }
    }

    translate([0, 0, -lidDepth])
      union() {
        standSide();
        // some quick rendering cleanup
        translate([0, 0.5 * $material_thickness, 0])
          standSide();
        translate([0, -0.5 * $material_thickness, 0])
          standSide();
      }

    translate([flatHeight,-$material_thickness, - (2 * lidDepth - 2* circularRadius ) + margin])
      cube([circularRadius - $material_thickness, 3 * $material_thickness, 3 * $material_thickness]);
  }
}

module otherRoundedSide() {
  union() {
    difference() {
      translate([0, 0, lidDepth - $material_thickness])
        cube([flatHeight, width, $material_thickness]);

      translate([$material_thickness,0, lidDepth - $material_thickness])
        rotate([0, 0, 0])
        crenel(3, $material_thickness);

      translate([$material_thickness,width, lidDepth ])
        rotate([180, 0, 0])
        crenel(3, $material_thickness);
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

module otherRoundedSideFlatten() {
  flattenLength = PI * .5 * (circularRadius - $material_thickness);

  translate([0, 0, -lidDepth + $material_thickness])
  union() {
    difference() {
      translate([0, 0, lidDepth - $material_thickness])
        #cube([flatHeight + flattenLength, width, $material_thickness]);

      translate([$material_thickness,0, lidDepth - $material_thickness])
        rotate([0, 0, 0])
        crenel(3, $material_thickness);

      translate([$material_thickness,width, lidDepth ])
        rotate([180, 0, 0])
        crenel(3, $material_thickness);
    }

    translate([flatHeight + flattenLength,0,lidDepth])
    rotate([0, 90, 0])
    difference() {
      translate([0, 0, 0])
        cube([$material_thickness, width, (lidDepth - circularRadius) * 2]);

      translate([0, 0, (lidDepth - circularRadius) * 2 - $material_thickness / 2])
        rotate([0, 90, 0])
        crenel(3, $material_thickness);

      translate([0, width - $material_thickness + margin, (lidDepth - circularRadius) * 2 - $material_thickness / 2])
        rotate([0, 90, 0])
        crenel(3, $material_thickness);
    }

    translate([flatHeight + flattenLength - 4, 0, lidDepth - $material_thickness])
    cube([5, width, $material_thickness]);
  }
}

module otherLid() {
  color("white")
    otherSide();

  translate([0, width - $material_thickness, 0])
    otherSide();

  color("green")
    otherRoundedSide();
}

module lid() {
  color("blue")
    standLid();

  translate([0, 0, lidDepth])
    otherLid();
}



otherLid();
