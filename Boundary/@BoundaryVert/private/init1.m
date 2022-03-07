function obj = init1( ~, shape )
%  INIT1 - Initialize boundary elements with linear shape elements.
%
%  Usage :
%    obj = init1( shape )
%  Input
%    shape    :  array of shape elements

%  boundary elememts 
tau = horzcat( shape.tau );
%  local and global vertex indices
nu  = horzcat( shape.nu  );
a   = horzcat( shape.a   );

%  index to unique boundary elements
[ ~, i1, i2 ] = unique( vertcat( tau.pos ), 'rows' );
%  unique boundary elements
tau = tau( i1 );
%  global vertex indices
nu  = accumarray( { i2, a },  nu, [], [], nan );

%  allocate output
n = numel( tau );
obj = repmat( BoundaryVert, 1, n );
%  loop over boundary elements
for i = 1 : n
  for name = { 'inout', 'verts', 'mat', 'pos', 'nvec', 'area', 'nedges' }
    obj( i ).( name{ : } ) = tau( i ).( name{ : } );
  end
  m = size( tau( i ).verts, 1 );  
  %  set global vertex indices 
  obj( i ).nu  = nu( i, 1 : m );
end
