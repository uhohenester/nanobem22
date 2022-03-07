function qinc = eval( obj, tau, k0 )
%  EVAL - Inhomogeneities for planewave excitation.
%
%  Usage for obj = galerkinstat.planewave :
%    qinc = eval( obj, tau, k0 )
%  Input
%    tau    :  boundary elements
%    k0     :  wavelength of light in vacuum
%  Output
%    qinc   :  structure containing normal derivative of potential

%  dummy indices for internal tensor class
[ i, ipol, q, a, k ] = deal( 1, 2, 3, 4, 5 );
%  polarization pol(ipol,k)
pol = tensor( obj.pol, [ ipol, k ] );

%  allocate output
[ n, m ] = deal( ndof( tau ), size( obj.pol, 1 ) );
qinc = struct( 'vn', zeros( n, m ), 'tau', tau, 'k0', k0 );

%  loop over boundary elements
for pt = quadboundary( tau, obj.rules )
  %  weights and shape functions
  [ ~, w, f ] = eval( pt );
  w = tensor( w, [ i, q ] );
  f = tensor( f, [ i, q, a ] );
  %  normal vector
  nvec = tensor( vertcat( pt.tau.nvec ), [ i, k ] );
  %  normal derivative of potential
  vn = - sum( ( w * f * nvec ) * pol, k, q );

  nu = vertcat( pt.tau.nu );
  vn = reshape( double( vn( i, a, ipol ) ), [], m );
  %  loop over global degrees of freedom  
  for it = 1 : numel( nu )
    qinc.vn( nu( it ), : ) = qinc.vn( nu( it ), : ) +  vn( it, : );
  end
end
