/*
 * This file regroup all the common dimensions, angles, and repetitions
 */

/* harmonica dimensions
 *    ______________
 *   /             /|
 *  /_____________/ | <- height_gap
 *  |             | |
 *  |             | /
 *  |_____________|/ <- thick_gap
 *    ^ length_gap
 */
$thick_gap = 25;
$height_gap = 30;
$length_gap = 105;

// base material thickness, this represent the thickness of the most commonly used material.
$material_thickness = 4;
// dictate how slanted should the inside slant be: if put to 0 then it's just a vertical wall (pointless), if put to 90° then it's a horizontal slant (also pointless)
// 20° was not slanted enough, 30° should be ok.
$slant_angle = 30;


// how far should the inset goes?
$insideHeight = 110;
// how much futher should the ouset cover?
$outsetMargin = 5;

// how many harmonica do you want to store on a given row?
$horizontalPlacements = 5;
// NOTE: there are 2 rows for now and the model isn't ready to change that part easily
