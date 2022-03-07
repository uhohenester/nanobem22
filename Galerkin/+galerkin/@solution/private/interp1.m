function [ e, h ] = interp1( obj, pts, varargin )
%  INTERP1 - Interpolate BEM solution from edges to quadrature points.
%
%  Usage for obj = galerkin.solution :
%    [ e, h ] = interp( obj, pts, PropertyPairs )
%  Input
%    pts    :  quadrature points
%  PropertyName
%    inout  :  compute fields at boundary inside or outside
%  Output
%    e      :  electric fields at requested points
%    h      :  magnetic fields at requested points

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'inout', [] );
%  parse input
parse( p, varargin{ : } );

%  interpolate fields from edges to quadrature points
[ e1, e2 ] = interp( pts, reshape( obj.e, size( obj.e, 1 ), [] ) );
[ h1, h2 ] = interp( pts, reshape( obj.h, size( obj.h, 1 ), [] ) );

%  dummy indices for internal tensor class
[ i, j, q, k ] = deal( 1, 2, 3, 4 );
%  normal vector
nvec = tensor( vertcat( pts.tau.nvec ), [ i, k ] );

%  tangential electromagnetic fields
[ n, m ] = deal( size( e1, 1 ), size( e1, 2 ) );
e = - cross( nvec, tensor( reshape( e1, n, m, 3, [] ), [ i, q, k, j ] ), k );
h = - cross( nvec, tensor( reshape( h1, n, m, 3, [] ), [ i, q, k, j ] ), k );
%  normal electromagnetic fields
if ~isempty( p.Results.inout )
  %  material properties
  tau = pts.tau( 1 );
  mat = tau.mat( tau.inout( p.Results.inout ) );
  %  wavenumber in medium and impedance
  [ k1, Z1 ] = deal( mat.k( obj.k0 ), mat.Z( obj.k0 ) );
  %  add normal field component
  e = e - 1i / k1 * Z1 * nvec * tensor( reshape( h2, n, m, [] ), [ i, q, j ] );
  h = h + 1i / k1 / Z1 * nvec * tensor( reshape( e2, n, m, [] ), [ i, q, j ] );
end

%  size of output array
siz = size( obj.e );
siz = [ n, m, 3, siz( 2 : end ) ];
%  set output
e = reshape( double( e( i, q, k, j ) ), siz );
h = reshape( double( h( i, q, k, j ) ), siz );
