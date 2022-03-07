%  DEMOSTATFIELD02 - Electric field of optically excited coupled nanospheres.

%  diameter of sphere and gap distance
diameter = 10;
gap = 2;
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
tau = BoundaryVert( mat, p1, [ 2, 1 ], p2, [ 3, 1 ] );
%  initialize BEM solver
bem = galerkinstat.bemsolver( tau, 'relcutoff', 2, 'waitbar', 1 );
%  planewave excitation
exc = galerkinstat.planewave( [ 0, 0, 1 ] );

% %  solve BEM equation
k0 = 2 * pi / 590;
sol = bem \ exc( tau, k0 );

%  points
n = 51;
xx = 0.8 * diameter * linspace( - 1, 1,     n );
zz = 0.8 * diameter * linspace( - 2, 2, 2 * n );
[ x, z ] = ndgrid( xx, zz );
pt = Point( tau, [ x( : ), 0 * x( : ), z( : ) ] );
%  evaluate fields
e = fields( sol, pt, 'relcutoff', 2, 'waitbar', 1 );
ei = fields( exc, pt, k0 );

%%
%  final plot
ee = real( squeeze( dot( e + ei, e + ei, 2 ) ) );
%  plot intensity
figure
imagesc( xx, zz, reshape( ee, size( x ) ) .' );  hold on

t = linspace( 0, 2 * pi, 101 );
z0 = 0.5 * diameter + 0.5 * gap;
plot( 0.5 * diameter * cos( t ), 0.5 * diameter * sin( t ) - z0, 'w-' );
plot( 0.5 * diameter * cos( t ), 0.5 * diameter * sin( t ) + z0, 'w-' );

set( gca, 'YDir', 'norm' );
axis equal tight

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );
