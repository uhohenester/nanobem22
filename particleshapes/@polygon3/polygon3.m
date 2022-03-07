classdef polygon3
  %  3D polygon for extrusion of particles.
  
  properties
    poly        %  polygon
    z           %  z-value of polygon
    edge = []   %  edge profile
  end
  
  properties (Access = private)
    refun       %  refine function for plate discretization
  end
    
  methods
    function obj = polygon3( varargin )
      %  Initialize polygon3 object.
      %
      %  Usage
      %    obj = polygon3( poly, z )
      %    obj = polygon3( poly, z, op, PropertyPairs )
      %  Input
      %    poly     :  polygon
      %    z        :  z-value of polygon
      %  PropertyName
      %    'edge'   :  edge profile
      %    'refun'  :  refine function for plate discretization
      obj = init( obj, varargin{ : } );
    end
  end  
end
