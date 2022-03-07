classdef BoundaryVert < BoundaryElement
  %  Boundary elements with linear elements.
  
  properties
    nu      %  global vertex indices
  end
  
  methods 
    function obj = BoundaryVert( varargin )
      %  Initialize boundary elements with linear elements.
      %
      %  Usage :
      %    obj = BoundaryVert( shape )
      %    obj = BoundaryVert( mat, p1, inout1, p2, inout2, ... )
      %  Input
      %    shape  :  array of shape elements
      %    mat    :  material parameters
      %    p      :  discretized particle boundary
      %    inout  :  index to material at inside and outside
      if ~isempty( varargin )
        switch class( varargin{ 1 } )
          case 'ShapeVert'
            obj = init1( obj, varargin{ : } );
          otherwise
            obj = init2( obj, varargin{ : } );
        end
      end
    end
    
  end  
end
      