function fun = diffcalderon( obj, bem, ktab )
%  DIFFCALDERON - Interpolation function for background matrix.
%
%  Usage for obj = galerkin.cimsolver :
%    fun = diffcalderon( obj, bem, ktab )
%  Input
%    bem    :  BEM solver
%    ktab   :  wavenumbers of light in vacuum for background matrix
%  Output
%    fun    :  nonresonant background function for CIM solver

%  difference between exact and approximate inverse of Calderon matrix
diff = @( k0 ) inv( calderon( bem, k0 ) ) - icalderon( obj, k0 );
htab = arrayfun( diff, ktab, 'uniform', 0 );
%  interpolation function for holomorphic matrix
fun = @( k0 ) fun1( htab, ktab, k0 );


function h = fun1( htab, ktab, k0 )
%  FUN1 - Interpolation function for background matrix.

%  coefficients for series expansion
n = numel( htab );
coeff = k0 .^ ( 0 : n - 1 ) / ( ktab( : ) .^ ( 0 : n - 1 ) );
%  put together background matrix
h = 0;
for i = 1 : n
  h = h + htab{ i } * coeff( i );
end
