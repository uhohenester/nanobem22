%  DEMOCIM02 - Compute resonance modes and perform simulations for
%    oscillating dipole in proximity to ellipsoid.

%  nanosphere
diameter = 50;
p = trisphere( 144, diameter );
p.verts( :, 3 ) = p.verts( :, 3 ) * 2;

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
%  points for dipole positions
n = 41;
z = reshape( max( p.verts( :, 3 ) ) * linspace( 1.1, 5, n ), [], 1 );
pt = Point( tau, [ 0 * z, 0 * z, z ] );
%  dipole excitation
dip = galerkin.dipole( pt );

%  wavenumber of light in vacuum
k0 = 2 * pi / 550;
%  inhomogeneities for Galerkin scheme
q = dip( tau, k0 );

%  solve BEM equations
sol1 = data.bem \ q;
sol2 = cim \ q;

%  total decay rates
[ tot1, rad1 ] = decayrate( dip, sol1 );
[ tot2, rad2 ] = decayrate( dip, sol2 );

%%  final plot
figure
set( gca, 'ColorOrderIndex', 1 );
plot( z, 1 ./ tot1( :, 2 : 3 ), '+-' );  hold on
set( gca, 'ColorOrderIndex', 1 );
plot( z, 1 ./ tot2( :, 2 : 3 ), 'o-' );  hold on

legend( 'x CIM', 'z CIM', 'x BEM', 'z BEM' );

xlabel( 'Position (nm)' );
ylabel( 'Decay time' );
