function [ e, h ] = fields( obj, pt, k0 )
%  FIELDS - Electromagnetic fields for dipole.
%
%  Usage for obj = galerkin.dipole :
%    [ e, h ] = fields( obj, pt, k0 )
%  Input
%    pt     :  positions where field is evaluated
%    k0     :  wavelength of light in medium
%  Output
%    e      :  electric field
%    h      :  magnetic field

%  material properties and indices of points
mat = pt( 1 ).mat;
imat = horzcat( pt.imat );
%  wavenumber im media
k1 = arrayfun( @( x ) x.k( k0 ), mat, 'uniform', 1 );
k1 = k1( imat );

%  positions 
pos1 = vertcat( pt.pos );
pos2 = vertcat( obj.pt.pos );
%  distance
d = pdist2( pos1, pos2 );

%  dummy indices for internal tensor class
[ i1, i2, j, k ] = deal( 1, 2, 3, 4 );
%  convert positions to tensors
pos1 = tensor( pos1, [ i1, k ] );
pos2 = tensor( pos2, [ i2, k ] );
%  unit vector connecting positions
d = tensor( d, [ i1, i2 ] );
n = ( pos1 - pos2 ) ./ d;
%  dipole orientations
dip = tensor( eye( 3 ), [ j, k ] );
k1 = tensor( k1, i1 );

%  electromagnetic fields, Jackson Eq. (9.18)
fac = exp( 1i * k1 * d ) / ( 4 * pi );
e = k1 .^ 2 * cross( cross( n, dip, k ), n, k ) * fac ./ d +   ...
  ( 3 * n * dot( n, dip, k ) - dip ) * ( 1 ./ d .^ 3 - 1i * k1 ./ d .^ 2 ) * fac;
h = k1 .^ 2 * cross( n, dip, k ) * fac ./ d * ( 1 + 1i ./ ( k1 * d ) );
%  points and dipoles connected ?
is = tensor( connected( pt, obj.pt ), [ i1, i2 ] );
e = e * is;
h = h * is;
%  convert to numeric
e = double( e( i1, k, i2, j ) );
h = double( h( i1, k, i2, j ) );
