function [ G, F ] = stat2( obj, pos, ind )
%  STAT2 - Quasistatic Green function using integrals PIERS 63, 243 (2006).
%
%  Same size for OBJ.TAU(IND) and POS.   
%
%  Usage for obj = potbase3 :
%    [ G, F ] = stat2( obj, pos, ind )
%  Input
%    pos    :  positions
%    ind    :  index to boundary elements
%  Output
%    G    :  quasistatic Green function
%    F    :  normal derivative of Green function

%  line and surface integrals
[ I1tab, I2tab ] = eval2( obj, pos, ind );
%  dummy indices for internal tensor class
[ i, j, a, k ] = deal( 1, 2, 3, 4 );

%  positions pos(j,k) and centroid positions pos1(i,k)
pos = tensor( pos, [ i, j, k ] );
pos1 = tensor( vertcat( obj.tau( ind ).pos ), [ i, k ] );
%  normal vector nvec(i,k) and edge normal mvec(i,a,k)
nvec = tensor( obj.nvec( ind, : ), [ i, k ] );
mvec = tensor( obj.mvec( ind, :, : ), [ i, a, k ] );
%  projection vector u(i,a,k)
u = 0.5 * obj.mvec .* repmat( reshape( obj.val, [], 3, 1 ), 1, 1, 3 );
u = tensor( u( ind, [ 2, 3, 1 ], : ), [ i, a, k ] );

%  inner product of normal vector and difference vector
h = sum( nvec * pos - nvec * pos1, k );
%  pos - h * nvec
rho = pos - h * nvec;
alpha = 1 / 3 + sum( ( pos1 - rho ) * u, k );

%  quasistatic Green function
I1 = tensor( I1tab{ 2 }, [ j, i, a ] );
I2 = tensor( I2tab{ 2 }, [ j, i ] );

mI1 = sum( mvec * I1, a );
G = - sum( u * mI1, k ) + alpha * I2;

%  surface derivative of Green function
I1 = tensor( I1tab{ 1 }, [ j, i, a ] );
I2 = tensor( I2tab{ 1 }, [ j, i ] );

mI1 = sum( mvec * I1, a );
F = h * ( sum( u * mI1, k ) + alpha * I2 );

%  set output
G = double( G( i, a, j ) );
F = double( F( i, a, j ) );
