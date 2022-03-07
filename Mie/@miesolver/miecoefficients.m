function [ a, b, c, d ] = miecoefficients( obj, k0, varargin )
%  MIECOEFFICIENTS - Mie coefficients at sphere outside, Eq. (E.22).
%
%  Usage for obj = miesolver :
%    [ a, b, c, d ] = miecoefficients( obj, k0 )
%  Input
%    k0     :  wavevector of light in vacuum
%  Output
%    a,b    :  Mie coefficients for outside field
%    c,d    :  Mie coefficients for inside field

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'ltab', [] );
%  parse input
parse( p, varargin{ : } );

%  wavenumbers and impedances
[ k1, Z1 ] = deal( obj.mat1.k( k0 ), obj.mat1.Z( k0 ) );
[ k2, Z2 ] = deal( obj.mat2.k( k0 ), obj.mat2.Z( k0 ) );

[ z1, z2 ] = deal( 0.5 * k1 * obj.diameter, 0.5 * k2 * obj.diameter );
%  compute Riccati-Bessel functions
[ j1, zjp1 ] = riccatibessel( 1 : obj.lmax, z1, 'j' );
[ j2, zjp2 ] = riccatibessel( 1 : obj.lmax, z2, 'j' );
[ h2, zhp2 ] = riccatibessel( 1 : obj.lmax, z2, 'h' );

%  Mie coefficients for outside field
a = ( Z2 * z1 * j1 .* zjp2 - Z1 * z2 * j2 .* zjp1 ) ./  ...
    ( Z2 * z1 * j1 .* zhp2 - Z1 * z2 * h2 .* zjp1 );
b = ( Z2 * z2 * j2 .* zjp1 - Z1 * z1 * j1 .* zjp2 ) ./  ...
    ( Z2 * z2 * h2 .* zjp1 - Z1 * z1 * j1 .* zhp2 );
%  Mie coefficients for inside field, Hohenester Eq. (E.13)
c = ( Z1 * z2 * j2 .* zhp2 - Z1 * z2 * h2 .* zjp2 ) ./  ...
    ( Z2 * z1 * j1 .* zhp2 - Z1 * z2 * h2 .* zjp1 ) * k1 / k2;
d = ( Z1 * z2 * j2 .* zhp2 - Z1 * z2 * h2 .* zjp2 ) ./  ...
    ( Z2 * z1 * j1 .* zhp2 - Z1 * z2 * h2 .* zjp1 ) * k1 / k2;

if ~isempty( p.Results.ltab )
  [ a, b ] = deal( a( p.Results.ltab ), b( p.Results.ltab ) );
  [ c, d ] = deal( c( p.Results.ltab ), d( p.Results.ltab ) );
end
