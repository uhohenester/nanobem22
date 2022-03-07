function obj = init( obj, mat1, mat2, diameter, varargin )
%  Set up quasistatic Mie solver.
%
%  Usage for obj = miestatsolver :
%    obj = init( obj, mat1, mat2, diameter )
%  Input
%    mat1       :  material properties at sphere inside
%    mat2       :  material properties at sphere outside
%    diameter   :  diameter of sphere in nm    

[ obj.mat1, obj.mat2, obj.diameter ] = deal( mat1, mat2, diameter );
