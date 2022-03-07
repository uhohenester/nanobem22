classdef dipole
  %  Dipole excitation for full Maxwell equations.
  
  properties
    pt      %  dipole positions
    pot     %  potential integrator
  end
    
  methods 
    function obj = dipole( varargin )
      %  Initialize dipole object.
      %
      %  Usage :
      %    obj = galerkin.dipole( pt, varargin )
      %  Input
      %    pt     :  dipole positions
      obj = init( obj, varargin{ : } );
    end
  end

end 
