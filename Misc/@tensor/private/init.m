function obj = init( obj, val, varargin )
%  INIT - Initialize tensor object.
%
%  Usage for obj = tensor :
%    obj = init( obj, val )
%    obj = init( obj, val, idx )
%  Input
%    val    :  multidimensional array
%    idx    :  symbolic indices

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addOptional( p, 'idx', [] );
%  parse input
parse( p, varargin{ : } );

%  value array and size
[ obj.val, obj.siz ] = deal( val, size( val ) );
%  symbolic indices
obj.idx = p.Results.idx;

if ~isempty( obj.idx )
  if numel( obj.siz ) > numel( obj.idx )
    %  row [1,n] or column [n,1] vector
    obj.siz = max( obj.siz );
  elseif numel( obj.siz ) < numel( obj.idx )
    %  tailing dimension internally removed by Matlab
    obj.siz = [ obj.siz, 1 ];
  end
end
