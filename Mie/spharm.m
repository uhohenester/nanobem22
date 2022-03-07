function  y = spharm( ltab, mtab, theta, phi )
% SPHARM - Spherical harmonics.
%
%  Usage : 
%    y = spharm( ltab, mtab, theta, phi )
%  Input
%    ltab   :  table of spherical harmonic degrees
%    mtab   :  table of spherical harmonic orders
%    theta  :  polar angle
%    phi    :  azimuthal angle
%  Output
%    y      :  spherical harmonic

%  convert to column and row vectors
[ ltab, mtab ] = deal( reshape( ltab,  [], 1 ), reshape( mtab, [], 1 ) );
[ theta, phi ] = deal( reshape( theta, 1, [] ), reshape( phi,  1, [] ) );
%  table of factorials
ftab = factorial( 0 : ( 2 * max( ltab ) + 1 ) );
%  dimension output
y  = zeros( length( ltab ), length( theta ) );

%  loop over unique ltab values
for l = reshape( unique( ltab ), 1, [] )
    
  %  full table of Legendre functions
  ptab = legendre( l, cos( theta ) );
  
  %  index to entries with degree L and 
  %                   with angular order smaller than angular order
  ind = find( ltab == l );
  ind = ind( abs( mtab( ind ) ) <= l );
  
  for i = reshape( ind, 1, [] )
    %  corresponding spherical order (only absolute value considered first)
    m = mtab( i );
    %  prefactor for spherical harmonics
    c = sqrt( ( 2 * l + 1 ) / ( 4 * pi ) *  ...
        ftab( l - abs( m ) + 1 ) / ftab( l + abs( m ) + 1 ) );
    %  spherical harmonics
    y( i, : ) = c * ptab( abs( m ) + 1, : ) .* exp( 1i * abs( m ) * phi );
    %  correct for negative orders
    if ( m < 0 ),  y( i, : ) = ( - 1 ) ^ m * conj( y( i, : ) );  end
  end    
end
