function data = eval2( obj, k1, varargin )
%  EVAL2 - Default evaluation for all evaluation points and boundary elements.
%
%  Usage for obj = galerkin.pot2.std :
%    data = eval2( obj, k1 )
%  Input
%    k1       :  wavenumber of light in medium
%  Output
%    data     :  single and double layer potential

[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 ); 
%  evaluation points 
pos1 = eval( pt1 );
n1 = size( pos1, 1 );
%  integration points, weights and shape functions
[ pos2, w2, f2, fp2 ] = eval( pt2 );
n2 = size( pos2, 1 );
%  multiply shape functions with integration weights
f2  = reshape( bsxfun( @times, reshape( f2,  numel( w2 ), [] ), w2( : ) ), size( f2  ) );
fp2 = reshape( bsxfun( @times, reshape( fp2, numel( w2 ), [] ), w2( : ) ), size( fp2 ) );
 
%  distance
d = reshape( pdist2( pos1, reshape( pos2, [], 3 ) ), n1, n2, [] );
%  Green function and derivative
G = exp( 1i * k1 * d ) ./ ( 4 * pi * d );
F = ( 1i * k1 - 1 ./ d ) .* G ./ d;

%  dummy indices for internal tensor class
[ i1, i2, a2, q2, k ] = deal( 1, 2, 3, 4, 5 );
%  convert positions and shape functions to tensors
pos1 = tensor( pos1, [ i1, k ] );
pos2 = tensor( pos2, [ i2, q2, k ] );
f2  = tensor( f2,  [ i2, q2, a2, k ] );
fp2 = tensor( fp2, [ i2, q2, a2    ] );
%  convert Green function to tensor class
G = tensor( G, [ i1, i2, q2 ] );
F = tensor( F, [ i1, i2, q2 ] );

%  single and double layer potentials, Hohenester Eq. (5.34-35)
SL = sum( G * f2 + ( pos1 - pos2 ) * F * fp2 / k1 ^ 2, q2 );
DL = sum( - cross( pos1 - pos2, F * f2, k ), q2 );
%  bring to output shape
SL = double( SL( i1, i2, a2, k ) );
DL = double( DL( i1, i2, a2, k ) );

%  set output
data = struct( 'SL', SL, 'DL', DL );
