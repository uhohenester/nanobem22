function nvec = norm( obj )
%  NORM - Normal vector at polygon positions.
%
%  Usage for obj = polygon :
%    nvec = norm( obj )
%  Output
%    nvec   :  normal vectors

%  unit vector
pos = obj.pos;
unit = @( x ) bsxfun( @rdivide, x, sqrt( dot( x, x, 2 ) ) );

%  normal vectors
vec = pos( [ 2 : end, 1 ], : ) - pos( 1 : end, : );
nvec = unit( [ - vec( :, 2 ), vec( :, 1 ) ] );
%  intgerpolate to polygon positions
nvec = 0.5 * ( nvec + circshift( nvec, [ 1, 0 ] ) );
nvec = unit( nvec );

%  check direction of normal vectors
posp = pos + 1e-6 * nvec;
in = inpolygon( posp( :, 1 ), posp( :, 2 ), pos( :, 1 ), pos( :, 2 ) );
%  change directions of normal vectors
switch obj.dir
  case 1
    nvec(  in, : ) = - nvec(  in, : );
  case - 1
    nvec( ~in, : ) = - nvec( ~in, : );
end

