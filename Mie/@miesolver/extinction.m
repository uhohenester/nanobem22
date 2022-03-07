function ext = extinction( obj, k0 )
%  EXTINCTION - Exctinction cross section for sphere, Eq. (E.26).
%
%  Usage for obj = miesolver :
%    ext = extinction( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%    ext    :  extinction cross section

%  allocate output
ext = zeros( size( k0 ) );
%  spherical orders
l = reshape( 1 : obj.lmax, [], 1 );

for i = 1 : numel( k0 )
  %  wavenumber of light in outer medium
  k2 = obj.mat2.k( k0( i ) );  
  %  Mie coefficients 
  [ a, b ] = miecoefficients( obj, k0( i ) );
  %  scattering cross section
  ext( i ) = 2 * pi / k2 ^ 2 * sum( ( 2 * l + 1 ) .* real( a + b ) );    
end
