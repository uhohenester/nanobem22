classdef dipole
  %  Dipole excitation for quasistatic approximation.
  
  properties
    pt      %  dipole positions
    pot     %  potential integrator
  end
    
  methods 
    function obj = dipole( varargin )
      %  Initialize dipole object.
      %
      %  Usage :
      %    obj = galerkinstat.dipole( pt, varargin )
      %  Input
      %    pt     :  dipole positions
      obj = init( obj, varargin{ : } );
    end
  end

end 
