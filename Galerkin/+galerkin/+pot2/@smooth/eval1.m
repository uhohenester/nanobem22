function obj = eval1( obj )
%  EVAL1 - Precomute elements for single and double layer potential.

%  evaluation and integration points 
[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );

%   evaluation points
pos1 = vertcat( pt1.pos );
n = size( pos1, 1 );
%  compute gradient of K1 using finite differences 
eta = 1e-6;
pos1 = repmat( reshape( pos1, n, 1, 3 ), 1, 4, 1 );
for k = 1 : 3
  pos1( :, k, k ) = pos1( :, k, k ) + eta;
end
%  unique boundary elements
[ ~, i1, i2 ] = unique( vertcat( pt2.tau.pos ), 'rows' );
  
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
  %  gradient of K1
  K1{ it } = cat( 2,  ...
    ( K1{ it }( :, 1, : ) - K1{ it }( :, 4, : ) ) / eta,  ...
    ( K1{ it }( :, 2, : ) - K1{ it }( :, 4, : ) ) / eta,  ...
    ( K1{ it }( :, 3, : ) - K1{ it }( :, 4, : ) ) / eta );
  K1{ it } = permute( K1{ it }, [ 1, 3, 2 ] );
  %  single and double layer potential
  siz = [ n, pt2.npoly, 3 ]; 
  data.SL{ 1, it } = reshape( K1{ it }, siz ) / ( 4 * pi );
  data.SL{ 2, it } = reshape( K2{ it }( :, 4, :, : ), siz ) / ( 4 * pi );
  data.DL{ 1, it } = reshape( K4{ it }( :, 4, :, : ), siz ) / ( 4 * pi );
end

%  save precomputed SL and DL potential data
obj.data = data;
