function [ net, iface, ivert ] = edges( obj )
%  EDGES - Find unique edges of particle.
%
%  Usage for obj = particle :
%    [ net, iface, ivert ] = edges( obj )
%  Output
%    net    :  list of unique edges
%    iface  :  index to faces
%    ivert  :  index to vertex opposite of edge

%  The unique edges are computed using the following algorithm
%    -  we make a list of edges [ v1, v2 ], [ v2, v2 ], [ v3, v1 ]
%    -  entries [ v1, v2 ] and [ v2, v1 ] are treated as equal
%    -  we extract the unique edges
%    -  for each edge we define a left  neighbour with #v1 < #v2
%                           and a right neighbour with #v1 > #v2
faces = obj.faces;
n = size( obj.faces, 1 );
%  edge list
net = [ faces( :, [ 1, 2 ] ); faces( :, [ 2, 3 ] ); faces( :, [ 3, 1 ] ) ];
%  index to edges with increasing and decreasing order 
ind1 = net( :, 2 ) > net( :, 1 );
ind2 = net( :, 2 ) < net( :, 1 );
%  face and vertex list
iface = repmat( reshape( 1 : n, [], 1 ), 3, 1 );
ivert = [ faces( :, 3 ); faces( :, 1 ); faces( :, 2 ) ];
%  unique edges
[ net, ~, ind ] = unique( sort( net, 2 ), 'rows' );
%  index to faces on both sides of edge
iface = accumarray( { ind, ind1 + 2 * ind2 }, iface );
%  index to vertex opposite to edge
ivert = accumarray( { ind, ind1 + 2 * ind2 }, ivert );
