%% galerkinstat.bemsolver
%
% galerkinstat.bemsolver is the central object for the quasistatic BEM
% solution. It sets up the Green function and its normal derivative, and
% solves the BEM equations. Users not interested in the working details of
% the BEM solver can control its performance using just a few parameters,
% as described in the following.
%
%% Initialization

%  initialize BEM solver
bem = galerkinstat.bemsolver( tau, PropertyPairs );

%%
% * *|tau|* discretized particle boundary
% * *|'relcutoff'|* relative cutoff for refined integration, see
% <matlab:doc('BoundaryElement/bdist2') bdist2>
% * *|'nduffy'|* number of Legendre-Gauss points for Duffy integration
% * *|'rules'|* default integration rules
% * *|'rules1'|* integration rules for refinement
% * *|'waitbar'|* show waitbar during initialization
% * *|'mode'|* engine mode 'duffy' (full numerical integration) or 'smooth'
% (analytic integration, default)
%
% Alternatively, one can also supply an integration engine

%  initialize BEM solver with integration engine
bem = galerkinstat.bemsolver( tau, 'engine', engine );

%%
% Details about the engine and the properties controlling the BEM
% performance are given in the <nanobem_stat_bem2.html working principle>.
%
%% Methods

%  Green function and normal derivative
G = bem.G;
F = bem.F;
%  solve BEM equations for given inhomogeneity
sol = solve( bem, q );
%  shorthand notation for BEM solution
sol = bem \ q;

%%
% The BEM solver returns a <nanobem_stat_solution.html
% galerkinstat.solution> object, which can be visualized or used for
% further manipulations, for instance the computation of optical cross
% sections or the decay rates of optically excited quantum emitters.
%
% Copyright 2022 Ulrich Hohenester

