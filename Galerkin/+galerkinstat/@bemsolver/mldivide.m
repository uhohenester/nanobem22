function sol = mldivide( obj, q )
%  MLDIVIDE - Solve quasistatic BEM equations.
%
%  Usage for obj = galerkinstat.bemsolver :
%    sol = obj, \ q
%  Input
%    q      :  structure with inhomogeneities and wavenumber
%  Output
%    sol    :  solution with surface charge distribution

sol = solve( obj, q );
