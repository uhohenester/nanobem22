function [ verts, faces ] = fvgrid( x, y )
%  FVGRID - Convert 2d grid to face-vertex structure.
%
%  Usage :
%    [ verts, faces ] = fvgrid( x, y )
%  Input
%    x            :  x-coordinates of grid
%    y            :  y-coordinates of grid
%  Output
%    verts        :  vertices of triangulated grid
%    faces        :  faces of triangulated grid

[ x, y ] = meshgrid( x, y ); 
[ faces, verts ] = surf2patch( x, y, 0 * x, 'triangles' );
