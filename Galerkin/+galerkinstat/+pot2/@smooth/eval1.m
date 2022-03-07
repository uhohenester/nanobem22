function obj = eval1( obj )
%  EVAL1 - Precomute elements for quasistatic potentials.

%  evaluation and integration points 
[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );

%   evaluation points
pos1 = vertcat( pt1.pos );
n = size( pos1, 1 );
%  compute gradient of G and F using finite differences 
eta = 1e-6;
pos1 = repmat( reshape( pos1, n, 1, 3 ), 1, 4, 1 );
for k = 1 : 3
  pos1( :, k, k ) = pos1( :, k, k ) + eta;
end
%  unique boundary elements
[ ~, i1, i2 ] = unique( vertcat( pt2.tau.pos ), 'rows' );
  
%  boundary element integration using analytic integration
%  see Hänninen et al., PIERS 63, 243 (2006).
switch size( pt2.tau( 1 ).verts, 2 )
  case 3
    pot3 = potbase3( pt2.tau( i1 ) );
    %  integration over boundary elements
    [ G, F ] = stat2( pot3, pos1, i2 );
    %  permute arrays
    G = permute( G, [ 1, 3, 2 ] );
    F = permute( F, [ 1, 3, 2 ] );
end

%  Green function and gradient of G
data.G = G( :, 4, : ) / ( 4 * pi );
data.G1 = cat( 2,  ...
  G( :, 1, : ) - G( :, 4, : ),  ...
  G( :, 2, : ) - G( :, 4, : ),  ...
  G( :, 3, : ) - G( :, 4, : ) ) / ( 4 * pi * eta );
%  gradient of F
data.F1 = cat( 2,  ...
  F( :, 1, : ) - F( :, 4, : ),  ...
  F( :, 2, : ) - F( :, 4, : ),  ...
  F( :, 3, : ) - F( :, 4, : ) ) / ( 4 * pi * eta );

%  save precomputed potential data
obj.data = data;
