function obj = init2( ~, varargin )
%  INIT2 - Initialize boundary elements with linear shape elements.
%
%  Usage :
%    obj = init2( mat, inout1, p1, inout2, p2, ... )
%  Input
%    shape  :  array of shape elements
%    mat    :  material parameters
%    inout  :  index to material at inside and outside
%    p      :  discretized particle boundary

%  boundary elements
tau = BoundaryElement( varargin{ : } );
%  shape elements
shape = ShapeVert( tau );
%  boundary elements with shape elements
obj = BoundaryVert( shape );

%  sort boundary elements in same way as TAU
[ ~, i1 ] = ismember( vertcat( tau.pos ), vertcat( obj.pos ), 'rows' );
obj = obj( i1 );
