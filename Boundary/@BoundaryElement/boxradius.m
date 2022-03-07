function rad = boxradius( obj )
%  BOXRADIUS - Bounding box radius.
%
%  Usage for obj = BoundaryElement :
%    rad = boxradius( obj )
%  Output
%    rad    :  bounding box radius

%  vector from vertices to centroid
p = arrayfun( @( x ) bsxfun( @minus, x.verts, x.pos ), obj, 'uniform', 0 );
%  bounding box radius
rad = cellfun( @( x ) max( sqrt( dot( x, x, 2 ) ) ), p, 'uniform', 1 );
