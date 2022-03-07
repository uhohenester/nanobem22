function dip = dipole( obj )
%  DIPOLE - Dipole moment for surface charge distribution.
%
%  Usage for obj = galerkinstat.solution :
%    dip = dipole( obj, sol )
%  Input
%    sol    :  solution of quasistatic BEM solver
%  Output
%    dip    :  dipole moment of surface charge distribution

%  surface charge distribution
siz = size( obj.sig );
sol.sig = reshape( obj.sig, siz( 1 ), [] );
%  allocate output
dip = zeros( siz( 2 ), 3 );

%  dummy indices for internal tensor class
[ i, m, q, k ] = deal( 1, 2, 3, 4 );

%  loop over boundary elements
for pt = quadboundary( obj.tau )
  %  integration points and weights
  [ pos, w ] = eval( pt );
  pos = tensor( pos, [ i, q, k ] );
  w = tensor( w, [ i, q ] );
  %  interpolate surface charge to boundary elements
  sig = tensor( interp( pt, obj.sig ), [ i, q, m ] );  
  %  dipole moment
  d = sum( w * pos * sig, i, q );
  dip = dip + double( d, [ m, k ] );
end

%  correct for factor of 4 * pi, Hohenester Eq. (9.19)
dip = dip / ( 4 * pi );
dip = reshape( dip, [ siz( 2 : end ), 3 ] );
  