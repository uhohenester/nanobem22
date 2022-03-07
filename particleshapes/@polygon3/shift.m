function obj = shift( obj, pos )
%  SHIFT - Shift polygon by given vector.
%
%  Usage for obj = polygon2 :
%    obj = shift( obj, vec )
%  Input
%    pos    :  translation vector

%  shift polygon
obj.poly = shift( obj.poly, pos( 1 : 2 ) );
%  shift z-value
obj.z = obj.z + pos( 3 );
