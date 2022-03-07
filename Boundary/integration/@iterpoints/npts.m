function n = npts( obj, flag )
%  NPTS - Total number of points.
%
%  Usage for obj = iterpoints :
%    n = npts( obj )
%    n = npts( obj, 'sum' )
%  Output
%    n    :  total number of points

if ~isscalar( obj )    
  n = arrayfun( @( x ) npts( x ), obj, 'uniform', 1 );
  if exist( 'flag', 'var' ) && ischar( flag ) && strcmp( flag, 'sum' )
    n = sum( n( : ) );
  end
else
  %  number of points 
  n = sum( arrayfun( @( x ) numel( x.tau  ), obj, 'uniform', 1 ) );
end

