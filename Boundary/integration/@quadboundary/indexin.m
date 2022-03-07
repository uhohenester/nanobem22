function ind = indexin( obj, tau )
%  INDEXIN - Indices of obj.tau in tau.
%
%  Usage for obj = quadboundary :
%    ind = indexin( obj, tau )
%  Input
%    tau    :  vector of boundary elements
%  Output
%    ind    :  index of obj in TAU

%  centroid positions
pos = arrayfun( @( x ) vertcat( x.tau.pos ), obj, 'uniform', 0 );
%  number of positions
n = cellfun( @( x ) size( x, 1 ), pos, 'uniform', 1 );

%  find centroid positions in TAU
[ ~, ind ] = ismember( vertcat( pos{ : } ), vertcat( tau.pos ), 'rows' );
%  split array
ind = mat2cell( ind, n );
