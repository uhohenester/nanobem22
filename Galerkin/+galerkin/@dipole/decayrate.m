function [ tot, rad ] = decayrate( obj, sol, varargin )
%  DECAYRATE - Total and radiative decay rate.
%
%  Usage for obj = galerkin.dipole :
%    [ tot, rad ] = decayrate( obj, sol )
%  Input
%    sol    :  solution of Galerkin scheme
%  Output
%    tot    :  enhancement of total decay rate wrt free-space dipole
%    rad    :  enhancement of radiative decay rate

%  initialize potential integrator and split at PARENT positions
pot = set( obj.pot, obj.pt, sol.tau, varargin{ : } );
pot = mat2cell( pot );

%  wavenumber of light in vacuum
k0 = sol.k0;
%  dummy indices for internal vector class
[ nu1, nu2, k ] = deal( 1, 2, 3 );

%  allocate output
n = numel( obj.pt );
[ e, h, P0 ] = deal( zeros( n, 3 ) );

for it = 1 : numel( pot )
  %  evaluate SL and DL potential
  data = potential( pot{ it }, k0 );
  %  evaluation points and boundary elements 
  [ pt1, pt2 ] = deal( pot{ it }( 1 ).pt1, pot{ it }( 1 ).pt2 );
  %  particle inside or outside
  sig = [ 1, -1 ];
  sig = sig( pt1.imat == pt2.inout );
    
  %  single and double layer potential
  SL = tensor( data.SL, [ nu1, nu2, k ] );
  DL = tensor( data.DL, [ nu1, nu2, k ] );
  %  electric and magnetic fields
  nu = vertcat( pt2.tau.nu );
  e1 = sum( SL * tensor( sol.e( nu, pt1.nu, : ), [ nu2, nu1, k ] ), nu2 );
  e2 = sum( DL * tensor( sol.e( nu, pt1.nu, : ), [ nu2, nu1, k ] ), nu2 );
  h1 = sum( SL * tensor( sol.h( nu, pt1.nu, : ), [ nu2, nu1, k ] ), nu2 );
  h2 = sum( DL * tensor( sol.h( nu, pt1.nu, : ), [ nu2, nu1, k ] ), nu2 );
  %  convert to numeric
  [ e1, h1 ] = deal( double( e1, [ nu1, k ] ), double( h1, [ nu1, k ] ) );
  [ e2, h2 ] = deal( double( e2, [ nu1, k ] ), double( h2, [ nu1, k ] ) );          
         
  %  material properties
  mat = pt1.mat( pt1.imat );
  [ mu, eps, n ] = deal( mat.mu( k0 ), mat.eps( k0 ), mat.n( k0 ) );
  %  electromagnetic fields, Hohenester Eq. (5.26)
  e( pt1.nu, : ) = e( pt1.nu, : ) - sig * (   1i * k0 * mu  * h1 - e2 );
  h( pt1.nu, : ) = h( pt1.nu, : ) - sig * ( - 1i * k0 * eps * e1 - h2 );  
  %  dissipated power of isolated dipole
  P0( pt1.nu, : ) = n ^ 3 / eps * k0 ^ 4 / ( 12 * pi );
end

%  dissipated and absorbed power
Ptot = 0.5 * k0 * imag( e ) + P0;
Pabs = absorption( obj, sol, varargin{ : } );
%  enhancement of decay rates
rad = ( Ptot - Pabs ) ./ P0;
tot = Ptot ./ P0;

