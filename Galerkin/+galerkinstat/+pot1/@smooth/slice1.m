function obj = slice1( obj )
%  SLICE1 - Slice object into two parts.

[ pt1, k1, k2 ] = slice( obj.pt1 );
pt2 = slice( obj.pt2 );
%  slice object
[ obj1, obj2 ] = deal( obj );
[ obj1.pt1, obj1.pt2, obj1.i1, obj1.i2 ] = deal( pt1( 1 ), pt2( 1 ), obj.i1( k1 ), obj.i2( k1 ) );
[ obj2.pt1, obj2.pt2, obj2.i1, obj2.i2 ] = deal( pt1( 2 ), pt2( 2 ), obj.i1( k2 ), obj.i2( k2 ) );
%  set output
obj = [ obj1, obj2 ];
