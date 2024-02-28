include <./../3d-models/dimensions.scad>
use <./../3d-models/lid-lock.scad>

margin = $margin;

module pivotAssemblyLayout() {
  pivot();
  translate([2*$materialThickness + margin, 0, 0])
    rotate([0, 90, 0])
    insertA();
  translate([$materialThickness + margin, -$materialThickness -margin, 0])
    rotate([90,0,0])
    insertB();
}

module movingArmLayout(length) {
  translate([-2*$materialThickness, 0, 0])
  movingArm(length);
}

module oblongPivotAssemblyLayout() {
  oblongPivot();
  translate([4*$materialThickness+margin, -margin, 0])
    rotate([0,90,-90])
    insertD();

  translate([8*$materialThickness +margin,0,0])
    rotate([90,0,180])
    insertC();
}

module offCenterPieceLayout() {
  offCenterPiece();
}

module exampleSupport() {
  difference() {
    cube([150,150, $materialThickness]);
    translate([40,40,$materialThickness-1])
    slideLock();
  }
}

module holderLayout() {
  holder();
}
module handleLayout() {
  rotate([90, 0,0])
    handle();
}
module longSliderBaseLayout() {
  longSliderBase(40);
}
module shortSliderBaseLayout() {
  handlePlacement = 30-3.5*$materialThickness;
  shortSlider(handlePlacement);
}

projection(cut = true) {
  holderLayout();
  //handleLayout();
  //longSliderBaseLayout();
  //shortSliderBaseLayout();
  
  //exampleSupport();
}
