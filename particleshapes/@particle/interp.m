function val = interp( obj, val )
%  INTERP - Interpolate values VAL to vertices.
%
%  Usage for obj = particle :
%    val = interp( obj, val )
%  Input
%    val    :  value or value array

if isscalar( val )
  val = repmat( val, size( obj.verts, 1 ), 1 );
elseif size( val, 1 ) ~= size( obj.verts, 1 )
  %  reshape input
  siz = size( val );
  val = reshape( val, size( val, 1 ), [] );
  %  interpolation and weight function
  ival = zeros( size( obj.verts, 1 ), size( val, 2 ) );
  w = zeros( size( obj.verts, 1 ), 1 );
  area = obj.area;
  %  interpolate from faces to vertices
  for i = 1 : size( obj.faces, 1 )
    ival( obj.faces( i, : ), : ) =  ...
    ival( obj.faces( i, : ), : ) + area( i ) * val( i, : );
    w( obj.faces( i, : ), : ) = w( obj.faces( i, : ), : ) + area( i );
  end
  %  normalize interpolated array
  val = bsxfun( @rdivide, ival, max( w, 1e-10 ) );
  val = reshape( val, [ size( obj.verts, 1 ), siz( 2 : end ) ] );
end
