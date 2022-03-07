function obj = slice1( obj )
%  SLICE1 - Slice object into two parts.

[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );
%  slice object
obj = [ obj, obj ];

if numel( pt1 ) > npts( pt2 )
  n = numel( pt1 );
  [ k1, k2 ] = deal( 1 : fix( 0.5 * n ), fix( 0.5 * n + 1 : n ) );
  obj( 1 ).pt1 = obj( 1 ).pt1( k1 );
  obj( 2 ).pt1 = obj( 2 ).pt1( k2 );
else
  pt2 = slice( pt2 );
  obj( 1 ).pt2 = pt2( 1 );
  obj( 2 ).pt2 = pt2( 2 );
end
