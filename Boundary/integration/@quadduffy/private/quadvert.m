function quad = quadvert( n )
%  TAYLORVERT - Integration points and weights for vertex integration. 
%
%  Usage :
%    quad = quadvert( n )
%  Input
%    n      :  number of Gauss-Legendre points
%  Output
%    quad   :  integration points and weights in triangular coordinates
%
%  D'Elia et al., Int. J. Num. Methods in Biomed. Eng. 27, 314 (2011).
%  Sarraf et al., Comp. Appl. Math. 33, 63 (2014).

%  quadrature points and weights for Galerkin method
[ ww, z1, z2, z3, w ] = nodes( n );

%  mu and eta-coordinates, determinants, table 3
xi1  = ww;
xi2  = ww .* z1;
eta1 = ww .* z2;
eta2 = ww .* z2 .* z3;
%  determinant and integration weights
J = z2 .* ww .^ 3;

%  symmetrize integral in Eq. (39)
[ eta1, xi1 ] = deal( [ eta1, xi1 ], [ xi1, eta1 ] );
[ eta2, xi2 ] = deal( [ eta2, xi2 ], [ xi2, eta2 ] );
%  expand determinants and weights
[ J, w ] = deal( [ J, J ], [ w, w ] );

%  transform to triangular coordinates
[ x1, y1, ~ ] = deal( 1 - xi1( : ), xi1( : ) - xi2( : ), xi2( : ) );
[ x2, y2, ~ ] = deal( 1 - eta1( : ), eta1( : ) - eta2( : ), eta2( : ) );
%  integration weights
%    4 is conversion factor between simplex coordinates and unit triangle
w = 4 * w( : ) .* J( : );

%  save to output
quad = struct( 'x1', x1, 'y1', y1, 'x2', x2, 'y2', y2, 'w', w );
