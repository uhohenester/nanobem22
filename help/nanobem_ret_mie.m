%% miesolver
%
% Class for the solution of Mie's theory, see Hohenester, Nano and Quantum
% Optics (Springer 2020), appendix E.
%
%% Initialization

%  initialize Mie solver
obj = miesolver( mat1, mat2, diameter, PropertyPair );

%%
% * *|mat1|* <nanobem_material.html Material> properties at inside of
% sphere
% * *|mat2|* <nanobem_material.html Material> properties at outside of
% sphere
% * *|diameter|* diameter of sphere in nm 
% * *|'lmax'|* maximum number of spherical degrees
%
%% Methods

%  decy rates of quantum emitter above sphere
decay = decayrate( obj, k0, z );

%%
% * *|k0|* wavenumber of light in vacuum
% * *|z|* position of quantum emitter
% * *|decay|* decay rates in units of free-space decay rate
% * *|decay.totx|* total decay rate for dipole moment along x
% * *|decay.totz|* total decay rate for dipole moment along z
% * *|decay.radx|* radiative decay rate for diple along x
% * *|decay.radz|* radiative decay rate for diple along z

%  extinction cross section, Eq. (E.26)
ext = extinction( obj, k0 );
%  scattering cross section, Eq. (E.30)
sca = scattering( obj, k0 );
%  Mie coefficients, Eq. (E.22)
[ a, b ] = miecoefficients( obj, k0 );
%  far-fields for light scattering at sphere, Eq. (E.27)
far = farscattering( obj, k0, pol, dir );

%%
% * *|k0|* wavenumber of light in vacuum
% * *|pol|* light polarization for plane wave propagating along z
% * *|dir|* directions for scattered light
%
%% Examples

%  photon energies (eV)
ene = linspace( 1, 4, 100 );
%  convert to wavenumbers
units;
k0 = 2 * pi ./ ( eV2nm ./ ene );

%  initialize material object for gold and water
mat1 = Material( epstable( 'gold.dat' ), 1 );
mat2 = Material( 1.33 ^ 2, 1 );
%  initialize Mie solver
diameter = 100;
mie = miesolver( mat1, mat2, diameter );

%  extinction and scattering cross section
ext = extinction( mie, k0 );
sca = scattering( mie, k0 );

%  final plot
plot( ene, ext, ene, sca );

legend( 'ext', 'sca' );
xlabel( 'Photon energy (eV)' );
ylabel( 'Cross section (nm^2)' );

%%
% * <matlab:edit('demoretspec01') demoretspec01.m> |-| Optical spectrum for
% metallic nanosphere and comparison with Mie theory.
% * <matlab:edit('demoretdip01') demoretdip01.m> |-| Lifetime of dipole
% above nanosphere and comparison with Mie theory.
%
% Copyright 2022 Ulrich Hohenester