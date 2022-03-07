%% User-defined excitation
%
% Setting up your own excitation or excitation class is relatively simple
% within the nanobem toolbox. Here we briefly discuss how to compute the
% inhomogeneities qinc for the quasistatic BEM approach.
%
%% Working principle
%
% To set up the structure that can be passed to a <nanobem_stat_bem.html
% galerkinstat.bemsolver> object one has to set up the struture qinc for the
% inhomogeneities of the external excitation.

%  inhomogeneity of normal potential derivative
vn = qbasis( tau, fun, PropertyNames );
%  set output
qinc = struct( 'vn', vn, 'tau', tau, 'k0', k0 );

%%
% * *|tau|* discretized particle boundary
% * *|fun|* user-defined function fun(pt), for details see below
% * *|'rules'|* <nanobem_quadboundary.html quadrature rules> for boundary
% element integration
% * *|k0|* wavenumber of light in vacuum
%
% The user-defined function fun receives a <nanobem_quadboundary.html
% quadboundary> object pt and must return the electric field.

%  user-defined function
e = fun( pt );
%  display quadboundary object PT
pt

%%
%  pt = 
% 
%    quadboundary with properties:
% 
%        tau: [1×284 BoundaryVert]
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
% Inhomogeneity for planewave excitation with polarization vector [1,0,0].

%  electric field for planewave excitation
fun = @( pt ) repmat(  ...
  reshape( [ 1, 0, 0 ], 1, 1, 3 ), numel( pt.tau ), numel( pt.quad.w ), 1 );
%  normal derivative of incoming potential
vn = qbasis( tau, fun );
%  set output
qinc = struct( 'vn', vn, 'tau', tau, 'k0', k0 );

%%
%
% Copyright 2022 Ulrich Hohenester 
