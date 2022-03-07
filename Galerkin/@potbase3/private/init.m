function obj = init( obj, tau, varargin )
%  INIT - Initialize basic integrals for BEM potentials.
%
%  Usage for obj = potbase3 :
%    obj = init( obj, tau, PropertyPair )
%  Input
%    tau    :  vector of triangle boundary elements
%  PropertyName
%    order  :  number of odd orders for singularity extraction

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'order', 2 );
%  parse input
parse( p, varargin{ : } );

obj.tau = tau;
%  get vertices of boundary elements
obj.verts = permute( reshape( vertcat( tau.verts ), 3, [], 3 ), [ 2, 1, 3 ] );
%  normal vector
obj.nvec = vertcat( tau.nvec );

%  edge normals
nvec = repmat( reshape( obj.nvec, [], 1, 3 ), 1, 3, 1 );
mvec = cross( nvec, obj.verts( :, [ 2, 3, 1 ], : ) -  ...
                    obj.verts( :, [ 1, 2, 3 ], : ), 3 );                 
%  normalization
if isprop( tau, 'val' )
  obj.val = vertcat( tau.val );
else
  obj.val = bsxfun( @rdivide, sqrt( dot( mvec, mvec, 3 ) ), vertcat( tau.area ) );
end
obj.mvec = mvec ./ repmat( sqrt( dot( mvec, mvec, 3 ) ), 1, 1, 3 );

%  number of odd orders for singularity extraction
obj.order = p.Results.order;
