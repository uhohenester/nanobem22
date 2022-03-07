function [ obj, idx2 ] = idxfront( obj, varargin )
%  IDXFRONT - Push indexed dimensions to front.
%
%  Usage for obj = tensor :
%    [ obj, idx2 ] = idxfront( obj, idx, ... )
%  Input
%    idx    :  indices to be brought to front
%  Output
%    obj    :  reshaped value array with indexed dimensions at front
%    idx2   :  back indices

%  indices to be brought to front
idx1 = [ varargin{ : } ];
%  dimensions at back and front
[ ~, i1 ] = ismember( idx1, obj.idx );
l = true( 1, numel( obj.idx ) );  l( i1 ) = false;
[ i2, idx2 ] = deal( find( l ), obj.idx( l ) );

%  permute multidimensional array
dimorder = horzcat( i1, i2 ); 
if ~isscalar( dimorder )
  obj.val = permute( reshape( obj.val, obj.siz ), dimorder );
  obj.siz = obj.siz( dimorder );
  %  indices
  obj.idx = obj.idx( dimorder );
end

%  reshape to 2d array
obj.val = reshape( obj.val, prod( obj.siz( 1 : numel( varargin ) ) ), [] );
