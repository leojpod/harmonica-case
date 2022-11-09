harmonicaHeight = 30;
harmonicaLength = 105;
HarmonicaThickness = 20;

module harmonicaBody() {
    cube([harmonicaLength, HarmonicaThickness, harmonicaHeight]);
}

rotate([0,90,0])
  translate([-harmonicaLength,0,0])
  harmonicaBody();
