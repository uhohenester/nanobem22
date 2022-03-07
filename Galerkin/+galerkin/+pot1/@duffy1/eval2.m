function data = eval2( obj, k1, varargin )
%  EVAL2 - Evaluate single and double layer potential.
%
%  Usage for obj = galerkin.pot1.duffy2 :
%    data = eval2( obj, k1 )
%    data = eval2( obj, k1, data )
%  Input
%    k1     :  wavenumber of light in medium
%    data   :  previously computed SL and DL terms
%  Output
%    data   :  single and double layer potential

pts = obj.pts;
%  quadrature points and shape elements
[ pos1, f1, fp1 ] = eval( pts, 1 );
[ pos2, f2, fp2 ] = eval( pts, 2 );
%  integration weigths and boundary elements
w = pts.w;
[ tau1, tau2 ] = deal( pts.tau1, pts.tau2 );

%  distance and Green function
u = pos1 - pos2;
d = sqrt( dot( u, u, 3 ) );
G = exp( 1i * k1 * d ) ./ ( 4 * pi * d );
F = ( 1i * k1 - 1 ./ d ) .* G;
%  size of potential terms
m1 = tau1( 1 ).nedges;
m2 = tau2( 1 ).nedges;
siz = [ numel( tau1 ), m1, m2 ];
%  allocate output
[ data.SL, data.DL ] = deal( zeros( siz ) );

for a1 = 1 : m1
for a2 = 1 : m2
  ff1 = squeeze( f1( :, :, a1, : ) );  ffp1 = squeeze( fp1( :, :, a1 ) );
  ff2 = squeeze( f2( :, :, a2, : ) );  ffp2 = squeeze( fp2( :, :, a2 ) );
  %  single and double layer potential
  SL =   G .* ( squeeze( dot( ff1, ff2, 3 ) ) - ffp1 .* ffp2 / k1 ^ 2 );
  DL = - F .* galerkin.pot1.layer.triple( ff1, u, ff2 ) ./ d;
  %  perform integration
  data.SL( :, a1, a2 ) = sum( w .* SL, 2 );
  data.DL( :, a1, a2 ) = sum( w .* DL, 2 );
end
end

%  deal with previously computed SL and DL data
if ~isempty( varargin )
  [ SL, DL, data ] = deal( data.SL, data.DL, varargin{ : } );
  %  loop over refinement elements
  for it = 1 : numel( obj.i1 )
    [ i1, i2 ] = deal( obj.i1( it ), obj.i2( it ) );
    data.SL( i1, :, i2, : ) = SL( it, :, : );
    data.DL( i1, :, i2, : ) = DL( it, :, : );
  end
end
