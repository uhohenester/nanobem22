%  DEMOFIELD01 - Electric field of optically excited nanosphere using the
%    quasistatic approximation.

%  nanosphere
diameter = 10;
p = trisphere( 144, diameter );

mat1 = Material( 1, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
%  material properties
mat = [ mat1, mat2 ];

%  boundary elements with linear shape functions
tau = BoundaryVert( mat, p, [ 2, 1 ] );
%  initialize BEM solver
bem = galerkinstat.bemsolver( tau, 'relcutoff', 2 );
%  planewave excitation
exc = galerkinstat.planewave( [ 1, 0, 0; 0, 1, 0 ] );
% %  dipole excitation
% exc = galerkinstat.dipole( Point( tau, [ 0.8, 0, 0 ] * diameter ) );

% %  solve BEM equation
k0 = 2 * pi / 500;
sol = bem \ exc( tau, k0 );

%  points
n = 51;
xx = 0.8 * diameter * linspace( -1, 1, n );
[ x, y ] = ndgrid( xx );
pt = Point( tau, [ x( : ), y( : ), 0 * x( : ) ] );
%  evaluate fields
e = fields( sol, pt );
ei = fields( exc, pt, k0 );

%%
%  final plot
ee = real( squeeze( dot( e + ei, e + ei, 2 ) ) );
%  plot intensity
figure
imagesc( xx, xx, reshape( ee( :, 1 ), size( x ) ) .' );  hold on

t = linspace( 0, 2 * pi, 200 );
plot( 0.5 * diameter * cos( t ), 0.5 * diameter * sin( t ), 'w-' );

axis equal tight

xlabel( 'x (nm)' );
ylabel( 'y (nm)' );
