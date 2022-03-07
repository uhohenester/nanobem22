function n = npts( obj )
%  NPTS - Total number of integration points.
%
%  Usage for obj = quadduffy :
%    n = npts( obj )
%  Output
%    n    :  total number of integration points

n = arrayfun(  ...
  @( x ) numel( x.tau1 ) * numel( x.quad.w ), obj, 'uniform', 1 );
