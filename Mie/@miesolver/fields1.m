function f = fields1( obj, pos, k0 )
%  FIELDS1 - Fields for planewave excitation.
%
%  Usage for obj = miesolver :
%    f = fields1( obj, pos, k0 )
%  Input
%    pos    :  positions where fields are evaluated
%    k0     :  wavenumber of light in vacuum
%  Output
%    f      :  structure containing fields

%  positions inside and outside of sphere
d = sqrt( dot( pos, pos, 2 ) );
i1 = d <  0.5 * obj.diameter;
i2 = d >= 0.5 * obj.diameter;
%  wavenumbers and refractive indices inside and outside of sphere
[ k1, n1 ] = deal( obj.mat1.k( k0 ), obj.mat1.n( k0 ) );
[ k2, n2 ] = deal( obj.mat2.k( k0 ), obj.mat2.n( k0 ) );

%  expansion coefficients for plane wave, Hohenester Eq. (E.21)
ltab = 1 : obj.lmax;
binc = 0.5 * 1i .^ ltab .* sqrt( 4 * pi .* ( 2 * ltab + 1 ) );
ainc = - 1i * binc;

mtab = reshape( [ 0 * ltab - 1, 0 * ltab + 1 ], [], 1 );
ltab = reshape( [ ltab, ltab ], [], 1 );

binc = reshape( [ binc,   binc ], [], 1 );
ainc = reshape( [ ainc, - ainc ], [], 1 );

% %  Mie coefficients
[ a2, b2, a1, b1 ] = miecoefficients( obj, k0, ltab );
%  allocate output
[ f.e, f.h ] = deal( zeros( size( pos ) ) );

%  electromagnetic fields, Eq. (17)
fun = @( a, x )  ...
  reshape( transpose( a ) * reshape( x, numel( a ), [] ), [], 3 );

if nnz( i1 )
  %  multipole fields
  [ M1, N1 ] = multifield( ltab, mtab, k1, pos( i1, : ), 'j' );
  %  scattered fields
  f.e( i1, : ) = ( fun( binc .* b1, M1 ) + fun( ainc .* a1, N1 ) );
  f.h( i1, : ) = ( fun( ainc .* a1, M1 ) - fun( binc .* b1, N1 ) ) * n1;
end
if nnz( i2 )
  %  multipole fields
  [ M2, N2 ] = multifield( ltab, mtab, k2, pos( i2, : ), 'h' );
  %  scattered fields
  f.e( i2, : ) = - ( fun( binc .* b2, M2 ) + fun( ainc .* a2, N2 ) );
  f.h( i2, : ) = - ( fun( ainc .* a2, M2 ) - fun( binc .* b2, N2 ) ) * n2;  
end
end  
