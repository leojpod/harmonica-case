/*
 * This file regroup all the common dimensions, angles, and repetitions
 */

// how many harmonica do you want to store on a given row?
$horizontalPlacements = 5;
$verticalPlacements = 3;

/* hole around the harmonica
 *    ______________
 *   /             /|
 *  /_____________/ | <- height_gap
 *  |             | |
 *  |             | /
 *  |_____________|/ <- thick_gap
 *       ^ length_gap
 */
$thickGap = 25;
//$height_gap = 30; <- this one was a bit tight for Seydels and too tight for the old golden melody
$heightGap = 35; // <- I'll increase that somewhat so I can also install some felt inside the box.
$lengthGap = 105;

// base material thickness, this represent the thickness of the most commonly used material.
$materialThickness = 4;

/* On different rows, harmonica will be seating more or less deelply inside (higher rows deepers than lower ones).
 * You'll probably want to tweak that a bit:
 * - make then seat far enough that the lid doesn't need to be too huge to cover them
 * - not too far so that they are easy to pick up
 * - have a good difference between the different rows so you can see them all nicely
*/
$minHarpSeating = 55;
$maxHarpSeating = 85;

// the difference between the harp seatings dictates how slanted should the inside slant be.
deltaSeating = $maxHarpSeating - $minHarpSeating;
deltaHeight = ($heightGap + $materialThickness) * ($verticalPlacements - 1);
$slantAngle = 90 - atan(deltaHeight / deltaSeating);
echo("slant angle -> ", $slantAngle);


/*
 * inset looks like: 
 *
 * =================================== <- outset border
 * |\
 * | \ <-     maxHarpSeating     ->
 * |  \----------------------------
 * |   \
 * |    \
 * |     \-------------------------      <- vertical separator
 * |      \
 * |       \
 * |        \----------------------
 * | slant ->\
 * |          \<- minHarpSeating ->
 * ===================================
 *                                 \_/ 
 *                                  ^outsetMargin
 *  \_________insetLength_________/
 */

// how far should the inset goes?
insetHeight = $heightGap + ($heightGap + $materialThickness) * ($verticalPlacements - 1);
slantDeltaLength = insetHeight * deltaSeating / deltaHeight;
$insetMargin = 10;
$insetLength = $minHarpSeating + slantDeltaLength + $materialThickness + $insetMargin;
echo("insetLength -> ", $insetLength);
// how much futher should the outset cover?
$outsetMargin = 5;

// Box dimensions: 
$boxWidth = $horizontalPlacements * ($thickGap + $materialThickness) + $materialThickness;
$boxHeight = $insetLength + $outsetMargin;
$boxDepth = $verticalPlacements * ($heightGap + $materialThickness) + $materialThickness;

// the angle at which the box should sit when the lid is opened
// !TODO adjust the angle if you want a flat part on the top of the standing lid
$boxTiltingAngle = 35;
