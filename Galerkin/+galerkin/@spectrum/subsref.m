function varargout = subsref( obj, s )
%  Evaluate detector object.

switch s( 1 ).type
  case '()'
    varargout{ 1 } = scattering( obj, s( 1 ).subs{ : } );
  otherwise
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
end
