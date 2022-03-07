function obj = at( obj, idx )
%  AT - Set tensor indices.

if ~isempty( obj.idx ) && ~isscalar( idx )
  [ ~, i1 ] = ismember( idx, obj.idx );
  obj.val = permute( reshape( obj.val, obj.siz ), i1 );
end
%  set new size and indices
obj.siz = size( obj.val );
obj.idx = idx;

if numel( obj.siz ) > numel( obj.idx )
  %  row [1,n] or column [n,1] vector
  obj.siz = max( obj.siz );
elseif numel( obj.siz ) < numel( obj.siz )
  %  tailing dimension internally removed by Matlab
  obj.siz = [ obj.siz, 1 ];
end
