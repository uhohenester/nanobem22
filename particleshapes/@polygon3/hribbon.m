function [ rib, in, out ] = hribbon( obj, d, varargin )
%  HRIBBON - Make horizontal ribbon.
%
%  Usage for obj = polygon3 :
%    [ rib, in, out ] = vribbon( obj, d, PropertyPairs )
%  Input
%    d          :  d-values of horizontal ribbon
%  PropertyPair
%    'dir'      :  direction of surface normals for ribbon
%  Output
%    p          :  discretized horizontal ribbon
%    in, out    :  POLYGON3 for inner/outer ribbon boundary

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'dir', 1 );
%  parse input
parse( p, varargin{ : } );

%  cell arrays for output
[ rib, in, out ] = deal( cell( size( obj ) ) );
%  loop over polygons
for it = 1 : numel( obj )
  %  discretize ribbon
  [ rib{ it }, in{ it }, out{ it } ] =  ...
    ribbon( obj( it ), d, p.Results.dir, varargin{ : }  );
end

%  put together particles and polygons
[ rib, in, out ] =  ...
  deal( vertcat( rib{ : } ), vertcat( in{ : } ), vertcat( out{ : } ) );


function [ rib, in, out ] = ribbon( obj, rib, dir, varargin )
%  RIBBON - Make horizontal ribbon for a single polygon.

%  smoothened polygon
poly = midpoints( obj.poly );
%  positions and normal vector of polygon
[ pos, nvec ] = deal( poly.pos, norm( poly ) );
%  close contour ?
if isempty( sym ) || ~all( abs( prod( pos( [ 1, end ], : ), 2 ) ) < 1e-6 )
  pos = [ pos; pos( 1, : ) ];
  nvec = [ nvec; nvec( 1, : ) ];
end

%  triangulate flat ribbon 
[ u, faces ] = fvgrid( 1 : size( pos, 1 ), 1 : length( rib ) );

%  face vertices
[ x, y ] = deal( zeros( size( pos, 1 ), numel( rib ) ) ); 
%  loop over displacements
for i = 1 : length( rib )
  [ ~, dist ] = shiftbnd( poly, rib( i ) );  
  %  deal with closed polygons
  if numel( dist ) ~= size( pos, 1 ),  dist = [ dist; dist( 1 ) ];  end
  %  displace ribbon vertices
  x( :, i ) = pos( :, 1 ) + dist .* nvec( :, 1 ); 
  y( :, i ) = pos( :, 2 ) + dist .* nvec( :, 2 );
end

%  assemble vertices
verts = [ x( sub2ind( size( x ), u( :, 1 ), u( :, 2 ) ) ),  ...
          y( sub2ind( size( x ), u( :, 1 ), u( :, 2 ) ) ) ];
%  save as particle
rib = particle( [ verts, 0 * verts( :, 1 ) + obj.z ], faces, varargin{ : } );
%  make sure that normal vector point into right direction
if sign( sum( rib.nvec( :, 3 ) ) ) ~= dir,  rib = flipfaces( rib ); end

%  shift function
shift = @( d ) shiftbnd( obj.poly, d );
%  polygon for upper/lower ribbon boundary
in  = obj;  [ in. poly, in. z ] = deal( shift( min( rib ) ), obj.z );
out = obj;  [ out.poly, out.z ] = deal( shift( max( rib ) ), obj.z );

