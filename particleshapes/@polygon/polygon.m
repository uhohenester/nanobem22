classdef polygon
  %  2D polygons for use with Mesh2d.
  
  properties
    pos     %  positions of polygon vertices
    dir     %  direction of polygon (clockwise or counterclockwise)
  end

  methods
    
    function obj = polygon( varargin )
      %  Initialize polygon.
      %
      %  Usage :
      %    obj = polygon( n,   PropertyPairs )
      %    obj = polygon( pos, PropertyPairs )
      %  Input
      %    n    :  number of polygon vertices
      %    pos  :  polygon vertices
      %  PropertyName
      %    dir  :  direction of polygon (clockwise or counterclockwise)
      %    size :  scaling factor for polygon
      obj = init( obj, varargin{ : } );
    end
  end  
end
