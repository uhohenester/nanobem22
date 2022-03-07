function contour = ellipse( zlim, irad, n )
%  ELLIPSE - Elliptic contour integration.
%
%  Usage :
%    contour = cimbase.ellipse( zlim, irad, n )
%  Input
%    zlim     :  limits of z on real axis, possibly w/ imaginary offset
%    irad     :  radius of ellipse in imaginary direction
%    n        :  number of integration points

t = 2 * pi * ( 0 : n - 1 ) / n;
%  exctract center and radius
[ center, rad ] = deal( mean( zlim ), 0.5 * real( diff( zlim ) ) );
%  integration contour and derivative wrt t
z  = center + rad * cos( t ) + 1i * irad * sin( t );
zp =        - rad * sin( t ) + 1i * irad * cos( t );
%  integration points and weights
dt = t( 2 ) - t( 1 );
contour = struct( 'z', num2cell( z ), 'w', num2cell( zp * dt ) );
