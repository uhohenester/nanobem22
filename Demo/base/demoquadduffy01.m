%  DEMOQUADDUFFY01 - Quadrature rules for identical and touching triangles.

%  dummy material vector
mat = [];
%  touching triangles
verts = [ 0, 0, 0; 1, 0, 0; 1, 1, 0; 0, 1, 0 ];
faces = [ 1, 2, 3; 3, 4, 1 ];
%  boundary elements
p = particle( verts, faces );
tau = BoundaryEdge( mat, p, [ 2, 1 ] );

%  Duffy integration points
quad = quadduffy( tau( [ 1, 1 ] ), tau( [ 1, 2 ] ), 3, 'rows', 1 );

%  loop over integrators
for it = 1 : numel( quad )
  %  quadrature points
  pos1 = squeeze( eval( quad( it ), 1 ) );
  pos2 = squeeze( eval( quad( it ), 2 ) );
  %  plot quadrature points
  plot( pos1( :, 1 ) + 1.5 * ( it - 1 ), pos1( :, 2 ), 'b.' );  hold on
  plot( pos2( :, 1 ) + 1.5 * ( it - 1 ), pos2( :, 2 ), 'ro', 'MarkerSize', 3 );
end

axis equal tight off
