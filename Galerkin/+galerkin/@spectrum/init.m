function obj = init( obj, mat, pinfty, varargin )
%  INIT - Initialize far-field detector.
%
%  Usage for obj = galerkin.spectrum :
%    obj = galerkin.detector( mat, pinfty, imat, PropertyPairs )
%  Input
%    mat      :  material properties
%    pinfty   :  discretized unit sphere
%    imat     :  index for background material

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'imat', 1 );
addParameter( p, 'rules', quadboundary.rules );
%  parse input
parse( p, varargin{ : } );

[ obj.pinfty, obj.imat ] = deal( pinfty, p.Results.imat );
%  quadrature points
pts = quadboundary(  ...
  BoundaryVert( mat, pinfty, [ 1, 1 ] * p.Results.imat ), p.Results.rules );
%  only one set of boundary points implemented
assert( isscalar( pts ) );

%  quadrature positions and weights
[ pos, w ] = eval( pts );
%  scale to unit sphere
d = sqrt( dot( pos, pos, 3 ) );
pos = double( tensor( pos, [ 1, 2, 3 ] ) ./ tensor( d, [ 1, 2 ] ), [ 1, 2, 3 ] );
w = w ./ d .^ 2;
%  save integration positions and weights
obj.pt = Point( mat, p.Results.imat, reshape( pos, [], 3 ) );
obj.w = w;
