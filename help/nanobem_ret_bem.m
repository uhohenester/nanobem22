%% galerkin.bemsolver
%
% galerkin.bemsolver is the central object for the BEM solution of the full
% Maxwell equations. It sets up the Calderon matrix Eq. (11.41) of
% Hohenester, Nano and Quantum Optics (Springer, 2020) and solves the BEM
% equations. Users not interested in the working details of the BEM solver
% can control its performance using just a few parameters, as described in
% the following.
%
%% Initialization

%  initialize BEM solver
bem = galerkin.bemsolver( tau, PropertyPairs );

%%
% * *|tau|* discretized particle boundary
% * *|'relcutoff'|* relative cutoff for refined integration, see
% <matlab:doc('BoundaryElement/bdist2') bdist2>
% * *|'nduffy'|* number of Legendre-Gauss points for Duffy integration
% * *|'rules'|* default integration rules
% * *|'rules1'|* integration rules for refinement
% * *|'order'|* orders for series expansion, |[]| if none
% * *|'waitbar'|* show waitbar during initialization
%
% Alternatively, one can also supply an integration engine

%  initialize BEM solver with integration engine
bem = galerkin.bemsolver( tau, 'engine', engine );

%%
% Details about the engine and the properties controlling the BEM
% performance are given in the <nanobem_ret_bem1.html working principle>.
%
%% Methods

%  compute Calderon matrix for given wavenumber
cal = calderon( bem, k0 );
%  solve BEM equations for given inhomogeneity
sol = solve( bem, q );
%  shorthand notation for BEM solution
sol = bem \ q;

%%
% The BEM solver returns a <nanobem_ret_solution.html galerkin.solution>
% object, which can be visualized or used for further manipulations, for
% instance the computation of optical cross sections or the decay rates of
% optically excited quantum emitters.
%
% Copyright 2022 Ulrich Hohenester

