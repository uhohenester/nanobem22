classdef miesolver
  %  Mie theory.
  
  properties
    mat1      %  material properties at sphere inside
    mat2      %  material properties at sphere outside
    diameter  %  diameter of sphere in nm
    lmax      %  maximum number of spherical degrees
  end
  
  methods
    function obj = miesolver( varargin )
      %  Set up Mie solver.
      %
      %  Usage :
      %    obj = miesolver( mat1, mat2, diameter, PropertyPair )
      %  Input
      %    mat1       :  material properties at sphere inside
      %    mat2       :  material properties at sphere outside
      %    diameter   :  diameter of sphere in nm    
      %  PropertyName
      %    lmax       :  maximum number of spherical degrees
      obj = init( obj, varargin{ : } );
    end
  end
  
end
