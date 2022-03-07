function sca = scattering( obj, k0 )
%  SCATTERING - Scattering cross section for sphere, Eq. (E.30).
%
%  Usage for obj = miesolver :
%    sca = scattering( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%    sca    :  scattering cross section

%  allocate output
sca = zeros( size( k0 ) );
%  spherical orders
l = reshape( 1 : obj.lmax, [], 1 );

for i = 1 : numel( k0 )
  %  wavenumber of light in outer medium
  k2 = obj.mat2.k( k0( i ) );  
  %  Mie coefficients 
  [ a, b ] = miecoefficients( obj, k0( i ) );
  %  scattering cross section
  sca( i ) = 2 * pi / k2 ^ 2 *  ...
     sum( ( 2 * l + 1 ) .* ( abs( a ) .^ 2 + abs( b ) .^ 2 ) );    
end
