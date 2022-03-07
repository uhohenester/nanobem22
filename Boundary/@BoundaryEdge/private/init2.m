function obj = init2( ~, varargin )
%  INIT2 - Initialize boundary elements with Raviart-Thomas shape elements.
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
shape = ShapeEdge( tau );
%  boundary elements with shape elements
obj = BoundaryEdge( shape );

%  sort boundary elements in same way as TAU
[ ~, i1 ] = ismember( vertcat( tau.pos ), vertcat( obj.pos ), 'rows' );
obj = obj( i1 );
