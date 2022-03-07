function decay = decayrate( obj, k0, z )
%  DECAYRATE - Decay rates for quantum emitter close to sphere.
%
%  Usage for obj = miesolver :
%    decay = decayrate( obj, k0, z )
%  Input
%    k0       :  wavenumber of light in vacuum
%    z        :  position of quantum emitter
%  Output
%    decacy   :  structure with rates (in units of free-space decay rate)
%                  totx   -  total decay rate for dipole moment along x
%                  totz   -  total decay rate for dipole moment along z
%                  radx   -  radiative decay rate for diple along x
%                  radz   -  radiative decay rate for diple along z

%  allocate output
[ totx, totz, radx, radz ] = deal( zeros( numel( k0 ), numel( z ) ) );
%  spherical orders
l = reshape( 1 : obj.lmax, [], 1 );

for i1 = 1 : numel( k0 )
  %  wavenumber of light in outer medium
  k2 = obj.mat2.k( k0( i1 ) );  
  %  Mie coefficients 
  [ a, b ] = miecoefficients( obj, k0( i1 ) );
  for i2 = 1 : numel( z )
    %  Riccati-Bessel functions
    x = k2 * z( i2 );
    [ j, psip ] = riccatibessel( l, x, 'j' ); 
    [ h, xip  ] = riccatibessel( l, x, 'h' ); 
  
    %  Eqs. (E.37), (E.38)
    radz( i1, i2 ) = 1.50 * sum( l .* ( l + 1 ) .* ( 2 * l + 1 ) .*  ...
      abs( ( j + a .* h ) / x ) .^ 2 );
    radx( i1, i2 ) = 0.75 * sum( ( 2 * l + 1 ) .*  ...
    ( abs( j + a .* h ) .^ 2 + abs( ( psip + b .* xip ) / x ) ) .^ 2 );
    %  Eqs. (E.41), (E.42)
    totz( i1, i2 ) = 1 - 1.50 * sum( real(  ...
      l .* ( l + 1 ) .* ( 2 * l + 1 ) .* a .* ( h / x ) .^ 2 ) );
    totx( i1, i2 ) = 1 - 0.75 * sum( real(  ...
      ( 2 * l + 1 ) .* ( a .* ( xip / x ) .^ 2 + b .* h .^ 2 ) ) );
  end
end

%  save output in structure
decay = struct( 'radx', radx, 'radz', radz, 'totx', totx, 'totz', totz );
