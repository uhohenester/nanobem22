classdef (Abstract) quadpair
  %  Base class for quadrature over pair objects.
    
  properties
    parent = 0  %  start element of vector
  end
  
  properties (Hidden)
    i1 = []   %  indices of first  pair object in parent element
    i2 = []   %  indices of second pair object in parent element
  end
  
  properties (Abstract, Dependent, Hidden)
    npts      %  number of integration points
  end  
  
  methods (Abstract)
    obj = slice1( obj );     %  slice object
  end    
  
  %  seal methods for matlab.mixin.Heterogeneous objects
  methods (Sealed)
    obj = feval1( obj, fun, varargin );
    obj = slice( obj, varargin );
    obj = mat2cell( obj );
  end
end
