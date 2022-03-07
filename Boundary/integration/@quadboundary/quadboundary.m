classdef quadboundary
  %  Quadrature points for boundary element integration.
  
  properties
    tau       %  boundary elements
    quad      %  integration points 
    npoly     %  number of polygon edges
  end
  
  properties (Dependent)
    mat     %  material properties
    inout   %  material indices at particle inside and outside
  end  
  
  methods 
    function obj = quadboundary( varargin )
      %  Initialize boundary element integration.
      %
      %  Usage :
      %    obj = quadboundary( tau, PropertyPairs )
      %  Input
      %    tau        :  vector of boundary elements
      %  PropertyName
      %    'quad3'    :  quadrature points for triangle integration
      %    'quad4'    :  quadrature points for quadrilateral integration
      %    'memax'    :  slice integration into bunches of size MEMAX
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
    
    function obj = select( obj, ind )
      %  SELECT - Select indexed boundary elements.
      obj.tau = obj.tau( ind );
    end
    
    function mat = get.mat( obj )
      %  MATERIAL - Material parameters for integration points.
      mat = obj.tau( 1 ).mat;
    end
    
    function inout = get.inout( obj )
      %  INOUT - Material indices at particle inside and outside.
      inout = obj.tau( 1 ).inout;
    end    
  end
  
  methods (Static)
    r = rules( varargin );
  end
end
