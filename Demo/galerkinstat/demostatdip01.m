%  DEMOSTATDIP01 - Lifetime of dipole above nanosphere.

%  nanosphere
diameter = 20;
p = trisphere( 144, diameter );

mat1 = Material( 1, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
%  material properties
mat = [ mat1, mat2 ];

%  boundary elements with linear shape functions
tau = BoundaryVert( mat, p, [ 2, 1 ] );

%  points
n = 41;
z = reshape( diameter * linspace( 0.55, 3, n ), [], 1 );
pt = Point( tau, [ 0 * z, 0 * z, z ] );
%  dipole excitation
dip = galerkinstat.dipole( pt );

%  wavenumber of light in vacuum
k0 = 2 * pi / 500;
%  inhomogeneities for Galerkin scheme
q = dip( tau, k0 );

%  initialize BEM solver
bem = galerkinstat.bemsolver( tau, 'relcutoff', 2 );
%  solve BEM equation
sol = bem \ q;

%%
%  total decay rate
tot = decayrate( dip, sol );

%  Mie solve
mie = miestatsolver( mat2, mat1, diameter, 'lmax', 20 );
decay = decayrate( mie, k0, z );

%  final plot
set( gca, 'ColorOrderIndex', 1 );
plot( z, 1 ./ tot( :, 2 : 3 ), '+-' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( z, 1 ./ decay.totx, 'o-', z, 1 ./ decay.totz, 'o-' );

legend( 'x', 'z', 'x Mie', 'z Mie' );

xlabel( 'Position (nm)' );
ylabel( 'Decay time' );

