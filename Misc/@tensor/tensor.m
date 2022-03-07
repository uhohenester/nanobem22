classdef tensor
  %  Multidimensional array with symbolic indexing.
  
  properties
    val       %  value array
    siz       %  size of multidimensional array
    idx       %  symbolic indices
  end
  
  methods 
    function obj = tensor( varargin )
      %  Initialize tensor object.
      %
      %  Usage :
      %    obj = tensor
      %    obj = tensor( val, idx )
      %  Input
      %    val    :  multidimensional array
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
    
    function obj = uplus( obj ),  end
    
    function obj = plus(   obj1, obj2 ),  obj = eval( @plus,  obj1, obj2 );  end
    function obj = mtimes( obj1, obj2 ),  obj = eval( @times, obj1, obj2 );  end
    
    function obj = abs(  obj ),  obj.val = abs(  obj.val );  end
    function obj = conj( obj ),  obj.val = conj( obj.val );  end
    function obj = real( obj ),  obj.val = real( obj.val );  end
    function obj = imag( obj ),  obj.val = imag( obj.val );  end
    
    function obj = exp( obj ),  obj.val = exp( obj.val );  end
    function obj = sin( obj ),  obj.val = sin( obj.val );  end
    function obj = cos( obj ),  obj.val = cos( obj.val );  end
    function obj = log( obj ),  obj.val = log( obj.val );  end
    
    function obj = sqrt( obj ),  obj.val = sqrt( obj.val );  end
    function obj = sinh( obj ),  obj.val = sinh( obj.val );  end
    function obj = cosh( obj ),  obj.val = cosh( obj.val );  end
    function obj = tanh( obj ),  obj.val = tanh( obj.val );  end
    
    function obj = besselk( n, obj ),  obj.val = besselk( n, obj.val );  end
    
  end
  
  methods (Static)
    varargout = set( varargin );
  end
  
end
