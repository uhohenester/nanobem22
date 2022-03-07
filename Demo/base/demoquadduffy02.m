%  DEMOQUADDUFFY02 - Apply quadrature rules for Duffy integration.

%    See D'Elia et al., Int. J. Num. Methods in Biomed. Eng. 27, 314 (2011)
%    Table 9

%  dummy material vector
mat = [];
%  triangulate plate
[ x, y ] = ndgrid( linspace( - 1, 1, 6 ) );
[ faces, verts ] = surf2patch( x, y, 0 * x, 'triangles' );
%  boundary elements
p = particle( verts, faces );
tau = BoundaryEdge( mat, p, [ 2, 1 ] );

%  quadrature points for default integration
std = quadboundary( tau, 'quad3', triquad( 11 ) );
%  Duffy integration for touching triangles 
nduffy = 4;
duffy = quadduffy( tau, tau, nduffy );

%  set output
m = 5;
Z = zeros( 1, m );
%  dummy indices for internal tensor class
[ i, i1, i2, q, q1, q2 ] = deal( 1, 2, 3, 4, 5, 6 );
%  semi-analytic Z, Table 9
Z0 = [ 23.785677, 0.705130, 0.337057, 0.083744, 0.057834 ];


for it = 1 : m
  %  default integration points
  [ pos, w ] = eval( std );
  %  integration points for square
  x1 = tensor( pos( :, :, 1 ), [ i1, q1 ] );
  y1 = tensor( pos( :, :, 2 ), [ i1, q1 ] );
  x2 = tensor( pos( :, :, 1 ), [ i2, q2 ] );
  y2 = tensor( pos( :, :, 2 ), [ i2, q2 ] );  
  %  integration weights
  w = tensor( w, [ i1, q1 ] ) * tensor( w, [ i2, q2 ] );
  %  integrand
  r = sqrt( ( x1 - x2 ) .^ 2 + ( y1 - y2 ) .^ 2 );
  z = ( x1 * y1 * x2 * y2 ) .^ ( it - 1 ) ./ r;
  %  default integration
  z = double( sum( w * z, q1, q2 ), [ i1, i2 ] );
  
  %  Duffy integration
  for quad = duffy
    %  index to boundary pairs with refinement
    [ ~, ind1 ] = ismember( vertcat( quad.tau1.pos ), vertcat( tau.pos ), 'rows' );
    [ ~, ind2 ] = ismember( vertcat( quad.tau2.pos ), vertcat( tau.pos ), 'rows' );
    %  quadrature points
    pos1 = eval( quad, 1 );
    pos2 = eval( quad, 2 );
    %  integration points for square
    x1 = tensor( pos1( :, :, 1 ), [ i, q ] );
    y1 = tensor( pos1( :, :, 2 ), [ i, q ] );
    x2 = tensor( pos2( :, :, 1 ), [ i, q ] );
    y2 = tensor( pos2( :, :, 2 ), [ i, q ] );  
    %  integration weights
    w = tensor( quad.w, [ i, q ] );
    %  integrand
    r = sqrt( ( x1 - x2 ) .^ 2 + ( y1 - y2 ) .^ 2 );
    z1 = ( x1 * y1 * x2 * y2 ) .^ ( it - 1 ) ./ r;
    %  Duffy integration
    ind = sub2ind( size( z ), ind1, ind2 );
    z( ind ) = double( sum( w * z1, q ), i );    
  end
  
  %  perform integration
  Z( it ) = sum( z( : ) );
end

%  final output
fprintf( 1, '  %1s  %10s  %10s\n', 'm', 'Z', 'Z0' );
for it = 1 : m
  fprintf( 1, '  %1i  %10.6f  %10.6f\n', it - 1, Z( it ), Z0( it ) );
end
