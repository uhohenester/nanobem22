%  DEMOPARTICLE01 - Plot elementary particle shapes.

for it = 1 : 6
  
  switch it
    case 1
      %  triangulated sphere with given number of vertices
      %    32 60 144 169 225 256 289 324 361 400 441 484 529 576 625 676 
      %    729 784 841 900 961 1024 1225 1444
      diameter = 10;
      p = trisphere( 144, diameter );
      
    case 2
      %  discretized surface of sphere
      phi = linspace( 0, 2 * pi, 25 );
      theta = linspace( 0, pi, 25 );
      diameter = 10;
      p = trispheresegment( phi, theta, diameter );
      
    case 3
      %  prolate ellipsoid
       diameter = 10;
      p = trisphere( 256, diameter );     
      %  deform sphere
      p.verts( :, 3 ) = 2 * p.verts( :, 3 );
      
    case 4
      %  rod
      %    number of discretization points [nphi,ntheta,nz]
      n = [ 25, 15, 10 ];
      %  diameter and height of nanorod
      diameter = 10;
      height = 20;
      p = trirod( diameter, height, n );
      
    case 5
      %  cube
      %  number of points for cube triangulation
      n = 10;
      %  cube size
      siz = [ 10, 10, 10 ];
      %  parameter for super-sphere, zero for perfect cube
      e = 0.2;
      p = tricube( n, 'siz', siz, 'e', e );
      
    case 6
      %  same as cube (5) but with additional refinement at edges
      nsub = 1;
      p = tricube( n, 'siz', siz, 'nsub', nsub, 'e', e );
  end
  
  
  %  plot particle
  p.verts( :, 1 ) = p.verts( :, 1 ) + ( it - 1 ) * 12;
  plot( p, 'EdgeColor', 'b' );
end
