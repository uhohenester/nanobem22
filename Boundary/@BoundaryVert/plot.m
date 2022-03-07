function plot( obj, varargin )
%  PLOT - Plot using plot function for particles.

%  triangular elements
n = horzcat( obj.nedges );
ind3 = n == 3;
%  plot triangular elements
if nnz( ind3 )
  %  faces
  faces = vertcat( obj( ind3 ).nu );
  %  vertices
  verts1 = arrayfun( @( x ) x.verts, obj( ind3 ), 'uniform', 0 );
  verts1 = reshape( vertcat( verts1{ : } ), 3, [], 3 );
  verts1 = reshape( permute( verts1, [ 2, 1, 3 ] ), [], 3 );
  %  reshape vertices
  verts = zeros( max( faces( : ) ), 3 );
  for i = 1 : numel( faces )
    verts( faces( i ), : ) = verts1( i, : );
  end
  %  plot
  plot( particle( verts, faces ), varargin{ : } );
end
