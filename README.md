# Harmonica carry-case (and show off stand)

## TL;DR
The idea is to create a case that can carry safely about 10 diatonic harmonicas.
The case should also open in a way that would allow to easily locate and pick up the desired harmonica.

## The story behind this
I used to put my harmonicas on my hand made stand-up desk, but I start to have too many to line up like in this picture.

![IMG_20221030_145218](https://user-images.githubusercontent.com/4479457/202927481-43aaefc8-f4df-43ff-afca-a8ba6212d1d5.jpg)

After a few drawing on paper, I thought "why not make something that could hold my harmonicas but also display them".
Few more paper draft later, I started to play with FreeCAD, but I was quite unhappy with it eventually, and I like the ability to "code" my model and to version it.

For specific information about each file, check their "headers".

## How to assemble it?

First, set up the variables in `dimensions.scad`, and make sure they match your harmonicas (or whatever you want to store) and the base material you wish to use.

Then check the `main.scad` file with OpenSCAD, and make sure it looks OK.
Don't hesitate to comment out part of the `BoxOutset` to see inside more easily.

The whole thing is meant to be assembled from laser cut parts.

### The laser cut pieces:

- For the inset:
  - 1 horizontal plank
  - 1 slant plank (to make sure the lower row of harmonicas sticks out more than the top row)
  - 2 sorts of vertical separators:
    - how many depends on how many harmonicas you want to have on a given row
    - For the default version: 2 vertical separators with front notch, and 2 with back notch

- For the outset:
  - 2 long sides (you might want to customize the outside facing part of this),
  - 2 short sides
  - 1 bottom

- For the lid (the lid is in 2 parts: the stand part -- that support the box when it's open, and the "other" -- that is folder over the top of the box when it's open ):
  - "stand" parts: 
    - 2 short sides
    - 1 stabiliser
    - 1 long cork side
  - "other" parts: 
    - 2 short sides
    - 1 long cork side

### Other pieces & material

- the lid lock
    - ***TODO find one and explain it here***
- the lid hinge joins
    - ***TODO Same***
- the carry strings
    - ***TODO Same***

