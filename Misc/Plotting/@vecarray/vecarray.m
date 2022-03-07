classdef vecarray
  %  Vector array for plotting.
  
  properties
    pos                 %  vector positions
    vec                 %  vector array
    mode = 'cone'       %  'cone' or 'arrow'
  end
  
  properties
    h = []              %  handle of graphics object
    color = 'b'         %  color for 'arrow' plotting
  end
    
  methods
    
    function obj = vecarray( pos, vec, varargin )
      %  Initialization of VECARRAY.
      %
      %  Usage :
      %    obj = vecarray( pos, vec )
      %    obj = vecarray( pos, vec, mode )
      %  Input
      %    pos      :  vector positions
      %    vec      :  vector array
      %    mode     :  'cone' or 'arrow'
      
      %  set up parser
      p = inputParser;
      p.KeepUnmatched = true;
      addOptional( p, 'mode', 'cone', @( x ) true );
      %  parse input
      parse( p, varargin{ : } );     
      
      [ obj.pos, obj.vec, obj.mode ] = deal( pos, vec, p.Results.mode );
    end
  end
  
end