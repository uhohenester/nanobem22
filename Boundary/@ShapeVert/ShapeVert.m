classdef ShapeVert
  %  Linear shape element.
  
  properties
    tau     %  boundary element connected to vertex
    a       %  local vertex index    
    nu      %  global vertex index
  end
  
  methods 
    function obj = ShapeVert( varargin )
      %  Initialize linear shape element.
      %
      %  Usage :
      %    obj = ShapeVert
      %    obj = ShapeVert( tau, PropertyPairs )
      %  Input
      %    tau    :  vector of boundary elements
      %  PropertyName
      %    'nu'   :  start value for global vertex indices
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
  end

end
