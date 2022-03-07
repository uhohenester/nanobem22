function data = eval2( obj, varargin )
%  EVAL2 - Default evaluation for all points and boundary elements.
%
%  Usage for obj = galerkinstat.pot2.std :
%    data = eval2( obj )
%  Output
%    data     :  single and double layer potential

[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 ); 
%  evaluation points 
pos1 = eval( pt1 );
n1 = size( pos1, 1 );
%  integration points, weights and shape functions
[ pos2, w2, f2 ] = eval( pt2 );
n2 = size( pos2, 1 );
%  multiply shape functions with integration weights
f2 = reshape( bsxfun( @times, reshape( f2,  numel( w2 ), [] ), w2( : ) ), size( f2  ) );

%  dummy indices for internal tensor class
[ i1, i2, a2, q2, k ] = deal( 1, 2, 3, 4, 5 );
%  distance 
d = reshape( pdist2( pos1, reshape( pos2, [], 3 ) ), n1, n2, [] );
d = tensor( d, [ i1, i2, q2 ] );
%  convert positions and shape functions to tensors
pos1 = tensor( pos1, [ i1, k ] );
pos2 = tensor( pos2, [ i2, q2, k ] );
f2  = tensor( f2, [ i2, q2, a2 ] );
%  outer surface normal and unit vector
nvec = tensor( vertcat( pt2.tau.nvec ), [ i2, k ] );
u = ( pos1 - pos2 ) ./ d;

%  Green function and derivative
G = 1 ./ ( 4 * pi * d );
G1 = - u ./ ( 4 * pi * d .^ 2 );
%  derivative of F
F1 = ( nvec - 3 * u * dot( nvec, u, k ) ) ./ ( 4 * pi * d .^ 3 );

%  perform integration
G  = double( sum( G  * f2, q2 ), [ i1,    i2, a2 ] );
G1 = double( sum( G1 * f2, q2 ), [ i1, k, i2, a2 ] );
F1 = double( sum( F1 * f2, q2 ), [ i1, k, i2, a2 ] );

%  set output
data = struct( 'G', G, 'G1', G1, 'F1', F1 );
