classdef cimbase
  %  Solver for contour integral method of Beyn.
  
  properties
    tau       %  boundary elements
    contour   %  energies and weights for contour integration
    nr        %  number of columns for random matrix
    ene       %  eigenvalues
    sol       %  eigenmodes
  end
  
  properties (Hidden)
    nz      %  maximal power for z^n
    seed    %  seed for random number generator
  end
  
  properties (Dependent, Hidden)
    nev     %  number of eigenvalues
  end
    
  methods
    function obj = cimbase( varargin )
      %  Initialize contour integral method solver.
      %
      %  Usage :
      %    obj = cimbase( tau, PropertyPairs )
      %  Input
      %    tau      :  boundary elements
      %  PropertyName
      %    contour  :  energies and weights for contour integration
      %    nr       :  number of columns for random matrix
      %    nz       :  maximal power for z^n
      %    seed     :  seed for random number generator
      obj = init( obj, varargin{ : } );
    end
    
    function n = get.nev( obj )
      %  Number of eigenvalues.
      n = numel( obj.ene );
    end        
  end
  
  methods (Static)
    varargout = ellipse( varargin );
  end
end
