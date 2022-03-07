function obj = init( ~, tau, varargin )
%  Init - Initialize linear shape elements.
%
%  Usage :
%    obj = ShapeVert( tau, PropertyPairs )
%  Input
%    tau    :  vector of boundary elements
%  PropertyName
%    'nu'   :  start value for global vertex indices

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'nu', 0 );
%  parse input
parse( p, varargin{ : } );

%  vertices of boundary elements
n = numel( tau );
[ verts{ 1 : n } ] = tau.verts;

%  local vertex indices
a = cellfun( @( x ) reshape( 1 : size( x, 1 ), [], 1 ), verts, 'uniform', 0 );
%  corresponding face indices
itau = cellfun( @( x, i ) repmat( i, size( x, 1 ), 1 ),  ...
                                     verts, num2cell( 1 : n ), 'uniform', 0 );
%  transform to vectors
[ a, itau ] = deal( vertcat( a{ : } ), vertcat( itau{ : } ) );

%  unique vertices
[ ~, ~, i2 ] = unique( vertcat( verts{ : } ), 'rows' );
%  number of local vertex indices
n2 = numel( i2 );

%  allocate local shape elements
obj = repmat( ShapeVert, 1, n2 );
%  loop over global vertices
for i = 1 : n2  
  %  set boundary element
  obj( i ).tau = tau( itau( i ) );
  %  set local and global edge index
  obj( i ).a = a( i );
  obj( i ).nu = p.Results.nu + i2( i );  
end
