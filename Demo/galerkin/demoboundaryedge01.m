%  DEMOBOUNDARYEDGE01 - Plot Raviart-Thomas shape elements.

%  dummy material vector
mat = [];
%  touching triangles
verts = [ 0, 0, 0; 1, 0, 0; 0, 1, 0 ];
faces = [ 1, 2, 3 ];
%  boundary element
tau = BoundaryEdge( mat, particle( verts, faces ), [ 2, 1 ] );

%  quadrature points
quad = quadboundary( tau, 'quad3', triquad( 19 ) );
%  quadrature positions and Raviart-Thomas shape elememts
[ pos, ~, f ] = eval( quad );

%  loop over shape elements
for a = 1 : 3
  %  offset
  x0 = ( a - 1 ) * 1.5;
  %  plot triangle
  plot( x0 + [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], 'k-' );  hold on
  quiver( x0 + pos( 1, :, 1 ), pos( 1, :, 2 ),  ...
    f( 1, :, a, 1 ), f( 1, :, a, 2 ) );
end

axis equal tight off
