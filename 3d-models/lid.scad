/*
 * This file models the lid.
 * it has 2 parts, the part that can be used as a stand, and the other one.
 *
 * the stand part is a bit shorter and will hold a lock part that can attach to close the lid or to fix the cover in an open position.
 *
 */

include <./dimensions.scad>
use <./utils/crenel.scad>

lidDepth = $heightGap + 3 * $materialThickness / 2;
echo("lidDepth -> ", lidDepth);
width = $thickGap * $horizontalPlacements + ($horizontalPlacements + 1) * $materialThickness;
margin = 2;
// TODO compute that one based on the insideHeight, the outsetMargin and the slant angle
flatHeight = ceil(($lengthGap + ($heightGap + ($heightGap + $materialThickness) * ($verticalPlacements -1))/tan(90-$slantAngle)) - $insetLength - $outsetMargin) + 2* margin;
echo("flatHeight -> ", flatHeight);

circularRadius = 2 * lidDepth/3;
echo("Circular radius -> ", circularRadius);

bodyLength = $insetLength + $outsetMargin;

wedgeLength =  floor(circularRadius * bodyLength/(bodyLength - flatHeight - circularRadius) - circularRadius);
echo("wedge length -> ", wedgeLength);

$angle = floor(asin((wedgeLength + circularRadius) / (bodyLength)));
echo("angle -> ", $angle);

wedgePoints = [
  [0, 0, wedgeLength], // 0
  [flatHeight + circularRadius, 0, 0], // 1
  [0,0,0], // 2
  [0, $materialThickness, wedgeLength], // 3
  [flatHeight + circularRadius, $materialThickness, 0], // 4
  [0, $materialThickness, 0] // 5
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
      cylinder($materialThickness, r = r, center = false);

    translate([- r - margin, - margin, 0])
      cube([2 * r + 2 * margin, $materialThickness + 2 * margin, r + margin]);

    translate([- margin - r, - margin, -r - margin])

      cube([r + margin, $materialThickness + 2 * margin, 2 * r + 2 * margin]);
  }
}

module roundedTop() {
  translate([0, width/2, circularRadius ])
    rotate([90, 0, 0])
    difference() {
      cylinder(width, r = circularRadius, center = true);

      cylinder(width + 2 * margin, r = circularRadius - $materialThickness, center = true);

      translate([- circularRadius - margin, - circularRadius - margin, - (width + margin) / 2])
        cube([circularRadius + margin, (circularRadius + margin)* 2, width +  margin]);

      translate([- circularRadius - margin, 0, - (width + margin) / 2])
        cube([(circularRadius + margin)* 2, circularRadius + margin, width +  margin]);
    }
}

module roundedSideFlatten() {
  w = round(width * 0.05);
  flattenLength = PI * .5 * (circularRadius - $materialThickness);

  difference() {
    cube([flatHeight + flattenLength, width, $materialThickness]);

    translate([flatHeight + flattenLength, $materialThickness + w, 0])
      rotate([0, 0, 90])
      crenel(10, w);

    translate([$materialThickness, 0, 0])
    crenel(3, $materialThickness);

    translate([$materialThickness, width, $materialThickness])
    rotate([180, 0, 0])
      crenel(3, $materialThickness);
  }
}

module roundedSide() {
  w = round(width * 0.05);
  crenelOffset = round((width - w * 20) / 2);
  difference() {
    union() {
      cube([flatHeight, width, $materialThickness]);

      translate([flatHeight, 0, 0])
        roundedTop();
    }
    translate([flatHeight + circularRadius - $materialThickness, $materialThickness + w, circularRadius - margin])
      rotate([90, 0, 90])
      crenel(10, w);

    translate([$materialThickness, 0, 0])
    crenel(3, $materialThickness);

    translate([$materialThickness, width, $materialThickness])
    rotate([180, 0, 0])
      crenel(3, $materialThickness);
  }
}

module standSide() {
  difference() {
    union() {
      cube([flatHeight, $materialThickness, circularRadius]);

      translate([flatHeight, 0, circularRadius])
        roundedCorner(circularRadius - $materialThickness);

      translate([0, 0, circularRadius])
        polyhedron(wedgePoints, wedgeFaces);
    }
    translate([0, $materialThickness, 0])
      rotate([90,0,0])
      crenel(4, $materialThickness);

    translate([2 * $materialThickness * 3,-$materialThickness, - $materialThickness])
      cube([3 * $materialThickness, 3 * $materialThickness, $materialThickness + 2 * margin ]);

    translate([flatHeight + circularRadius - $materialThickness - 10, - 10 + $materialThickness / 2, circularRadius - $materialThickness])
      cube([5, 20, $materialThickness]);

    translate([flatHeight + circularRadius - $materialThickness,-margin,circularRadius])
      cube([$materialThickness, 2 * margin + $materialThickness, $materialThickness]);
  }
}

module stabiliser() {
  w = round(width * 0.05);
  translate([0, $materialThickness, 0])
  difference() {
    union() {
      cube([10 + $materialThickness, width - 2 * $materialThickness, $materialThickness]);

      translate([0, -$materialThickness, 0])
        cube([5, width, $materialThickness]);

    }


    translate([10 + $materialThickness, 0, 0])
      rotate([0, 0, 90])
      crenel(11, w);
  }
}

module standLid() {
  standSide();

  color("red")
  translate([0, width - $materialThickness, 0])
    standSide();

  color("blue")
  roundedSide();

  color("green")
  translate([flatHeight + circularRadius - $materialThickness - 10, 0, circularRadius - $materialThickness])
    stabiliser();
}


module otherSide() {
  difference() {
    union() {
      difference() {
        cube([flatHeight, $materialThickness, lidDepth]);

        translate([0, $materialThickness, lidDepth - $materialThickness + margin])
          rotate([90, 0, 0])
          crenel(4, $materialThickness);

        translate([2 * $materialThickness * 3,-$materialThickness, lidDepth - $materialThickness])
          cube([3 * $materialThickness, 3 * $materialThickness, $materialThickness + 2 * margin ]);
      }

      translate([flatHeight, 0, lidDepth - circularRadius])
        rotate([0,-90, 0])
        roundedCorner(circularRadius - $materialThickness);

      difference() {
        translate([0, 0, -lidDepth + circularRadius])
          cube([flatHeight + circularRadius, $materialThickness, (lidDepth - circularRadius) * 2]);


        translate([flatHeight + circularRadius, 0, 3.5 * $materialThickness])
          rotate([0,90,90])
          crenel(4, $materialThickness);
      }
    }

    translate([0, 0, -lidDepth])
      union() {
        standSide();
        // some quick rendering cleanup
        translate([0, 0.5 * $materialThickness, 0])
          standSide();
        translate([0, -0.5 * $materialThickness, 0])
          standSide();
      }

    translate([flatHeight,-$materialThickness, - (2 * lidDepth - 2* circularRadius ) + margin])
      cube([circularRadius - $materialThickness, 3 * $materialThickness, 3 * $materialThickness]);
  }
}

module otherRoundedSide() {
  union() {
    difference() {
      translate([0, 0, lidDepth - $materialThickness])
        cube([flatHeight, width, $materialThickness]);

      translate([$materialThickness,0, lidDepth - $materialThickness])
        rotate([0, 0, 0])
        crenel(3, $materialThickness);

      translate([$materialThickness,width, lidDepth ])
        rotate([180, 0, 0])
        crenel(3, $materialThickness);
    }

    translate([flatHeight, width, lidDepth])
      rotate([180, 0, 0])
      roundedTop();

    difference() {
      translate([flatHeight + circularRadius - $materialThickness, 0, - lidDepth + circularRadius])
        cube([$materialThickness, width, (lidDepth - circularRadius) * 2]);

      translate([flatHeight + circularRadius - $materialThickness, 0, lidDepth - circularRadius - $materialThickness / 2])
        rotate([0, 90, 0])
        crenel(3, $materialThickness);

      translate([flatHeight + circularRadius - $materialThickness, width - $materialThickness + margin, lidDepth - circularRadius - $materialThickness / 2])
        rotate([0, 90, 0])
        crenel(3, $materialThickness);
    }
  }
}

module otherRoundedSideFlatten() {
  flattenLength = PI * .5 * (circularRadius - $materialThickness);

  translate([0, 0, -lidDepth + $materialThickness])
  union() {
    difference() {
      translate([0, 0, lidDepth - $materialThickness])
        #cube([flatHeight + flattenLength, width, $materialThickness]);

      translate([$materialThickness,0, lidDepth - $materialThickness])
        rotate([0, 0, 0])
        crenel(3, $materialThickness);

      translate([$materialThickness,width, lidDepth ])
        rotate([180, 0, 0])
        crenel(3, $materialThickness);
    }

    translate([flatHeight + flattenLength,0,lidDepth])
    rotate([0, 90, 0])
    difference() {
      translate([0, 0, 0])
        cube([$materialThickness, width, (lidDepth - circularRadius) * 2]);

      translate([0, 0, (lidDepth - circularRadius) * 2 - $materialThickness / 2])
        rotate([0, 90, 0])
        crenel(3, $materialThickness);

      translate([0, width - $materialThickness + margin, (lidDepth - circularRadius) * 2 - $materialThickness / 2])
        rotate([0, 90, 0])
        crenel(3, $materialThickness);
    }

    translate([flatHeight + flattenLength - 4, 0, lidDepth - $materialThickness])
    cube([5, width, $materialThickness]);
  }
}

module otherLid() {
  color("white")
    otherSide();

  translate([0, width - $materialThickness, 0])
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



lid();
use <./box-outset.scad>
translate([-$outsetMargin - $insetLength - 10,0,0])
boxOutset();
