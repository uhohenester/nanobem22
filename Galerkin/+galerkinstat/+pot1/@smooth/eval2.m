function data = eval2( obj, varargin )
%  EVAL2 - Evaluate Green function and normal derivative.
%
%  Usage for obj = galerkinstat.pot1.smooth :
%    data = eval2( obj )
%    data = eval2( obj, data )
%  Input
%    data   :  previously computed Green function and normal derivative
%  Output
%    data   :  Green function and normal derivative

%  dummy indices for internal tensor class
[ i, a1, a2, q2 ] = deal( 1, 2, 3, 4 );
%  integration points
[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );
  
%  unique boundary elements
[ ~, i1, i2 ] = unique( vertcat( pt1.tau.pos ), 'rows' );
%  get integration points, weights and shape functions 
[ pos2, w2, f2 ] = eval( pt2 );  
nw = size( pos2, 2 );
%  reshape positions and transform to internal tensor class
f2 = tensor( f2, [ i, q2, a2 ] );
w2 = tensor( w2, [ i, q2 ] );
  
%  boundary element integration using analytic integration
%  see Hänninen et al., PIERS 63, 243 (2006).
switch pt1.npoly
  case 3
    pot3 = potbase3( pt1.tau( i1 ) );
    %  integration over boundary elements
    [ G, F ] = stat2( pot3, pos2, i2 );
end
  
%  convert to tensors
G = tensor( reshape( G, [], pt1.npoly, nw ), [ i, a1, q2 ] );
F = tensor( reshape( F, [], pt1.npoly, nw ), [ i, a1, q2 ] );
%  perform integration
G = sum( ( w2 * f2 ) * G, q2 );
F = sum( ( w2 * f2 ) * F, q2 );

%  set output
G = double( G( i, a1, a2 ) ) / ( 4 * pi );
F = double( F( i, a1, a2 ) ) / ( 4 * pi );

%  deal with previously computed BEM potentials
if ~isempty( varargin )
  data = deal( varargin{ : } );
  %  loop over refinement elements
  for it = 1 : numel( obj.i1 )
    [ i1, i2 ] = deal( obj.i1( it ), obj.i2( it ) );
    data.G( i1, :, i2, : ) = G( it, :, : );
    data.F( i1, :, i2, : ) = F( it, :, : );
  end
end
