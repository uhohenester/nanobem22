classdef solution
  %  Solution of BEM equation.
  
  properties
    tau     %  vector of boundary elements
    k0      %  wavelength of light in vacuum
    e       %  electric field coefficients
    h       %  magnetic field coefficients
  end
  
  methods
    function obj = solution( varargin )
      %  Initialize BEM solution.
      %
      %  Usage :
      %    obj = solution( tau, k0, e, h )
      %  Input
      %    tau    :  vector of boundary elements
      %    k0     :  wavelength of light in vacuum
      %    e      :  electric field coefficients
      %    h      :  magnetic field coefficients
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
  end 
end
