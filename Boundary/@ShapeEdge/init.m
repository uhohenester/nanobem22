function obj = init( ~, tau, varargin )
%  SET - Set Thomas-Raviart shape elements.
%
%  Usage :
%    obj = init( tau, PropertyPairs )
%  Input
%    tau    :  vector of boundary elements
%  PropertyName
%    'nu'   :  start value for global edge indices

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'nu', 0 );
%  parse input
parse( p, varargin{ : } );

%  vertices of boundary elements
n = numel( tau );
[ verts{ 1 : n } ] = tau.verts;
%  close boundaries
verts = cellfun( @( x ) [ x; x( 1, : ) ], verts, 'uniform', 0 );

%  edge positions
pos1 = cellfun( @( x ) x( 1 : end - 1, : ), verts, 'uniform', 0 );
pos2 = cellfun( @( x ) x( 2 : end,     : ), verts, 'uniform', 0 );
%  local edge indices
a = cellfun( @( x ) reshape( 1 : size( x, 1 ) - 1, [], 1 ), verts, 'uniform', 0 );
%  face index for edges
itau = cellfun( @( x, i ) repmat( i, size( x, 1 ) - 1, 1 ),  ...
                     verts, num2cell( 1 : numel( verts ) ), 'uniform', 0 );
%  transform to vectors
[ pos1, pos2, a, itau ] = deal(  ...
  vertcat( pos1{ : } ), vertcat( pos2{ : } ), vertcat( a{ : } ), vertcat( itau{ : } ) );

%  unique positions
[ pos, ~, i2 ] = unique( [ pos1; pos2 ], 'rows' );
%  label edges with unique positions
edge = reshape( i2, [], 2 );
%  get unique edges and edge indices
[ edge, i1, i2 ] = unique( sort( edge, 2 ), 'rows' );

%  number of global and local edge indices
n1 = numel( i1 );
n2 = numel( i2 );
%  allocate local shape elements
obj = repmat( ShapeEdge, 1, n2 );
%  loop over local shape elements
for i = 1 : n2
  %  set boundary element
  obj( i ).tau = tau( itau( i ) );
  %  set local and global edge index
  obj( i ).a = a( i );
  obj( i ).nu = p.Results.nu + i2( i );
end
  
%  use accumarray to group the local edge indices into cell array
i2 = accumarray( i2, 1 : n2, [], @( x ) { x } );
%  loop over global edges
for nu = 1 : n1  
  %  edge positions
  pos1 = pos( edge( nu, 1 ), : );
  pos2 = pos( edge( nu, 2 ), : );
   
  %  length of edge divided by area of boundary element
  ind = i2{ nu };
  val = norm( pos1 - pos2 ) ./ horzcat( tau( itau( ind ) ).area );
  %  prefactor for Thomas-Raviart shape elements
  n = numel( val );
  val = val .* [ 1, repmat( - 1 / ( n - 1 ), 1, n - 1 ) ];
  
  %  set prefactors of local shape elements
  for i = 1 : n
    obj( ind( i ) ).val = val( i );
  end
end
