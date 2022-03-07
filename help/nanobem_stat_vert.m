%% BoundaryVert
%
% BoundaryVert is a class derived from the superclass
% <nanobem_boundary.html BoundaryElement> that stores the discretized
% boundary elements $\tau_i$ together with linear shape elements which
% perform an interpolation from the vertices to the boundary interior.
%
% $$ \partial\Omega=\bigcup_i\tau_i $$
%
%% Initialization

%  set up array of boundary elements
obj = BoundaryVert( mat, p1, inout1, p2, inout2, etc );

%%
% * *|mat|* array of <nanobem_material.html Material> objects
% * *|p|*   <nanobem_particle.html particle> object
% * *|inout|* index to material at inside and outside
% * *|obj|* vector of boundary elements
%
% After initialization, the BoundaryVert elements hold in addition to the
% properties of the <nanobem_boundary.html BoundaryElement> class the
% following element
%
% * *|obj.nu|* global degree of freedom for vertices of boundary element
%
%% Methods
%
% In addition to the methods of the <nanobem_boundary.html BoundaryElement>
% class, the BoundaryVert class has the following methods

%  shape element and positions
%    X,Y are triangular coordinates
[ f, pos ] = basis( obj, x, y );
%  number of global degrees of freedom
n = ndof( obj );
%  plot value or vector array
plot( obj, varargin );

%% Examples
%
% * <matlab:edit('demoboundaryvert01') demoboundaryvert01.m> |-| Plot
% linear shape elements for unit triangle.
%
% Copyright 2022 Ulrich Hohenester

