function obj = init( obj, mat1, mat2, diameter, varargin )
%  Set up Mie solver.
%
%  Usage for obj = miesolver :
%    obj = init( obj, mat1, mat2, diameter, PropertyPair )
%  Input
%    mat1       :  material properties at sphere inside
%    mat2       :  material properties at sphere outside
%    diameter   :  diameter of sphere in nm    
%  PropertyName
%    lmax       :  maximum number of spherical degrees

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'lmax', 20 );
%  parse input
parse( p, varargin{ : } );

%  save input
[ obj.mat1, obj.mat2, obj.diameter ] = deal( mat1, mat2, diameter );
%  maximum number of spherical degrees
obj.lmax = p.Results.lmax;
