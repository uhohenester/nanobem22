classdef miestatsolver
  %  Quasistatic Mie theory.
  
  properties
    mat1      %  material properties at sphere inside
    mat2      %  material properties at sphere outside
    diameter  %  diameter of sphere in nm
  end
  
  methods
    function obj = miestatsolver( varargin )
      %  Set up quasistatic Mie solver.
      %
      %  Usage :
      %    obj = miestatsolver( mat1, mat2, diameter )
      %  Input
      %    mat1       :  material properties at sphere inside
      %    mat2       :  material properties at sphere outside
      %    diameter   :  diameter of sphere in nm    
      obj = init( obj, varargin{ : } );
    end
  end
  
end