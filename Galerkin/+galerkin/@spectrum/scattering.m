function [ sca, dsca ] = scattering( obj, e, h )
%  SCATTERING - Scattered power for far-fields.
%
%  Usage for obj = galerkin.spectrum :
%    [ sca, dsca ] = scattering( obj, e, h )
%  Input
%    e      :  electric far-fields along direction obj.pt
%    h      :  magnetic far-fields along direction obj.pt
%  Output
%    sca    :  total scattered power
%    dsca   :  scattered power along directions of discretized unit sphere

%  reshape input
siz = size( e );
e = reshape( e, size( obj.w, 1 ), size( obj.w, 2 ), 3, [] );
h = reshape( h, size( obj.w, 1 ), size( obj.w, 2 ), 3, [] );

%  dummy indices for internal dummy class
[ i, q, k, j ] = deal( 1, 2, 3, 4 );
%  convert electromagnetic fields to tensor class
e = tensor( e, [ i, q, k, j ] );
h = tensor( h, [ i, q, k, j ] );
%  integration weight and propagation direction 
w = tensor( obj.w, [ i, q ] );
nvec = tensor( obj.pinfty.nvec, [ i, k ] );

%  Poynting vector
s = 0.5 * real( cross( e, conj( h ), k ) );
%  scattered power, Hohenester Eq. (4.22b)
dsca = dot( sum( s * w, q ), nvec, k );

%  convert to numeric
dsca = double( dsca( i, j ) );
sca = sum( dsca, 1 );
%  reshape output
if numel( siz ) > 2
  dsca = reshape( dsca, [ size( dsca, 1 ), siz( 3 : end ) ] );
  sca = squeeze( reshape( sca, [ 1, siz( 3 : end ) ] ) );
end
