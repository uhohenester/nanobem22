%% galerkinstat.planewave
%
% Plane wave excitations and optical cross sections for optical plane wave
% excitations are computed with the galerkinstat.planewave class.
%
%% Initialization

%  initialize planewave object
obj = galerkin.planewave( pol, PropertyPairs );

%%
% * *|pol|* light polarizations of size [npol,3]
% * *|'rules'|* integration rules for computation of inhomoegeneity
% * *|'imat'|* index to medium through which the nanoparticles are excited
%
%% Methods
%
% After initialization, the galerkinstat.planewave object can be used as
% follows.

%  inhomogeneity for BEM solver galerkinstat.bemsolver
%    tau    -  vector of boundary elements
%    k0     -  wavenumber of light in vaccum
qinc = obj( tau, k0 );
qinc = eval( obj, tau, k0 );
%   electric fields at Point positions PT
e = fields( obj, pt, k0 );
%  absorption cross section for solution SOL of BEM equations
cabs = absorption( obj, sol );
%  extinction cross section for solution SOL of BEM equations
cext = extinction( obj, sol );
%  scattering cross section for solution SOL of BEM equations
sca = scattering( obj, sol );
 
%% Examples
%
% * <matlab:edit('demostatspec01') demostatspec01.m> |-| Optical spectrum
% for metallic nanosphere using the quasistatic approximation.
% * <matlab:edit('demostatspec02') demostatspec02.m> |-| Optical spectrum
% for coupled metallic nanospheres.
%
% Copyright 2022 Ulrich Hohenester
