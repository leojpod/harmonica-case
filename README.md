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

### 3 by 5 box

#### laser-cut pieces

All the pieces are cut on some 4 mm thick laminated wood.

- For the inset:
  - [ ] 1 horizontal plank
  - [ ] 1 slant plank
  - [ ] 2 even vertical separators
  - [ ] 2 odd vertical separators
- For the outset:
  - [ ] 1 bottom
  - [ ] 2 long side "a"
  - [ ] 2 long side "b"
  - [ ] 2 short side "a"
  - [ ] 2 short side "b"
- For the lid-lock:
  - [ ] 1 example support (optional to check the lock works)
  - [ ] 10 holders
  - [ ] 4 handles
  - [ ] 2 long slider base
  - [ ] 2 short slider base
- For the lid:
  - [ ] the "stand lid part"
    - [ ] 2 stand side
    - [ ] 1 "stand" cover
    - [ ] 1 stabiliser with overhead
  - [ ] the "other lid part"
    - [ ] 2 "other" side
    - [ ] 2 stabilisers without overhead
    - [ ] 1 "other" cover

### Other pieces & material

- the lid lock
  - **_TODO find one and explain it here_**
- the lid hinge joins
  - **_TODO Same_**
- the carry strings
  - **_TODO Same_**
