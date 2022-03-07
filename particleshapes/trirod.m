function p = trirod( diameter, height, varargin )
%  TRIROD - Triangualted rod boundary.
%
%  Usage :
%    p = trirod( diameter, height, n )
%  Input
%    diameter     :  diameter of rod
%    height       :  total height of rod
%    n            :  number of discretization points [nphi,ntheta,nz]
%  Output
%    p        :  triangulated faces and vertices of sphere

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'n', [ 15, 20, 20 ] );
%  parse input
parse( p, varargin{ : } );

%  number of discretization points
n = p.Results.n;
%  angles and z-values
phi   = linspace( 0, 2   * pi, n( 1 ) );
theta = linspace( 0, 0.5 * pi, n( 2 ) );
z = 0.5 * linspace( -1, 1, n( 3 ) ) * ( height - diameter );
%  upper and lower cap
p1 = trispheresegment( phi, theta, diameter );
p1 = particle(  ...
  bsxfun( @plus, p1.verts, [ 0, 0, 0.5 * ( height - diameter ) ] ), p1.faces );
p2 = particle( bsxfun( @times, p1.verts, [ 1, 1, -1 ] ), fliplr( p1.faces ) );

%  cylinder
[ phi, z ] = ndgrid( phi, z );
[ phi, z ] = deal( phi( : ), z( : ) );
faces = fliplr( delaunay( phi, z ) );
verts = [ 0.5 * diameter * cos( phi ), 0.5 * diameter * sin( phi ), z ];
%  particle
p = union( p1, p2, particle( verts, faces ) );
