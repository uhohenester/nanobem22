function  p = trisphere( n, varargin )
%  Load points on sphere from file and perform triangulation.
%    Given a set of stored points on the surface of a sphere, 
%    TRISPHERE loads the points and performs a triangulation.
%
%  Usage :
%    fv = trisphere( n, diameter )
%  Input
%    n         :  number of points for sphere triangulation
%    diameter  :  diameter of sphere
%  Output
%    p         :  triangulated faces and vertices of sphere

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'diameter', 1 );
%  parse input
parse( p, varargin{ : } );

%%  load data from file
%  saved vertex points
nsav = [ 32 60 144 169 225 256 289 324 361 400 441 484 529 576 625  ...
         676 729 784 841 900 961 1024 1225 1444 ];
     
%  find number closest to saved number
[ ~, ind ] = min( abs( nsav - n ) );
%  input file name
inp = [ 'sphere', num2str( nsav( ind ) ) ];

if n ~= nsav( ind )
  fprintf( 1, 'trisphere: loading %s from trisphere.mat\n', inp ); 
end

%  load data from file
load( 'trisphere.mat', '-regexp', inp );
eval( [ 'sphere = ', inp, ';' ] );

%%  make sphere
%  vertices
verts = [ double( sphere.x ), double( sphere.y ), double( sphere.z ) ];
%  face list
faces = sphtriangulate( verts );
%  rescale sphere
verts = 0.5 * verts * p.Results.diameter;
%  make particle
p = particle( verts, faces );



function faces = sphtriangulate( verts )
%  Triangulates a set of points on the unit sphere.
%    Using stereographical projection, SPHTRIANGULATE returns the
%    triangulated surface for the input array verts. The routine is
%    adapted from a matlab file from Tianli Yu (www.mathworks.com).
%
%  STEPS
%    1.  Use the first vertex as the projection center and project all
%        other points onto a plane.
%    2.  Call the Delaunay triangulation to triangulate the points in
%        the plane.
%    3.  Connect the first point to the convex hull of the other vertices
%        in the plane.
%
%  Usage :
%    faces = sphtriangulate( verts )
%  Input
%    verts  :  n x 3 matrix of vertices
%  Output
%    faces  :  m x 3 matrix of faces

n = size( verts, 1 );

%%  Step 1. Projection
%           Select the first vertex as the projection center
center = verts( 1, : );     

%  build a rotation matrix that rotates the first point to [ 0 0 -1 ]
r3 = -center;
if ( center( 3 ) ~= 0 )
  r2 = [ 0, -r3( 3 ), r3( 2 ) ];
else
  r2 = [ -r3( 2 ), r3( 1 ), 0 ];
end
r2 = r2 / norm( r2 );
r1 = cross( r3, r2, 2 );
  
rot = [ r1; r2; r3 ];

%  compute rotated vertex list
vertr = verts( 2 : n, : ) * rot';

%  use the projection center [ 0 0 -1 ] to project all points to z = 0
%  solve the simple intersection problem
tp = -ones( n - 1, 1 ) ./ ( vertr( :, 3 ) + 1 );
xp = vertr( :, 1 ) .* tp;
yp = vertr( :, 2 ) .* tp;


%%  Step 2. Triangulate the projected points
faces = delaunay( xp, yp );

%  make all surface normal point into outward direction
vertp = [ xp, yp, zeros( n - 1, 1 ) ];
u = vertp( faces( :, 1 ), : ) - vertp( faces( :, 2 ), : );
v = vertp( faces( :, 3 ), : ) - vertp( faces( :, 2 ), : );
w = cross( u, v, 2 );

index = find( w( :, 3 ) > 0 );
faces( index, : ) = fliplr( faces( index, : ) );


%%  Step 3. Triangulate the last missing triangles 
%           by connecting the projection center to the convex hull vertices
hindex = convhull( xp, yp );
hlen = length( hindex ) - 1;

faces = [ faces + 1;                                       ...
          hindex( 2:hlen + 1 ) + 1, hindex( 1:hlen ) + 1,  ...
                                           ones( hlen, 1 ) ];
                                         