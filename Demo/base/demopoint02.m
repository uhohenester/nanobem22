%  DEMOPOINT02 - Place points in environment of coupled spheres.

%  diameter of sphere and gap distance
diameter = 50;
gap = 5;
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


%  points
xx =       diameter * linspace( - 0.8, 0.8, 41 );
zz = 1.6 * diameter * linspace( - 0.8, 0.8, 81 );
[ x, z ] = ndgrid( xx, zz );
%  put points in dielectric environment
pt = Point( tau, [ x( : ), 0 * x( : ), z( : ) ] );

%  material index
imat = horzcat( pt.imat );
%  loop over materials
for i = unique( imat )
  pos = vertcat( pt( imat == i ).pos );
  h = plot( pos( :, 1 ), pos( :, 3 ), 'o', 'MarkerSize', 3 );  hold on
  h.MarkerFaceColor = get( h, 'Color' );
end

t = linspace( 0, 2 * pi, 101 );
z0 = 0.5 * diameter + 0.5 * gap;
plot( 0.5 * diameter * cos( t ), 0.5 * diameter * sin( t ) - z0, 'k-' );
plot( 0.5 * diameter * cos( t ), 0.5 * diameter * sin( t ) + z0, 'k-' );

axis equal tight off
