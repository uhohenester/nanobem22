function csca = scattering( obj, sol )
%  SCATTERING - Scattering cross section.
%
%  Usage for obj = galerkinstat.planewave :
%    csca = scattering( obj, sol )
%  Input
%    sol    :  solution of quasistatic BEM equation
%  Output
%    csca   :  scattering cross section

%  induced dipole moment
dip = dipole( sol );
%  dielectric function and wavenumber
mat = sol.tau( 1 ).mat( obj.imat );
k = mat.k( sol.k0 );
%  scattering cross section
csca = 8 * pi / 3 * k ^ 4 .* dot( dip, dip, 2 );
