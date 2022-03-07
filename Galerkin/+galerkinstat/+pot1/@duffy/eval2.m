function data = eval2( obj, varargin )
%  EVAL2 - Evaluate Green function and normal derivative.
%
%  Usage for obj = galerkinstat.pot1.duffy2 :
%    data = eval2( obj )
%    data = eval2( obj, data )
%  Input
%    data   :  previously computed Green function and normal derivative
%  Output
%    data   :  Green function and normal derivative

pts = obj.pts;
%  dummy indices for internal tensor class
[ i, a1, a2, q, k ] = deal( 1, 2, 3, 4, 5 );

%  quadrature points and shape elements
[ pos1, f1 ] = eval( pts, 1 );
[ pos2, f2 ] = eval( pts, 2 );
%  convert to tensor class
pos1 = tensor( pos1, [ i, q, k ] );  f1 = tensor( f1, [ i, q, a1 ] );
pos2 = tensor( pos2, [ i, q, k ] );  f2 = tensor( f2, [ i, q, a2 ] );
%  integration weigths and boundary elements
w = tensor( pts.w, [ i, q ] );

%  distance
d = sqrt( dot( pos1 - pos2, pos1 - pos2, k ) );      
%  normal vector
nvec = tensor( vertcat( obj.tau1.nvec ), [ i, k ] );
    
%  Green function
G = sum( w * f1 * f2 ./ d, q );
%  normal derivative of Green function
F = - sum( w * dot( nvec, pos1 - pos2, k ) * f1 * f2 ./ d .^ 3, q );

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
