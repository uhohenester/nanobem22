classdef Point
  %  Point embedded in dielectric environment.
  
  properties
    mat     %  material vector
    imat    %  material index
    pos     %  point position
  end
  
  methods
    function obj = Point( varargin )
      %  Initialize boundary.
      %
      %  Usage :
      %    obj = Point( mat, imat, pos )
      %    obj = Point( tau, pos )
      %  Input
      %    mat    :  material parameters
      %    imat   :  material index
      %    pos    :  point position
      %    tau    :  boundary elements
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end

  end
end
      