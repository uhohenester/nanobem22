function n = touching( obj1, obj2, varargin )
%  TOUCHING - Find touching boundary elements.
%
%  Usage for obj = BoundaryElement :
%    n = touching( obj1, obj2 )
%    n = touching( obj1, obj2, 'rows' )
%  Output
%    n    :  number of common vertices

if ~isempty( varargin ) && strcmp( varargin{ 1 }, 'rows' )
  %  unique boundary elements
  [ ~, i1, k1 ] = unique( vertcat( obj1.pos ), 'rows' );
  [ ~, i2, k2 ] = unique( vertcat( obj2.pos ), 'rows' );
  %  find touching elements
  n = touching( obj1( i1 ), obj2( i2 ) );
  n = n( sub2ind( size( n ), k1, k2 ) );
  
else
  %  vertices
  verts1 = round( vertcat( obj1.verts ), 5 );
  verts2 = round( vertcat( obj2.verts ), 5 );
  %  face indices
  i1 = arrayfun( @( x, i ) repelem( i, x.nedges, 1 ), obj1, 1 : numel( obj1 ), 'uniform', 0 );
  i2 = arrayfun( @( x, i ) repelem( i, x.nedges, 1 ), obj2, 1 : numel( obj2 ), 'uniform', 0 );

  %  uniform edges
  verts = unique( [ verts1; verts2 ], 'rows' );
  %  global vertex indices
  [ ~, nu1 ] = ismember( verts1, verts, 'rows' );
  [ ~, nu2 ] = ismember( verts2, verts, 'rows' );
  %  find common vertices
  is = bsxfun( @eq, nu1, transpose( nu2 ) );

  %  accumulate output array
  [ i1, i2 ] = ndgrid( vertcat( i1{ : } ), transpose( vertcat( i2{ : } ) ) );
  n = accumarray( { i1( : ), i2( : ) }, is( : ) );
end
