function [ I1, I2 ] = eval2( obj, pos, ind )
%  EVAL2 - Line and surface integrals PIERS 63, 243 (2006).
%
%  Same size for OBJ.TAU(IND) and POS. 
%
%  Usage for obj = potbase3 :
%    [ I1, I2 ] = eval2( obj, pos, ind )
%  Input
%    pos    :  positions
%    ind    :  index to selected boundary elements
%  Output
%    I1     :  line integrals Eq. (40), (58)
%    I2     :  surface integrals Eq. (47), (63)

%  orders for singularity extraction
qtab = - 1 + ( 0 : obj.order - 1 ) * 2;
%  allocate output
[ I1, I2 ] = deal( cell( size( qtab ) ) );

%  dummy indices for internal tensor class
[ i, j, a, k ] = deal( 1, 2, 3, 4 );

%  positions
pos = tensor( pos, [ j, i, k ] );
%  edge points
p1 = tensor( obj.verts( ind, [ 1, 2, 3 ], : ), [ j, a, k ] );
p2 = tensor( obj.verts( ind, [ 2, 3, 1 ], : ), [ j, a, k ] );
%  unit edge vector
svec = p2 - p1;
svec = svec ./ sqrt( dot( svec, svec, k ) );

%  Eq. (36)
s1 = dot( p1 - pos, svec, k );
s2 = dot( p2 - pos, svec, k );
%  transverse distance r0, norm of cross( svec, pos - p1 )
r0 = cross( svec, pos - p1, k );
r0 = sqrt( dot( r0, r0, k ) );
%  constants Eqs. (38), (39)
r1 = sqrt( s1 .^ 2 + r0 .^ 2 );
r2 = sqrt( s2 .^ 2 + r0 .^ 2 );

%  integral, Eq. (40)
I1{ 1 } = log( ( r2 + s2 ) ./ ( r1 + s1 ) );
I1{ 1 }.val( isinf( I1{ 1 }.val ) ) = 0;
for it = 2 : numel( qtab )
  q = qtab( it );
  %  recursion formula Eq. (58)
  I1{ it } = ( q * r0 .^ 2 * I1{ it - 1 } + s2 * r2 .^ q - s1 * r1 .^ q ) / ( q + 1 );
end

%  triangle corners
p1 = tensor( reshape( obj.verts( ind, 1, : ), [], 3 ), [ j, k ] );
p2 = tensor( reshape( obj.verts( ind, 2, : ), [], 3 ), [ j, k ] );
p3 = tensor( reshape( obj.verts( ind, 3, : ), [], 3 ), [ j, k ] );
%  normal vector
nvec = tensor( obj.nvec( ind, : ), [ j, k ] );

%  inner product of normal vector and difference vector
h = dot( nvec, pos - p1, k );
%  norm of vectors, Eq. (51)
n1 = sqrt( dot( p1 - pos, p1 - pos, k ) );
n2 = sqrt( dot( p2 - pos, p2 - pos, k ) );
n3 = sqrt( dot( p3 - pos, p3 - pos, k ) );
%  inner product, Eq. (50)
x = 1 + dot( p1 - pos, p2 - pos, k ) ./ ( n1 * n2 ) +  ...
        dot( p2 - pos, p3 - pos, k ) ./ ( n2 * n3 ) +  ...
        dot( p3 - pos, p1 - pos, k ) ./ ( n3 * n1 );

%  triple product, Eq. (50)
vol = dot( p1, cross( p2, p3, k ), k );
b = cross( p2 - p1, p3 - p1, k );
y = ( dot( pos, b, k ) - vol ) ./ ( n1 * n2 * n3 );

%  surface integral, Eq. (47)
I2{ 1 } = - 2 * atan2( y( i, j ).val, x( i, j ).val ) ./ h( i, j ).val; 
I2{ 1 }( abs( h( i, j ).val ) < 1e-10 ) = 0;
%  convert to tensor
I2{ 1 } = tensor( I2{ 1 }, [ i, j ] );

%  outer edge normal and triangle corners
m = tensor( obj.mvec(  ind, :, : ), [ j, a, k ] );
p = tensor( obj.verts( ind, :, : ), [ j, a, k ] );
%  inner product with difference vector
t = dot( m, pos - p, k );

for it = 2 : numel( qtab )
  q = qtab( it - 1 );
  %  recursion formula Eq. (63)
  I2{ it } =  ...
    ( q * h .^ 2 * I2{ it - 1 } - sum( t * I1{ it - 1 }, a ) ) / ( q + 2 );
end

%  convert from tensor to double 
I1 = cellfun( @( x ) double( x, [ i, j, a ] ), I1, 'uniform', 0 );
I2 = cellfun( @( x ) double( x, [ i, j    ] ), I2, 'uniform', 0 );
