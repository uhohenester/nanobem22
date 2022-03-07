function obj = slice( obj, varargin )
%  SLICE - Slice objects into bunches of given size.
%
%  Usage for obj = quadpair :
%    obj = slice( obj, PropertyPairs )
%  PropertyName
%    'memax'    :  slice objects into size of MEMAX

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'memax', 1e8 );
%  parse input
parse( p, varargin{ : } );

if numel( obj ) ~= 1
  obj = arrayfun( @( x ) slice( x, varargin{ : } ), obj, 'uniform', 0 );
  obj = horzcat( obj{ : } );
else
  if obj.npts >= p.Results.memax
    obj = slice( slice1( obj ), varargin{ : } );
  end
end
