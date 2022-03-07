function [ K1, K2, K4 ] = ret1( obj, pos, varargin )
%  RET1 - Basic integrals PIERS 63, 243 (2006).
%
%  Product output for OBJ.TAU and POS. 
%
%  Usage for obj = potbase3 :
%    [ K1, K2, K4 ] = ret1( obj, pos, ind )
%  Input
%    pos    :  positions
%    ind    :  index to selected boundary elements (optional)
%  Output
%    K1     :  Eq. (65) 
%    K2     :  Eq. (70) 
%    K4     :  Eq. (77) 

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'ind', 1 : numel( obj.tau ) );
%  parse input
parse( p, varargin{ : } );

%  line and surface integrals
[ I1tab, I2tab ] = eval1( obj, pos, p.Results.ind );
%  dummy indices for internal tensor class
[ i, j, a, k ] = deal( 1, 2, 3, 4 );

%  positions pos(j,k) and centroid positions pos1(i,k)
pos = tensor( pos, [ j, k ] );
pos1 = tensor( vertcat( obj.tau( p.Results.ind ).pos ), [ i, k ] );
%  normal vector nvec(i,k) and edge normal mvec(i,a,k)
nvec = tensor( obj.nvec( p.Results.ind, : ), [ i, k ] );
mvec = tensor( obj.mvec( p.Results.ind, :, : ), [ i, a, k ] );

%  inner product of normal vector and difference vector
h = sum( nvec * pos - nvec * pos1, k );
%  pos - h * nvec
rho = pos - h * nvec;
%  prefactor for shape function and vertex opposite to edge
val = tensor( obj.val, [ i, a ] );
pvec = tensor( obj.verts( p.Results.ind, [ 3, 1, 2 ], : ), [ i, a, k ] );

%  allocate output
[ K1, K2, K4 ] = deal( cell( 1, 2 ) );
%  line and surface integrals
I1 = @( it ) tensor( I1tab{ it }, [ j, i, a ] );
I2 = @( it ) tensor( I2tab{ it }, [ j, i ] );

%  Eq. (65)
K1{ 1 } = val * I2( 2 );
K1{ 2 } = val * I2( 3 );
%  Eq. (70)
K2{ 1 } = 0.5 * val * ( sum( mvec * I1( 2 ), a )     + ( rho - pvec ) * I2( 2 ) );
K2{ 2 } = 0.5 * val * ( sum( mvec * I1( 3 ), a ) / 3 + ( rho - pvec ) * I2( 3 ) );
%  Eq. (74,77)
K4{ 1 } = - 0.5 * val * cross( pos - pvec, sum( mvec * I1( 1 ), a ) + h * nvec * I2( 1 ), k );
K4{ 2 } = + 0.5 * val * cross( pos - pvec, sum( mvec * I1( 2 ), a ) - h * nvec * I2( 2 ), k );

%  set output
K1 = cellfun( @( x ) double( x, [ j, i, a ]    ), K1, 'uniform', 0 );
K2 = cellfun( @( x ) double( x, [ j, i, a, k ] ), K2, 'uniform', 0 );
K4 = cellfun( @( x ) double( x, [ j, i, a, k ] ), K4, 'uniform', 0 );
