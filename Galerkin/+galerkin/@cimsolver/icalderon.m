function ical = icalderon( obj, k0 )
%  CALDERON - Inverse Calderon matrix using resonance modes.
%
%  Usage for obj = galerkin.cimsolver :
%    ical = icalderon( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%    ical   :  inverse of Calderon matrix

%  resonance and adjoint modes
[ ue1, uh1 ] = deal( obj.sol.e,  obj.sol.h  );
[ ue2, uh2 ] = deal( obj.sol2.e, obj.sol2.h );
%  convert wavenumber to energy
eV2nm = 1 / 8.0655477e-4;
z = eV2nm * k0 / ( 2 * pi );
%  inverse of Calderon matrix
ical = [ ue1; uh1 ] * diag( 1 ./ ( z - obj.ene ) ) * transpose( [ ue2; uh2 ] );
