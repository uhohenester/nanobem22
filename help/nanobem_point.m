%% Point
%
% Point is a nanobem object which is used for the evaluation of potentials
% and fields away from the boundary, as well as for oscillating dipoles.
%
%% Initialization

%  place positions POS in photonic environment of nanoparticle
obj = Point( tau, pos );
%  positions PSO placed in materials MAT(IMAT)
obj = Point( mat, imat, pos );

%%
% * *|tau|* vector of boundary elements
% * *|pos|* point positions
% * *|mat|* vector of materials
% * *|imat|* index to material vector
%
%% Methods

%  points connected to other points TAU ? 
is = connected( obj, pts );
%  points connected to boundary elements TAU ?
is = connected( obj, tau );
%  pairwise distance between points and boundary elements TAU
%    scaled by bounding box radius of boundary elements
d = bdist2( obj, tau );
%  return only K smallest distances
%    IND is index to smallest elements
[ d, ind ] = bdist2( obj, tau, k );

%% iterpoints
%
% For internal use we also provide the iterpoints class which groups points
% into bunches of equal materials or maximal size memax.

%  group points TAU into bunches of equal material properties
%    nu     -  index to selected points
%    memax  -  maximal number of points 
iter = iterpoints( tau );
iter = iterpoints( tau, nu );
iter = iterpoints( tau, nu, 'memax', memax );

%%
% After initialization iter is a vector where each element has the
% following propreties

%  points
iter.tau;
%  global index wrt TAU object of initialization
iter.nu;
%  material index
iter.imat;

%%
% The following methods are implemented for iterpoints objects.

%  get all point positions
pos = eval( iter );
%  index of points TAU 
ind = indexin( iter, tau );
%  total number of points
n = npts( iter );

%% Examples
%
% * <matlab:edit('demopoint01') demopoint01.m> |-| Place points in
% environment of sphere.
% * <matlab:edit('demopoint02') demopoint02.m> |-| Place points in
% environment of coupled spheres.
%
% Copyright 2022 Ulrich Hohenester