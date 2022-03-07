function  [ M, N ] = multifield( ltab, mtab, k, pos, key )
%  MULTIFIELD - Multipole field, Kiselev et al., PRA 89, 043803 (2014).
%
%  Usage :
%    [ M, N ] = multifield( ltab, mtab, k, pos, key )
%  Input
%    ltab   :  table of spherical harmonic degrees
%    mtab   :  table of spherical harmonic orders
%    k      :  wavenumber 
%    pos    :  positions where fields are evaluated
%    key    :  'j' or 'h' for Bessel or Hankel functions
%  Output
%    M      :  multipole field, Eq. (14)
%    N      :  multipole field, Eq. (15)

if ~exist( 'key', 'var' ),  key = 'j';  end

%  convert to polar coordinates
[ phi, theta, r ] = cart2sph( pos( :, 1 ), pos( :, 2 ), pos( :, 3 ) );
theta = 0.5 * pi - theta;

%  vector spherical harmonics
[ xm, xe, x0 ] = vsh( ltab, mtab, theta, phi );
%  radial function
rho = reshape( k * r, 1, [] );
[ z, zp ] = riccatibessel( ltab, rho, key );

%  multipole field M, Eq. (14)
M = z .* xm;
%  multipole field N, Eq. (15)
fac = sqrt( ltab .* ( ltab + 1 ) );
N = ( fac ./ rho ) .* z .* x0 + bsxfun( @rdivide, zp, rho ) .* xe;
