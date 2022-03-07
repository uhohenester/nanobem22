function varargout = bdist2( obj1, obj2, k )
%  BDIST2 - Pairwise distance scaled by bounding box radius.
%
%  Usage for obj = BoundaryElement :
%    d = bdist2( obj1, obj2 )
%    [ d, ind ] = bdist2( obj1, obj2, k )
%  Input
%    k    :  K smallest boundary pairs
%  Output
%    d    :  pairwise distance scaled by bounding box radius
%    ind  :  index to smallest elements

%  centroid positions
pos1 = vertcat( obj1.pos );  
pos2 = vertcat( obj2.pos );
%  bounding box radii
rad1 = boxradius( obj1 ); 
rad2 = boxradius( obj2 );

if ~exist( 'k', 'var' ) || isempty( k )
  varargout{ 1 } =  ...
    pdist2( pos1, pos2 ) ./ bsxfun( @plus, transpose( rad1 ), rad2 );
else
  [ d, ind ] = pdist2( pos1, pos2, 'euclidean', 'smallest', k );
  [ d, ind ] = deal( transpose( d ), transpose( ind ) );
  d = d ./ bsxfun( @plus, rad2( ind ), rad1 );
  %  set output
  [ varargout{ 1 : nargout } ] = deal( d, ind );
end
