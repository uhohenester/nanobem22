function plot( obj, varargin )
%  PLOT - Plot using plot function for particles.

%  triangular elements
n = horzcat( obj.nedges );
ind3 = n == 3;
%  plot triangular elements
if nnz( ind3 )
  %  vertices
  verts = arrayfun( @( x ) x.verts, obj( ind3 ), 'uniform', 0 );
  verts = reshape( vertcat( verts{ : } ), 3, [], 3 );
  verts = reshape( permute( verts, [ 2, 1, 3 ] ), [], 3 ); 
  %  unique vertices
  [ verts, ~, faces ] = unique( verts, 'rows' );
  faces = reshape( faces, [], 3 );
  %  plot
  plot( particle( verts, faces ), varargin{ : } );
end
