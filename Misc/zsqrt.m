function y = zsqrt( x )
%  ZSQRT - ZSQRT function for complex arguments.

%  select phase from range [ - 0.5 * pi, 1.5 * pi )
phi = angle( x );
phi( phi < - 0.5 * pi ) = phi( phi < - 0.5 * pi ) + 2 * pi;
%  SQRT function
y = builtin( 'sqrt', abs( x ) ) .* exp( 0.5i * phi );
