function [ ftot, frc ] = optforce( obj, varargin )
%  OPTFORCE - Optical force on particle.
%
%  Usage for obj = galerkin.solution :
%    [ ftot, frc ] = optforce( sol, ind, PropertyPairs )
%  Input
%    ind    :  index to selected boundary elements 
%  PropertyName
%    imat   :  material index for embedding medium
%  Output
%    ftot   :  total optical force
%    frc    :  force acting on boundary elements

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'ind', 1 : numel( obj.tau ) );
addParameter( p, 'imat', 1 );
%  parse input
parse( p, varargin{ : } );

%  boundary elements connected to embedding medium
tau = obj.tau( p.Results.ind );
inout = vertcat( tau.inout );
tau = tau( inout( :, 2 ) == p.Results.imat );
%  material properties of embedding medium
mat = tau( 1 ).mat( p.Results.imat );
[ eps1, mu1 ] = deal( mat.eps( obj.k0 ), mat.mu( obj.k0 ) );

%  quadrature points
pts = quadboundary( tau, varargin{ : } );
assert( numel( pts ) == 1 );
%  dummy indices for internal tensor class
[ i, j, q, k ] = deal( 1, 2, 3, 4 );
%  normal vector
nvec = tensor( vertcat( pts.tau.nvec ), [ i, k ] );
%  interpolate fields from edges to quadrature points
[ e, h ] = interp( obj, pts, 'inout', 2 );
e = tensor( e, [ i, q, k, j ] ); 
h = tensor( h, [ i, q, k, j ] ); 

%  Maxwell's stress tensor in normal direction
t = eps1 * dot( e, conj( e ), k ) + mu1 * dot( h, conj( h ), k );
t = 0.5 * real( eps1 * e * dot( nvec, conj( e ), k ) +  ...
                 mu1 * h * dot( nvec, conj( h ), k ) - 0.5 * nvec * t );
%  conversion factor force in pN, use vacuum permittivity
fac = 1e12 * 8.854e-12;
%  integrate over boundary elements
[ ~, w ] = eval( pts );
frc = fac * double( sum( t * tensor( w, [ i, q ] ), q ), [ i, k, j ] );
ftot = squeeze( sum( frc, 1 ) );
if size( ftot, 1 ) ~= 1,  ftot = transpose( ftot );  end
