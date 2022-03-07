function decay = decayrate( obj, k0, z, varargin )
%  DECAYRATE - Decay rates for quantum emitter close to sphere.
%
%  Usage for obj = miestatsolver :
%    decay = decayrate( obj, k0, z )
%  Input
%    k0       :  wavenumber of light in vacuum
%    z        :  position of quantum emitter
%  Output
%    decacy   :  structure with rates (in units of free-space decay rate)
%                  totx   -  total decay rate for dipole moment along x
%                  totz   -  total decay rate for dipole moment along z

%  dielectric function and refractive index
[ eps2, n2 ] = deal( obj.mat2.eps( k0 ), obj.mat2.n( k0 ) );
%  dissipated power of isolated dipole
P0 = n2 ^ 3 / eps2 * k0 ^ 4 / ( 12 * pi );

%  allocate output
[ decay.totx, decay.totz ] = deal( zeros( numel( k0 ), numel( z ) ) );

for iz = 1 : numel( z )
  %  position
  zz = z( iz );

  %  dipole potential
  eta = 1e-4;
  v = @( pos, dir )  ...
    ( potential( obj, pos, [ 0, 0, zz ] + eta * dir, k0, varargin{ : } ) -  ...
      potential( obj, pos, [ 0, 0, zz ] - eta * dir, k0, varargin{ : } ) ) / ( 2 * eta );
  %  electric fields
  ex = - ( v( [   eta, 0, zz ], [ 1, 0, 0 ] ) -  ...
           v( [ - eta, 0, zz ], [ 1, 0, 0 ] ) ) / ( 2 * eta );
  ez = - ( v( [ 0, 0, zz + eta ], [ 0, 0, 1 ] ) -  ...
           v( [ 0, 0, zz - eta ], [ 0, 0, 1 ] ) ) / ( 2 * eta );
              
  %  dissipated power and enhancement of decay rate
  decay.totx( :, iz ) = 0.5 * k0 * imag( ex ) / P0 + 1;
  decay.totz( :, iz ) = 0.5 * k0 * imag( ez ) / P0 + 1;
end
       