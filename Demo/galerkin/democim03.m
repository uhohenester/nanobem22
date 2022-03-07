%  DEMOCIM03 - Optical spectrum for Si nanosphere using CIM.

%  nanosphere
diameter = 150;
p = trisphere( 400, diameter );

%  Si dielectric function
%    see Sauvan, Opt. Express 29, 8268 (2021)
epsz = @( w ) 8.51 * ( 1 - 2.38 ^ 2 ./ ( w .^ 2 - 3.35 ^ 2 + 0.076i * w ) );
%  dielectric functions for air and Si
mat1 = Material( 1, 1 );
mat2 = Material( epsz, 1 );
%  material properties
mat = [ mat1, mat2 ];

%  boundary elements with linear shape functions
tau = BoundaryEdge( mat, p, [ 2, 1 ] );
%  countour integral method solver
cim = galerkin.cimsolver( tau, 'nr', 250 );
cim.contour = cimbase.ellipse( [ 1.5, 3.1 ], 0.2, 60 );
%  compute contour integral and eigenvalues
rules = quadboundary.rules( 'quad3', triquad( 1 ) );
data = eval1( cim, 'relcutoff', 2, 'rules', rules, 'waitbar', 1 );

tol = tolselect( cim, data, 'tol', 1e-2 );
if isempty( tol ),  return;  end
cim = eval2( cim, data, 'tol', tol );
%  add nonresonant background to CIM solver
ktab = 2 * pi ./ [ 450, 600, 700 ];
cim.nonresonant = diffcalderon( cim, data.bem, ktab );

%  planewave excitation
exc = galerkin.planewave( [ 1, 0, 0 ], [ 0, 0, 1 ] );

%  light wavenumber in vacuum
lambda = linspace( 400, 800, 40 );
k0 = 2 * pi ./ lambda;
%  allocate optical cross sections
[ cext1, cext2, cext3 ] = deal( zeros( numel( k0 ), size( exc.pol, 1 ) ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavenumbers
for i = 1 : numel( k0 )
  %  solution of BEM equations
  sol1 = solve( cim, exc( tau, k0( i ) ), 'nonresonant', 1 );
  sol2 = solve( cim, exc( tau, k0( i ) ), 'nonresonant', 0 );
  sol3 = data.bem \ exc( tau, k0( i ) );

  %  extinction cross sections
  cext1( i, : ) = extinction( exc, sol1 );
  cext2( i, : ) = extinction( exc, sol2 );
  cext3( i, : ) = extinction( exc, sol3 );
 
  multiWaitbar( 'BEM solver', i / numel( k0 ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );


%%  final plot
figure
plot( lambda, cext1, 'o-' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( lambda, cext1 - cext2, '--'  );  
plot( lambda, cext3, 's-'  );  

xlabel( 'Wavelength (nm)' );
ylabel( 'Cross section (nm^2)' );

%  comparison with Mie theory
mie = miesolver( mat2, mat1, diameter );
cext0 = extinction( mie, k0 );

plot( lambda, cext0, '+-' ); 

legend( 'CIM + bg', 'bg', 'BEM', 'Mie' );
