function sca = scattering( obj, k0 )
%  SCATTERING - Scattering cross section for sphere, Eq. (9.21).
%
%  Usage for obj = miestatsolver :
%    sca = scattering( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%    sca    :  scattering cross section

%  wavenumber in embedding medium
k = obj.mat2.k( k0 );
%  scattering cross section, Eq. (9.21)
sca = 8 * pi / 3 * k .^ 4 .* abs( dipole( obj, k0 ) ) .^ 2;
