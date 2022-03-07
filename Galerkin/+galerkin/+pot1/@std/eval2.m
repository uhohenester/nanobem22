function data = eval2( obj, k1, varargin )
%  EVAL2 - Evaluate w/o refinement for all boundary element pairs.
%
%  Usage for obj = galerkin.pot1.std :
%    data = eval2( obj, k1 )
%  Input
%    k1       :  wavenumber of light in medium
%  Output
%    data     :  single and double layer potential

%  integration points 
[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );
%  integration points, weights and shape functions
[ pos1, w1, f1, fp1 ] = eval( pt1 );
[ pos2, w2, f2, fp2 ] = eval( pt2 );
%  number of boundary elements and integration points
[ n1, m1 ] = deal( size( w1, 1 ), size( w1, 2 ) );
[ n2, m2 ] = deal( size( w2, 1 ), size( w2, 2 ) );
%  multiply shape functions with integration weights
f1  = reshape( bsxfun( @times, reshape( f1,  numel( w1 ), [] ), w1( : ) ), size( f1  ) );
f2  = reshape( bsxfun( @times, reshape( f2,  numel( w2 ), [] ), w2( : ) ), size( f2  ) );
fp1 = reshape( bsxfun( @times, reshape( fp1, numel( w1 ), [] ), w1( : ) ), size( fp1 ) );
fp2 = reshape( bsxfun( @times, reshape( fp2, numel( w2 ), [] ), w2( : ) ), size( fp2 ) );

%  cross product of position and shape function
g1 = cross( tensor( f1, [ 1, 2, 3, 4 ] ), tensor( pos1, [ 1, 2, 4 ] ), 4 );
g2 = cross( tensor( f2, [ 1, 2, 3, 4 ] ), tensor( pos2, [ 1, 2, 4 ] ), 4 );
%  convert to numeric
g1 = double( g1( 1, 2, 3, 4 ) );
g2 = double( g2( 1, 2, 3, 4 ) );
%  reshape functions
fun1 = @( f, a ) reshape( f( :, :, a, : ), [], 3 );
fun2 = @( f, a ) reshape( f( :, :, a ), [], 1 );

%  Green function and derivative
d = reshape( pdist2( reshape( pos1, [], 3 ),  ...
                     reshape( pos2, [], 3 ) ), [ n1, m1, n2, m2 ] );
G = exp( 1i * k1 * d ) ./ ( 4 * pi * d );
F = ( 1i * k1 - 1 ./ d ) .* G ./ d;
%  allocate output
[ SL, DL ] = deal( zeros( n1, pt1.npoly, n2, pt2.npoly ) );

%  loop over edges
for a1 = 1 : pt1.npoly
for a2 = 1 : pt2.npoly
  %  single layer potential
  ff = fun1( f1,  a1 ) * fun1( f2,  a2 )' -  ...
       fun2( fp1, a1 ) * fun2( fp2, a2 )' / k1 ^ 2;
  SL( :, a1, :, a2 ) =  ...
  SL( :, a1, :, a2 ) + sum( sum( reshape( ff, n1, m1, n2, m2 ) .* G, 2 ), 4 );
  %  double layer potential
  ff = fun1( g1, a1 ) * fun1( f2, a2 )' + fun1( f1, a1 ) * fun1( g2, a2 )';
  DL( :, a1, :, a2 ) =  ...
  DL( :, a1, :, a2 ) - sum( sum( reshape( ff, n1, m1, n2, m2 ) .* F, 2 ), 4 );  
end
end

%  set output
data = struct( 'SL', SL, 'DL', DL );
