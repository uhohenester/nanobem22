function tot = decayrate( obj, sol, varargin )
%  DECAYRATE - Total and radiative decay rate.
%
%  Usage for obj = galerkinstat.dipole :
%    tot = decayrate( obj, sol )
%  Input
%    sol    :  solution of Galerkin scheme
%  Output
%    tot    :  enhancement of total decay rate wrt free-space dipole

%  initialize potential integrator and split at PARENT positions
pot = set( obj.pot, obj.pt, sol.tau, varargin{ : } );
pot = mat2cell( pot );

%  wavenumber of light in vacuum
k0 = sol.k0;
%  dummy indices for internal vector class
[ nu1, nu2, k ] = deal( 1, 2, 3 );

%  allocate output
n = numel( obj.pt );
[ e, P0 ] = deal( zeros( n, 3 ) );

for it = 1 : numel( pot )
  %  evaluate Green function and derivatives
  data = green( pot{ it } );
  
  %  evaluation points and boundary elements 
  [ pt1, pt2 ] = deal( pot{ it }( 1 ).pt1, pot{ it }( 1 ).pt2 );
  %  Green function and derivative
  n1 = size( data.G1, 1 );
  G1 = tensor( reshape( data.G1, n1, 3, [] ), [ nu1, k, nu2 ] );
  %  electric field at dipole positions
  sig = tensor( sol.sig(  ...
    vertcat( pt2.tau.nu ), vertcat( pt1.nu ), : ), [ nu2, nu1, k ] );
  e1 = sum( G1 * sig, nu2 );  
  %  accumulate electric field at dipole positions
  e( pt1.nu, : ) = e( pt1.nu, : ) - double( e1, [ nu1, k ] );
  
  %  material properties
  mat = pt1.mat( pt1.imat );
  [ eps, n ] = deal( mat.eps( k0 ), mat.n( k0 ) );
  %  dissipated power of isolated dipole
  P0( pt1.nu, : ) = n ^ 3 / eps * k0 ^ 4 / ( 12 * pi );
end

%  dissipated power and enhancement of decay rate
Ptot = 0.5 * k0 * imag( e ) + P0;
tot = Ptot ./ P0;

