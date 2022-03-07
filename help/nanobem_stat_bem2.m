%% Working principle
%
% The evaluation of the Green function and its normal derivative is needed
% for the quasistatic BEM approach, and is performed using an integration
% <nanobem_quadengine.html engine>.

%% Integration engine 
%
% When calling galerkinstat.bemsolver without further specification, the
% BEM solver uses the <matlab:edit('galerkinstat.pot1.engine') default
% engine>.

%  default engine for BEM solver
engine = galerkinstat.pot1.engine( PropertyPairs );

%%
% Alternatively one could also set up an engine such as
engine( 1 ) = galerkinstat.pot1.std( PropertyPairs );
engine( 2 ) = galerkinstat.pot1.refine( PropertyPairs );
engine( 3 ) = galerkinstat.pot1.duffy( PropertyPairs ); 
%  pass engine to BEM solver
bem = galerkinstat.bemsolver( tau, 'engine', engine );

%%
% In the following we describe the various engine components in more
% detail. 

%% std
%
% Default integrator for all pairs of boundary elements.

%  initialization of default integrator for all pairs of boundary elements
obj = galerkinstat.pot1.std( PropertyPairs );

%%
% * *|'rules'|* quadrature <matlab:edit('quadboundary.rules') rules>

%  apply quadrature rules to boundary elements TAU1 and TAU2
obj = set1( obj, tau1, tau2 );
%  evaluate Green function data.G and normal derivative data.F
data = eval2( obj );

%% refine
%
% Refinement integrator for selected pairs of boundary elements.

%  initialize refined integration 
obj = galerkinstat.pot1.refine( PropertyPairs );

%%
% * *|'rules1'|* quadrature <matlab:edit('quadboundary.rules') rules> for
% refined integration
% * *|'relcutoff'|* relative cutoff for refined integration, see
% <matlab:doc('BoundaryElement/bdist2') bdist2>

%  apply quadrature rules to boundary elements TAU1 and TAU2
obj = set1( obj, tau1, tau2 );
%  evaluate Green function data.G and normal derivative data.F
%    overwrite previously computed elements 
data = eval2( obj, data );

%% duffy
%
% Refinement integrator for identical or touching pairs of boundary
% elements using a Duffy transformation.

%  initialize refined Duffy integration
obj = galerkinstat.pot1.duffy1( PropertyPairs );

%%
% * *|'nduffy'|* number of Legendre-Gauss points for Duffy integration

%  apply quadrature rules to boundary elements TAU1 and TAU2
obj = set1( obj, tau1, tau2 );
%  evaluate Green function data.G and normal derivative data.F
%    overwrite previously computed elements 
data = eval2( obj,  data );

%% smooth
%
% Refinement integrator for selected pairs of boundary elements using
% analytic integration.

%  initialize analytic integration 
obj = galerkinstat.pot1.smooth( PropertyPairs );

%%
% * *|'rules1'|* quadrature <matlab:edit('quadboundary.rules') rules> for
% refined integration
% * *|'relcutoff'|* relative cutoff for refined integration, see
% <matlab:doc('BoundaryElement/bdist2') bdist2>
%
% For details of the analytic integration see the <nanobem_potbase.html
% potbase> documentation.
%
%
% Copyright 2022 Ulrich Hohenester

