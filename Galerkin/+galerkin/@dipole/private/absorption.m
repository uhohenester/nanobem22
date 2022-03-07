function P = absorption( obj, sol, varargin )
%  ABSORPTION - Absorbed power for dipole excitation.
%
%  Usage for obj = galerkin.dipole :
%    P = absorption( obj, sol )
%  Input
%    sol    :  solution of BEM equations
%  Output
%    P      :  absorbed power

%  allocate output
P = zeros( numel( obj.pt ), 3 );
%  dummy indices for internal vector class
[ i1, i2, q2, k1, k2 ] = deal( 1, 2, 3, 4, 5 );

%  loop over boundary elements
for pt2 = quadboundary( sol.tau, varargin{ : } )
  
  %  quadrature weights
  [ ~, w2 ] = eval( pt2 );
  w2 = tensor( w2, [ i2, q2 ] );
  %  normal vector
  nvec = tensor( vertcat( pt2.tau.nvec ), [ i2, k2 ] );
  %  interpolate electromagnetic fields
  [ e, h ] = interp( sol, pt2 );
  e = tensor( e, [ i2, q2, k2, i1, k1 ] );
  h = tensor( h, [ i2, q2, k2, i1, k1 ] );
  
  %  Poynting vector in normal direction
  s = 0.5 * sum( nvec * sum( w2 * cross( e, conj( h ), k2 ), q2 ), i2, k2 );
  %  update absorbed power
  P = P - real( double( s( i1, k1 ) ) );
end
