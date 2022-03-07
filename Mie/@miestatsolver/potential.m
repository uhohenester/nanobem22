function pot = potential( obj, pos1, pos2, k0, varargin )
%  POTENTIAL - Potential for point charge and sphere, PRE 84, 016705 (2011).
%
%  Usage for obj = miestatsolver :
%    pot = potential( obj, pos1, pos2, k0, PropertyPairs )
%  Input
%    pos1   :  charge position
%    pos2   :  position for potential
%    k0     :  wavelength of light in vacuum
%  PropertyName
%    lmax   :  maximum number of spherical degrees
%  Output
%    pot    :  reflected potential

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'lmax', 40 );
%  parse input
parse( p, varargin{ : } );

%  dielectric functions
eps1 = obj.mat1.eps( k0 );
eps2 = obj.mat2.eps( k0 );
%  diameter of sphere
a = 0.5 * obj.diameter;
%  distances
r1 = norm( pos1 );
r2 = norm( pos2 );

%  Legendre polynomial
x = dot( pos1, pos2 ) / ( r1 * r2 );
P = zeros( 1, p.Results.lmax );
P( 1 : 2 ) = [ x, 0.5 * ( 3 * x ^ 2 - 1 ) ];
%  recursion relation
for l = 2 : p.Results.lmax - 1
  P( l + 1 ) = ( ( 2 * l + 1 ) * x * P( l ) - l * P( l - 1 ) ) / ( l + 1 );
end

%  allocate output
pot = 0;
%  loop over spherical degrees, Eq. (9)
for l = 1 : p.Results.lmax
  pot = pot + a ^ ( 2 * l + 1 ) / ( r1 * r2 ) ^ ( l + 1 ) * P( l ) *  ...
    l * ( eps2 - eps1 ) ./ ( l * eps1 + ( l + 1 ) * eps2 );
end

%  scale potential
pot = pot / ( 4 * pi * eps2 );
