function far = farscattering( obj, k0, pol, dir )
%  FARSCATTERING - Far fields for light scattering at sphere, Eq. (E.27).
%
%  Usage for obj = miesolver :
%    far = farscattering( obj, k0, pol, dir )
%  Input
%    k0     :  wavenumber of light in vacuum
%    pol    :  light polarization for plane wave propagating along z
%    dir    :  directions for scattered light


assert( isscalar( k0 ) );
%  propagation angles
[ phi, theta ] = cart2sph( dir( :, 1 ), dir( :, 2 ), dir( :, 3 ) );
theta = 0.5 * pi - theta;

%  spherical orders
ltab = reshape( 1 : obj.lmax, [], 1 );
%  wavenumber and impedance of light in outer medium
k2 = obj.mat2.k( k0 );  
Z2 = obj.mat2.Z( k0 );
%  Mie coefficients 
[ a, b ] = miecoefficients( obj, k0 );

%  decompose polarization into helicity states
%    note that in Sec. E.3 we use unnormalized basis states
cp = dot( 0.5 * [ 1,  1i, 0 ], pol, 2 );
cm = dot( 0.5 * [ 1, -1i, 0 ], pol, 2 );
%  vector spherical harmonics
Xp = vsh( ltab,   ones( size( ltab ) ), theta, phi );
Xm = vsh( ltab, - ones( size( ltab ) ), theta, phi );
%  index functions
fun = @( X, l ) squeeze( X( l, :, : ) );

%  allocate output
e = zeros( size( dir ) );
%  loop over angular degrees
for l = reshape( ltab, 1, [] )
  %  electric far field, Eq. (E.22)
  e = e + 1i / k2 * sqrt( 4 * pi * ( 2 * l + 1 ) ) *  ...
    ( cp * ( b( l ) * fun( Xp, l ) + 1i * a( l ) * cross( dir, fun( Xp, l ) ) ) +  ...
      cm * ( b( l ) * fun( Xm, l ) - 1i * a( l ) * cross( dir, fun( Xm, l ) ) ) );
end

%  magnetic far field
h = cross( dir, e ) / Z2;
%  save output
far = struct( 'e', e, 'h', h );
