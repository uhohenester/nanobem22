%  DEMOCALDERON01 - Calderon matrix for nanosphere.

%  materials, vacuum and silver
mat1 = Material( 1, 1 );
mat2 = Material( epstable( 'silver.dat' ), 1 );
%  vector of materials
mat = [ mat1, mat2 ];
%  nanosphere
diameter = 10;
p = trisphere( 144, diameter );
%  boundary elements with Raviart-Thomas shape elements
tau = BoundaryEdge( mat, p, [ 2, 1 ] );

%  quadrature engine, default integrator
pot( 1 ) = galerkin.pot1.std;
pot( 2 ) = galerkin.pot1.refine1( 'relcutoff', 2 );
pot( 3 ) = galerkin.pot1.duffy1( 'nduffy', 4 );
%  apply quadrature engine to boundary elements
%    this approach only works for sufficiently small nanoparticles with
%    only one STD potential integrator
pot = set( pot, tau, tau, 'memax', 1e8 );

%  wavenumber of light in medium
k0 = 2 * pi / 500;
k1 = mat1.k( k0 );
%  evaluate default integrator and refinement integrators
data = eval2( pot( 1 ), k1 );
for it = 2 : numel( pot )
  data = eval2( pot( it ), k1, data );
end

%  plot single layer potential
figure
imagesc( log10( abs( squeeze( data.SL( :, 1, :, 1 ) ) ) ) );
xlabel( 'Boundary Element \tau' );
ylabel( 'Boundary Element \tau' );

%  convert to global degrees of freedom
[ nu1, nu2 ] = ndgrid( vertcat( tau.nu ) );
SL = accumarray( { nu1( : ), nu2( : ) }, data.SL( : ) );
%  plot single layer potential
figure
imagesc( log10( abs( SL ) ) );
xlabel( 'Global DOF \nu' );
ylabel( 'Global DOF \nu' );
