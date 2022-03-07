%% BoundaryEdge
%
% BoundaryEdge is a class derived from the superclass
% <nanobem_boundary.html BoundaryElement> that stores the discretized
% boundary elements $\tau_i$ together with Raviart-Thomas shape elements.
%
% $$ \partial\Omega=\bigcup_i\tau_i $$
%
%% Initialization

%  set up array of boundary elements
obj = BoundaryEdge( mat, p1, inout1, p2, inout2, etc );

%%
% * *|mat|* array of <nanobem_material.html Material> objects
% * *|p|*   <nanobem_particle.html particle> object
% * *|inout|* index to material at inside and outside
% * *|obj|* vector of boundary elements
%
% After initialization, the BoundaryEdge elements hold in addition to the
% properties of the <nanobem_boundary.html BoundaryElement> class the
% following elements
%
% * *|obj.nu|* global degree of freedom for edges of boundary element
% * *|obj.val|* prefactor $\pm\ell_\nu/(2A_\nu)$ for Raviart-Thomas shape
% element, see Hohenester, Nano and Quantum Optics (Springer 2020), Eq.
% (11.36)
%
%% Methods
%
% In addition to the methods of the <nanobem_boundary.html BoundaryElement>
% class, the BoundaryEdge class has the following methods

%  Raviart-Thomas shape element and its divergence, as well as positions
%    X,Y are triangular coordinates
[ f, fp, pos ] = basis( obj, x, y );
%  number of global degrees of freedom
n = ndof( obj );
%  plot value or vector array
plot( obj, varargin );
%  computation of inhomogeneity for Galerkin scheme
%    FUN is function that returns incoming fields for given Point positions
[ qe, qh ] = qbasis( obj, fun );

%% Examples
%
% * <matlab:edit('demoboundaryedge01') demoboundaryedge01.m> |-| Plot
% Raviart-Thomas shape elements for unit triangle.
%
% Copyright 2022 Ulrich Hohenester
