function v1 = interp( obj, x, y, v, varargin )
%  INTERP - Interpolate array values to boundary elements.
%
%  Usage for obj = BoundaryVert :
%    vi = interp( obj, x, y, v )
%  Input
%    x,y    :  quadrature points
%    v      :  value array 
%  Output
%    v1     :  values interpolated to boundaries

%  reshape input array
siz = size( v );
v = reshape( v, size( v, 1 ), [] );
%  assign values to boundary elements
v = reshape( v( vertcat( obj.nu ), : ), numel( obj ), obj( 1 ).nedges, [] );

%  shape function
f = basis( obj, x, y, varargin{ : } );
[ m, n ] = deal( size( f, 1 ), size( f, 2 ) );
%  interpolation f(i,q,a)*v(i,a,j)
v1 = sum( tensor( f, [ 1, 2, 3 ] ) * tensor( v, [ 1, 3, 4 ] ), 3 );
v1 = reshape( double( v1( 1, 2, 4 ) ), m, n, siz( 3 : end ) );
