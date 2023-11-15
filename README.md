# An application of the Swift simd library

Once upon a time, some kid from Wisconsin who thinks he’s going to write video games for a living asked the internet to do his homework for him.

This is the URL of his job post:

https://www.upwork.com/jobs/~0149e331c40a0b1b2a

Just in case the post has been edited, deleted, or marked private by the time you read this, the original text is pasted below:

> I need a very straight forward problem solved in Swift.  I have two Cartesian grids overlaid, one on top of the other, but not aligned.  I have a rectangle in the middle, and I know the coordinates of the four corners of the rectangle in both grid systems.  I need you to take this information and create a function that can transform coordinates in one of the two systems into coordinates in the other system.
>
> I'll explain slightly more:
>
> In one grid system the corners are located at (0,0), (0,1), (1,0) and (1,1).
In the other grid system the corners are located at (205,-55), (385,-55), (205,160) and (385,160)
>
> I need a function written in Swift that allows me to pass in any coordinate in grid 1 and it transforms the coordinate and returns the coordinate in the grid 2 system.  And I need a function that can do the reverse transformation also, grid 2 to grid 1.
>
> I need the setup or init to allow me to set coordinate pairs - the corners of the rectangle in both grid systems.  So the functions need to be dynamic, based on this initial set of 4 coordinate pairs (the corners of the rectangle).

This is, of course, just a change-of-basis operation for a 2-dimensional vector space over the real numbers. Like any change-of-basis operation, it is (and must be) a _linear_ operation.

Linear operations can be broken down into four primitive transformations:
- Translation
- Rotation
- Dilation (or scaling)
- Reflection

_**Note:** One can argue (successfully) that reflection is just dilation by a negative scale on one or more axes, but when coding, it’s often easier to treat it separately._

To code the solution, take two adjacent sides of the first rectangle and transform them into orthonormal basis vectors by applying each of the operations above, in the order listed.
- Translation maps the first corner of the rectangle to the origin.
- Rotation maps the second corner of the rectangle to the positive X axis.
- Dilation maps the rectangle into a square of unit dimension, but with ambiguous orientation along the Y axis.
- Finally, reflection maps the third corner to (0, 1) positively.

In other words, the first three corners of the rectangle get transformed to (0, 0), (1, 0), and (0, 1).

We then take the orthonormal basis vectors and map them to the corresponding sides of the second rectangle by applying an additional four primitive transformations, but this time in reverse order (i.e. translation goes last).

The composition of all eight primitive transformations forms the change-of-basis operation for mapping any point in one space to the other space.

# How to use

Clone the repo and open the Playground in Xcode.

Add your own tests, or copy the `Transformer` class wherever you need it.
