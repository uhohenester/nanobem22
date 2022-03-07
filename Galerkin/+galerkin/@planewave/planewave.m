classdef planewave
  %  Plane wave excitation for full Maxwell equations.
  
  properties
    pol     %  polarizations of plane waves
    dir     %  light propagation direction
  end
  
  properties (Hidden)
    rules   %  quadrature rules 
    imat    %  index for embedding medium
  end
  
  methods 
    function obj = planewave( varargin )
      %  Initialize plane wave object.
      %
      %  Usage :
      %    obj = galerkin.planewave( pol, dir, varargin )
      %  Input
      %    pol    :  polarizations of plane waves
      %    dir    :  propagation direction
      obj = init( obj, varargin{ : } );
    end
  end

end 
