classdef (Abstract) base < matlab.mixin.Heterogeneous & quadpair
  %  Base class for evaluation of BEM potentials.
    
  properties (Abstract)
    initialize
  end
  
  %  seal methods for matlab.mixin.Heterogeneous objects
  methods (Sealed)
    obj = set( obj, varargin );
    [ e, h ] = fields( obj, varargin );
    data = potential( obj, varargin );
  end  
end
