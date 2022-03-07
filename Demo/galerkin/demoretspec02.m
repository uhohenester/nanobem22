%  DEMORETSPEC02 - Optical spectra for coupled nanospheres.

%  diameter of sphere and gap distance
diameter = 50;
gap = 10;
%  angles for sphere discretization
phi = linspace( 0, 2 * pi, 21 );
theta = pi * linspace( 0, 1, 21 ) .^ 2;
%  spheres
[ p1, p2 ] = deal( trispheresegment( phi, theta, diameter ) );
p1.verts( :, 3 ) =   p1.verts( :, 3 ) - 0.5 * ( diameter + gap );
p2.verts( :, 3 ) = - p2.verts( :, 3 ) + 0.5 * ( diameter + gap );
%  flip faces 
p2.faces = p2.faces( :, [ 1, 3, 2 ] );

%  dielectric functions
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
mat3 = Material( epstable( 'gold.dat' ), 1 );
%  material properties
mat = [ mat1, mat2, mat3 ];

%  boundary elements with linear shape functions
tau = BoundaryEdge( mat, p1, [ 2, 1 ], p2, [ 3, 1 ] );
%  initialize BEM solver
rules = quadboundary.rules( 'quad3', triquad( 1 ) );
bem = galerkin.bemsolver( tau, 'rules', rules, 'waitbar', 1 );

%  planewave excitation
exc = galerkin.planewave( [ 1, 0, 0; 0, 0, 1 ], [ 0, 0, 1; 1, 0, 0 ] );

%  light wavelength in vacuum
lambda = linspace( 400, 800, 20 );
k0 = 2 * pi ./ lambda;
%  allocate optical cross sections
[ csca, cabs, cext ] = deal( zeros( numel( k0 ), size( exc.pol, 1 ) ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavenumbers
for i = 1 : numel( k0 )
  %  solution of BEM equations
  sol = bem \ exc( tau, k0( i ) );

  %  scattering and extinction cross sections
  csca( i, : ) = scattering( exc, sol );
  cabs( i, : ) = absorption( exc, sol );
  cext( i, : ) = extinction( exc, sol );
 
  multiWaitbar( 'BEM solver', i / numel( k0 ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );


%%  final plot
plot( lambda, csca, 'o-'  );  hold on

xlabel( 'Wavelength (nm)' );
ylabel( 'Cross section (nm^2)' );
