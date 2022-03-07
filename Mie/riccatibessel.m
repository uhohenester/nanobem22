function [ z, zp ] = riccatibessel( ltab, x, key )
%  RICCATIBESSEL - Riccati-Bessel functions.
%    Abramowitz and Stegun, Handbook of Mathematical Functions, Chap. 10.
%
%  Input
%    ltab   :  angular degrees
%    x      :  argument
%    key    :  'j' - spherical Bessel function 
%              'h' - spherical Hankel function 
%
%  Output
%    z      :  spherical function
%    zp     :  derivative [ x * z ]'

if ~exist( 'key', 'var' ),  key = 'j';  end 

%  maximum of LTAB
lmax = max( ltab );
x = reshape( x, 1, [] );
%  allocate output
[ z, zp ] = deal( zeros( lmax + 1, numel( x ) ) );

%  spherical Bessel functions
j = @( l, x ) sqrt( pi ./ ( 2 * x ) ) .* besselj( l + 0.5, x );
y = @( l, x ) sqrt( pi ./ ( 2 * x ) ) .* bessely( l + 0.5, x );
%  Jackson, Eq. (9.85)
switch key
  case 'j'
    for l = 0 : lmax
      z( l + 1, : ) = j( l, x );
    end
  case 'h'
    for l = 0 : lmax
      z( l + 1, : ) = j( l, x ) + 1i * y( l, x );
    end
end

%  recursion formula, Jackson Eq. (9.90)
for l = 1 : lmax
  zp( l + 1, : ) = x .* z( l, : ) - l * z( l + 1, : );
end

%  table assignement
[ z, zp ] = deal( z( ltab + 1, : ), zp( ltab + 1, : ) );
