%  DEMORETSPEC01 - Optical spectrum for metallic nanosphere using the 
%    full Maxwell's equations.

%  nanosphere
diameter = 50;
p = trisphere( 144, diameter );

%  dielectric functions for water and gold
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
%  material properties
mat = [ mat1, mat2 ];

%  boundary elements with linear shape functions
tau = BoundaryEdge( mat, p, [ 2, 1 ] );
%  initialize BEM solver
rules = quadboundary.rules( 'quad3', triquad( 1 ) );
bem = galerkin.bemsolver( tau, 'rules', rules, 'waitbar', 1 );

%  planewave excitation
exc = galerkin.planewave( [ 1, 0, 0 ], [ 0, 0, 1 ] );

%  light wavelength in vacuum
lambda = linspace( 400, 800, 20 );
k0 = 2 * pi ./ lambda;
%  allocate optical cross sections
[ csca, csca2, cabs, cext ] = deal( zeros( numel( k0 ), size( exc.pol, 1 ) ) );

%  far-field spectrometer
rules = quadboundary.rules( 'quad3', triquad( 1 ) );
spec = galerkin.spectrum( mat, trisphere( 256 ), 'rules', rules );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavenumbers
for i = 1 : numel( k0 )
  %  solution of BEM equations
  sol = bem \ exc( tau, k0( i ) );

  %  scattering and extinction cross sections
  csca( i, : ) = scattering( exc, sol );
  cabs( i, : ) = absorption( exc, sol );
  cext( i, : ) = extinction( exc, sol );
  %  scattering cross section using far-fields
  csca2( i, : ) = farscattering( exc, sol, spec );
 
  multiWaitbar( 'BEM solver', i / numel( k0 ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );


%%  final plot
plot( lambda, csca, 'o-'  );  hold on
plot( lambda, csca2, 's-' );

xlabel( 'Wavelength (nm)' );
ylabel( 'Cross section (nm^2)' );

%  comparison with Mie theory
mie = miesolver( mat2, mat1, diameter );
csca0 = scattering( mie, k0 );
cabs0 = absorption( mie, k0 );
cext0 = extinction( mie, k0 );

plot( lambda, csca0, '+-' ); 

legend( 'sca', 'farsca', 'Mie' );
