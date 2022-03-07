function [ v1, v2 ] = interp( obj, x, y, v, varargin )
%  INTERP - Interpolate array values to boundary elements.
%
%  Usage for obj = BoundaryEdge :
%    vi = interp( obj, x, y, v )
%  Input
%    v      :  value array 
%  Output
%    v1     :  values interpolated to boundaries
%    v2     :  divergence of V1

%  reshape input array
siz = size( v );
v = reshape( v, size( v, 1 ), [] );
%  assign values to boundary elements
v = reshape( v( vertcat( obj.nu ), : ), numel( obj ), obj( 1 ).nedges, [] );

%  Raviart-Thomas shape function
[ f, fp ] = basis( obj, x, y, varargin{ : } );
[ m, n ] = deal( size( f, 1 ), size( f, 2 ) );
%  interpolation f(i,q,a,k)*v(i,a,j)
v1 = sum( tensor( f, [ 1, 2, 3, 4 ] ) * tensor( v, [ 1, 3, 5 ] ), 3 );
v2 = sum( tensor( fp,   [ 1, 2, 3 ] ) * tensor( v, [ 1, 3, 5 ] ), 3 );
%  convert to numeric
v1 = reshape( double( v1, [ 1, 2, 4, 5 ] ), m, n, 3, siz( 3 : end ) );
v2 = reshape( double( v2, [ 1, 2,    5 ] ), m, n,    siz( 3 : end ) );

