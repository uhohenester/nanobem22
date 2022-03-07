%  DEMOBOUNDARYVERT01 - Plot linear shape elements.

%  dummy material vector
mat = [];
%  touching triangles
verts = [ 0, 0, 0; 1, 0, 0; 1, 1, 0 ];
faces = [ 1, 2, 3 ];
%  boundary elements
tau1 = BoundaryVert( mat, particle( bsxfun( @plus, verts, [ 0.0, 0, 0 ] ), faces ), [ 2, 1 ] );
tau2 = BoundaryVert( mat, particle( bsxfun( @plus, verts, [ 1.5, 0, 0 ] ), faces ), [ 2, 1 ] );
tau3 = BoundaryVert( mat, particle( bsxfun( @plus, verts, [ 3.0, 0, 0 ] ), faces ), [ 2, 1 ] );

plot( tau1, [ 1; 0; 0 ] );
plot( tau2, [ 0; 1; 0 ] );
plot( tau3, [ 0; 0; 1 ] );

view( 0, 90 );
