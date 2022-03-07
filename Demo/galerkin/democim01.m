%  DEMOCIM01 - Compute resonance modes and perform simulations for
%    optically excited ellipsoid.

%  nanoellipsoid
diameter = 50;
p = trisphere( 144, diameter );
p.verts( :, 1 ) = p.verts( :, 1 ) * 2;

mat1 = Material( 1, 1 );
mat2 = Material( epsdrude( 'Au' ), 1 );
%  material properties
mat = [ mat1, mat2 ];

%  boundary elements with linear shape functions
tau = BoundaryEdge( mat, p, [ 2, 1 ] );
%  countour integral method solver
cim = galerkin.cimsolver( tau, 'nr', 150 );
cim.contour = cimbase.ellipse( [ 1.5, 2.6 ], 0.2, 60 );
%  compute contour integral and eigenvalues
rules = quadboundary.rules( 'quad3', triquad( 1 ) );
data = eval1( cim, 'relcutoff', 2, 'rules', rules, 'waitbar', 1 );

tol = tolselect( cim, data, 'tol', 1e-2 );
if isempty( tol ),  return;  end
cim = eval2( cim, data, 'tol', tol );

% plot( horzcat( cim.contour.z ) );  hold on
% plot( cim.ene, 'm+' );

%%
%  planewave excitation
exc = galerkin.planewave( [ 1, 0, 0 ], [ 0, 0, 1 ] );

%  light wavelength in vacuum
lambda = linspace( 400, 700, 20 );
k0 = 2 * pi ./ lambda;
%  allocate optical cross sections
[ csca, csca2, cabs, cabs2, csca3, cext, cext2 ] =  ...
  deal( zeros( numel( k0 ), size( exc.pol, 1 ) ) );

%  far-field spectrometer
rules = quadboundary.rules( 'quad3', triquad( 1 ) );
spec = galerkin.spectrum( mat, trisphere( 256 ), 'rules', rules );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavenumbers
for i = 1 : numel( k0 )
  %  solution of BEM equations
  sol1 = cim \ exc( tau, k0( i ) );
  %  optical cross sections
  csca( i, : ) = farscattering( exc, sol1, spec );
  cabs( i, : ) = absorption( exc, sol1 );
  cext( i, : ) = extinction( exc, sol1 );
  
  sol2 = data.bem \ exc( tau, k0( i ) );
  csca2( i, : ) = farscattering( exc, sol2, spec );
  cabs2( i, : ) = absorption( exc, sol2 );
  cext2( i, : ) = extinction( exc, sol2 );
  
  multiWaitbar( 'BEM solver', i / numel( k0 ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
figure
plot( lambda, cext,  'o-' );  hold on
plot( lambda, cext2, '+-' );

legend( 'CIM', 'BEM' );

xlabel( 'Wavelength (nm)' );
ylabel( 'Cross section (nm^2)' );
