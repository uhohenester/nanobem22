function qinc = eval( obj, tau, k0 )
%  EVAL - Inhomogeneities for planewave excitation.
%
%  Usage for obj = galerkin.planewave :
%    qinc = eval( obj, tau, k0 )
%  Input
%    tau    :  boundary elements
%    k0     :  wavelength of light in vacuum
%  Output
%    qinc   :  structure containing inhomogeneities for Galerkin scheme

%  function for computation of electromagnetic fields
fun = @( pt ) fields2( obj, pt, k0 );
%  inhomogeneities
[ e, h ] = qbasis( tau, fun, obj.rules );
%  set output
qinc = struct( 'e', e, 'h', h, 'tau', tau, 'k0', k0 );
