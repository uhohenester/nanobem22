classdef cimsolver < cimbase
  %  Solver for contour integral method using principal parts.
  
  properties
    sol2          %  adjoint eigenmodes
    res = []      %  residua
    nonresonant   %  function for nonresonant background matrix
  end
     
  methods
    function obj = cimsolver( varargin )
      %  Initialize contour integral method solver.
      %
      %  Usage :
      %    obj = galerkin.cimsolver( tau, PropertyPairs )
      %  Input
      %    tau      :  boundary elements
      %  PropertyName
      %    contour  :  energies and weights for contour integration
      %    nr       :  number of columns for random matrix
      %    nz       :  maximal power for z^n
      %    seed     :  seed for random number generator
      obj = obj@cimbase( varargin{ : } );
    end
  end
end
