function [ ind, imat ] = nearest( obj, pos, varargin )
%  NEAREST - Find nearest boundary elements for given positions.
%
%  Usage for obj = BoundaryElement :
%    [ ind, imat ] = nearest( obj, pos, PropertyPairs )
%  Input
%    pos    :  positions
%  Output
%    ind    :  index to nearest boundary elements
%    imat   :  material index for position

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'quad3', triquad( 1 ) );
addParameter( p, 'quad4', [] );
%  parse input
parse( p, varargin{ : } );

%  allocate arrays
n = size( pos, 1 );
[ ind, imat ] = deal( zeros( 1, n ) );
%  distance array and nearest positions
d = inf( 1, n );

%  for a better resolution we use a discretized boundary
for pt = quadboundary( obj, 'quad3', p.Results.quad3 )
  %  quadrature positions and corresponding boundary indices
  pos2 = eval( pt );
  ind2 = indexin( pt, obj );
  ind2 = repmat( vertcat( ind2{ : } ), 1, size( pos2, 2 ) );
  %  find nearest positions
  pos2 = reshape( pos2, [], 3 );
  [ d2, i2 ] = pdist2( pos2, pos, 'euclidean', 'smallest', 1 );
  ind2 = ind2( i2 );
  %  elements closer in comparison to previously computed elements
  id = find( d2 < d );
  [ ind2, i2, d2 ] = deal( ind2( id ), i2( id ), d2( id ) );
  
  if ~isempty( id )
    %  update distance and index
    d( id ) = d2;
    ind( id ) = ind2;
    %  normal vector and material indices at boundary inside and outside
    nvec = vertcat( obj( ind2 ).nvec );
    inout = vertcat( obj( ind2 ).inout );
    %  inner product between distance vector and outer surface normal
    in = dot( pos( id, : ) - pos2( i2, : ), nvec, 2 );
    %  set matreial index
    imat( id( in <  0 ) ) = inout( in <  0, 1 );
    imat( id( in >= 0 ) ) = inout( in >= 0, 2 );
  end
end
