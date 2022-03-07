classdef (Abstract) base < matlab.mixin.Heterogeneous & quadpair
  %  Base class for evaluation of quasistatic BEM potentials.
    
  %  seal methods for matlab.mixin.Heterogeneous objects
  methods (Sealed)
    obj = set( obj, varargin );
    [ G, F ] = green( obj, varargin );
  end  
end
