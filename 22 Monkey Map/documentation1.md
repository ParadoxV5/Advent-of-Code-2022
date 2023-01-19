It looks like the puzzle only involves rectangular blocks stacked on top of one other.
The strategies, however, are applicable for any map of any configuration of one or more shapes connected or disjoint.

There is ambiguity with the meaning of **wrap around** with arbitrary shapes, though,
if a row or column has more than one continuous chunk of land (**open tile** or **solid wall**).
Specifically, if one of the following configurations makes up the board: 
  * two or more disjoint shapes;
  * a shape with a hole; or
  * one orthogonally concave shape.

In those board shapes, one can interpret wrapping around from one edge as either:
1. *Local Wrap Around*: *You* would wrap to the other edge of the same chunk of land.
2. *Global Wrap Around*: *You* would wrap to the closer edge of the next chunk of land in front of you.
   The first and last chunks of land wrap to each other as expected.

Algorithms differ slightly for the two interpretations regardless of the strategy.
Both are compatible with board shapes whose rows and columns all have one chunk of land –
i.e., comprised of a single orthogonally convex shape – such as the puzzle’s stack of rectangular blocks.

I came up with two strategies:

* _Brute-force with char table_
  
  This strategy is the most straightforward approach and is suitable for aiming at simplicity.
  For each forward instruction, *you* move forward a tile as long as the cell in front is `.` and interrupt upon a `#`.
  *Local Wrap Around* rewinds backward upon an edge of the chunk of land until the other edge,
  whereas *Global Wrap Around* slides through ` `s like ice physics without counting steps and wraps at array ends.
  
  
* _Compile to indices of board edges and walls_
  
  This strategy is more efficient in both time and space.
  One can represent each row’s and column’s chunks of land with the indices of their edges,
  plus a list for each row and column to record the indices of walls _or_ edges of chunks of wall.
  Record the current position with an x-y coordinate pair. Add the number of unobstructed tiles moved directly to them.
  The number of tiles moved is the smaller of the instructed count and the distance to the closest wall minus one.
  *Local Wrap Around* requires the count of instructed tiles first modulo-ed by the length of the current chunk of land,
  while *Global Wrap Around* requires transferring the excess steps to the next chunk of land in sequence.
  
Finally, if the movement instructions have enormous numbers,
both interpretations of strategies can modulo the numbers by the length of the currently applicable chunks of land.
This optimization applies is because either the divisible part of the steps would wrap back to where *you* began;
or a wall would have cut *your* steps short before you could complete a full lap.
