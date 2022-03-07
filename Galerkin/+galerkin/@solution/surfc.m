function sig = surfc( obj )
%  SURFC - Surface charge at centroids, Hohenester Eq. (7.24).
%
%  Usage for obj = galerkin.solution :
%    sig = surfc( obj )
%  Output
%    sig    :  surface charge

%  quadrature points for centroid positions
pts = quadboundary( obj.tau, 'quad3', triquad( 1 ) );
sig = cell( numel( pts ) );
%  dielectric functions
if ~isempty( obj.k0 )
  epsz = arrayfun( @( x ) x.eps( obj.k0 ), pts( 1 ).mat, 'uniform', 1 );
end

%  loop over boundary elements
for it = 1 : numel( pts )
  %  normal component of tangential magnetic field
  pt = pts( it );
  [ ~, sig{ it } ] = interp( pt, reshape( obj.h, size( obj.h, 1 ), [] ) );
  
  %  multiply with prefactor
  if ~isempty( obj.k0 )
    sig{ it } = sig{ it } * 1i / obj.k0 *  ...
      ( 1 / epsz( pt.inout( 1 ) ) - 1 / epsz( pt.inout( 2 ) ) );
  end
end

%  concatenate array 
sig = cat( 1, sig{ : } );
%  rearrange order of boundary elements
ind = indexin( pts, obj.tau );
ind = vertcat( ind{ : } );
sig = squeeze( reshape( sig( ind, : ), size( sig ) ) );
