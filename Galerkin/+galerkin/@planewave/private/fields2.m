function [ e, h ] = fields2( obj, pt, k0 )
%  FIELDS - Electromagnetic fields for planewave excitation.
%
%  Usage for obj = galerkin.planewave :
%    [ e, h ] = fields2( obj, pt, k0 )
%  Input
%    pt     :  integration points
%    k0     :  wavelength of light in vacuum
%  Output
%    e      :  electric field
%    h      :  magnetic field

%  material properties
mat = pt.tau( 1 ).mat( obj.imat );
%  wavelength and impedance in medium
[ k1, Z1 ] = deal( mat.k( k0 ), mat.Z( k0 ) );

%  positions 
pos = eval( pt );
%  allocate output
e = zeros( size( pos, 1 ), size( pos, 2 ), 3, size( obj.pol, 1 ) );
h = zeros( size( pos, 1 ), size( pos, 2 ), 3, size( obj.pol, 1 ) );

if any( pt.tau( 1 ).inout == obj.imat )
  %  dummy indices for internal tensor class
  [ i, ipol, q, k ] = deal( 1, 2, 3, 4 );
  %  polarization pol(ipol,k) and light propagation direction
  pol = tensor( obj.pol, [ ipol, k ] );
  dir = tensor( obj.dir, [ ipol, k ] );
  %  positions
  pos = tensor( pos, [ i, q, k ] );
  
  %  electric and magnetic field
  e = pol * exp( 1i * k1 * dot( pos, dir, k ) );
  h = cross( dir, e, k ) / Z1;
  %  convert to numeric
  e = double( e, [ i, q, k, ipol ] );
  h = double( h, [ i, q, k, ipol ] );
end
