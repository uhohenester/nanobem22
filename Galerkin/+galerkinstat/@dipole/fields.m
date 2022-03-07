function e = fields( obj, pt, k0 )
%  FIELDS - Electromagnetic fields for dipole.
%
%  Usage for obj = galerkinstat.dipole :
%    [ e, h ] = fields( obj, pt, k0 )
%  Input
%    pt     :  positions where field is evaluated
%    k0     :  wavelength of light in medium
%  Output
%    e      :  electric field

%  material properties and indices of points
mat = pt( 1 ).mat;
imat = horzcat( obj.pt.imat );
%  permittivities in media
epsz = arrayfun( @( x ) x.eps( k0 ), mat, 'uniform', 1 );
epsz = epsz( imat );

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
epsz = tensor( epsz, i2 );

%  electric fields, Jackson Eq. (4.13)
e = ( 3 * dot( dip, n, k ) * n - dip ) ./ ( 4 * pi * epsz * d .^ 3 );
%  convert to numeric
e = double( e( i1, k, i2, j ) );
