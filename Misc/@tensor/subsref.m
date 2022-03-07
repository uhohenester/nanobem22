function varargout = subsref( obj, s )
%  SUBSREF - Access class properties and symbolic indices.

switch s( 1 ).type
  case '()'
    varargout{ 1 } = at( obj, [ s( 1 ).subs{ : } ] ); 
    if ~isscalar( s )
      varargout{ 1 } = subsref( varargout{ 1 }, s( 2 : end ) );
    end
  otherwise
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
end
    