function obj = union( varargin )
%  UNION - Combine particles.
%
%  Usage for obj = particle :
%    obj = union( obj1, obj2, ... )
%  Output
%    obj    :  union of particles 

%  vertices and faces
verts = cellfun( @( x ) x.verts, varargin, 'uniform', 0 );
faces = cellfun( @( x ) x.faces, varargin, 'uniform', 0 );

n = size( verts{ 1 }, 1 );
%  add offset to faces
for i = 2 : numel( varargin )
  faces{ i } = faces{ i } + n;
  n = n + size( verts{ i }, 1 );
end

%  put together vertices and faces
verts = vertcat( verts{ : } );
faces = vertcat( faces{ : } );
%  unique list of vertices
[ ~, i1, i2 ] = unique( round( verts, 5 ), 'rows' );
%  union of particles
obj = particle( verts( i1, : ), i2( faces ) );
