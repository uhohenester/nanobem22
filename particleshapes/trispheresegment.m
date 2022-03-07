function  p = trispheresegment( phi, theta, diameter )
%  TRISPHERESEGMENT - Discretized surface of sphere.
%
%  Usage :
%    p = trispheresegment( phi, theta, diameter )
%    
%  Input
%    phi          :  azimuthal angles
%    theta        :  polar angles
%    diameter     :  diameter fo sphere
%  Output
%    p            :  discretized particle surface

if ~exist( 'diameter', 'var' ),  diameter = 1;  end
%  grid of PHI and THETA values
[ phi, theta ] = meshgrid( phi, theta );

x = diameter / 2 * sin( theta ) .* cos( phi );
y = diameter / 2 * sin( theta ) .* sin( phi );
z = diameter / 2 * cos( theta );

%  triangular faces
[ faces, verts ] = surf2patch( x, y, z, 'triangles' );
p = particle( verts, faces );
%  remove too small face elements 
area = p.area;
ind = area > 1e-8 * max( area );
faces = faces( ind, : );
%  unique vertices
[ ~, i1, i2 ] = unique( round( verts, 5 ), 'rows' );
p = particle( verts( i1, : ), i2( faces ) );

