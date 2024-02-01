use <./utils/cylinder-outer.scad>

rivetDiameter= 3.4;
clearingDiameter= 7;
lockDiameter= 14;
lockShortDiameter = 8;
lockHeight= 4;

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

module stringLock() {
  difference() {
  union() {
    translate([0,0,lockHeight ])
    #roundedFace(2, lockDiameter * 0.7);
    rotate_extrude(convexity = 10, $fn = 50)
    polygon(points = [[0,0], [lockDiameter/2, 0], [lockShortDiameter/2, lockHeight / 2], [lockDiameter/2.4, lockHeight], [0, lockHeight]]);
  }
  translate([0,0,-lockHeight])
  cylinder_outer(lockHeight * 4, rivetDiameter / 2, fn = 50);

  translate([0,0, 2])
  #cylinder_outer(lockHeight * 2, (clearingDiameter / 2), fn= 50);
  }
}



stringLock();
