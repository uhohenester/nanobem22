%  DEMOSTATEIG01 - Quasistatic eigenmodes for nanosphere.

%  materials, needed for BoundaryVerts but not for eigenmodes
mat1 = Material( 1, 1 );
mat2 = Material( epstable( 'silver.dat' ), 1 );
%  vector of materials
mat = [ mat1, mat2 ];
%  nanosphere
diameter = 10;
p = trisphere( 144, diameter );
%  boundary elements with linear shape elements
tau = BoundaryVert( mat, p, [ 2, 1 ] );

%  default parameters for integration engine
op.rules  = quadboundary.rules( 'quad3', triquad( 3 ) );
op.rules1 = quadboundary.rules( 'quad3', triquad( 11 ) );
op.relcutoff = 2;
%  compute quasistatic eigenmodes
[ ene, u ] = galerkinstat.eig( tau, 'nev', 25, op );

%  eigenmodes for perfect sphere
ltab = [ 0; sphtable( 4 ) ];
ene0 = - 0.5 ./ ( 2 * ltab + 1 );

%  plot eigenenergies
figure
plot( ene, '+' );  hold on
plot( ene0, 'o' );
xlabel( '# Eigenmode' );
ylabel( 'Eigenvalue' );
%  plot eigenmodes
figure
plot( tau, u );
