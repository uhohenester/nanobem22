function sol = mldivide( obj, q )
%  MLDIVIDE - Solve BEM equations using resonance modes.
%
%  Usage for obj = galerkin.cimsolver :
%    sol = obj \ q
%  Input
%    q      :  structure with inhomogeneities and wavenumber
%  Output
%    sol    :  solution with tangential electromagnetic fields

sol = solve( obj, q );
