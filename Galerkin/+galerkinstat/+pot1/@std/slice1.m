function obj = slice1( obj )
%  SLICE1 - Slice object into two parts.

[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );
%  slice object
obj = [ obj, obj ];

if npts( pt1 ) > npts( pt2 )
  pt1 = slice( pt1 );
  obj( 1 ).pt1 = pt1( 1 );
  obj( 2 ).pt1 = pt1( 2 );
else
  pt2 = slice( pt2 );
  obj( 1 ).pt2 = pt2( 1 );
  obj( 2 ).pt2 = pt2( 2 );
end
