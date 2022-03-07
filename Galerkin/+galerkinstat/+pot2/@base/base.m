classdef (Abstract) base < matlab.mixin.Heterogeneous & quadpair
  %  Base class for evaluation of quasistatic BEM potentials.
  % 
  %  G    -  Green function for evaluation of potential
  %  G1   -  gradient of Green function for evaluation of field
  %  F1   -  gradient of nomrmal deriative of G for dipole excitation
    
  properties (Abstract)
    initialize
  end
  
  %  seal methods for matlab.mixin.Heterogeneous objects
  methods (Sealed)
    obj = set( obj, varargin );
    [ pot, e ] = eval( obj, varargin );
    data = green( obj );
  end  
end
