classdef Boundary
  %  Vertices and faces of boundary, material properties.
  
  properties
    mat     %  material vector
    p       %  discretized boundary
    inout   %  index to material at particle inside and outside
  end
  
  methods
    function obj = Boundary( varargin )
      %  Initialize boundary.
      %
      %  Usage :
      %    obj = Boundary( p, inout )
      %    obj = Boundary( mat, p, inout )
      %  Input
      %    mat    :  material parameters
      %    p      :  discretized particle boundary
      %    inout  :  index to material at particle inside and outside
      switch numel( varargin )
        case 2
          [ obj.p, obj.inout ] = deal( varargin{ : } );
        case 3
          [ obj.mat, obj.p, obj.inout ] = deal( varargin{ : } );
      end
    end
    
    function n = nfaces( obj )
      %  NFACES - Number of faces.
      n = nfaces( obj.p );
    end
  end
end
      