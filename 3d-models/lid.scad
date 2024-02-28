/*
 * This file models the lid.
 * it has 2 parts, the part that can be used as a stand, and the other one.
 *
 * the stand part is a bit shorter and will hold a lock part that can attach to close the lid or to fix the cover in an open position.
 *
 */

include <./dimensions.scad>
use <./utils/crenel.scad>
use <./lid-lock.scad>



/*
 *   lid-radius     flat length
 * <-------><------------------------------------->
 *         , - ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ - ,                      ^ ^
 *     , '   |                  |          /       | ' ,                  | |
 *   ,                                    /              ,                | | lid-radius
 *  ,        |                  |        /         |      ,               | |
 * ,             other wedge            /                  ,              | |
 * ,         |                  |      /           |       ,              | V
 * |                                  /                    | ^            |
 * |         |                  |    /   stand     |       | |            |
 * |                                /    wedge             | | height     | lidHeight
 * |         |                  |  /               |       | | clearance  |
 * |                             α/                        | |            |
 * |_________|__________________|/_________________|_______| V            V
 * <------------------------------------><--------------->
 *           otherLid top                     standLid top
 * <----------------------------><------------------------->
 *         otherLid base                   standLid base
 * <------------------------------------------------------->
 *          box-depth = verticalPlacements * (heightGap + materialThickness) + materialThickness
 */

margin = 2;

lidRadius = $lidRadius;
heightClearance = $lidHeightClearance;

lidHeight = $lidHeight;
flatLength = $boxDepth - 2 * lidRadius;


standLidBase_ = $boxHeight * tan($boxTiltingAngle);
standLidTop_ = (standLidBase_ * ($boxHeight - lidHeight)) / $boxHeight;
echo("before potential correction");
echo("standLidBase -> ", standLidBase_);
echo("standLidTop -> ", standLidTop_);
standLidTop = (standLidTop_ < lidRadius)? lidRadius: standLidTop_;
$standLidTop = standLidTop;
standLidBase = (standLidTop_ < lidRadius)? standLidTop * $boxHeight / ($boxHeight - lidHeight) : standLidBase_;
$standLidBase = standLidBase;
echo("after potential correction");
echo("standLidBase -> ", standLidBase);
echo("standLidTop -> ", standLidTop);
otherLidTop = $boxDepth - standLidTop;
otherLidBase = $boxDepth - standLidBase;

module rawLid() {
  cube([heightClearance, $boxWidth, $boxDepth]);
  translate([heightClearance, 0, lidRadius])
    cube([lidRadius, $boxWidth, flatLength]);
  translate([heightClearance, 0, lidRadius])
    rotate([-90, 0, 0])
      cylinder($boxWidth, r = lidRadius, center = false);
  translate([heightClearance, 0, flatLength + lidRadius])
    rotate([-90, 0, 0])
      cylinder($boxWidth, r = lidRadius, center = false);
}

// translate([1.5 * lidHeight, 0, 0])
  // rawLid();

module stabiliser( closed = false ) {
  difference() {
    cube([(closed? 4 : 3)* $materialThickness, $boxWidth, $materialThickness]);
    translate([$materialThickness, -margin, -margin])
    cube([(closed? 2 : 3)*$materialThickness, margin + $materialThickness, $materialThickness + 2*margin]);
    translate([$materialThickness, $boxWidth - $materialThickness, -margin])
    cube([(closed? 2 : 3)*$materialThickness, margin + $materialThickness, $materialThickness + 2*margin]);


    crenelReps = 10;
    crenelWidth = ($boxWidth - 2*$materialThickness) / (2*crenelReps);
    translate([3*$materialThickness, $materialThickness + crenelWidth / 2, 0])
    rotate([0,0,90])
    if (closed) {
      hole_crenel(crenelReps, crenelWidth);
    } else {
      crenel(crenelReps, crenelWidth);
    }

    if(!closed) {
      translate([2*$materialThickness,0,-5])
      cube(10+$materialThickness);
      translate([2*$materialThickness,$boxWidth - $materialThickness - 10,-5])
      cube(10+$materialThickness);
    }
  }
}

standWedgePoints = [
  [0, 0, 0], // 0
  [0, $materialThickness, 0], // 1
  [lidHeight, $materialThickness, 0], // 2
  [lidHeight, 0, 0], // 3
  [lidHeight, 0, standLidTop - lidRadius], // 4
  [lidHeight, $materialThickness, standLidTop - lidRadius], // 5
  [0, $materialThickness, standLidBase - lidRadius], // 6
  [0, 0, standLidBase - lidRadius], // 7
];


standWedgeFaces = [
  [3, 2, 1, 0], // A
  [2, 3, 4, 5], // B
  [0, 7, 4, 3], // C
  [1, 2, 5, 6], // D
  [4, 7, 6, 5], // E
  [0, 1, 6, 7], // F
];

module standSide() {
  difference() {
    union() {
      cube([heightClearance, $materialThickness, lidRadius]);
      translate([heightClearance, 0, lidRadius])
        difference() {
          rotate([-90, 0, 0])
            cylinder($materialThickness, r = lidRadius - $materialThickness, center = false);
          translate([-lidRadius, -5, 0])
            cube([2 * lidRadius, 10 + $materialThickness, 2* lidRadius]);
          translate([-2*lidRadius,-5,-lidRadius])
            cube([2 * lidRadius,10 + $materialThickness, 2* lidRadius]);
        }
      translate([0,0, lidRadius])
        polyhedron(standWedgePoints, standWedgeFaces);
    }
    translate([heightClearance / 12, $materialThickness, 0])
      rotate([90, 0, 0])
      crenel(6, heightClearance / 12);
    translate([heightClearance - margin, 0, -$materialThickness])
      cube($materialThickness + 2 * margin);

    translate([lidHeight - $materialThickness, -$materialThickness, 0])
      cube([2*$materialThickness, 3* $materialThickness, 2 *standLidTop]);

    translate([lidHeight - 3*$materialThickness, -margin, standLidTop - $materialThickness])
      cube([$materialThickness, $materialThickness + 2*margin, $materialThickness]);
  }
}

module standCover() {
  difference() {
    union () {
      cube([heightClearance, $boxWidth, $materialThickness]);
      if(standLidTop > lidRadius) {
        translate([lidHeight - $materialThickness, 0, lidRadius])
          cube([$materialThickness, $boxWidth, standLidTop - lidRadius]);
      }

      translate([heightClearance, 0, lidRadius])
      rotate([-90, 0, 0])
      difference() {
        cylinder($boxWidth, r = lidRadius, center = false);
        translate([0, 0, -margin])
          cylinder($boxWidth + 2*margin, r = lidRadius - $materialThickness, center = false);
        translate([-$boxWidth, -$boxWidth, -$boxWidth/2])
          cube([2 * $boxWidth, $boxWidth, 2* $boxWidth]);
        translate([-$boxWidth,-$boxWidth,-$boxWidth/2])
          cube([$boxWidth, 2* $boxWidth, 2* $boxWidth]);
      }
    }

    crenel(6, heightClearance / 12);
    translate([0, $boxWidth, $materialThickness])
      rotate([180, 0, 0])
      crenel(6, heightClearance / 12);

    crenelWidth = ($boxWidth - 2*$materialThickness) / 20;
    translate([lidHeight, 2*crenelWidth, standLidTop])
      rotate([0, -90, 0])
      rotate([0, 0, 90])
      crenel(9, crenelWidth);

    translate([lidHeight, $materialThickness, standLidTop])
      rotate([0, -90, 0])
      rotate([0, 0, 90])
      crenel(1, crenelWidth/2);

    translate([lidHeight, $materialThickness + 19.5* crenelWidth, standLidTop])
      rotate([0, -90, 0])
      rotate([0, 0, 90])
      crenel(1, crenelWidth/2);
  }
}

module standLid(spread = false) {
  color("white")
  standSide();
  color("white")
  translate([0, $boxWidth - $materialThickness + (spread? 10 : 0), 0])
    standSide();
  color("blue")
  translate([0, spread? 5 : 0, 0])
    standCover();
  color("green") 
  translate([lidHeight - 3* $materialThickness, (spread? 5: 0), standLidTop - $materialThickness + (spread? 10 : 0)])
    stabiliser(true);
}
// translate([0, $boxWidth, $boxDepth + 0*margin ])
// rotate([180, 0, 0])
// color("blue")
// standLid(true);

otherWedgePoints = [
  [0, 0, 0], // 0
  [0, $materialThickness, 0], // 1
  [lidHeight, $materialThickness, 0], // 2
  [lidHeight, 0, 0], // 3
  [lidHeight, 0, otherLidTop - lidRadius], // 4
  [lidHeight, $materialThickness, otherLidTop - lidRadius], // 5
  [0, $materialThickness, otherLidBase - lidRadius], // 6
  [0, 0, otherLidBase - lidRadius], // 7
];
otherWedgeFaces = standWedgeFaces;

module otherSide() {
  difference() {
    union() {
      cube([heightClearance, $materialThickness, lidRadius]);
      translate([heightClearance, 0, lidRadius])
        difference() {
          rotate([-90, 0, 0])
            cylinder($materialThickness, r = lidRadius - $materialThickness, center = false);
          translate([-lidRadius, -5, 0])
            cube([2 * lidRadius, 10 + $materialThickness, 2* lidRadius]);
          translate([-2*lidRadius,-5,-lidRadius])
            cube([2 * lidRadius,10 + $materialThickness, 2* lidRadius]);
        }
      translate([0, 0, lidRadius])
        polyhedron(otherWedgePoints, otherWedgeFaces);
    }
    translate([lidHeight - 3* $materialThickness, -margin, lidRadius + 2 * $materialThickness])
      cube([$materialThickness, $materialThickness + 2*margin, $materialThickness]);
    triangleTop = otherLidTop - otherLidBase;
    triangleStab = triangleTop * (lidHeight - 3*$materialThickness) / lidHeight;
    stabOffset = otherLidBase + triangleStab - 2*$materialThickness;
    translate([lidHeight - 3* $materialThickness, -margin, stabOffset])
      cube([$materialThickness, $materialThickness + 2*margin, $materialThickness]);
    translate([heightClearance / 12, $materialThickness, 0])
      rotate([90, 0, 0])
      crenel(6, heightClearance / 12);
    translate([heightClearance * 11/12,-5, -10])
      cube(10 + $materialThickness);
    translate([lidHeight, 1*$materialThickness, lidRadius + (otherLidTop - lidRadius)/12])
    rotate([90, -90, 0])
    crenel(6, (otherLidTop - lidRadius)/12);

    translate([$lidHeight*.8,$materialThickness,1.5*$lidRadius])
      rotate([-90, 180, 0])
      slideLock();
  }
}

module otherCover() {
  difference () {
    union () {
      cube([heightClearance, $boxWidth, $materialThickness]);
      translate([lidHeight - $materialThickness, 0, lidRadius])
        cube([$materialThickness, $boxWidth, otherLidTop - lidRadius]);

      translate([heightClearance, 0, lidRadius])
      rotate([-90, 0, 0])
      difference() {
        cylinder($boxWidth, r = lidRadius, center = false);
        translate([0, 0, -margin])
          cylinder($boxWidth + 2*margin, r = lidRadius - $materialThickness, center = false);
        translate([-$boxWidth, -$boxWidth, -$boxWidth/2])
          cube([2 * $boxWidth, $boxWidth, 2* $boxWidth]);
        translate([-$boxWidth,-$boxWidth,-$boxWidth/2])
          cube([$boxWidth, 2* $boxWidth, 2* $boxWidth]);
      }
    }
    translate([0, 0, 0])
      crenel(6, heightClearance / 12);
    translate([0, $boxWidth, $materialThickness])
      rotate([180, 0, 0])
      crenel(6, heightClearance / 12);
    translate([lidHeight,0,lidRadius])
      rotate([0,-90,0])
      crenel(6, (otherLidTop - lidRadius) / 12);
    translate([lidHeight-$materialThickness,$boxWidth,lidRadius])
      rotate([180,-90,0])
      crenel(6, (otherLidTop - lidRadius) / 12);
    crenelReps = 10;
    crenelWidth = ($boxWidth - 2*$materialThickness) / (2*crenelReps);
    triangleTop = otherLidTop - otherLidBase;
    triangleStab = triangleTop * (lidHeight - 3*$materialThickness) / lidHeight;
    stabOffset = otherLidBase + triangleStab - 2*$materialThickness;
    translate([lidHeight - $materialThickness, 2*crenelWidth,lidRadius + 2 * $materialThickness])
      rotate([90,0,90])
      hole_crenel(crenelReps - 1, crenelWidth);
    translate([lidHeight - $materialThickness, 2*crenelWidth,stabOffset])
      rotate([90,0,90])
      hole_crenel(crenelReps -1, crenelWidth);
  }
}

module otherLid(spread = false) {
  color("white")
    otherSide();
  color("white")
  translate([0, $boxWidth - $materialThickness + (spread? 10 : 0), 0])
    otherSide();
  color("blue")
  translate([0, (spread? 5: 0), 0])
    otherCover();

  color("green")
  translate([lidHeight - 3* $materialThickness - (spread? 10 : 0), spread? 5: 0, lidRadius + 2 * $materialThickness]) 
    stabiliser(false);

  triangleTop = otherLidTop - otherLidBase;
  triangleStab = triangleTop * (lidHeight - 3*$materialThickness) / lidHeight;
  stabOffset = otherLidBase + triangleStab - 2*$materialThickness;
  color("green")
  translate([lidHeight - 3* $materialThickness - (spread? 10 : 0), spread? 5: 0, stabOffset]) 
    stabiliser(false);
}
//!otherLid(true);

module standCoverFlatten() {
  flattenLength = PI * .5 * ($lidRadius - $materialThickness);
  difference() {
    union () {
      cube([heightClearance, $boxWidth, $materialThickness]);

      translate([heightClearance, 0, 0])
        cube([flattenLength, $boxWidth, $materialThickness]);

      if(standLidTop > lidRadius) {
        translate([heightClearance + flattenLength, 0, 0])
          cube([standLidTop - lidRadius, $boxWidth, $materialThickness]);
      }
    }
    crenel(6, heightClearance / 12);
    translate([0, $boxWidth, $materialThickness])
      rotate([180, 0, 0])
      crenel(6, heightClearance / 12);


    crenelWidth = ($boxWidth - 2*$materialThickness) / 20;
    translate([standLidTop - lidRadius + flattenLength + heightClearance, 0, 0])
      rotate([0, 0, 90])
      union() {
      translate([2*crenelWidth, 0,0])
        crenel(9, crenelWidth);
      translate([$materialThickness,0,0])
        crenel(1, crenelWidth/2);
      translate([$materialThickness + 19.5*crenelWidth, 0,0])
        crenel(1, crenelWidth/2);
      }

    translate([5, 0, -margin]) {
      for(i=[0:2:$horizontalPlacements - 1]) {
        translate([0,2*$materialThickness+margin + (($thickGap - 2*margin - 14 )/ 2)+ i*($thickGap + $materialThickness), 0]) {
          cylinder_outer(2*margin+$materialThickness, 1.5, fn=25);
          translate([0,14,0])
            cylinder_outer(2*margin+$materialThickness, 1.5, fn=25);
        }
      }
    }
  }
}

/*
flattenLength = PI * .5 * ($lidRadius - $materialThickness);
translate([standLidTop - 2*lidRadius + flattenLength + heightClearance,0,lidHeight])
rotate([0,90,0])
standCover();
*/

module otherCoverFlatten() {
  flattenLength = PI * .5 * ($lidRadius - $materialThickness);
  difference () {
    union () {
      cube([heightClearance, $boxWidth, $materialThickness]);
      translate([heightClearance, 0, 0])
        cube([flattenLength, $boxWidth, $materialThickness]);
      
      translate([heightClearance + flattenLength, 0, 0])
        cube([otherLidTop - lidRadius, $boxWidth, $materialThickness]);
    }
    translate([0, 0, 0])
      crenel(6, heightClearance / 12);
    translate([0, $boxWidth, $materialThickness])
      rotate([180, 0, 0])
      crenel(6, heightClearance / 12);
    translate([heightClearance + flattenLength,0,0])
      crenel(6, (otherLidTop - lidRadius) / 12);
    translate([heightClearance + flattenLength,$boxWidth,0])
      rotate([180,0,0])
      crenel(6, (otherLidTop - lidRadius) / 12);
    crenelReps = 10;
    crenelWidth = ($boxWidth - 2*$materialThickness) / (2*crenelReps);
    triangleTop = otherLidTop - otherLidBase;
    triangleStab = triangleTop * (lidHeight - 3*$materialThickness) / lidHeight;
    stabOffset = otherLidBase + triangleStab - 2*$materialThickness;
    translate([heightClearance + flattenLength + 3*$materialThickness, 2*crenelWidth,0])
      rotate([0,0,90])
      hole_crenel(crenelReps - 1, crenelWidth);
    translate([heightClearance + flattenLength + stabOffset - lidRadius + $materialThickness, 2*crenelWidth,0])
      rotate([00,0,90])
      hole_crenel(crenelReps -1, crenelWidth);
    translate([5, 0, -margin]) {
      for(i=[0:2:$horizontalPlacements - 1]) {
        translate([0,2*$materialThickness+margin + (($thickGap - 2*margin - 14 )/ 2)+ i*($thickGap + $materialThickness), 0]) {
          cylinder_outer(2*margin+$materialThickness, 1.5, fn=25);
          translate([0,14,0])
            cylinder_outer(2*margin+$materialThickness, 1.5, fn=25);
        }
      }
    }

  }
}
/*
flattenLength = PI * .5 * ($lidRadius - $materialThickness);
translate([standLidTop - 2*lidRadius + flattenLength + heightClearance,0,lidHeight])
rotate([0,90,0])
otherCover();
*/
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

module standSide_() {
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

module standLid_() {
  standSide_();

  color("red")
  translate([0, width - $materialThickness, 0])
    standSide_();

  color("blue")
  roundedSide();

  color("green")
  translate([flatHeight + circularRadius - $materialThickness - 10, 0, circularRadius - $materialThickness])
    stabiliser(true);
}


module otherSide_() {
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
        standSide_();
        // some quick rendering cleanup
        translate([0, 0.5 * $materialThickness, 0])
          standSide_();
        translate([0, -0.5 * $materialThickness, 0])
          standSide_();
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
    #difference() {
      translate([0, 0, lidDepth - $materialThickness])
        cube([flatHeight + flattenLength, width, $materialThickness]);

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

module lid(spread = false) {
  color("blue")
    standLid(spread);

  translate([0, $boxWidth + (spread? 10: 0), $boxDepth + (spread? 25: 0)])
    rotate([180, 0, 0])
    otherLid(spread);
}
//lid(spread = true);
