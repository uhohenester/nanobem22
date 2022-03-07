%% miestatsolver
%
% Class for the solution of the quasistatic Mie theory, see Hohenester,
% Nano and Quantum Optics (Springer 2020), chapter 9.
%
%% Initialization

%  initialize Mie solver
obj = miestatsolver( mat1, mat2, diameter, PropertyPair );

%%
% * *|mat1|* <nanobem_material.html Material> properties at inside of
% sphere
% * *|mat2|* <nanobem_material.html Material> properties at outside of
% sphere
% * *|diameter|* diameter of sphere in nm 

%% Methods

%  decy rates of quantum emitter above sphere
decay = decayrate( obj, k0, z );

%%
% * *|k0|* wavenumber of light in vacuum
% * *|z|* position of quantum emitter
% * *|decay|* decay rates in units of free-space decay rate
% * *|decay.totx|* total decay rate for dipole moment along x
% * *|decay.totz|* total decay rate for dipole moment along z

%  extinction cross section, Eq. (9.22)
ext = extinction( obj, k0 );
%  scattering cross section, Eq. (9.21)
sca = scattering( obj, k0 );

%%
% * *|k0|* wavenumber of light in vacuum
% * *|pol|* light polarization for plane wave propagating along z
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
diameter = 10;
mie = miestatsolver( mat1, mat2, diameter );

%  extinction and scattering cross section
ext = extinction( mie, k0 );
sca = scattering( mie, k0 );

%  final plot
plot( ene, ext, ene, sca );

legend( 'ext', 'sca' );
xlabel( 'Photon energy (eV)' );
ylabel( 'Cross section (nm^2)' );

%%
% * <matlab:edit('demostatspec01') demostatspec01.m> |-| Optical spectrum
% for metallic nanosphere and comparison with quasistatuic Mie theory.
% * <matlab:edit('demostatdip01') demostatdip01.m> |-| Lifetime of dipole
% above nanosphere and comparison with quasistatic Mie theory.
%
% Copyright 2022 Ulrich Hohenester