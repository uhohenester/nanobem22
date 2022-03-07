classdef valarray
  %  Value array for plotting.
  
  properties
    p                   %  particle
    val                 %  value array
    truecolor = false   %  true color array
  end
  
  properties
    h = []              %  handle of graphics object
  end
    
  methods
    
    function obj = valarray( varargin )
      %  Initialization of VALARRAY.
      %
      %  Usage :
      %    obj = valarray( p )
      %    obj = valarray( p, val )
      %    obj = valarray( p, val, 'truecolor' )
      %  Input
      %    p    :  particle
      %    val  :  value array
      obj = init( obj, varargin{ : } );
    end
  end
  
end