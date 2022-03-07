%% galerkinstat.dipole
%
% Excitation of oscillating dipole, and enhancement of total and radiative
% decay rate for oscillating dipole placed in photonic envrionment.
%
%% Initialization

%  initialization of oscillating dipole at Point position PT
obj = galerkinstat.dipole( pt, PropertyPairs );

%%
% * *|pt|* <nanobem_point.html Point> object for dipole positions
% * *|'relcutoff'|* refined integration for dipoles located close to
% boundary, we use an <nanobem_quadengine.html integration engine> together
% with an <nanobem_potbase.html analytic integration>
% * *|'rules'|* default <nanobem_quadboundary.html> quadrature rules
%
%% Methods

%  enhancement of total decay rate for given solution SOL of BEM equations
tot = decayrate( obj, sol );
%  inhomogeneities for dipole excitation to be used for solution of BEM equations
%    tau  -  vector of boundary elements
qinc = eval( obj, tau, k0 );
qinc = obj( tau, k0 );

%% Examples
%
% * <matlab:edit('demostatdip01') demostatdip01.m> |-| Lifetime of dipole
% above nanosphere.
%
% Copyright 2022 Ulrich Hohenester
