function [ plate, obj ] = plate( obj, varargin )
%  PLATE - Make a plate out of polygons.
%
%  Usage for obj = polygon3 :
%    [ p, poly ] = plate( obj, PropertyPairs )
%  PropertyName
%    'dir'      :  direction of surface normals for plate
%    'hdata'    :  data array for Mesh2d
%    'op'       :  options for Mesh2d
%    'refun'    :  refine function
%    'edge'     :  edge profile
%  Output
%    plate      :  discretized plate
%    poly       :  polygons for plate

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'dir', 1 );
addParameter( p, 'edge', [] );
addParameter( p, 'refun', [] );
addParameter( p, 'hdata', struct );
addParameter( p, 'op', struct( 'output', false ) );
%  parse input
parse( p, varargin{ : } );

%  get z-values of polygons
z = arrayfun( @( obj ) obj.z, obj );
%  make sure that all z-values are identical
[ z, ind ] = unique( round( z, 8 ) );  assert( numel( ind ) == 1 );
%  overwrite edge profile
if ~isempty( p.Results.edge ),  obj = set( obj, 'edge', p.Results.edge );  end

%  refine functions of polygons
fun = arrayfun( @( obj ) obj.refun, obj, 'UniformOutput', false );
%  add refine function passed to PLATE
if ~isempty( p.Results.refun ),  fun{ end + 1 } = p.Results.refun;  end

hdata = p.Results.hdata;
op = p.Results.op;

if ~all( cellfun( 'isempty', fun ) )
  hdata.fun = @( x, y, ~ ) refun( obj, x, y, fun );
end

%  get polygons
poly = arrayfun( @( obj ) obj.poly, obj, 'UniformOutput', false );
poly = horzcat( poly{ : } );
%  triangulate plate
[ verts, faces ] = polymesh2d( poly, 'hdata', hdata, 'options', op );
%  add additional boundary points to polygon at boundary
for it = 1 : numel( obj )
  obj( it ).poly = interp1( obj( it ).poly, verts );
end

%  make particle
plate = particle( [ verts, 0 * verts( :, 1 ) + obj( 1 ).z ], faces );
%  direction of plate normal
%  make sure that normal vector point into right direction
if sign( sum( plate.nvec( :, 3 ) ) ) ~= p.Results.dir
  plate.faces = fliplr( plate.faces ); 
end

%  index to polygon position 
ipoly = zeros( size( obj ) );
% minimum distance to polygons (for EDGESHIFT)
dmin = inf( size( plate.verts, 1 ), 1 );

%  loop over polygons
for it = 1 : numel( obj )
  %  add additional boundary points to polygon at boundary
  poly = interp1( obj( it ).poly, plate.verts( :, 1 : 2 ) );
  %  index to vertices at boundary
  [ row, ~ ] = find(  ...
      bsxfun( @eq, plate.verts( :, 1 ), poly.pos( :, 1 ) .' ) &  ...
      bsxfun( @eq, plate.verts( :, 2 ), poly.pos( :, 2 ) .' ) );
  %  save first point on polygon
  ipoly( it ) = row( 1 );
  
  %  distance to edges
  d = dist( poly, plate.verts( :, 1 : 2 ) );
  %  index to distances smaller than DMIN and update DMIN
  ind = d < dmin;  dmin( ind ) = d( ind );
  %  shift edges
  plate.verts( ind, 3 ) = z + vshift( obj( it ).edge, obj( it ).z, d( ind ) );
end

%  z-value of polygons
for it = 1 : numel( obj ),  obj( it ).z = plate.verts( ipoly( it ), 3 );  end
%  particle with midpoints
plate = particle( plate.verts, plate.faces );


function h = refun( obj, x, y, fun )
%  REFUN - Refine function for Mesh2d toolbox.
%
%  Usage for obj = polygon3d :
%    h = refun( obj, x, y, fun )
%  Input
%    x, y   :  mesh points
%    fun    :  user-provided refine function 
%  Output
%    h      :  parameter that controls discretization of Mesh2d toolbox
%
%  The refine function is of the form fun(pos,d), where POS is the
%  position and D the distance(s) to the polygon(s).

%  position
pos = [ x( : ), y( : ), 0 * x( : ) + obj( 1 ).z ];
%  distance array
d = arrayfun(  ...
  @( obj ) dist( obj.poly, [ x( : ), y( : ) ] ), obj, 'UniformOutput', false );

%  index to non-empty refine functions
ind = ~cellfun( 'isempty', fun( 1 : numel( obj ) ) );  
%  discretization parameter
if ~isempty( ind )
  h = cellfun( @( fun, d ) fun( pos, d ), fun( ind ), d( ind ), 'UniformOutput', false );
  h = min( [ h{ : } ], [], 2 );
else
  h = inf;
end
%  refine function passed to PLATE
if numel( fun ) > numel( obj ),  h = min( [ h, fun{ end }( pos, d ) ], [], 2 ); end
