%% Particle
%
% Particle is a base class of the nanobem toolbox that stores the geometry
% of the discretized boundary.
%
%% Initialization

%  set up partice boundary
obj = particle( verts, faces );

%%
% * *|verts|* vertices of discretized boundary
% * *|faces|*  faces forming discretized boundary

obj.pos       %  centroid positions of boundary elements
obj.nvec      %  normal vectors of boundary elements
obj.area      %  area of boundary elements

%% Examples
%
% * <matlab:edit('demoparticle01') demoparticle01.m> |-| Plot elementary
% particle shapes provided by nanobem toolbox.

%%
% Copyright 2022 Ulrich Hohenester