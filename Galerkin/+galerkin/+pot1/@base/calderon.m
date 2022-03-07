function cal = calderon( obj, k0 )
%  CALDERON - Compute Calderon matrix.
%
%  Usage for obj = galerkin.pot1.base :
%    cal = calderon( obj, k0 )
%  Input
%    k0     :  wavenumber of light in vacuum
%  Output
%   cal     :  Calderon matrix
%                see Hohenester, Nano & Quantum Optics, Eq. (11.41).

%  compute SL and DL potential at particle inside and outside
data1 = eval( obj, k0, 1 );
data2 = eval( obj, k0, 2 );
%  Calderon submatrices
A11 = data1.DL  + data2.DL;
A12 = - 1i * k0 * ( data1.SL1 + data2.SL1 );
A21 =   1i * k0 * ( data1.SL2 + data2.SL2 );
%  assemble Calderon matrix
cal = [ A11, A12; A21, A11 ];
