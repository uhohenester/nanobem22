classdef BoundaryEdge < BoundaryElement
  %  Boundary elements with Raviart-Thomas shape elements.
  
  properties
    nu      %  global edge indices
    val     %  prefactor for shape elements
  end
  
  methods 
    function obj = BoundaryEdge( varargin )
      %  Initialize boundary elements with Raviart-Thomas elements.
      %
      %  Usage :
      %    obj = BoundaryEdge( shape )
      %    obj = BoundaryEdge( mat, p1, inout1, p2, inout2, ... )
      %  Input
      %    shape  :  array of shape elements
      %    mat    :  material parameters
      %    p      :  discretized particle boundary
      %    inout  :  index to material at inside and outside
      if ~isempty( varargin )
        switch class( varargin{ 1 } )
          case 'ShapeEdge'
            obj = init1( obj, varargin{ : } );
          otherwise
            obj = init2( obj, varargin{ : } );
        end
      end
    end
  end  
end
      