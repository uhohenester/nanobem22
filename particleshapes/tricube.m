function p = tricube( varargin )
%  TRICUBE - Triangualted cube boundary.
%
%  Usage :
%    p = tricube( n, PropertyPairs )
%  Input
%    n        :  number of points for cube triangulation
%  PropertyName
%    nsub     :  number of refinements at edges
%    siz      :  cube size
%    e        :  parameter for super-sphere
%  Output
%    p        :  triangulated faces and vertices of sphere

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional(  p, 'n', 8 );
addParameter( p, 'nsub', [] );
addParameter( p, 'siz', 1 );
addParameter( p, 'e', [] );
%  parse input
parse( p, varargin{ : } );

%  triangulated plate
[ x, y, faces ] = triplate( p.Results.n, p.Results.nsub, p.Results.e );
%  put together cube
n = numel( x );
faces2 = flip( faces, 2 );
verts = [ x, y, 0 * x - 1;  0 * x - 1, x, y;  y, 0 * x - 1, x;  ...
          x, y, 0 * x + 1;  0 * x + 1, x, y;  y, 0 * x + 1, x ];
faces = [ faces; faces + n; faces + 2 * n;  ...
          faces2 + 3 * n; faces2 + 4 * n;  faces2 + 5 * n ];  

%  deal with super-sphere
if ~isempty( p.Results.e )
 %  vertex positions in spherical coordinates
  [ phi, theta ] =  ...
    cart2sph( verts( :, 1 ), verts( :, 2 ), verts( :, 3 ) );
  %  signed sinus and cosinus
  isin = @( x ) sign( sin( x ) ) .* abs( sin( x ) ) .^ p.Results.e;
  icos = @( x ) sign( cos( x ) ) .* abs( cos( x ) ) .^ p.Results.e;
  %  use super-sphere for rounding-off edges
  verts( :, 1 ) = icos( theta ) .* icos( phi );
  verts( :, 2 ) = icos( theta ) .* isin( phi );
  verts( :, 3 ) = isin( theta );  
end
        
%  remove duplicate vertices
[ ~, i1, i2 ] = unique( round( verts, 8 ), 'rows' );
verts = verts( i1, : );
faces = i2( faces );
%  scale cube
verts = bsxfun( @times, verts, 0.5 * p.Results.siz );

%  set particle structure
p = particle( verts, faces );


function [ x, y, faces ] = triplate( n, nsub, e )
%  TRIPLATE - Triangulated plate.

%  plate vertices
[ x, y ] = ndgrid( linspace( -1, 1, n ) );
%  quadrilaterals
[ i1, i2 ] = deal( 1 : n - 1, 2 : n );
x = [ reshape( x( i1, i1 ), [], 1 ), reshape( x( i2, i1 ), [], 1 ),  ...
      reshape( x( i2, i2 ), [], 1 ), reshape( x( i1, i2 ), [], 1 ) ];
y = [ reshape( y( i1, i1 ), [], 1 ), reshape( y( i2, i1 ), [], 1 ),  ...
      reshape( y( i2, i2 ), [], 1 ), reshape( y( i1, i2 ), [], 1 ) ];
    
 %  refine quadrilaterals at edges
 for i = 1 : nsub
   %  index to quadrilaterals at plate boundary
   ind = any( x == -1, 2 ) | any( x == 1, 2 ) |  ...
         any( y == -1, 2 ) | any( y == 1, 2 );
   %  vertices of quadrilaterals at plate boundary
   x1 = x( ind, 1 );  x2 = x( ind, 2 );  xm = 0.5 * ( x1 + x2 );
   y1 = y( ind, 1 );  y2 = y( ind, 4 );  ym = 0.5 * ( y1 + y2 );
   %  split quadrilaterals
   x = [ x( ~ind, : );   ...
         x1, xm, xm, x1;  xm, x2, x2, xm;  ...
         x1, xm, xm, x1;  xm, x2, x2, xm ];
   y = [ y( ~ind, : );  ...
         y1, y1, ym, ym;  y1, y1, ym, ym;  ...
         ym, ym, y2, y2;  ym, ym, y2, y2 ];
 end
       
%  vertices and faces
[ ~, ind ] = unique( round( [ x( : ), y( : ) ], 8 ), 'rows' );
[ x, y ] = deal( x( ind ), y( ind ) );
faces = delaunay( x, y );

%  deal with super-sphere
if ~isempty( e )
  x = sign( x ) .* ( abs( x ) ) .^ ( 1 / e );
  y = sign( y ) .* ( abs( y ) ) .^ ( 1 / e );
end
                                  