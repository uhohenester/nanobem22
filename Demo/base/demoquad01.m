%  DEMOQUAD01 - Quadrature rules for triangle.

for it = 1 : 5
  
  switch it
    case 1
      quad = triquad( 1 );
    case 2
      quad = triquad( 2 );
    case 3
      quad = triquad( 11 );
    case 4
      quad = triquad( 11, 'refine', 2 );
    case 5
      quad = triquad( 11, 'refine', 3 );      
  end
  
  %  quadrature points
  [ x, y ] = deal( quad.x + ( it - 1 ) * 1.2, quad.y );
  %  plot quadrature points
  plot( ( it - 1 ) * 1.2 + [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], 'k-' );  hold on
  h = plot( x, y, 'o', 'MarkerSize', 3 ); 
  h.MarkerFaceColor = get( h, 'Color' );
end

axis equal tight off
