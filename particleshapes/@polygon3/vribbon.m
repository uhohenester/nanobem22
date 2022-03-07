function [ rib, up, lo ] = vribbon( obj, varargin )
%  VRIBBON - Extrude vertical ribbon.
%
%  Usage for obj = polygon3 :
%    [ rib, up, lo ] = vribbon( obj, z, PropertyPairs )
%    [ rib, up, lo ] = vribbon( obj,    PropertyPairs )
%  Input
%    z          :  z-values of vertical ribbon
%                    use default edge values if missing
%  PropertyName
%    'edge'     :  edge profile
%  Output
%    rib        :  discretized vertical ribbon
%    up, lo     :  POLYGON3 for upper/lower ribbon boundary

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'z', [] );
addParameter( p, 'edge', [] );
addParameter( p, 'refun', [] );
%  parse input
parse( p, varargin{ : } );

%  cell arrays for output
[ rib, up, lo ] = deal( cell( size( obj ) ) );

%  loop over polygons
for it = 1 : numel( obj )
  %  edge profile of ribbon
  fun = @( z ) hshift( obj( it ).edge, z );
  %  discretize ribbon
  if isempty( p.Results.z )
    z = obj( it ).edge.z;
  else
    z = p.Results.z;
  end 
  [ rib{ it }, up{ it }, lo{ it } ] = ribbon( obj( it ), z, fun, varargin{ : } );
end

%  put together particles and polygons
[ rib, up, lo ] =  ...
  deal( vertcat( rib{ : } ), vertcat( up{ : } ), vertcat( lo{ : } ) );


function [ rib, up, lo ] = ribbon( obj, z, fun, varargin )
%  RIBBON - Extrude vertical ribbon for a single polygon.

%  smoothened polygon
poly = midpoints( obj.poly );
%  positions and normal vector of polygon
[ pos, nvec ] = deal( poly.pos, norm( poly ) );
%  close contour ?
if ~all( abs( prod( pos( [ 1, end ], : ), 2 ) ) < 1e-6 )
  pos = [ pos; pos( 1, : ) ];
  nvec = [ nvec; nvec( 1, : ) ];
end

%  triangulate flat ribbon 
[ u, faces ] = fvgrid( 1 : size( pos, 1 ), 1 : numel( z ) );

%  transform ribbon positions
verts = [ pos( u( :, 1 ), 1 ),  ...
          pos( u( :, 1 ), 2 ), reshape( z( u( :, 2 ) ), [], 1 ) ];
%  apply shift function
shift = fun( verts( :, 3 ) );
%  displace vertices
verts( :, 1 ) = verts( :, 1 ) + shift .* nvec( u( :, 1 ), 1 );
verts( :, 2 ) = verts( :, 2 ) + shift .* nvec( u( :, 1 ), 2 );
    
%  save as particle
rib = particle( verts, faces );

%  find point that is closest to first point of polygon
[ ~, ind ] = min( ( rib.pos( :, 1 ) - pos( 1, 1 ) ) .^ 2 +  ...
                  ( rib.pos( :, 2 ) - pos( 1, 2 ) ) .^ 2 );
%  make sure that normal vectors point into the right direction                
if dot( [ nvec( 1, : ), 0 ], rib.nvec( ind, : ) ) < 0
  rib.faces = fliplr( rib.faces );
end

%  shift function
shift = @( z ) shiftbnd( obj.poly, fun( z ) );
%  polygon for upper/lower ribbon boundary
up = obj;  [ up.poly, up.z ] = deal( shift( max( z ) ), max( z ) );
lo = obj;  [ lo.poly, lo.z ] = deal( shift( min( z ) ), min( z ) );
