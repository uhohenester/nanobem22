function obj = round( obj, varargin )
%  ROUND - Round edges of polygon.
%
%  Usage for obj = polygon :
%    obj = round( obj, PropertyPairs )
%  PropertyName
%    'rad'      :  radius of rounded edges
%    'nrad'     :  number of interpolation points for rounded edges
%    'edge'     :  mask for edges that should be rounded

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rad', 0.1 );
addParameter( p, 'nrad', 5 );
addParameter( p, 'edge', 1 : size( obj.pos, 1 ) );
%  parse input
parse( p, varargin{ : } );

%  rounding radius
rad = p.Results.rad * max( abs( obj.pos( : ) ) );  
%  find centers of circles (for rounding)
norm = @( x ) ( x ./ repmat( sqrt( sum( x .^ 2, 2 )  ), 1, 2 ) );

vec = norm( circshift( obj.pos, [ - 1, 0 ] ) - obj.pos );
dir = norm( vec - circshift( vec, [ 1, 0 ] ) );

beta = acos( sum( circshift( vec, [ 1, 0 ] ) .* vec, 2 ) ) / 2;
zero = obj.pos + rad * dir ./ cos( [ beta, beta ] );

xv = [ obj.pos( :, 1 )', obj.pos( 1, 1 ) ];
yv = [ obj.pos( :, 2 )', obj.pos( 1, 2 ) ];

sgn = fix( inpolygon( zero( :, 1 ) .', zero( :, 2 ) .', xv, yv ) );
sgn( sgn == 0 ) = - 1;

%  put together positions
[ pos, obj.pos ] = deal( obj.pos, [] );
rot = @( phi ) ( [ cos( phi ), sin( phi ); - sin( phi ), cos( phi ) ] );

for it = 1 : size( zero, 1 )
  if isempty( find( it == p.Results.edge, 1 ) )
    obj.pos = [ obj.pos; pos( it, : ) ];
  else
    if abs( beta( it ) ) < 1e-3
      angle = 0;
    else
      angle = beta( it ) * linspace( - 1, 1, p.Results.nrad ) * sgn( it );
    end
    for phi = angle
      obj.pos = [ obj.pos;  ...
        zero( it, : ) - rad * dir( it, : ) * rot( phi ) ];
    end
  end
end
