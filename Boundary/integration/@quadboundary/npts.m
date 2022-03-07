function n = npts( obj, flag )
%  NPTS - Total number of integration points.
%
%  Usage for obj = quadboundary :
%    n = npts( obj )
%    n = npts( obj, 'sum' )
%  Output
%    n    :  total number of integration points

if ~isscalar( obj )    
  n = arrayfun( @( x ) npts( x ), obj, 'uniform', 1 );
  if exist( 'flag', 'var' ) && ischar( flag ) && strcmp( flag, 'sum' )
    n = sum( n( : ) );
  end
else
  %  number of boundary elements and integration points
  n1 = arrayfun( @( x ) numel( x.tau  ), obj, 'uniform', 1 );
  n2 = arrayfun( @( x ) nquad( x.quad ), obj, 'uniform', 1 );
  %  total number of integration points
  n = sum( n1 .* n2 );  
end


function n = nquad( quad )
%  NQUAD - Number of quadrature points.
if isempty( quad )
  n = 1;
else
  n = numel( quad.w );
end
