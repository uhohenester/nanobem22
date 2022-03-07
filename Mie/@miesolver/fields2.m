function f = fields2( obj, pos, z, k0 )
%  FIELDS2 - Fields for dipole excitation.
%
%  Usage for obj = miesolver :
%    f = fields2( obj, pos, z, k0 )
%  Input
%    pos    :  positions where fields are evaluated
%    z      :  dipole position outside of sphere
%    k0     :  wavenumber of light in vacuum
%  Output
%    f      :  structure containing fields

assert( z > 0.5 * obj.diameter );
%  positions inside and outside of sphere
d = sqrt( dot( pos, pos, 2 ) );
i1 = d <  0.5 * obj.diameter;
i2 = d >= 0.5 * obj.diameter;
%  wavenumbers and refractive indices inside and outside of sphere
[ k1, n1 ] = deal( obj.mat1.k( k0 ), obj.mat1.n( k0 ) );
[ k2, n2 ] = deal( obj.mat2.k( k0 ), obj.mat2.n( k0 ) );

ltab = reshape( 1 : obj.lmax, [], 1 );
%  expansion coefficients for dipole
switch 'z'
  case 'z'
    %  Hohenester Eq. (E.35)
    fac = sqrt( ltab .* ( ltab + 1 ) .* ( 2 * ltab + 1 ) / ( 4 * pi ) );
    h = riccatibessel( ltab, z * k2, 'h' );
    ainc = 1i * n2 * k0 ^ 2 * fac .* h / z;
    binc = 0 * ainc;
    %  spherical order
    mtab = 0 * ltab;
end
    
% %  Mie coefficients
[ a2, b2, a1, b1 ] = miecoefficients( obj, k0, ltab );
%  allocate output
[ f.e, f.h, f.einc, f.hinc ] = deal( zeros( size( pos ) ) );

%  electromagnetic fields, Eq. (17)
fun = @( a, x )  ...
  reshape( transpose( a ) * reshape( x, numel( a ), [] ), [], 3 );

if nnz( i1 )
  %  multipole fields
  [ M1, N1 ] = multifield( ltab, mtab, k1, pos( i1, : ), 'j' );
  %  scattered fields
  f.e( i1, : ) = nan; %( fun( binc .* b1, M1 ) + fun( ainc .* a1, N1 ) );
  f.h( i1, : ) = ( fun( ainc .* a1, M1 ) - fun( binc .* b1, N1 ) ) * n1;
end
if nnz( i2 )
  %  multipole fields
  [ Mi, Ni ] = multifield( ltab, mtab, k2, pos( i2, : ), 'j' );
  [ M2, N2 ] = multifield( ltab, mtab, k2, pos( i2, : ), 'h' );
  %  incoming fields
  f.einc( i2, : ) = ( fun( binc, Mi ) + fun( ainc, Ni ) );
  f.hinc( i2, : ) = ( fun( ainc, Mi ) - fun( binc, Ni ) ) * n2;    
  %  scattered fields
  f.e( i2, : ) = - ( fun( binc .* b2, M2 ) + fun( ainc .* a2, N2 ) );
  f.h( i2, : ) = - ( fun( ainc .* a2, M2 ) - fun( binc .* b2, N2 ) ) * n2;  
end
end  
