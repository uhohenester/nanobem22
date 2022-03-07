classdef iterpoints
  %  Iterator for points embedded in dielectric environment.
  
  properties
    tau     %  points
    nu      %  global index
  end
  
  properties (Dependent)
    pos     %  positions
    mat     %  material properties
    imat    %  material indices
  end
  
  methods 
    function obj = iterpoints( varargin )
      %  Initialize point iterator.
      %
      %  Usage :
      %    obj = iterpoints( tau, nu, PropertyPairs )
      %  Input
      %    tau        :  points embedded in dielectric environment
      %    nu         :  point indices (optional)
      %  PropertyName
      %    'memax'    :  slice points into bunches of size MEMAX
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
    
    function obj = select( obj, ind )
      %  SELECT - Select indexed points.
      obj.tau = obj.tau( ind );
      obj.nu  = obj.nu(  ind );
    end
    
    function pos = get.pos( obj )
      %  POS - Point positions.
      pos = vertcat( obj.tau.pos );
    end
    
    function mat = get.mat( obj )
      %  MATERIAL - Material parameters for point environment.
      mat = obj.tau( 1 ).mat;
    end
    
    function imat = get.imat( obj )
      %  IMAT - Material index for point environment.
      imat = obj.tau( 1 ).imat;
    end
    
    function is = connected( obj, tau )
      %  CONNECTED - Determine whether points are connected to boundary.
      is = connected( obj.tau, tau );
    end
    
  end

end
