%% galerkin.spectrum
%
% The galerkin.spectrum class allows the implementation of a detector for
% electromagnetic far-fields using spectral filtering.
%
%% Initialization

%  initialize far-field detector
obj = galerkin.spectrum( mat, pinfty, imat );


%% 
% * *|mat|*  vector of <nanobem_material.html material properties>
% * *|pinfty|* discretized unit sphere
% * *|imat|* index for background material
%
%% Methods

%  scattered power computed from far-fields E,H
[ sca, dsca ] = scattering( obj, e, h );

%%
% The following lines show a simple example which uses the
% galerkin.spectrum object.

%  far-field spectrometer
rules = quadboundary.rules( 'quad3', triquad( 1 ) );
spec = galerkin.spectrum( mat, trisphere( 256 ), 'rules', rules );
%  electromagnetic far-fields for solution SOL of BEM equations
[ e, h ] = farfields( sol, spec.pt );
%  scattered power for far-fields
[ csca, dsca ] = scattering( spec, e, h );

%%
%
% Copyright 2022 Ulrich Hohenester
