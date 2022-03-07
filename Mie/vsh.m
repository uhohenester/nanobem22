function  [ xm, xe, x0 ] = vsh( ltab, mtab, theta, phi )
%  VSH - Vector spherical harmonics, Kiselev et al., PRA 89, 043803 (2014).
%
%  Usage :
%    [ xm, xe, x0 ] = vsh( ltab, mtab, theta, phi )
%  Input
%    ltab   :  table of spherical harmonic degrees
%    mtab   :  table of spherical harmonic orders
%    theta  :  polar angle
%    phi    :  azimuthal angle
%  Output
%    xm     :  vector spherical harmonics, Eq. (3a)
%    xe     :  Eq. (3b)
%    x0     :  Eq. (3c)

%  convert to column and row vectors
[ l, m ] = deal( ltab( : ), mtab( : ) );
%  spherical harmonics
y  = spharm( l, m,     theta, phi );
yp = spharm( l, m + 1, theta, phi );
ym = spharm( l, m - 1, theta, phi );

%  normalization constant
norm = 1 ./ sqrt( l .* ( l + 1 ) ); 
%  action of angular momentum operator on spherical harmonic
%    [ Jackson eq. (9.104) ]
lpy = bsxfun( @times, yp, norm .* sqrt( ( l - m ) .* ( l + m + 1 ) ) );
lmy = bsxfun( @times, ym, norm .* sqrt( ( l + m ) .* ( l - m + 1 ) ) );
lzy = bsxfun( @times, y,  norm .* m );
%  put together vector spherical harmonics
x = cat( 3, 0.5 * ( lpy + lmy ), - 0.5i * ( lpy - lmy ), lzy );
  
%  unit vector
nx = reshape( sin( theta ) .* cos( phi ), 1, [] );
ny = reshape( sin( theta ) .* sin( phi ), 1, [] );
nz = reshape( cos( theta ),               1, [] );
%  transverse vector spherical harmonics, Eqs. (3a,b)
xm = x;
xe = 1i * cat( 3,  ...
  bsxfun( @times, x( :, :, 2 ), nz ) - bsxfun( @times, x( :, :, 3 ), ny ),  ...
  bsxfun( @times, x( :, :, 3 ), nx ) - bsxfun( @times, x( :, :, 1 ), nz ),  ...
  bsxfun( @times, x( :, :, 1 ), ny ) - bsxfun( @times, x( :, :, 2 ), nx ) );
%  longitudinal vector spherical harmonics
x0 = cat( 3,  ...
  bsxfun( @times, y, nx ), bsxfun( @times, y, ny ), bsxfun( @times, y, nz ) );
