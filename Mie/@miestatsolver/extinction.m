function ext = extinction( obj, k0 )
%  EXTINCTION - Exctinction cross section for sphere, Eq. (9.22).
%
%  Usage for obj = miesolver :
%    ext = extinction( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%    ext    :  extinction cross section

%  wavenumber in embedding medium
k = obj.mat2.k( k0 );
%  scattering cross section, Eq. (9.21)
ext = 4 * pi * k .* imag( dipole( obj, k0 ) );