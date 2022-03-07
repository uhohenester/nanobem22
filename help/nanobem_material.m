%% Material
%
% Material is a base class of the nanobem toolbox that stores the
% permittivity and permeability of the material.
%
%% Initialization

%  initialize material
obj = Material( eps, mu );

%%
% * *|eps|* either constant or function for permittivity in units of vacuum
% permittivity
% * *|mu|*  either constant or function for permittivity in units of vacuum
% permeability

%  initialization with constant value
obj = Material( 2.25, 1 );
%  initialization with tabulated values for gold or silver permittivity
obj = Material( epstable( 'gold.dat' ), 1 );
%  initialization with Drude dielectric function for 'Au', 'Ag', 'Al'
obj = Material( epsdrude( 'Au' ), 1 );

%% 
% It is also possible to supply user-defined dielectric or permeability
% functions, which internally use units in eV.

%  user-defined dielectric function using energies in eV
[ wp, gamma ] = deal( 10, 0.66 / 10 );
epsz = @( w ) 1 - wp ^ 2 ./ ( w .* ( w + 1i * gamma ) );
%  initialization with user-defined dielectric function
obj = Material( epsz, 1 );

%% Methods

eps = obj.eps( k0 );  %  dielectric function 
mu  = obj.mu(  k0 );  %  permeability 
n   = obj.n( k0 );    %  refractive index
Z   = obj.Z( k0 );    %  impedance
k   = obj.k( k0 );    %  wavenumber

%%
% Here |k0| is the wavenumber of light in vacuum.

%% Examples

%  photon energy (eV)
ene = 2;
%  convert to wavenumbers
units;
lambda = eV2nm / ene;
k0 = 2 * pi / lambda;

%  initialize material object for gold
mat = Material( epstable( 'gold.dat' ), 1 );
%  refractive index
n = mat.n( k0 )

%%
%  n =
% 
%     0.2038 + 3.3054i
%
% * <matlab:edit('demomaterial01') demomaterial01.m> |-| Plot tabulated and
% Drude dielectric functions for Ag and Au.
% 
% Copyright 2022 Ulrich Hohenester