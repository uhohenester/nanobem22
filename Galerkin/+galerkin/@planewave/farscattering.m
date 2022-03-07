function [ csca, dsca ] = farscattering( obj, sol, spec )
%  FARSCATTERING - Scattering cross section using far-fields.
%
%  Usage for obj = galerkin.planewave :
%    [ csca, dsca ] = farscattering( obj, sol, spec )
%  Input
%    sol    :  solution of BEM equations
%    spec   :  detector for spectrum of electromagnetic far-fields
%  Output
%    csca   :  scattering cross section
%    dsca   :  differential cross section

%  material properties and material index of embedding medium
imat = obj.imat;
mat = sol.tau( 1 ).mat( imat );

%  electromagnetic far-fields
[ e, h ] = farfields( sol, spec.pt );
%  scattered power for far-fields
[ csca, dsca ] = scattering( spec, e, h );
%  normalize with incoming intensity
inc = 0.5 / mat.Z( sol.k0 );
[ csca, dsca ] = deal( csca / inc, dsca / inc );
