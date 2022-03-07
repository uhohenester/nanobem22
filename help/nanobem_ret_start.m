%% Getting started 
%
% The BEM approach for the solution of the full Maxwell equations is
% described in Hohenester, Nano and Quantum Optics (Springer, 2020),
% chapters 9, 11. In the following we discuss a typical BEM example for a
% gold nanosphere in water.
%
%% Nanoparticle
%
% In a first step we set up the <nanobem_material.html Material> objects,
% the nanoparticle boundary, and define how the boundary is embedded in its
% photonic environment.

%  material properties for water and gold
mat1 = Material( 1.33 ^ 2, 1 );
mat2 = Material( epstable( 'gold.dat' ), 1 );
%  material vector, the first entry is the embedding medium
%    use the same material vector throughout a simulation
mat = [ mat1, mat2 ];
%  nanosphere with 50 nm radius
diameter = 50;
p = trisphere( 144, diameter );
%  convert to boundary elements with Raviart-Thomas shape functions
%    [ 2, 1 ] defines the materials at the particle inside and outside
tau = BoundaryEdge( mat, p, [ 2, 1 ] )

%%
%  tau = 
%
%    1×284 BoundaryEdge array with properties:
%
%      nu
%      val
%      inout
%      verts
%
% Once the boundary elements are initialized, the boundary can be displayed
% using 

%  plot nanosphere boundary
plot( tau, 'EdgeColor', 'b' );

%%
% <<../figures/start_ret_sphere1.jpg>>
%
%% BEM solver and excitation
%
% We next have to set up the BEM solver and the excitation, here a plane
% wave excitation.

%  initialize BEM solver
rules = quadboundary.rules( 'quad3', triquad( 1 ) );
bem = galerkin.bemsolver( tau, 'rules', rules );
%  planewave excitation
exc = galerkin.planewave( [ 1, 0, 0 ], [ 0, 0, 1 ] );

%% 
% The integration rules control the accuracy of the BEM approach. In the
% last line we set up a planewave object with the polarizaion along
% direction [1,0,0] and the propagation direction along [0,0,1]. In order
% to solve the BEM equations, we have to specify a wavelength $\lambda$,
% compute the inhomogeneities for the plane wave excitation, and solve the
% BEM equations

%  wavelength of light in vacuum
lambda = 600;
%  toolbox internally uses wavenumber of light in vacuum
k0 = 2 * pi / lambda;
%  plane wave excitation
q = exc( tau, k0 );
%  solve BEM equations
sol = bem \ q

%%
%  sol = 
% 
%    solution with properties:
% 
%      tau: [1×284 BoundaryEdge]
%       k0: 0.0105
%        e: [426×1 double]
%        h: [426×1 double]
%
% We can now plot the surface charge associated with the solution vector
% |sol| using

%  surface charge distribution
sig = surfc( sol );
%  plot surface charge distribution
plot( tau, sig, 'EdgeColor', 'b' );
colormap( redblue );

%%
% <<../figures/start_ret_sphere2.jpg>>
%
% See the help pages for the BEM <nanobem_ret_solution.html solution> of
% how to plot the electromagnetic fields on the sphere or at some
% user-defined positions. 
%
%% Spectrum
%
% In order to compute a spectrum for different wavelengths, one has to set
% up a wavenumber array and loop over the different wavenumbers

%  light wavelength in vacuum
lambda = linspace( 400, 800, 20 );
k0 = 2 * pi ./ lambda;
%  allocate optical cross sections
[ csca, cext ] = deal( zeros( numel( k0 ), size( exc.pol, 1 ) ) );

%  loop over wavenumbers
for i = 1 : numel( k0 )
  %  solution of BEM equations
  sol = bem \ exc( tau, k0( i ) );

  %  scattering and extinction cross sections
  csca( i, : ) = scattering( exc, sol );
  cext( i, : ) = extinction( exc, sol );
end

%%
% Once the spectrum has been computed, it can be plotted. For a spherical
% particle one can also compare the results with <nanobem_ret_mie.html Mie>
% theory.
%
% * <matlab:edit('demoretspec01') demoretspec01.m> |-| Optical spectrum for
% metallic nanosphere using the full Maxwell's equations.
%
% Copyright 2022 Ulrich Hohenester
