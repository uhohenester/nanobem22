classdef BoundaryElement
  %  Base class for boundary elements.
  
  properties
    inout     %  material index at inside and outside
    verts     %  face vertices
  end
  
  properties (Hidden = true)
    mat     %  material parameters
    pos     %  centroid position
    nvec    %  normal vector
    area    %  area
    nedges  %  number of edges
  end
  
  methods
    function obj = BoundaryElement( varargin )
      %  Initialization of boundary element object.
      %
      %  Usage :
      %    obj = BoundaryElement
      %    obj = BoundaryElement( mat, p1, inout1, p2, inout2, ... )
      %  Input
      %    mat    :  material parameters
      %    p      :  discretized particle boundary
      %    inout  :  index to material at inside and outside
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
  end
end
