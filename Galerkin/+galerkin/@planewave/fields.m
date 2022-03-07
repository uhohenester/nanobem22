function [ e, h ] = fields( obj, pt, k0 )
%  FIELDS - Electromagnetic fields for planewave excitation.
%
%  Usage for obj = galerkin.planewave :
%    [ e, h ] = fields( obj, pt, k0 )
%  Input
%    pt     :  evaluation points
%    k0     :  wavelength of light in vacuum
%  Output
%    e      :  electric field
%    h      :  magnetic field

%  allocate output
[ e, h ] = deal( zeros( numel( pt ), 3, size( obj.pol, 1 ) ) );
%  dummy indices for internal tensor class
[ i, ipol, k ] = deal( 1, 2, 3 );


%  group points in unique materials
for it = iterpoints( pt )
  
  if any( it.imat == obj.imat )  
    %  material properties
    mat = it.mat( it.imat );
    %  wavelength and impedance in medium
    [ k1, Z1 ] = deal( mat.k( k0 ), mat.Z( k0 ) );

    %  positions 
    pos = it.pos;
    %  polarization pol(ipol,k) and light propagation direction
    pol = tensor( obj.pol, [ ipol, k ] );
    dir = tensor( obj.dir, [ ipol, k ] );
    %  positions
    pos = tensor( pos, [ i, k ] );
  
    %  electric and magnetic field
    e1 = pol * exp( 1i * k1 * dot( pos, dir, k ) );
    h1 = cross( dir, e1, k ) / Z1;
    %  convert to numeric
    e( it.nu, :, : ) = e( it.nu, :, : ) + double( e1, [ i, k, ipol ] );
    h( it.nu, :, : ) = h( it.nu, :, : ) + double( h1, [ i, k, ipol ] );
  end
end
