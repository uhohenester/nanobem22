function [ pos, area, nvec ] = norm( obj, ind )
%  NORM - Auxiliary information for discretized particle surface.
%    Compute centroids, areas, and normal vectors for surface elements.
%
%  Usage for obj = particle :
%    [ pos, area, nvec ] = norm( obj, ind )
%  Input
%    ind    :  index to selected indices
%  Output
%    pos    :  centroid positions
%    area   :  area of surface elements
%    nvec   :  normal vectors

if ~exist( 'ind', 'var' ),  ind = 1 : size( obj.faces, 1 );  end
%  centroid positions of triangular elements
pos = ( obj.verts( obj.faces( ind, 1 ), : ) +  ...
        obj.verts( obj.faces( ind, 2 ), : ) +  ...
        obj.verts( obj.faces( ind, 3 ), : ) ) / 3;
%  vertices
v1 = obj.verts( obj.faces( ind, 1 ), : );
v2 = obj.verts( obj.faces( ind, 2 ), : );
v3 = obj.verts( obj.faces( ind, 3 ), : );
%  triangle vectors
[ vec1, vec2 ] = deal( v1 - v2, v3 - v2 );
%  normal vector
nvec = cross( vec1, vec2, 2 );

%  area of triangular elements and normalized vector
area = 0.5 * sqrt( dot( nvec, nvec, 2 ) );
nvec = bsxfun( @rdivide, nvec, sqrt( dot( nvec, nvec, 2 ) ) );
