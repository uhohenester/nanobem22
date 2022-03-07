classdef particle
  %  Particle Boundary for BEM approach. 
 
  properties
    verts     %  vertices of particle
    faces     %  faces of particle
  end
  
  properties (Dependent, Hidden)
    pos       %  centroid positions of boundary elements
    area      %  areea of boundary elememts
    nvec      %  normal vector of boundary elements
  end
  
  methods
    function obj = particle( varargin )
      %  Save vertices and faces of particle.
      %
      %  Usage :
      %    obj = particle( verts, faces )
      %  Input
      %    verts    :  vertices of discretized particle
      %    faces    :  faces of discretized particle
      [ obj.verts, obj.faces ] = deal( varargin{ : } );
    end
    
    function obj = shift( obj, pos )
      %  SHIFT - Shift particle.
      obj = transform( obj, 'shift', pos );
    end
    
    function n = nfaces( obj )
      %  NFACES - Number of faces.
      n = size( obj.faces, 1 );
    end
    
    function pos = get.pos( obj )
      %  POS - Centroid positions.
      pos = norm( obj );
    end
    
    function area = get.area( obj )
      %  AREA - Area of boundary elements.
      [ ~, area ] = norm( obj );
    end
    
    function nvec = get.nvec( obj )
      %  NVEC - Normal vectors of boundary elements.
      [ ~, ~, nvec ] = norm( obj );
    end
  end
end
