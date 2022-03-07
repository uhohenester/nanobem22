function obj = sum( obj, varargin )
%  SUM - Sum over indexed dimensions.
%
%  Usage for obj = tensor :
%    obj = sum( obj, idx1, ... )
%  Input
%    idx    :  summation indices
%  Output
%    obj    :  multidimensional array of scalar

%  bring summation indices to front
[ obj, idx2 ] = idxfront( obj, varargin{ : } );

%  result is scalar
if isempty( idx2 )
  obj = sum( obj.val( : ) );
else
  n = numel( varargin );
  obj.val = sum( obj.val, 1 );
  obj.siz = obj.siz( n + 1 : end );
  obj.idx = obj.idx( n + 1 : end );
end
