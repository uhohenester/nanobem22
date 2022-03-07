classdef planewave
  %  Plane wave excitation using quasistatic approximation.
  
  properties
    pol     %  polarizations of plane waves
  end
  
  properties (Hidden)
    rules    %  integration rules
    imat     %  index for embedding medium
  end
  
  methods 
    function obj = planewave( varargin )
      %  Initialize plane wave object.
      %
      %  Usage :
      %    obj = galerkinstat.planewave( pol, varargin )
      %  Input
      %    pol    :  polarizations of plane waves
      obj = init( obj, varargin{ : } );
    end
  end

end 
