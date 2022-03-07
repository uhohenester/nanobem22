function obj = init( obj, varargin )
%  INIT - Initialize polygon with n positions.
%
%  Usage :
%    obj = polygon( n,   PropertyPairs )
%    obj = polygon( pos, PropertyPairs )
%  Input
%    n    :  number of polygon vertices
%    pos  :  polygon vertices
%  PropertyName
%    dir  :  direction of polygon (clockwise or counterclockwise)
%    size :  scaling factor for polygon

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'dir', 1 );
addParameter( p, 'size', [] );
%  parse input
parse( p, varargin{ 2 : end } );

%  save direction flag
obj.dir = p.Results.dir;
%  position initialization
switch size( varargin{ 1 }, 2 )
  case 1
    n = varargin{ 1 };
    t = reshape( 0 : n - 1, [], 1 ) / n * 2 * pi + pi / n;
    obj.pos = [ cos( t ), sin( t ) ];
  case 2
    obj.pos = varargin{ 1 };
end

if ~isempty( p.Results.size )
  len = arrayfun( @( k )  ...
    max( obj.pos( :, k ) ) - min( obj.pos( :, k ) ), 1 : 2, 'uniform', 1 );
  obj.pos = bsxfun( @times, obj.pos, p.Results.size ./ len );
end
  