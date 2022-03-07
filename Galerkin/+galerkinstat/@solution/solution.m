classdef solution
  %  Solution of BEM equation.
  
  properties
    tau     %  vector of boundary elements
    k0      %  wavelength of light in vacuum
    sig     %  surface charge distribution
  end
  
  methods
    function obj = solution( varargin )
      %  Initialize BEM solution.
      %
      %  Usage :
      %    obj = solution( tau, k0, sig )
      %  Input
      %    tau    :  vector of boundary elements
      %    k0     :  wavelength of light in vacuum
      %    sig    :  surface charge distribution
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
  end 
end
