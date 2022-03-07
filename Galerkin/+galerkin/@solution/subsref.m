function varargout = subsref( obj, s )
%  Evaluate BEM solution object.

switch s( 1 ).type
  case '()'
    varargout{ 1 } = interp( obj, s( 1 ).subs{ : } );
  otherwise
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
end
