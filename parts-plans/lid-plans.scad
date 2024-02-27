include <./../3d-models/dimensions.scad>
include <./../3d-models/lid.scad>

module standSideLayout() {
  rotate([90, 0,0])
  standSide();
}
module standCoverLayout() {
  standCoverFlatten();
}
module stabiliserWithOverheadLayout() {
  stabiliser(true);
}

module otherSideLayout() {
  rotate([90, 0,0])
  otherSide();
}
module otherCoverLayout() {
  otherCoverFlatten();
}
module stabiliserLayout() {
  stabiliser();
}
projection(cut= true) {
  //standSideLayout();
  //standCoverLayout();
  //stabiliserWithOverheadLayout();

  //otherSideLayout();
  otherCoverLayout();
  //stabiliserLayout();
}
