function ind = connectivity( obj )
%  CONNECTIVITY - Find connected boundary elements.
%
%  Usage for obj = BoundaryEdge :
%    ind = connectivity( obj )
%  Output
%    ind    :  cell array with index to connected boundary elements

%  global degrees of freedom for boundary elements
nu = vertcat( obj.nu );
%  connected edges within boundary elements
nu1 = nu( :, [ 1, 1, 2, 2, 3, 3 ] );
nu2 = nu( :, [ 2, 3, 1, 3, 1, 2 ] ); 
%  adjacency matrix
a = accumarray( [ nu1( : ), nu2( : ) ], 0 * nu1( : ) + 1, [], @max, [], true );
g = graph( a );
%  find connections
bins = reshape( conncomp( g ), [], 1 );
ind = accumarray( bins, 1 : numel(bins), [], @( v ) { sort( v ) } );
