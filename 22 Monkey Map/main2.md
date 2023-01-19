Part 2 revealed the stack of blocks as a net of a closed 3D surface. Hah! This difference changes many aspects.
Orthogonal convexness no longer applies, for a net must be generally concave else it doesn’t fold.
Additionally, *Global Wrap Around* now takes the wheel to wrap *you* from one polyhedron surface to another.

Both strategies are still applicable (except *Local Wrap Around* is now out of the window);
only the wrapping connections have changed and now require updating the direction *you*’re currently facing.

Conveniently, Part 2 has specified the 3D surface to be a cube with side lengths of 50 tiles;
generalization to any rectangular prism is another challenge, let alone any rectangular polyhedra.
Knowing the net is valid,
programmatically converting the squares into 3Dly oriented cube faces only takes a quick traversal of 6 elements
(including the root).
