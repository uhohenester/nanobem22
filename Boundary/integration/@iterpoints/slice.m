function obj = slice( obj, varargin )
%  SLICE - Slice points into sufficiently small bunches.
%
%  Usage :
%    obj = slice( obj, PropertyPairs )
%  PropertyName
%    'memax'    :  slice points into bunches of size MEMAX

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'memax', 1e6 );
%  parse input
parse( p, varargin{ : } );

if isscalar( obj )
  %  number of points
  n = npts( obj );  
  %  slice iterator ?
  if n > p.Results.memax
    m = fix( n / 2 );
    [ i1, i2 ] = deal( 1 : m, m + 1 : n );
    %  slice iterator
    obj = [ select( obj, i1 ), select( obj, i2 ) ];
    %  continue with slicing
    obj = slice( obj, varargin{ : } );
  end
else
  obj = arrayfun( @( x ) slice( x, varargin{ : } ), obj, 'uniform', 0 );
  obj = horzcat( obj{ : } );
end
