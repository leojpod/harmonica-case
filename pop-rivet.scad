use <./cylinder-outer.scad>
pipeDiameter = 2.8;
flatDiameter = 6;
thickness = 1;


module roundedFace (thickness, diameter) {
  radius = diameter / 2;
  echo("radius: " , radius);
  sphereRadius = radius * radius / (2*thickness) + thickness*thickness;
  echo("sphere radius: " , sphereRadius);
  difference() {
    translate([0,0, - sphereRadius + thickness])
    sphere(r = sphereRadius, $fn = 50);
translate([-sphereRadius, -sphereRadius, - 2 * sphereRadius ])
    cube(sphereRadius * 2);
  }
}

module pipe(length) {
  translate([0,0,-length])
  cylinder(h = length, d = pipeDiameter, $fn = 50);
}

module popEnd(thickness_) {
  union() {
    cylinder_outer(thickness_, pipeDiameter / 2, fn = 50);
    translate([0,0,thickness_])
    mirror([0,0,1])
    rotate_extrude(convexity = 10, $fn = 50)
    translate([pipeDiameter/2, 0])
    intersection() {
      circle(r = thickness_, $fn = 50);
      square(thickness_);
    }
  }
}

module popRivet(pipeLength) {
  difference() {
    union() {
      translate([0,0,-thickness])
      roundedFace(thickness, flatDiameter);

      translate([0,0,-thickness])
      pipe(pipeLength);

      translate([0,0,-1.4*thickness -pipeLength])
      popEnd(thickness * 0.6);
    }

    translate([-thickness*0.8/2,-flatDiameter, -3 * thickness])
    mirror([0,0,1])
    cube([thickness*0.8, flatDiameter * 2 , flatDiameter * 2]);
  }
}

module popRivetReverse(pipeLength) {
  union() {
    difference() {
      translate([0,0,-thickness * 0.6])
      roundedFace(thickness, flatDiameter);

      translate([0,0,0])
      mirror([0,0,1])
      popEnd(thickness * 0.6);
    }
    translate([-thickness * 0.4, - pipeDiameter * 0.5, - thickness - pipeLength])
    cube([thickness * 0.8, pipeDiameter, thickness + pipeLength]);
  }
}


popRivet(pipeLength = 6);

translate([10,10, - thickness * .4])
popRivetReverse(pipeLength = 6 - 3.5 * thickness);

module stuff() {
  difference() {
    cylinder(h= 6, d = 4 + 2, $fn = 100);

    #cylinder_outer(6 + 4, 2, fn=100);
  }
}

/* stuff(); */

