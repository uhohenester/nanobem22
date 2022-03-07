function sol = solve( obj, q )
%  SOLVE - Solve quasistatic BEM equations.
%
%  Usage for obj = galerkinstat.bemsolver :
%    sol = solve( obj, q )
%  Input
%    q      :  structure with inhomogeneities and wavenumber
%  Output
%    sol    :  solution with surface charge distribution

%  solve quasistatic BEM equations
sig = - ( inner( obj, q.k0 ) + obj.F ) \ reshape( q.vn, size( q.vn, 1 ), [] );
%  set output structure
sol = galerkinstat.solution( obj.tau, q.k0, reshape( sig, size( q.vn ) ) );
