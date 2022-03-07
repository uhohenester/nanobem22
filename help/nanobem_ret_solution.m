%% galerkin.solution
%
% The solution of the BEM solver is a galerkin.solution object. This object
% can be used to compute and plot the fields on and off the boundary, as
% well as for further processing in the various simulation classes.
%
%% Initialization

%  initialize solution of BEM equation
sol = galerkin.bemsolver( tau, k0, e, h );

%%
% * *|tau|* vector of boundary elements
% * *|k0|* wavenumber of light in vacuum
% * *|e|* tangential electric field coefficients defined at edges of
% discretized particle boundary
% * *|h|* tangential magnetic field coefficients
%
%% Methods

%  electromagnetic far fields along directions defined by points PT1 on
%  unit sphere, PropertyPairs control boundary element integration
[ e, h ] = farfields( sol, pt1, PropertyPairs );
%  electromagnetic fields at points PT1 
%    'relcutoff'  -  cutoff for refined integration
%    'memax'      -  slice integration into bunches of size MEMAX
%    'waitbar'    -  show waitbar during evaluation
[ e, h ] = fields( sol, pt1, PropertyPairs );
%  evaluate tangential fields at centroid positions 
[ e, h ] = interp( sol );
%  evaluate fields at boundary inside or outside
[ e, h ] = interp( sol, 'inout', inout );
%  surface charge distribution
sig = surfc( sol );

%% Examples
%
% In the following we discuss the BEM example for a gold nanosphere in
% water, as discussed in more length in the <nanobem_ret_start.html Getting
% started> section.

%  wavenumber of light in vacuum
lambda = 600;
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

%  electromagnetic fields at particle outside
[ e, h ] = interp( sol, 'inout', 2 );
%  coneplot of total electric fields at particle boundary
plot( tau, 'cone', e, 'scale', 4 )

%%
% <<../figures/solution_ret_sphere1.jpg>>
%
% To compute the fields off the particle we first have to define the
% positions where the fields should be computed, using a
% <nanobem_point.html Point> object.

%  points where field is computed
n = 51;
xx = 0.8 * diameter * linspace( -1, 1, n );
[ x, y ] = ndgrid( xx );
pt = Point( tau, [ x( : ), y( : ), 0 * x( : ) ] );
%  evaluate fields
[ e, h ] = fields( sol, pt, 'relcutoff', 2, 'waitbar', 1 );

%  plot fields
imagesc( xx, xx, reshape( dot( e, e, 2 ), size( x ) ) .' );
axis equal tight

%%
% <<../figures/solution_ret_sphere2.jpg>>
%
% In the evaluation of the fields we use an integration
% <nanobem_quadengine.html engine> for the refined integration between
% sufficiently close positons and boundary elements. The computation is
% based on the representation formula (5.37) of Hohenester, Nano and
% Quantum Optics (Springer, 2020), together with an <nanobem_potbase.html
% analytic integration> of the singular integrals.
%
% * <matlab:edit('demoretfield01') demoretfield01.m> |-| Electric field of
% optically excited nanosphere.
% * <matlab:edit('demoretfield02') demoretfield02.m> |-| Electric field of
% optically excited coupled nanospheres.
%
%
% Copyright 2022 Ulrich Hohenester

