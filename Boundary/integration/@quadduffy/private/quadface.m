function quad = quadface( n )
%  QUADFACE - Integration points and weights for face integration. 
%
%  Usage :
%    quad = quadface( n )
%  Input
%    n      :  number of Gauss-Legendre points
%  Output
%    quad   :  integration points and weights in triangular coordinates
%
%  D'Elia et al., Int. J. Num. Methods in Biomed. Eng. 27, 314 (2011).
%  Sarraf et al., Comp. Appl. Math. 33, 63 (2014).

%  quadrature points and weights for Galerkin method
[ ww, x, x1, x2, w ] = nodes( n );

%  mu and xi-coordinates, determinants, table 1
[ mu11, mu21, xi11, xi21, J1 ] = fun( ww, x, x1, x2, 1 );
[ mu12, mu22, xi12, xi22, J2 ] = fun( ww, x, x1, x2, 2 );
[ mu13, mu23, xi13, xi23, J3 ] = fun( ww, x, x1, x2, 3 );

%  put together integration variables
mu1 = [ mu11, mu12, mu13 ];
mu2 = [ mu21, mu22, mu23 ];
xi1 = [ xi11, xi12, xi13 ];
xi2 = [ xi21, xi22, xi23 ];
%  Jacobi determinant and integration weights
J = [ J1 .* ww, J2 .* ww, J3 .* ww ];
w = [ w, w, w ];
%  convert to simplex coordinates, Eq. (37)
eta1 = mu1 + xi1;
eta2 = mu2 + xi2;

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


function [ mu1, mu2, xi1, xi2, J ] = fun( ww, x, x1, x2, flag )
%  FUN - Compute coordinates and Jacobi determinants from Table 1.

switch flag
  case 1
    mu1 = ww;                    
    mu2 = ww .* x;
    xi1 = ( 1 - mu1 ) .* x1;
    xi2 = xi1 .* x2;
    J = ( 1 - mu1 ) .* xi1;
  case 2
    mu1 = ww .* x;
    mu2 = ww .* ( x - 1 );
    xi1 = ( 1 - mu1 + mu2 ) .* x1 - mu2;
    xi2 = ( xi1 + mu2 ) .* x2 - mu2;
    J = ( 1 - mu1 + mu2 ) .* ( xi1 + mu2 );
  case 3
    mu1 = ww .* x;
    mu2 = ww;
    xi1 = ( 1 - mu2 ) .* x1 + mu2 - mu1;
    xi2 = ( xi1 - mu2 + mu1 ) .* x2;
    J = ( 1 - mu2 ) .* ( xi1 - mu2 + mu1 );
end

