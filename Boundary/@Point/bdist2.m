function varargout = bdist2( obj, tau, k )
%  BDIST2 - Pairwise distance scaled by bounding box radius.
%
%  Usage for obj = Point :
%    d = bdist2( obj, tau )
%    [ d, ind ] = bdist2( obj, tau, k )
%  Input
%    k    :  K smallest boundary pairs
%  Output
%    d    :  pairwise distance scaled by bounding box radius
%    ind  :  index to smallest elements

%  point and centroid positions
pos1 = vertcat( obj.pos );  
pos2 = vertcat( tau.pos );
%  bounding box radius
rad2 = boxradius( tau );

if ~exist( 'k', 'var' ) || isempty( k )
  varargout{ 1 } = bsxfun( @rdivide, pdist2( pos1, pos2 ), rad2 );
else
  [ d, ind ] = pdist2( pos2, pos1, 'euclidean', 'smallest', k );
  [ d, ind ] = deal( transpose( d ), transpose( ind ) );
  d = bsxfun( @rdivide, d, reshape( rad2( ind ), [], 1 ) );
  %  set output
  [ varargout{ 1 : 2 } ] = deal( d, ind );
end
