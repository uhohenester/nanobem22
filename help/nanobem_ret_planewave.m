%% galerkin.planewave
%
% Plane wave excitations and optical cross sections for optical plane wave
% excitations are computed with the galerkin.planewave class.
%
%% Initialization

%  initialize planewave object
obj = galerkin.planewave( pol, dir, PropertyPairs );

%%
% * *|pol|* light polarizations of size [npol,3]
% * *|dir|* light propagation directions of size [npol,3]
% * *|'rules'|* integration rules for computation of inhomoegeneity
% * *|'imat'|* index to medium through which the nanoparticles are excited
%
%% Methods
%
% After initialization, the galerkin.planewave object can be used as
% follows.

%  inhomogeneity for BEM solver galerkin.bemsolver
%    tau    -  vector of boundary elements
%    k0     -  wavenumber of light in vaccum
qinc = obj( tau, k0 );
qinc = eval( obj, tau, k0 );
%   electromagnetic fields at Point positions PT
[ e, h ] = fields( obj, pt, k0 );
%  absorption cross section for solution SOL of BEM equations
cabs = absorption( obj, sol );
%  extinction cross section for solution SOL of BEM equations
cext = extinction( obj, sol );
%  scattering cross section and differential cross section computed at
%  particle boundary SOL.TAU
[ csca, dsca ] = scattering( obj, sol );
%  scattering cross sections computed at infinity
%    SPEC is a galerikin.spectrum object
[ csca, dsca ] = farscattering( obj, sol, spec );
 
%% Examples
%
% * <matlab:edit('demoretspec01') demoretspec01.m> |-| Optical spectrum for
% metallic nanosphere using the full Maxwell's equations.
% * <matlab:edit('demoretspec02') demoretspec02.m> |-| Optical spectra for
% coupled metallic nanospheres.
%
% Copyright 2022 Ulrich Hohenester

