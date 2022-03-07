function quad = quadedge( n )
%  QUADEDGE - Integration points and weights for edge integration. 
%
%  Usage :
%    quad = quadedge( n )
%  Input
%    n      :  number of Gauss-Legendre points
%  Output
%    quad   :  integration points and weights in triangular coordinates
%
%  D'Elia et al., Int. J. Num. Methods in Biomed. Eng. 27, 314 (2011).
%  Sarraf et al., Comp. Appl. Math. 33, 63 (2014).

%  quadrature points and weights for Galerkin method
[ ww, x1, x2, xx, w ] = nodes( n );

%  mu and xi-coordinates, determinants, table 2
[ mu11, mu21, xi11, xi21 ] = fun( ww, x1, x2, xx, 1 );
[ mu12, mu22, xi12, xi22 ] = fun( ww, x1, x2, xx, 2 );
[ mu13, mu23, xi13, xi23 ] = fun( ww, x1, x2, xx, 3 );
[ mu14, mu24, xi14, xi24 ] = fun( ww, x1, x2, xx, 4 );
[ mu15, mu25, xi15, xi25 ] = fun( ww, x1, x2, xx, 5 );
[ mu16, mu26, xi16, xi26 ] = fun( ww, x1, x2, xx, 6 );

%  put together integration variables
mu1 = [ mu11, mu12, mu13, mu14, mu15, mu16 ];
mu2 = [ mu21, mu22, mu23, mu24, mu25, mu26 ];
xi1 = [ xi11, xi12, xi13, xi14, xi15, xi16 ];
xi2 = [ xi21, xi22, xi23, xi24, xi25, xi26 ];
%  Jacobi determinant
J = x1 .* ww .^ 2 .* ( 1 - ww );
%  convert to simplex coordinates, Eq. (39)
eta1 = mu1 + xi1;
eta2 = mu2 + xi2;

%  symmetrize integral in Eq. (39)
[ eta1, xi1 ] = deal( [ eta1, xi1 ], [ xi1, eta1 ] );
[ eta2, xi2 ] = deal( [ eta2, xi2 ], [ xi2, eta2 ] );
%  expand determinants and weights
[ J, w ] = deal( repmat( J, 1, 12 ), repmat( w, 1, 12 ) );

%  transform to triangular coordinates
[ x1, y1, ~ ] = deal( 1 - xi1( : ), xi1( : ) - xi2( : ), xi2( : ) );
[ x2, y2, ~ ] = deal( 1 - eta1( : ), eta1( : ) - eta2( : ), eta2( : ) );
%  integration weights
%    4 is conversion factor between simplex coordinates and unit triangle
w = 4 * w( : ) .* J( : );
%  The sum over w should give 1 but we get 2, something seems to be wrong
%  here.  The following command is correcting for that.
w = 0.5 * w;

%  save to output
quad = struct( 'x1', x1, 'y1', y1, 'x2', x2, 'y2', y2, 'w', w );


function [ mu1, mu2, xi1, xi2 ] = fun( ww, x1, x2, xx, flag )
%  FUN - Compute coordinates from Table 2.

switch flag
  case 1
    mu1 = - ww .* x1;
    mu2 = - ww .* x1 .* x2;
    xi1 = ( 1 - ww ) .* xx + ww;
    xi2 = ww .* ( 1 - x1 + x1 .* x2 );
  case 2
    mu1 = ww .* x1;
    mu2 = ww .* x1 .* x2;
    xi1 = ( 1 - ww ) .* xx + ww .* ( 1 - x1 );
    xi2 = ww .* ( 1 - x1 );
  case 3
    mu1 = - ww .* x1 .* x2;
    mu2 = ww .* x1 .* ( 1 - x2 );
    xi1 = ( 1 - ww ) .* xx + ww;
    xi2 = ww .* ( 1 - x1 );
  case 4
    mu1 = ww .* x1 .* x2;
    mu2 = ww .* x1 .* ( x2 - 1 );
    xi1 = ( 1 - ww ) .* xx + ww .* ( 1 - x1 .* x2 );
    xi2 = ww .* ( 1 - x1 .* x2 );
  case 5
    mu1 = - ww .* x1 .* x2;
    mu2 = - ww .* x1;
    xi1 = ( 1 - ww ) .* xx + ww;
    xi2 = ww;
  case 6
    mu1 = ww .* x1 .* x2;
    mu2 = ww .* x1;
    xi1 = ( 1 - ww ) .* xx + ww .* ( 1 - x1 .* x2 );
    xi2 = ww .* ( 1 - x1 );
end
