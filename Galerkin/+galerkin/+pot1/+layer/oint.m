function in = oint( H, f1, f2 )
%  OINT - Boundary integral over f1*H*f2.

[ n, q1, m1 ] = deal( size( f1, 1 ), size( f1, 2 ), size( f1, 3 ) );
[ ~, q2, m2 ] = deal( size( f2, 1 ), size( f2, 2 ), size( f2, 3 ) );
%  reshape matrices
[ H, f1, f2 ] = deal(  ...
  reshape( H, [], q2 ), reshape( f1, [], m1 ), reshape( f2, [], m2 ) );

in = zeros( n, m1, m2 );
%  loop over shape functions
for a1 = 1 : m1
  %  sum(f1*H,q1)
  x = bsxfun( @times, f1( :, a1 ), H );
  x = sum( reshape( x, n, q1, [] ), 2 );
  %  sum(x*f2,q2)
  y = bsxfun( @times, x( : ), f2 );
  in( :, a1, : ) = squeeze( sum( reshape( y, n, q2, m2 ), 2 ) );
end
