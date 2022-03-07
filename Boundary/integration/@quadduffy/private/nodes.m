function [ x1, x2, x3, x4, w ] = nodes( n )
%  NODES - Integration positions and weights for four-fold integration.

%  integration positions and weights
[ x, w ] = lgwt( n, 0, 1 );

%  integration positions
[ x1, x2, x3, x4 ] = ndgrid( x );
[ x1, x2, x3, x4 ] = deal( x1( : ), x2( : ), x3( : ), x4( : ) );
%  integration weights
[ w1, w2, w3, w4 ] = ndgrid( w );
w = w1( : ) .* w2( : ) .* w3( : ) .* w4( : );
