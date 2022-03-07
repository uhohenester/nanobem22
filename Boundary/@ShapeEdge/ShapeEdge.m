classdef ShapeEdge
  %  Raviart-Thomas shape element.
  
  properties
    tau     %  boundary element connected to edge
    a       %  local edge index    
    nu      %  global edge index
    val     %  prefactor for shape element
  end
  
  methods 
    function obj = ShapeEdge( varargin )
      %  Initialize linear shape element.
      %
      %  Usage :
      %    obj = ShapeEdge
      %    obj = ShapeEdge( tau, PropertyPairs )
      %  Input
      %    tau    :  vector of boundary elements
      %  PropertyName
      %    'nu'   :  start value for global vertex indices    
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
  end  
end
