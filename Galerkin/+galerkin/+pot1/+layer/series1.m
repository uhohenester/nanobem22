function data = series1( order, pts )
%  SERIES1 - Precompute Duffy series expansion of BEM potentials. 
%
%  Usage :
%    data = galerkin.pot1.layer.series1( order, pts )
%  Input
%    order  :  order for series expansion
%    pts    :  Duffy quadrature points
%  Output
%    data   :  precomputed BEM potential terms

%  quadrature points and shape elements
[ pos1, f1, fp1 ] = eval( pts, 1 );
[ pos2, f2, fp2 ] = eval( pts, 2 );
%  integration weigths and boundary elements
w = pts.w;
[ tau1, tau2 ] = deal( pts.tau1, pts.tau2 );

%  distance and Green function
u = pos1 - pos2;
d = sqrt( dot( u, u, 3 ) );
G = 1 ./ ( 4 * pi * d );
%  argument for series expansion
u0 = vertcat( tau1.pos ) - vertcat( tau2.pos );
d0 = sqrt( dot( u0, u0, 2 ) );
x = bsxfun( @minus, d, d0 );
%  size of potential terms
m1 = tau1( 1 ).nedges;
m2 = tau2( 1 ).nedges;
siz = [ numel( tau1 ), m1, m2, numel( order ) ];
%  allocate output
[ data.order, data.d0 ] = deal( order, d0 );
[ data.SL1, data.SL2, data.DL1, data.DL2 ] = deal( zeros( siz ) );

for a1 = 1 : m1
for a2 = 1 : m2
  ff1 = squeeze( f1( :, :, a1, : ) );  ffp1 = squeeze( fp1( :, :, a1 ) );
  ff2 = squeeze( f2( :, :, a2, : ) );  ffp2 = squeeze( fp2( :, :, a2 ) );
  %  lowest order contributions for single layer potential 
  SL1 = G .* squeeze( dot( ff1, ff2, 3 ) );
  SL2 = G .* ffp1 .* ffp2;
  %  lowest order contributions for double layer potential
  in = - galerkin.pot1.layer.triple( ff1, u, ff2 ) ./ d;
  DL1 = in .* G;
  DL2 = in .* G ./ d;
  %  loop over orders
  for it = 1 : numel( order )
    n = order( it );
    %  integrate single and double layer potentials
    data.SL1( :, a1, a2, it ) = sum( w .* SL1 .* x .^ n, 2 );
    data.SL2( :, a1, a2, it ) = sum( w .* SL2 .* x .^ n, 2 );
    data.DL1( :, a1, a2, it ) = sum( w .* DL1 .* x .^ n, 2 );
    data.DL2( :, a1, a2, it ) = sum( w .* DL2 .* x .^ n, 2 );  
  end
end
end
