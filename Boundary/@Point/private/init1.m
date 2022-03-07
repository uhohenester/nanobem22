function obj = init1( obj, mat, imat, pos )
%  INIT1 - Initialize point embedded in dielectric environment.
%
%  Usage for obj = Point :
%    obj = init1( obj, mat, imat, pos )
%  Input
%    mat    :  material parameters
%    imat   :  material index
%    pos    :  point position

if size( pos, 1 ) == 1
  [ obj.mat, obj.imat, obj.pos ] = deal( mat, imat, pos );
else
  %  number of positions
  n = size( pos, 1 );
  %  split positions into cell array 
  pos = mat2cell( pos, ones( 1, n ), 3 );
  if isscalar( imat ),  imat = repelem( imat, 1, n );  end
  %  initialize points
  obj = cellfun( @( i, x )  ...
    Point( mat, i, x ), num2cell( imat( : ) ), pos, 'uniform', 0 );
  obj = horzcat( obj{ : } );
end
 