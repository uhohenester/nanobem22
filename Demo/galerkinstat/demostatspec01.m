%  DEMOSTATSPEC01 - Optical spectrum for metallic nanosphere using the 
%    quasistatic approximation.

%  nanosphere
diameter = 20;
p = trisphere( 144, diameter );

%  dielectric functions for water and gold
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
%  material properties
mat = [ mat1, mat2 ];

%  boundary elements with linear shape functions
tau = BoundaryVert( mat, p, [ 2, 1 ] );
%  quasistatic BEM solver
bem = galerkinstat.bemsolver( tau, 'relcutoff', 2 );

%  plane wave excitation
exc = galerkinstat.planewave( [ 1, 0, 0; 0, 1, 0 ] );

%  light wavelength in vacuum
lambda = linspace( 400, 700, 30 );
k0 = 2 * pi ./ lambda;
%  allocate scattering and extinction cross sections
sca = zeros( numel( k0 ), 2 );
ext = zeros( numel( k0 ), 2 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavenumbers
for i = 1 : numel( k0 )
  %  surface charge
  sol = bem \ exc( tau, k0( i ) );
  %  scattering and extinction cross sections
  sca( i, : ) = exc.sca( sol );
  ext( i, : ) = exc.ext( sol );

  multiWaitbar( 'BEM solver', i / numel( k0 ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( lambda, sca, 'o-'  );  hold on;

xlabel( 'Wavelength (nm)' );
ylabel( 'Cross section (nm^2)' );

%  comparison with Mie theory
mie = miestatsolver( mat2, mat1, diameter );
csca0 = scattering( mie, k0 );
cext0 = extinction( mie, k0 );

plot( lambda, csca0, '+-' ); 

legend( 'BEM x', 'BEM y', 'Mie' );
