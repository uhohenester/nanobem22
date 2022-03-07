function data = eval2( obj, varargin )
%  EVAL2 - Evaluate Green function and normal derivative.
%
%  Usage for obj = galerkin.pot1.refine1 :
%    data = eval2( obj )
%    data = eval2( obj, data )
%  Input
%    data   :  previously computed Green function and normal derivative
%  Output
%    data   :  Green function and normal derivative

%  quadrature rules for boundary
[ pt1, pt2 ] = deal( obj.pt1, obj.pt2 );
%  dummy indices for internal tensor class
[ i, a1, a2, q1, q2, k ] = deal( 1, 2, 3, 4, 5, 6 );

%  get integration points, weights and shape functions 
[ pos1, w1, f1 ] = eval( pt1 );
[ pos2, w2, f2 ] = eval( pt2 ); 
%  convert integration points to tensor
pos1 = tensor( pos1, [ i, q1, k ] );  
pos2 = tensor( pos2, [ i, q2, k ] );  
%  convert shape functions including weights to tensor
f1 = tensor( f1, [ i, q1, a1 ] ) * tensor( w1, [ i, q1 ] );
f2 = tensor( f2, [ i, q2, a2 ] ) * tensor( w2, [ i, q2 ] );

%  distance
d = sqrt( dot( pos1 - pos2, pos1 - pos2, k ) );      
%  normal vector
nvec = tensor( vertcat( pt1.tau.nvec ), [ i, k ] );
    
%  Green function
G = sum( sum( f1 ./ d, q1 ) * f2, q2 );
%  normal derivative of Green function
F = - sum( dot( nvec, pos1 - pos2, k ) * ( f1 ./ d .^ 3 * f2 ), q1, q2 );

%  set output
G = double( G, [ i, a1, a2 ] ) / ( 4 * pi );
F = double( F, [ i, a1, a2 ] ) / ( 4 * pi );
%  set output
data = struct( 'G', G, 'F', F );

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
