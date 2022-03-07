function verts = vertices( obj )
%  VERTICES - Vertices of boundary elements with same shape.
%
%  Usage for obj = BoundaryElement :
%    verts = vertices( obj )
%  Output
%    verts    :  vertices of boundary elements

%  number of edges
n = unique( horzcat( obj.nedges ) );
assert( isscalar( n ) );
%  vertices
[ ~, i1, i2 ] = unique( vertcat( obj.pos ), 'rows' );
verts = reshape( vertcat( obj( i1 ).verts ), n, [], 3 );
verts = permute( verts( :, i2, : ), [ 2, 1, 3 ] );
