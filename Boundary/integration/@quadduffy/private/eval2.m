function [ pos, f, fp ] = eval2( obj, i1 )
  %  EVAL2 - Evaluate integration points and Raviart-Thomas basis functions.
  %
  %  Usage for obj = quadduffy :
  %    [ pos, f, fp ] = eval2( obj, i1 )
  %  Input
  %    i1     :  evaluation for first or second boundary
  %  Output
  %    pos    :  integration positions
  %    f      :  shape functions
  %    fp     :  divergence of shape functions

  quad = obj.quad;
  %  boundary elements and quadrature points
  switch i1
    case 1
      [ tau, x, y ] = deal( obj.tau1, quad.x1, quad.y1 );
    case 2
      [ tau, x, y ] = deal( obj.tau2, quad.x2, quad.y2 );
  end

  %  dummy indices for internal vector class and vertices
  [ i, a, q, k ] = deal( 1, 2, 3, 4 );
  verts = vertices( tau );
  %  prefactors for shape functions
  val = tensor( vertcat( tau.val ), [ i, a ] );
  
  %  integration points
  switch obj.mode
    case 'vert'
      xi = tensor( funvert( x, y, obj.shift{ i1 } ), [ i, q, a ] );
    case 'edge'
      xi = tensor( funedge( x, y, obj.shift{ i1 } ), [ i, q, a ] );
    case 'face'
      xi = tensor( [ x, y, 1 - x - y ], [ q, a ] );
  end
  
  %  integration positions
  pos = sum( xi * tensor( verts, [ i, a, k ] ), a );
  %  shape function and derivative
  f = 0.5 * val *  ...
    ( pos - tensor( verts( :, [ 3, 1, 2 ], : ), [ i, a, k ] ) );
  fp = val * tensor( ones( size( quad.w ) ), q );
 
  %  convert back from tensor class
  f  = double( f,  [ i, q, a, k ] );
  fp = double( fp, [ i, q, a ] );
  pos = double( pos, [ i, q, k ] );
end



function xi = funvert( x, y, shift )
  %  FUNVERT - Shift points for integration with common vertex.
  
  n = numel( shift );
  %  expand triangular coordinates
  [ x, y ] = deal( repmat( x .', n, 1 ), repmat( y .', n, 1 ) );
  z = 1 - x - y;
  %  shift triangular coordinates
  ind = shift == 2;  [ x( ind, : ), y( ind, : ) ] = deal( z( ind, : ), x( ind, : ) );  
  ind = shift == 3;  [ x( ind, : ), y( ind, : ) ] = deal( y( ind, : ), z( ind, : ) );  
  %  set output
  xi = cat( 3, x, y, 1 - x - y );
end

function xi = funedge( x, y, shift )
  %  FUNEDGE - Shift points for integration with common edge.

  n = numel( shift );
  %  expand triangular coordinates
  [ x, y ] = deal( repmat( x .', n, 1 ), repmat( y .', n, 1 ) );
  z = 1 - x - y;
  %  shift triangular coordinates
  ind = shift ==  2;  [ x( ind, : ), y( ind, : ) ] = deal( z( ind, : ), x( ind, : ) );  %  y
  ind = shift ==  3;  [ x( ind, : ), y( ind, : ) ] = deal( y( ind, : ), z( ind, : ) );  %  x
  ind = shift == -1;  [ x( ind, : ), y( ind, : ) ] = deal( x( ind, : ), z( ind, : ) );  %  y
  ind = shift == -2;  [ x( ind, : ), y( ind, : ) ] = deal( z( ind, : ), y( ind, : ) );  %  x
  ind = shift == -3;  [ x( ind, : ), y( ind, : ) ] = deal( y( ind, : ), x( ind, : ) );  %  z
  %  set output
  xi = cat( 3, x, y, 1 - x - y );
end
