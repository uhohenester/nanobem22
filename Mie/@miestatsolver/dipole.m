function dip = dipole( obj, k0 )
%  DIPOLE - Induced dipole for optically excited sphere, Eq. (9.9).
%
%  Usage for obj = miestatsolver :
%    dip = dipole( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%    dip    :  dipole moment for optically excited sphere

%  dielectric functions
eps1 = obj.mat1.eps( k0 );
eps2 = obj.mat2.eps( k0 );
%  dipole moment, Eq. (9.9)
dip = ( eps1 - eps2 ) ./ ( eps1 + 2 * eps2 ) * ( 0.5 * obj.diameter ) ^ 3;
