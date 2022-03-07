function obj = eval1( obj )
%  EVAL1 - Precomute elements for single and double layer potential.

%  integration points 
[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );

%  unique boundary elements
[ ~, i1, i2 ] = unique( vertcat( pt2.tau.pos ), 'rows' );
%  get integration points, weights and shape functions 
[ pos1, w1, f1, fp1 ] = eval( pt1 );  

%  dummy indices for internal tensor class
[ i, a1, a2, k, q1 ] = deal( 1, 2, 3, 4, 5 );
%  transform to internal tensor class
f1  = tensor( f1,  [ i, q1, a1, k ] );
fp1 = tensor( fp1, [ i, q1, a1    ] );
w1  = tensor( w1,  [ i, q1 ] );
  
%  boundary element integration using analytic integration
%  see Hänninen et al., PIERS 63, 243 (2006).
switch pt2.npoly
  case 3
    pot3 = potbase3( pt2.tau( i1 ), 'order', 3 );
    %  integration over boundary elements
    [ K1, K2, K4 ] = ret2( pot3, pos1, i2 );
end

%  allocate output
data.SL = cell( 2, 2 );
data.DL = cell( 1, 2 );
%  loop over orders
for it = 1 : 2
  %  extract input
  k1 = tensor( K1{ it }, [ i, q1, a2    ] );
  k2 = tensor( K2{ it }, [ i, q1, a2, k ] );
  k4 = tensor( K4{ it }, [ i, q1, a2, k ] );
  %  single and double layer potential terms
  k1 = sum( ( fp1 * w1 ) * k1, q1 );
  k2 = sum( ( f1  * w1 ) * k2, q1, k );
  k4 = sum( ( f1  * w1 ) * k4, q1, k );
  %  refined integrations for single and double layer potential
  data.SL{ 1, it } = double( k1( i, a1, a2 ) ) / ( 4 * pi );
  data.SL{ 2, it } = double( k2( i, a1, a2 ) ) / ( 4 * pi );
  data.DL{ 1, it } = double( k4( i, a1, a2 ) ) / ( 4 * pi );
end

%  save precomputed data
obj.data = data;
%  change quadrature points for boundaries
if ~isempty( obj.rules2 )
  obj.pt1 = quadboundary( obj.tau1, obj.rules2 );
  obj.pt2 = quadboundary( obj.tau2, obj.rules2 );
end
