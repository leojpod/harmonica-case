harmonicaHeight = 30;
harmonicaLength = 105;
harmonicaThickness = 20;

module harmonicaBody() {
    translate([0, ($thick_gap - harmonicaThickness) / 2, 0])
    cube([harmonicaLength, harmonicaThickness, harmonicaHeight]);
}

rotate([0,90,0])
  translate([-harmonicaLength,0,0])
  harmonicaBody();
