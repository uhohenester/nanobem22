function [] = savegmsh( p, fout )
%  SAVEGMSH - Save particle to gmsh file.
%
%  Usage :
%    savegmsh( p, fout )
%  Input
%    p      :  particle object
%    fout   :  output file

%  open output file
id = fopen( fout, 'w' );

%  particle index
ind = ones( p.n, 1 );
for ip = 1 : p.np
  ind( p.index( ip ) ) = ip;
end
  

%  $MeshFormat
%  version-number file-type data-size
%  $EndMeshFormat
%
%  version-number
%    is a real number equal to 2.0
%  file-type
%    is an integer equal to 0 in the ASCII file format
%   data-size
%     is an integer equal to the size of the floating point numbers used in
%     the file (currently only data-size = sizeof(double) is supported)
fprintf( id, '$MeshFormat\n'    );
fprintf( id, '2.0 0 8\n'        );
fprintf( id, '$EndMeshFormat\n' );

%  $Nodes
%  number-of-nodes
%  node-number x-coord y-coord z-coord
%  ...
%  $EndNodes
fprintf( id, '$Nodes\n'       );
fprintf( id, '%i\n', p.nverts );
for i = 1 : p.nverts
  fprintf( id, '%i %f %f %f\n', i, p.verts( i, : ) );
end
fprintf( id, '$EndNodes\n' );

%  $Elements
%  number-of-elements
%  elm-number elm-type number-of-tags < tag > … node-number-list
%  ...
%  $EndElements

%  number-of-elements
%     is the number of elements in the mesh.
%  elm-number
%     is the number (index) of the n-th element in the mesh; elm-number
%     must be a postive (non-zero) integer. Note that the elm-numbers do
%     not necessarily have to form a dense nor an ordered sequence.
%  elm-type
%     defines the geometrical type of the n-th element: 
%     (for complete list see bottom of file)
%       - 2  ...  3-node triangle
%       - 3  ...  4-node quadrilateral
%  number-of-tags
%    gives the number of integer tags that follow for the n-th element,
%    here physical and elementary entity (chosen to be equal)
fprintf( id, '$Elements\n'    );
fprintf( id, '%i\n', p.nfaces );

%  index to triangles
tri = isnan( p.faces( :, end ) );
%  loop over faces
for i = 1 : p.nfaces
  if tri( i )
    %  triangle
    %    #, type 2, physical, elementary, nodes 1 2 3
    fprintf( id, '%i 2 2 %i %i %i %i %i\n',  ...
                     i, ind( i ), ind( i ), p.faces( i, 1 : 3 ) );
  else
    %  quadrilateral
    %    #, type 3, physical, elementary, nodes 1 2 3 4
    fprintf( id, '%i 3 2 %i %i %i %i %i %i\n',  ...
                        i, ind( i ), ind( i ), p.faces( i, : ) );
  end
end
fprintf( id, '$EndElements\n' );


%  close output file
fclose( id );


% elm-type
%     defines the geometrical type of the n-th element: 
%  1
%     2-node line. 
%  2
%     3-node triangle. 
%  3
%     4-node quadrangle. 
%  4
%     4-node tetrahedron. 
%  5
%     8-node hexahedron. 
%  6
%     6-node prism. 
%  7
%     5-node pyramid. 
%  8
%     3-node second order line (2 nodes associated with the vertices and 1
%     with the edge).
%  9
%     6-node second order triangle (3 nodes associated with the vertices
%     and 3 with the edges).
%  10
%     9-node second order quadrangle (4 nodes associated with the vertices,
%     4 with the edges and 1 with the face).
%  11
%     10-node second order tetrahedron (4 nodes associated with the
%     vertices and 6 with the edges).
%  12
%     27-node second order hexahedron (8 nodes associated with the
%     vertices, 12 with the edges, 6 with the faces and 1 with the volume).
%  13
%     18-node second order prism (6 nodes associated with the vertices, 9
%     with the edges and 3 with the quadrangular faces).
%  14
%     14-node second order pyramid (5 nodes associated with the vertices, 8
%     with the edges and 1 with the quadrangular face).
%  15
%     1-node point.
%  16
%     8-node second order quadrangle (4 nodes associated with the vertices
%     and 4 with the edges).
%  17
%     20-node second order hexahedron (8 nodes associated with the vertices
%     and 12 with the edges).
%  18
%     15-node second order prism (6 nodes associated with the vertices and
%     9 with the edges).
%  19
%     13-node second order pyramid (5 nodes associated with the vertices
%     and 8 with the edges).
%  20
%     9-node third order incomplete triangle (3 nodes associated with the
%     vertices, 6 with the edges)
%  21
%     10-node third order triangle (3 nodes associated with the vertices, 6
%     with the edges, 1 with the face)
%  22
%     12-node fourth order incomplete triangle (3 nodes associated with the
%     vertices, 9 with the edges)
%  23
%     15-node fourth order triangle (3 nodes associated with the vertices,
%     9 with the edges, 3 with the face)
%  24
%     15-node fifth order incomplete triangle (3 nodes associated with the
%     vertices, 12 with the edges)
%  25
%     21-node fifth order complete triangle (3 nodes associated with the
%     vertices, 12 with the edges, 6 with the face)
%  26
%     4-node third order edge (2 nodes associated with the vertices, 2
%     internal to the edge)
%  27
%     5-node fourth order edge (2 nodes associated with the vertices, 3
%     internal to the edge)
%  28
%     6-node fifth order edge (2 nodes associated with the vertices, 4
%     internal to the edge)
%  29
%     20-node third order tetrahedron (4 nodes associated with the
%     vertices, 12 with the edges, 4 with the faces)
%  30
%     35-node fourth order tetrahedron (4 nodes associated with the
%     vertices, 18 with the edges, 12 with the faces, 1 in the volume)
%  31
%     56-node fifth order tetrahedron (4 nodes associated with the
%     vertices, 24 with the edges, 24 with the faces, 4 in the volume)

