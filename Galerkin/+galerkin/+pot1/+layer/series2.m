function data = series2( order, pt1, pt2 )
%  SERIES2 - Precompute series expansion of BEM potentials. 
%
%  Usage :
%    data = galerkin.pot1.layer.series2( order, pt1, pt2 )
%  Input
%    order  :  order for series expansion
%    pt1    :  quadrature points for first boundary
%    pt2    :  quadrature points for second boundary
%  Output
%    data   :  precomputed SL and DL potential terms

%  quadrature points and shape elements
[ pos1, w1, f1, fp1 ] = eval( pt1 );
[ pos2, w2, f2, fp2 ] = eval( pt2 );
%  multiply shape functions with integration weights
f1  = reshape( bsxfun( @times, reshape( f1,  numel( w1 ), [] ), w1( : ) ), size( f1  ) );
f2  = reshape( bsxfun( @times, reshape( f2,  numel( w2 ), [] ), w2( : ) ), size( f2  ) );
fp1 = reshape( bsxfun( @times, reshape( fp1, numel( w1 ), [] ), w1( : ) ), size( fp1 ) );
fp2 = reshape( bsxfun( @times, reshape( fp2, numel( w2 ), [] ), w2( : ) ), size( fp2 ) );

%  cross product of position and shape function
g1 = cross( tensor( f1, [ 1, 2, 3, 4 ] ), tensor( pos1, [ 1, 2, 4 ] ), 4 );
g2 = cross( tensor( f2, [ 1, 2, 3, 4 ] ), tensor( pos2, [ 1, 2, 4 ] ), 4 );
%  convert to numeric
g1 = double( g1( 1, 2, 3, 4 ) );
g2 = double( g2( 1, 2, 3, 4 ) );

%  distance and Green function
u = double( tensor( pos1, [ 1, 2, 4 ] ) - tensor( pos2, [ 1, 3, 4 ] ), [ 1, 2, 3, 4 ] );
d = sqrt( dot( u, u, 4 ) );  
G = 1 ./ ( 4 * pi * d );
F1 = G ./ d;
F2 = G ./ d .^ 2;
%  argument for series expansion
[ tau1, tau2 ] = deal( pt1.tau, pt2.tau );
u0 = vertcat( tau1.pos ) - vertcat( tau2.pos );
d0 = sqrt( dot( u0, u0, 2 ) );
x = double( tensor( d, [ 1, 2, 3 ] ) - tensor( d0, 1 ), [ 1, 2, 3 ] );
%  size of potential terms
m1 = tau1( 1 ).nedges;
m2 = tau2( 1 ).nedges;
siz = [ numel( tau1 ), m1, m2, numel( order ) ];

%  allocate output
[ data.order, data.d0 ] = deal( order, d0 );
[ data.SL1, data.SL2, data.DL1, data.DL2 ] = deal( zeros( siz ) );
%  evaluation functions
at = @( f, k ) f( :, :, :, k );
oint = @( H, f1, f2 ) galerkin.pot1.layer.oint( H, f1, f2 );

for it = 1 : numel( order )  
  %  single layer potential
  xn = x .^ order( it );
  data.SL1( :, :, :, it ) = oint( G .* xn, at( f1, 1 ), at( f2, 1 ) ) +  ...
                            oint( G .* xn, at( f1, 2 ), at( f2, 2 ) ) +  ...
                            oint( G .* xn, at( f1, 3 ), at( f2, 3 ) );
  data.SL2( :, :, :, it ) = oint( G .* xn, fp1, fp2 );
  %  double layer potential
  for k = 1 : 3
    data.DL1( :, :, :, it ) =  ...
    data.DL1( :, :, :, it ) - oint( F1 .* xn, at( g1, k ), at( f2, k ) ) -  ...
                              oint( F1 .* xn, at( f1, k ), at( g2, k ) );  
    data.DL2( :, :, :, it ) =  ...
    data.DL2( :, :, :, it ) - oint( F2 .* xn, at( g1, k ), at( f2, k ) ) -  ...
                              oint( F2 .* xn, at( f1, k ), at( g2, k ) );  
  end
end
