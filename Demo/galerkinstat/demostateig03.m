%  DEMOSTATEIG03 - Quasistatic eigenmodes for nanocube.

%  materials, needed for BoundaryVerts but not for eigenmodes
mat1 = Material( 1, 1 );
mat2 = Material( epstable( 'silver.dat' ), 1 );
%  vector of materials
mat = [ mat1, mat2 ];
%  nanocube
p = tricube( 10, 'nsub', 1, 'e', 0.25, 'siz', 10 );
%  boundary elements with linear shape elements
tau = BoundaryVert( mat, p, [ 2, 1 ] );

%  compute quasistatic eigenmodes
[ ene, u ] = galerkinstat.eig( tau, 'nev', 20 );
%  plot eigenmodes
figure
plot( tau, u );
