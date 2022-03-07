%  DEMOSTATEIG02 - Quasistatic eigenmodes for nanoellipsoid.

%  materials, needed for BoundaryVerts but not for eigenmodes
mat1 = Material( 1, 1 );
mat2 = Material( epstable( 'silver.dat' ), 1 );
%  vector of materials
mat = [ mat1, mat2 ];
%  nanoellispsoid
diameter = 10;
p = trispheresegment(  ...
  linspace( 0, 2 * pi, 25 ), linspace( 0, pi, 25 ), diameter );
p.verts( :, 3 ) = 2 * p.verts( :, 3 );
%  boundary elements with linear shape elements
tau = BoundaryVert( mat, p, [ 2, 1 ] );

%  compute quasistatic eigenmodes
[ ene, u ] = galerkinstat.eig( tau, 'nev', 20 );
%  plot eigenmodes
figure
plot( tau, u );
