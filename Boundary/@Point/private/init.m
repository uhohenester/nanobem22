function obj = init( obj, varargin )
%  INIT - Initialize point embedded in dielectric environment.
%
%  Usage for obj = Point :
%    obj = init( obj, mat, imat, pos )
%    obj = init( obj, tau, pos )
%  Input
%    mat    :  material parameters
%    imat   :  material index
%    pos    :  point position
%    tau    :  boundary elements

switch class( varargin{ 1 } )
  case 'Material'
    obj = init1( obj, varargin{ : } );
  case { 'BoundaryElement', 'BoundaryVert', 'BoundaryEdge' }
    obj = init2( obj, varargin{ : } );
end
