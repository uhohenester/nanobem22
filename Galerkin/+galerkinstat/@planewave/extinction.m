function cext = extinction( obj, sol )
%  EXTINCTION - Extinction cross section.
%
%  Usage for obj = galerkinstat.planewave :
%    cext = extinction( obj, sol )
%  Input
%    sol    :  solution of quasistatic BEM equation
%  Output
%    cext   :  extinction cross section

%  induced dipole moment
dip = dipole( sol );
%  dielectric function and wavenumber
mat = sol.tau( 1 ).mat( obj.imat );
k = mat.k( sol.k0 );
%  extinction cross section
cext = 4 * pi * k * imag( dot( obj.pol, dip, 2 ) );
