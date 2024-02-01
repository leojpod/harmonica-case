# 3d Models

Quick summary of the files and what they are used for:

- `dimansions.scad`: regroups different parameters that control the whole thing, mainly, how thick is the material we're working with, how big should be the holds for the harmonicas, how many holds should there be, etc.
- `box-inset.scad`: modelises the horizontal and vertical separators that go inside the box.
- `box-outset.scad`: modelises the outside of the box, this will hold the inset in place and the lid parts are going to attach to it.
- `lid.scad`: contains the 2 parts that are used for the lid.
- `string-lock.scad`: modelises the small things on the side that are used to hold the lid shut.
- `pop-rivet.scad`: was supposed to be used to seal the lid's hinges and the locks on the sides, but in the end I opted for real rivets.
