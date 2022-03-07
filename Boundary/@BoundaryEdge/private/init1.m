function obj = init1( ~, shape )
%  INIT1 - Initialize boundary elements with Raviart-Thomas shape elements.
%
%  Usage :
%    obj = init1( shape )
%  Input
%    shape    :  array of shape elements

%  boundary elememts 
tau = horzcat( shape.tau );
%  local and global edge indices, prefactors for shape elements
nu  = horzcat( shape.nu  );
a   = horzcat( shape.a   );
val = horzcat( shape.val );

%  index to unique boundary elements
[ ~, i1, i2 ] = unique( vertcat( tau.pos ), 'rows' );
%  unique boundary elements
tau = tau( i1 );
%  global edge indices and prefactors for shape elements
nu  = accumarray( { i2, a },  nu, [], [], nan );
val = accumarray( { i2, a }, val, [], [], 0 );

%  allocate output
n = numel( tau );
obj = repmat( BoundaryEdge, 1, n );
%  loop over boundary elements
for i = 1 : n
  for name = { 'inout', 'verts', 'mat', 'pos', 'nvec', 'area', 'nedges' }
    obj( i ).( name{ : } ) = tau( i ).( name{ : } );
  end
  m = size( tau( i ).verts, 1 );  
  %  set global edge indices and prefactors for shape elements
  obj( i ).nu  = nu(  i, 1 : m );
  obj( i ).val = val( i, 1 : m );
end
