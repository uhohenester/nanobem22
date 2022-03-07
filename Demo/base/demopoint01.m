%  DEMOPOINT01 - Place points in environment of sphere.

%  nanosphere
diameter = 20;
p = trisphere( 144, diameter );

mat1 = Material( 1, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
%  material properties
mat = [ mat1, mat2 ];

%  boundary elements with linear shape functions
tau = BoundaryVert( mat, p, [ 2, 1 ] );

%  points
xx = diameter * linspace( - 0.8, 0.8, 51 );
[ x, y ] = ndgrid( xx );
%  put points in dielectric environment
pt = Point( tau, [ x( : ), y( : ), 0 * x( : ) ] );

%  material index
imat = horzcat( pt.imat );
%  loop over materials
for i = unique( imat )
  pos = vertcat( pt( imat == i ).pos );
  h = plot( pos( :, 1 ), pos( :, 2 ), 'o', 'MarkerSize', 3 );  hold on
  h.MarkerFaceColor = get( h, 'Color' );
end

t = linspace( 0, 2 * pi, 101 );
plot( 0.5 * diameter * cos( t ), 0.5 * diameter * sin( t ), 'k-' );

axis equal tight off
