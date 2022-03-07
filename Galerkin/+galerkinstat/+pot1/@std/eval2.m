function data = eval2( obj, varargin )
%  EVAL2 - Evaluate w/o refinement for all boundary element pairs.
%
%  Usage for obj = galerkinstat.pot1.std :
%    data = eval2( obj )
%  Output
%    data   :  Green function and normal derivative

%  integration points 
[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );
%  dummy indices for internal tensor class
[ i1, i2, a1, a2, q1, q2, k ] = deal( 1, 2, 3, 4, 5, 6, 7 );

%  get integration points, weights and shape functions 
[ pos1, w1, f1 ] = eval( pt1 );
[ pos2, w2, f2 ] = eval( pt2 );  

%  distance
d = pdist2( reshape( pos1, [], 3 ), reshape( pos2, [], 3 ) );
d = tensor( reshape( d, [ size( w1 ), size( w2 ) ] ), [ i1, q1, i2, q2 ] );
    
%  positions 
pos1 = tensor( pos1, [ i1, q1, k ] ); 
pos2 = tensor( pos2, [ i2, q2, k ] ); 
%  normal vector
nvec = tensor( vertcat( pt1.tau.nvec ), [ i1, k ] );
%  shape functions including weights
f1 = tensor( f1, [ i1, q1, a1 ] ) * tensor( w1, [ i1, q1 ] );
f2 = tensor( f2, [ i2, q2, a2 ] ) * tensor( w2, [ i2, q2 ] );
    
%  Green function and normal derivative
G = sum( sum( f1 ./ d, q1 ) * f2, q2 );
F = - sum( dot( nvec, pos1 - pos2, k ) * ( f1 ./ d .^ 3 * f2 ), q1, q2 );

%  set output
G = double( G, [ i1, a1, i2, a2 ] ) / ( 4 * pi );
F = double( F, [ i1, a1, i2, a2 ] ) / ( 4 * pi );
%  set output
data = struct( 'G', G, 'F', F );
