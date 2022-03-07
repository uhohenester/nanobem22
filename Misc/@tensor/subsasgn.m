function obj = subsasgn( obj, s, b )
%  SUBSASGN - Subscripted assignement

switch s( 1 ).type
  case '()'
    obj.idx = [ s( 1 ).subs{ : } ];
    [ ~, i1 ] = ismember( b.idx, obj.idx );
    obj.val = ipermute( reshape( b.val, b.siz ), i1 );
    obj.siz = size( obj.val );
  otherwise
    obj = builtin( 'subsasgn', obj, s, b );
end
