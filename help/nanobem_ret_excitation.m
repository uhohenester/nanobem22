%% User-defined excitation
%
% Setting up your own excitation or excitation class is relatively simple
% within the nanobem toolbox. Here we briefly discuss how to compute the
% inhomogeneities qinc defined in Eq. (11.41) of Hohenester, Nano and
% Quantum Optics (Springer 2020).
%
%% Working principle
%
% To set up the structure that can be passed to a <nanobem_ret_bem.html
% galerkin.bemsolver> object one has to set up the struture qinc for the
% inhomogeneities of the external excitation.

%  inhomogeneities
[ e, h ] = qbasis( tau, fun, PropertyNames );
%  set output
qinc = struct( 'e', e, 'h', h, 'tau', tau, 'k0', k0 );

%%
% * *|tau|* discretized particle boundary
% * *|fun|* user-defined function fun(pt), for details see below
% * *|'rules'|* <nanobem_quadboundary.html quadrature rules> for boundary
% element integration
% * *|k0|* wavenumber of light in vacuum
%
% The user-defined function fun receives a <nanobem_quadboundary.html
% quadboundary> object pt and must return the electromagnetic fields.

%  user-defined function
[ e, h ] = fun( pt );
%  display quadboundary object PT
pt

%%
%  pt = 
% 
%    quadboundary with properties:
% 
%        tau: [1×284 BoundaryEdge]
%       quad: [1×1 struct]
%      npoly: 3
%        mat: [1×2 Material]
%      inout: [2 1]
%
% The integration points provided by pt are grouped such that there is
% always a single unique material index at the particle inside or outside.
% The integration points where the electromagnetic fields have to be
% evaluated are obtained through

%  evaluate electromagnetic fields at positions POS
pos = eval( pt );

%%
% pos(npos,nq,3) is an array where the first index runs over the different
% boundary elements, the second index over the quadrature points, and the
% last one over the Cartesian coordinates.
%
%% Examples
%
% * <matlab:edit('galerkin.planewave/eval') galerkin.planewave/eval>
%
% Copyright 2022 Ulrich Hohenester 
