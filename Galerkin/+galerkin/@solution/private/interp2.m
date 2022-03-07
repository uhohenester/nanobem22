function [ e, h ] = interp2( obj, varargin )
%  INTERP2 - Interpolate BEM solution from edges to centroids.
%
%  Usage for obj = galerkin.solution :
%    [ e, h ] = interp( obj, PropertyPairs )
%  PropertyName
%    inout  :  compute fields at boundary inside or outside
%  Output
%    e      :  electric fields at requested points
%    h      :  magnetic fields at requested points

%  quadrature points for centroid positions
pts = quadboundary( obj.tau, 'quad3', triquad( 1 ) );
%  electromagnetic fields at centroid positions
[ e, h ] = arrayfun(  ...
  @( pt ) interp1( obj, pt, varargin{ : } ), pts, 'uniform', 0 );

%  concatenate electromagnetic fields
e = cat( 1, e{ : } );
h = cat( 1, h{ : } );
%  rearrange order of boundary elements
ind = indexin( pts, obj.tau );
ind = vertcat( ind{ : } );
e = squeeze( reshape( e( ind, : ), size( e ) ) );
h = squeeze( reshape( h( ind, : ), size( h ) ) );
