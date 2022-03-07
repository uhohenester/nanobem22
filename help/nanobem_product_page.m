%% nanobem Toolbox
%
% <<../figures/nanobem.jpg>>
%
% nanobem is a toolbox for the solution of Maxwell's equations for metallic
% and dielectric nanoparticles using a Galerkin boundary element method
% (BEM) approach. Details of the computational approach are described in
%
% * Hohenester, Nano and Quantum Optics (Springer 2020).
% * Hohenester, Reichelt, Unger, Nanophotonic resonance modes with the
% nanobem toolbox, to appear in CPC (2022).
%
% When you publish results with the nanobem toolbox, please cite the CPC
% paper and check the <https://orcid.org/0000-0001-8929-2086 orcid> website
% for the final reference.
%
%% Short description of the toolbox
%
% The toolbox provides a number of general classes that allow setting up
% the nanoparticle boundaries and materials, and solving the full Maxwell's
% equations or the quasistatic approximation for planewave and dipole
% excitations. We additionally provide a contour integral method (CIM)
% solver for the computation of resonance modes (quasinormal modes), a
% solver for quasistatic eigenmodes, as well as an implementation for
% mesoscopic boundary conditions using Feibelman parameters (not yet part
% of the public toolbox).
%
% Throughout the toolbox, lengths are measured in nanometers and
% frequencies are given in terms of the wavenumbers of light in vacuum. For
% instance, a photon energy of 2 eV has to be converted to a wavenumber
% according to

%  photon energy in eV
ene = 2;
%  convert to wavelength in nm
units;
lambda = eV2nm / ene;
%  convert wavelength to wavenumber
k0 = 2 * pi / lambda;

%%
% For the simulation of the full Maxwell equations, the electric field $\bf
% E$ has to be scaled by the strength of the incoming field. The magnetic
% field $Z{\bf H}$ used in the simulations is multiplied with the
% free-space impedance $Z$, such that $\bf E$, $\bf H$ have the same units.
% We use SI units throughout.
%
%%
% The toolbox succeedes the MNPBEM toolbox written by the same developer.
% The main difference is now the use of a Galerkin scheme which makes the
% simulations more accurate and safely allows for the consideration of
% dielectric particles in the nanometer to micron range. In comparison to
% MNPBEM, the simulations are expected to be slower and the use of the
% toolbox functions is probably less flexible.
%
%% Examples
%
% * <nanobem_ret_start.html Getting started> with the solution of the full
% Maxwell's equations.
% * <nanobem_stat_start.html Getting started> with the solution of the 
% Maxwell's equations using the quasistatic approximation.
% * Collection of nanobem <nanobem_examples.html examples>.
%
%% Copyright
%
% The nanobem toolbox is distributed under the terms of the GNU General
% Public License. See the file COPYING in the main directory for license
% details.
%
%% Developers
%
% <https://orcid.org/0000-0001-8929-2086 Ulrich Hohenester>
%
% Copyright 2022 Ulrich Hohenester
