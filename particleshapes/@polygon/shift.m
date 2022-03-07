function obj = shift( obj, pos )
%  SHIFT - Shift polygon by given vector.
%
%  Usage for obj = polygon :
%    obj = shift( obj, pos )
%  Input
%    pos    :  translation vector

for it = 1 : numel( obj )
  obj( it ).pos = bsxfun( @plus, obj( it ).pos, pos );
end
