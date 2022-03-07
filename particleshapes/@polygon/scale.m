function obj = scale( obj, scale )
%  SCALE - Scale polygon.
%
%  Usage for obj = polygon :
%    obj = scale( obj, scale )
%  Input
%    scale  :  scaling factor

for it = 1 : numel( obj )
  obj( it ).pos = bsxfun( @times, obj( it ).pos, scale );
end
