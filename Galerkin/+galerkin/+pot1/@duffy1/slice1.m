function obj = slice1( obj )
%  SLICE1 - Slice object into two parts.

[ pts, k1, k2 ] = slice( obj.pts );
%  slice object
[ obj1, obj2 ] = deal( obj );
[ obj1.pts, obj1.i1, obj1.i2 ] = deal( pts( 1 ), obj.i1( k1 ), obj.i2( k1 ) );
[ obj2.pts, obj2.i1, obj2.i2 ] = deal( pts( 2 ), obj.i1( k2 ), obj.i2( k2 ) );
%  set output
obj = [ obj1, obj2 ];

