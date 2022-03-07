function cabs = absorption( obj, sol )
%  ABSORPTION - ABSORPTION cross section.
%
%  Usage for obj = galerkinstat.planewave :
%    cabs = absorption( obj, sol )
%  Input
%    sol    :  solution of quasistatic BEM equation
%  Output
%    cabs   :  absorption cross section

cabs = extinction( obj, sol ) - scattering( obj, sol );
